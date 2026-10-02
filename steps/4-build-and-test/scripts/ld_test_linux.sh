#!/bin/bash
# LD schedqos 만료 히스토그램 제거 검증 — 브랜치 schedqos-expired-histograms (cros-base 위), out/cros 증분 unit_tests
# 대조군(수정 전, LA 때 빌드한 unit_tests): DBusSchedQOSStateHandlerTest.* 21/21 → 기대 15 (지표 전용 테스트 6개 삭제)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/ld_done.marker"; rm -f "$M"
fail() { echo "$1" >> "$M"; echo END >> "$M"; exit 1; }
cd "$HOME/chromium/src" || fail "NO_SRC"
git checkout -q schedqos-expired-histograms || fail "CHECKOUT_FAILED"
echo "HEAD=$(git log -1 --format=%h)" >> "$M"
gn gen out/cros > "$L/ld_gn.log" 2>&1 || fail "GN=$?"
gn check out/cros '//chrome/browser/ash/schedqos/*' > "$L/ld_gncheck.log" 2>&1; echo "GN_CHECK=$?" >> "$M"
python3 tools/metrics/histograms/validate_format.py > "$L/ld_xml.log" 2>&1; echo "XML_VALIDATE=$?" >> "$M"
autoninja -C out/cros unit_tests > "$L/ld_build.log" 2>&1
grep -q 'Build Succeeded' "$L/ld_build.log" || fail "BUILD=FAILED"
echo "BUILD=0" >> "$M"
testing/xvfb.py out/cros/unit_tests --gtest_filter='DBusSchedQOSStateHandlerTest.*' \
  > "$L/ld_test.log" 2>&1; echo "TEST=$?" >> "$M"
echo END >> "$M"
