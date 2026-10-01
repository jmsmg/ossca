#!/bin/bash
# HH(BackgroundSync 만료 히스토그램 19개 제거) 검증 (Mac). content_unittests 첫 빌드(긴 빌드) → *BackgroundSync* 테스트.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/hh_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/hh_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q background-sync-expired-histograms || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
date "+START %F %T" >> "$M"
autoninja -C out/Default content_unittests > "$L/hh_build.log" 2>&1
echo "BUILD=$?" >> "$M"
date "+BUILT %F %T" >> "$M"
if grep -q 'Build Succeeded' "$L/hh_build.log"; then
  out/Default/content_unittests --gtest_filter='*BackgroundSync*' > "$L/hh_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
