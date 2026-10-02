#!/bin/bash
# LA arc_nearby_share_uma 만료 히스토그램 제거 검증 — 브랜치 arc-nearby-share-expired-histograms (cros-base 위), out/cros 증분
# 사용: bash ~/ossca/steps/4-build-and-test/scripts/la_test_linux.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/la_done.marker"; rm -f "$M"
fail() { echo "$1" >> "$M"; echo END >> "$M"; exit 1; }
cd "$HOME/chromium/src" || fail "NO_SRC"
git checkout -q arc-nearby-share-expired-histograms || fail "CHECKOUT_FAILED"
echo "HEAD=$(git log -1 --format=%h)" >> "$M"
gn gen out/cros > "$L/la_gn.log" 2>&1 || fail "GN=$?"
gn check out/cros '//chrome/browser/ash/arc/nearby_share/*' > "$L/la_gncheck.log" 2>&1; echo "GN_CHECK=$?" >> "$M"
python3 tools/metrics/histograms/validate_format.py > "$L/la_xml.log" 2>&1; echo "XML_VALIDATE=$?" >> "$M"
autoninja -C out/cros unit_tests > "$L/la_build.log" 2>&1
grep -q 'Build Succeeded' "$L/la_build.log" || fail "BUILD=FAILED"
echo "BUILD=0" >> "$M"
testing/xvfb.py out/cros/unit_tests --gtest_filter='*NearbyShare*:ShareInfoFileStreamAdapterTest.*' \
  > "$L/la_test.log" 2>&1; echo "TEST=$?" >> "$M"
echo END >> "$M"
