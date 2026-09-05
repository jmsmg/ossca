#!/bin/bash
# 범용 빌드+테스트 러너 — 로그와 완료 마커를 ../logs/ 에 남긴다. **tmux 안에서 실행할 것.**
#
# 사용법: run.sh [--sync] [--test-only] <이름> <빌드타깃> [gtest_filter]
#   --sync         빌드 전에 gclient sync (리베이스 직후 등)
#   --test-only    빌드 생략, 테스트만 (이미 빌드된 바이너리 재사용 — 필터만 바꿔 다시 돌릴 때)
#   <이름>         로그 접두어: logs/<이름>_build.log · <이름>_test.log · <이름>_done.marker
#   <빌드타깃>     autoninja 타깃 = 테스트 바이너리 (components_unittests, storage_unittests …)
#   [gtest_filter] 생략하면 빌드만 한다
# 예:
#   run.sh pmd components_unittests 'PaymentMethodManifestDownloaderTest.*'
#   run.sh --test-only pmd_wide components_unittests '*ManifestDownloader*:*PaymentManifestParser*'
#   run.sh --sync quota storage_unittests '*Quota*'
# 완료 판정: logs/<이름>_done.marker 내용이 OK / BUILD_FAILED / TEST_FAILED / SYNC_FAILED
# 설정: 루트 config.env 의 CHROMIUM_SRC · CHROMIUM_OUT · TEST_FLAGS (SETUP.md)
set -u
# autoninja 가 AI 에이전트 환경을 감지하면 --quiet 을 붙여 점만 찍으므로 해제
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT

SYNC=0; TEST_ONLY=0
while [ $# -gt 0 ] && [ "${1#--}" != "$1" ]; do
  case "$1" in
    --sync) SYNC=1 ;;
    --test-only) TEST_ONLY=1 ;;
    *) echo "알 수 없는 옵션: $1" >&2; exit 2 ;;
  esac
  shift
done
if [ $# -lt 2 ]; then sed -n '2,16p' "$0"; exit 2; fi
NAME=$1; TARGET=$2; FILTER=${3:-}

HERE="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"                       # 저장소 루트 (= $OSSCA)
[ -f "$ROOT/config.env" ] && . "$ROOT/config.env"      # 파일 값이 환경변수보다 우선 (track.py 와 동일)
SRC="${CHROMIUM_SRC:-$HOME/chromium/src}"; OUT="${CHROMIUM_OUT:-out/Default}"; FLAGS="${TEST_FLAGS-}"
echo "===== [$NAME] SRC=$SRC OUT=$OUT FLAGS=${FLAGS:-(없음)} ====="
L="$HERE/../logs"; mkdir -p "$L"; L="$(cd "$L" && pwd)"    # 로그·마커는 이 단계의 logs/ — 홈 최상위에 파일 금지
M="$L/${NAME}_done.marker"; rm -f "$M"
cd "$SRC" || { echo "CHROMIUM_SRC 없음: $SRC — config.env 확인" >&2; exit 1; }

finish() { echo "$1" > "$M"; echo "===== 완료: $1 ($(date '+%m-%d %H:%M')) — 마커 $M ====="; }

if [ $SYNC -eq 1 ]; then
  echo "===== [$NAME] gclient sync ($(date '+%m-%d %H:%M')) ====="
  gclient sync 2>&1 | tee "$L/${NAME}_sync.log"
  [ "${PIPESTATUS[0]}" -eq 0 ] || { finish SYNC_FAILED; exit 1; }
fi

if [ $TEST_ONLY -eq 0 ]; then
  echo "===== [$NAME] build $TARGET ($(date '+%m-%d %H:%M')) ====="
  autoninja -C "$OUT" "$TARGET" 2>&1 | tee "$L/${NAME}_build.log"
  grep -q "Build Succeeded" "$L/${NAME}_build.log" || { finish BUILD_FAILED; exit 1; }
fi

if [ -n "$FILTER" ]; then
  echo "===== [$NAME] test $TARGET --gtest_filter=$FILTER ====="
  # $FLAGS 는 의도적으로 따옴표 없이 — 플래그 여러 개를 공백으로 나눠 넘기기 위함
  "$OUT/$TARGET" $FLAGS --gtest_filter="$FILTER" 2>&1 | tee "$L/${NAME}_test.log" | tail -6
  [ "${PIPESTATUS[0]}" -eq 0 ] || { finish TEST_FAILED; exit 1; }
fi
finish OK
