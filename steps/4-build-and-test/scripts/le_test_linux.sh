#!/bin/bash
# LE Glanceables Tasks 만료 히스토그램 4개 제거 검증 — 브랜치 glanceables-tasks-expired-histograms (cros-base 위), out/cros 증분 unit_tests
# 대조군(수정 전, LD 때 빌드한 unit_tests): TasksClientImpl* 36/36 → 기대 36 (테스트 삭제 없음, 검사 문장만 삭제)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/le_done.marker"; rm -f "$M"
fail() { echo "$1" >> "$M"; echo END >> "$M"; exit 1; }
cd "$HOME/chromium/src" || fail "NO_SRC"
git checkout -q glanceables-tasks-expired-histograms || fail "CHECKOUT_FAILED"
echo "HEAD=$(git log -1 --format=%h)" >> "$M"
gn gen out/cros > "$L/le_gn.log" 2>&1 || fail "GN=$?"
gn check out/cros '//chrome/browser/ash/api/tasks/*' > "$L/le_gncheck.log" 2>&1; echo "GN_CHECK=$?" >> "$M"
python3 tools/metrics/histograms/validate_format.py > "$L/le_xml.log" 2>&1; echo "XML_VALIDATE=$?" >> "$M"
autoninja -C out/cros unit_tests > "$L/le_build.log" 2>&1
grep -q 'Build Succeeded' "$L/le_build.log" || fail "BUILD=FAILED"
echo "BUILD=0" >> "$M"
testing/xvfb.py out/cros/unit_tests --gtest_filter='TasksClientImpl*' \
  > "$L/le_test.log" 2>&1; echo "TEST=$?" >> "$M"
echo END >> "$M"
