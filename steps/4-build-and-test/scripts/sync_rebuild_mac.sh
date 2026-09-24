#!/bin/bash
# 밤새 돌려 두는 트리 최신화 (Mac): main 을 origin/main 으로 옮기고 gclient sync → 자주 쓰는 테스트 바이너리 4개 재빌드.
# 목적: 다음 CL 을 최신 main 에서 바로 시작하고, 리뷰 코멘트로 PS2 가 필요할 때 리베이스 후 재빌드를 짧게.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/sync_rebuild_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/sync_rebuild_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git fetch -q origin main && git checkout -q -B main origin/main || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
echo "HEAD=$(git log -1 --format='%h %ad' --date=short)" >> "$M"
update_depot_tools > "$L/sync_rebuild_sync.log" 2>&1
gclient sync -D >> "$L/sync_rebuild_sync.log" 2>&1
echo "SYNC=$?" >> "$M"
for t in unit_tests browser_tests media_unittests components_unittests; do
  autoninja -C out/Default $t > "$L/sync_rebuild_$t.log" 2>&1
  echo "BUILD_$t=$?" >> "$M"
done
echo END >> "$M"
