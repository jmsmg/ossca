#!/bin/bash
# K(335524391 Navigation.Prefetch.*BodySize 만료 히스토그램 제거) 검증 (Mac).
# 브랜치 prefetch-body-size-histograms-335524391 에서 unit_tests 빌드 → PrefetchManager 테스트.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/k_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/k_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q prefetch-body-size-histograms-335524391 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default unit_tests > "$L/k_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/k_build.log"; then
  out/Default/unit_tests --gtest_filter='PrefetchManager*:*LoadingPredictor*' > "$L/k_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
