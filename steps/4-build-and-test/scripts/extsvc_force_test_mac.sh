#!/bin/bash
# 8410065 PS2 검증 (Mac): unit_tests 빌드 → ExtensionServiceTest.* 실행.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/extsvc_force_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
BR="${1:-extension-service-force-install-workaround}"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/extsvc_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q "$BR" || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default unit_tests > "$L/extsvc_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/extsvc_build.log"; then
  out/Default/unit_tests --gtest_filter='ExtensionServiceTest.*' > "$L/extsvc_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
