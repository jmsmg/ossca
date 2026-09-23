#!/bin/bash
# 545843242 WPT 수정 검증 (Mac): content_shell(+image_diff)만 빌드 → payment-method-manifest 디렉터리 web test 실행.
# (blink_tests는 blink_unittests의 거대 TU 2,000개를 끌고 와 수 시간 걸림 — web test에는 content_shell만 있으면 된다)
# 사용자 tmux에서:  bash ~/Desktop/ossca/steps/4-build-and-test/scripts/wpt_pmm_test_mac.sh   (caffeinate는 에이전트가 붙임)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/wpt_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q wpt-pmm-multiple-link-headers-545843242 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default content_shell image_diff > "$L/wpt_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/wpt_build.log"; then
  third_party/blink/tools/run_web_tests.py -t Default --no-show-results \
    external/wpt/payment-method-manifest/ > "$L/wpt_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
