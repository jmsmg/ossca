#!/bin/bash
# 41161335 kSuspendMediaForFrozenFrames 플래그 제거 검증 (Mac). blink_unittests 증분 → WebMediaPlayerImplTest.* 실행.
# 사용자 tmux에서:  bash ~/Desktop/ossca/steps/4-build-and-test/scripts/frozen_frames_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/frozen_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q suspend-frozen-frames-flag-41161335 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default blink_unittests > "$L/frozen_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/frozen_build.log"; then
  out/Default/blink_unittests --gtest_filter='WebMediaPlayerImplTest.*' > "$L/frozen_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
