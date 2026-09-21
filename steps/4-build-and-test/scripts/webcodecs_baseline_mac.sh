#!/bin/bash
# 474398415: DecoderTemplateTest/0.ResetDuringFlush 크래시가 우리 변경 탓인지 확인 — main(변경 없음)으로 blink_unittests 재링크 후 같은 배치 실행.
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/webcodecs_baseline_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q main || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
nice -n 5 autoninja -j 4 -C out/Default blink_unittests > "$L/webcodecs_baseline_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/webcodecs_baseline_build.log"; then
  out/Default/blink_unittests --gtest_filter='AudioDecoder*:VideoDecoder*:DecoderTemplate*:DecoderSelector*' > "$L/webcodecs_baseline_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
git checkout -q webcodecs-flush-killswitch-474398415
echo END >> "$M"
