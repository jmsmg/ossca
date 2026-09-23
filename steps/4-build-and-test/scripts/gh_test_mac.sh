#!/bin/bash
# G(496016840 webview script origin) + H(489205993 actor popups) 킬스위치 제거 검증 (Mac).
# 통합 브랜치 verify-gh (2ca4848 + G + H) 에서 browser_tests 한 번 빌드 → 원 CL 이 추가한 테스트 실행.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/gh_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/gh_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q verify-gh || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default browser_tests > "$L/gh_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/gh_build.log"; then
  out/Default/browser_tests --gtest_filter='WebUIWebViewBrowserTest.*' > "$L/gh_test_webview.log" 2>&1
  echo "TEST_G=$?" >> "$M"
  out/Default/browser_tests --gtest_filter='ActorAttemptLoginToolFederatedTest.*' > "$L/gh_test_actor.log" 2>&1
  echo "TEST_H=$?" >> "$M"
fi
echo END >> "$M"
