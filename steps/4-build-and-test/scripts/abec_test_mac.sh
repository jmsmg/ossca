#!/bin/bash
# A(486351442 media)·B(495852034 viz)·E(524822746 viz)·C(gaia) 네 CL을 합친 검증 브랜치 verify-abec에서
# media_unittests + viz_unittests + google_apis_unittests 를 한 번에 빌드하고 각 필터를 실행.
# 사용자 tmux에서:  bash ~/Desktop/ossca/steps/4-build-and-test/scripts/abec_test_mac.sh   (caffeinate는 에이전트가 붙임)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/abec_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q verify-abec || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default media_unittests viz_unittests google_apis_unittests > "$L/abec_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/abec_build.log"; then
  out/Default/media_unittests --gtest_filter='SourceBufferStream*' > "$L/abec_media_test.log" 2>&1;      echo "TEST_MEDIA=$?" >> "$M"
  out/Default/viz_unittests --gtest_filter='HitTestAggregator*:*ImageContext*:SkiaOutputSurface*' > "$L/abec_viz_test.log" 2>&1; echo "TEST_VIZ=$?" >> "$M"
  out/Default/google_apis_unittests --gtest_filter='GaiaUrlsTest.*' > "$L/abec_gaia_test.log" 2>&1;      echo "TEST_GAIA=$?" >> "$M"
fi
echo END >> "$M"
