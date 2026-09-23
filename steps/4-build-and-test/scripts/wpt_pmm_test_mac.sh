#!/bin/bash
# 545843242 WPT 수정 검증 (Mac): chrome+chromedriver 빌드 → payment-method-manifest 디렉터리를 run_wpt_tests.py -p chrome 으로 실행.
# (이 디렉터리는 web_tests/TestLists/chrome.filter 에 있어 content_shell 로는 안 돈다 — 09-23 확인. 09-23 실측: 9/9 PASS, 7초)
# 사용자 tmux에서:  bash ~/Desktop/ossca/steps/4-build-and-test/scripts/wpt_pmm_test_mac.sh   (caffeinate는 에이전트가 붙임)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/wpt_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q wpt-pmm-multiple-link-headers-545843242 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
# payment-method-manifest 는 TestLists/chrome.filter 에 있어 chromedriver+Chrome 으로만 돈다 (content_shell 불가)
autoninja -C out/Default chrome chromedriver > "$L/wpt_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/wpt_build.log"; then
  third_party/blink/tools/run_wpt_tests.py -t Default -p chrome --no-show-results \
    external/wpt/payment-method-manifest/ > "$L/wpt_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
