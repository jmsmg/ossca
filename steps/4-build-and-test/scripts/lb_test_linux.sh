#!/bin/bash
# LB HPS 만료 히스토그램 제거 검증 — 브랜치 hps-expired-histograms (cros-base 위), out/cros 증분 ash_unittests
# 대조군(수정 전, 09-24 바이너리): SnoopingProtection*:PowerPrefs* 48/48 → 기대 42 (지표 전용 테스트 6개 삭제)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/lb_done.marker"; rm -f "$M"
fail() { echo "$1" >> "$M"; echo END >> "$M"; exit 1; }
cd "$HOME/chromium/src" || fail "NO_SRC"
git checkout -q hps-expired-histograms || fail "CHECKOUT_FAILED"
echo "HEAD=$(git log -1 --format=%h)" >> "$M"
gn gen out/cros > "$L/lb_gn.log" 2>&1 || fail "GN=$?"
rc=0; for t in '//ash:ash' '//ash:ash_unittests'; do gn check out/cros "$t" >> "$L/lb_gncheck.log" 2>&1 || rc=1; done; echo "GN_CHECK=$rc" >> "$M"
python3 tools/metrics/histograms/validate_format.py > "$L/lb_xml.log" 2>&1; echo "XML_VALIDATE=$?" >> "$M"
autoninja -C out/cros ash_unittests > "$L/lb_build.log" 2>&1
grep -q 'Build Succeeded' "$L/lb_build.log" || fail "BUILD=FAILED"
echo "BUILD=0" >> "$M"
testing/xvfb.py out/cros/ash_unittests --gtest_filter='SnoopingProtection*:PowerPrefs*' \
  > "$L/lb_test.log" 2>&1; echo "TEST=$?" >> "$M"
echo END >> "$M"
