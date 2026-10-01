#!/bin/bash
# HG(Commerce.Heuristics.* 만료 히스토그램 6개 + 기록 helper 클래스 제거) 검증 (Mac). components_unittests 증분 빌드 → 커머스 테스트.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/hg_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/hg_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q commerce-heuristics-expired-histograms || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default components_unittests > "$L/hg_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/hg_build.log"; then
  out/Default/components_unittests --gtest_filter='CommerceFeatureListTest.*:CommerceHeuristicsDataTest.*' > "$L/hg_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
