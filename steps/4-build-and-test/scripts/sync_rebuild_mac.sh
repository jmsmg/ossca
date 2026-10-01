#!/bin/bash
# 밤새 돌려 두는 트리 최신화 (Mac): main 을 origin/main 으로 옮기고 gclient sync → 자주 쓰는 테스트 바이너리 재빌드.
# 10-01: content_unittests(HH)·net_unittests(HA/HB/HD 후속 PS) 추가, 제일 긴 browser_tests 는 맨 뒤로. 인자로 대상을 주면 그것만 빌드.
# SKIP_SYNC=1 이면 fetch·gclient sync 없이 지금 main 에서 빌드만 (중단된 빌드 이어 하기).
# ⚠️ 로그는 반드시 «다른» tmux 창에서 tail -f — 빌드 창에서 Ctrl+C 하면 빌드가 죽는다 (10-01 18:06 사건).
# 목적: 다음 CL 을 최신 main 에서 바로 시작하고, 리뷰 코멘트로 PS2 가 필요할 때 리베이스 후 재빌드를 짧게.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/sync_rebuild_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/sync_rebuild_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
if [ "${SKIP_SYNC:-0}" = 1 ]; then
  # 빌드만 이어서 (sync 는 이미 끝난 상태): SKIP_SYNC=1 caffeinate -s -i bash <이 스크립트> [대상...]
  [ "$(git branch --show-current)" = main ] || { echo "NOT_ON_MAIN" >> "$M"; echo END >> "$M"; exit 1; }
  echo "HEAD=$(git log -1 --format='%h %ad' --date=short) (SKIP_SYNC)" >> "$M"
else
  git fetch -q origin main && git checkout -q -B main origin/main || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
  echo "HEAD=$(git log -1 --format='%h %ad' --date=short)" >> "$M"
  update_depot_tools > "$L/sync_rebuild_sync.log" 2>&1
  gclient sync -D >> "$L/sync_rebuild_sync.log" 2>&1
  echo "SYNC=$?" >> "$M"
fi
TARGETS="${*:-unit_tests content_unittests components_unittests net_unittests media_unittests browser_tests}"
for t in $TARGETS; do
  autoninja -C out/Default $t > "$L/sync_rebuild_$t.log" 2>&1
  echo "BUILD_$t=$?" >> "$M"
done
echo END >> "$M"
