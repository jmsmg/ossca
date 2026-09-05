#!/bin/bash
# 변이 테스트 드라이버 — "이 테스트가 정말 그 코드를 지키는가"를 확인한다.
#   대상 파일 백업 → 변이 스크립트 실행(지키려는 코드를 일부러 제거) → 빌드+테스트 → **실패해야 정상**
#   → 원복 → 빌드+테스트 → 통과 확인.  중간에 끊겨도 EXIT 트랩으로 원복된다.
#
# 사용법: mutation_test.sh <이름> <빌드타깃> <gtest_filter> <변이스크립트> <대상파일>...
#   <변이스크립트>  CHROMIUM_SRC 에서 실행되는 실행 파일(.py/.sh). 대상 파일을 고쳐 불변식을 깨뜨린다
#   <대상파일>...   변이스크립트가 건드리는 파일 (CHROMIUM_SRC 기준 상대 경로) — 백업·원복 대상
# 예 (CL 8282239 에서 실제로 쓴 변이): $OSSCA/examples/scripts/mutate_quota_commit.py 헤더 참고
# 결과: logs/<이름>_mutation_done.marker 에 mutation_exit=<n> (0 이 아니어야 함) / restored_exit=<n> (0 이어야 함)
# 로그: logs/<이름>_mutation_{build,test}_{mutated,restored}.log
set -u
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
if [ $# -lt 5 ]; then sed -n '2,12p' "$0"; exit 2; fi
NAME=$1; TARGET=$2; FILTER=$3; MUTATE="$(readlink -f "$4")"; shift 4      # 이제 "$@" = 대상 파일들

HERE="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
[ -f "$ROOT/config.env" ] && . "$ROOT/config.env"      # 파일 값이 환경변수보다 우선 (track.py 와 동일)
SRC="${CHROMIUM_SRC:-$HOME/chromium/src}"; OUT="${CHROMIUM_OUT:-out/Default}"; FLAGS="${TEST_FLAGS-}"
echo "===== [$NAME] SRC=$SRC OUT=$OUT FLAGS=${FLAGS:-(없음)} ====="
L="$HERE/../logs"; mkdir -p "$L"; L="$(cd "$L" && pwd)"
B="$L/${NAME}_mutation_backup"; M="$L/${NAME}_mutation_done.marker"
rm -f "$M"; rm -rf "$B"; mkdir -p "$B"
cd "$SRC" || { echo "CHROMIUM_SRC 없음: $SRC — config.env 확인" >&2; exit 1; }

for f in "$@"; do mkdir -p "$B/$(dirname "$f")"; cp "$f" "$B/$f"; done
restore() { for f in "$@"; do cp "$B/$f" "$f"; done; echo "===== 원복 완료 ($#개 파일) ====="; }
trap 'restore "$@"' EXIT

build_and_test() {  # $1 = mutated | restored  → 테스트 바이너리 종료 코드 반환, 빌드 실패면 99
  autoninja -C "$OUT" "$TARGET" > "$L/${NAME}_mutation_build_$1.log" 2>&1 || return 99
  "$OUT/$TARGET" $FLAGS --gtest_filter="$FILTER" > "$L/${NAME}_mutation_test_$1.log" 2>&1
}

echo "===== [$NAME] 변이 적용: $MUTATE ====="
"$MUTATE" || { echo "변이 스크립트 실패 — 대상 코드가 바뀌었는지 확인" >&2; exit 1; }
build_and_test mutated; ME=$?
if [ $ME -eq 99 ]; then echo "변이 상태에서 빌드 실패 — 컴파일되는 변이로 고칠 것 ($L/${NAME}_mutation_build_mutated.log)" >&2; exit 1; fi
echo "mutation_exit=$ME   (0 이 아니어야 테스트에 이빨이 있는 것)" | tee "$M"

restore "$@"; trap - EXIT
build_and_test restored; RE=$?
echo "restored_exit=$RE   (0 이어야 함)" | tee -a "$M"

if [ $ME -ne 0 ] && [ $RE -eq 0 ]; then
  echo "===== 변이 테스트 통과 ✓ — 테스트가 그 코드를 지킨다 ====="
else
  echo "===== 변이 테스트 실패 — 변이가 살아남았거나(테스트가 못 잡음) 원복 후에도 실패. 로그: $L/${NAME}_mutation_* =====" >&2
  exit 1
fi
