#!/bin/bash
# 432367602 kMediaStreamAccurateDroppedFrameCount 플래그 제거 검증 (Mac).
# blink_unittests 첫 빌드(dry-run 21,814스텝) → WebMediaPlayerMSCompositor* 실행. 사용자 tmux에서 실행:
#   tmux new -s dropped 'caffeinate -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/dropped_frame_test_mac.sh'
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/dropped_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q dropped-frame-count-flag-432367602 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
nice -n 5 autoninja -j 6 -C out/Default blink_unittests > "$L/dropped_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/dropped_build.log"; then
  out/Default/blink_unittests --gtest_filter='WebMediaPlayerMSCompositor*' > "$L/dropped_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
