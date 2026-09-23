#!/bin/bash
# 380105415 kMultipleLcppKeyInitiatorOriginFix 킬스위치 제거 검증 (Mac). unit_tests(sync 후 첫 빌드) → LCPP 테스트.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/lcpp_killswitch_test_mac.sh [브랜치]
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
BR="${1:-lcpp-initiator-origin-killswitch-380105415}"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/lcpp_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q "$BR" || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default unit_tests > "$L/lcpp_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/lcpp_build.log"; then
  out/Default/unit_tests --gtest_filter='LcpCriticalPathPredictor*:*Lcpp*:*LCPP*' > "$L/lcpp_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
