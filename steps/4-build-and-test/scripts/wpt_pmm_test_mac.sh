#!/bin/bash
# 545843242 WPT 수정 검증 (Mac): blink_tests(content_shell) 빌드 → payment-method-manifest 디렉터리 전체 web test 실행.
# 사용자 tmux에서:  bash ~/Desktop/ossca/steps/4-build-and-test/scripts/wpt_pmm_test_mac.sh   (caffeinate는 에이전트가 붙임)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/wpt_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q wpt-pmm-multiple-link-headers-545843242 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
nice -n 5 autoninja -j 4 -C out/Default blink_tests > "$L/wpt_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/wpt_build.log"; then
  third_party/blink/tools/run_web_tests.py -t Default --no-show-results \
    external/wpt/payment-method-manifest/ > "$L/wpt_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
