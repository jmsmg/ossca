#!/bin/bash
# HA(40874231 Net.DNS.DnsHosts.* 만료 히스토그램 제거) 검증 (Mac). net_unittests 빌드 → DnsHosts* 테스트.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/ha_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/ha_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q dns-hosts-expired-histograms-40874231 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default net_unittests > "$L/ha_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/ha_build.log"; then
  out/Default/net_unittests --gtest_filter='DnsHosts*:*HostsParser*:*DnsConfigService*' > "$L/ha_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
echo END >> "$M"
