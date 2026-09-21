#!/bin/bash
# 474398415 kWebCodecsDecoderFlushOptimizations 킬스위치 제거 검증 (Mac).
# 트리가 09-21 main으로 앞서가 있어 먼저 gclient sync → gn check → blink_unittests(-j 4) → webcodecs 디코더 테스트.
# 사용자 tmux에서 (전원 연결 후):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/webcodecs_flush_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/webcodecs_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q webcodecs-flush-killswitch-474398415 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
gclient sync -D > "$L/webcodecs_sync.log" 2>&1
echo "SYNC=$?" >> "$M"
gn gen out/Default > "$L/webcodecs_gn.log" 2>&1 && gn check out/Default "//third_party/blink/renderer/modules/webcodecs/*" >> "$L/webcodecs_gn.log" 2>&1 && gn check out/Default "//media/base/*" >> "$L/webcodecs_gn.log" 2>&1
echo "GNCHECK=$?" >> "$M"
nice -n 5 autoninja -j 4 -C out/Default blink_unittests > "$L/webcodecs_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/webcodecs_build.log"; then
  out/Default/blink_unittests --gtest_filter='AudioDecoder*:VideoDecoder*:DecoderTemplate*:DecoderSelector*' > "$L/webcodecs_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
