#!/bin/bash
# #440 kResetDecoderForNonIDR 킬스위치 제거 검증 (Mac 전용 코드): media_unittests 빌드 → VideoToolboxH264Accelerator* 테스트
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/killswitch_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q reset-decoder-nonidr-killswitch || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default media_unittests > "$L/killswitch_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/killswitch_build.log"; then
  out/Default/media_unittests --gtest_filter='VideoToolboxH264Accelerator*' > "$L/killswitch_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
