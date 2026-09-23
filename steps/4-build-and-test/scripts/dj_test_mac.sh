#!/bin/bash
# D(379418979 kStrictFFmpegCodecs) + J(467555325 kAccurateVideoFrameConverterColorSpace) 검증 (Mac).
# 통합 브랜치 verify-dj (2ca4848 + D + J) 에서 media_unittests 한 번 빌드 → 두 필터.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/dj_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/dj_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q verify-dj || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default media_unittests > "$L/dj_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/dj_build.log"; then
  out/Default/media_unittests --gtest_filter='FFmpeg*:AudioFileReaderTest.*:AudioDecoderTest*:*FFmpegVideoDecoder*' > "$L/dj_test_ffmpeg.log" 2>&1
  echo "TEST_D=$?" >> "$M"
  out/Default/media_unittests --gtest_filter='*VideoFrameConverter*' > "$L/dj_test_converter.log" 2>&1
  echo "TEST_J=$?" >> "$M"
fi
echo END >> "$M"
