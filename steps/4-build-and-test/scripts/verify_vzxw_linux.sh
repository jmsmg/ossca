#!/bin/bash
# V·Z·X·W(ChromeOS 후보) 통합 검증 — 브랜치 verify-vzxw(cros-base + 4커밋), out/cros 증분 빌드
#   대조군은 cros_base_linux.sh 결과(Z 7 · V 46 · X+Y 33). 기대: Z 5 · V 45 · X+Y 32 (지운 테스트만큼 감소)
# 사용: bash ~/ossca/steps/4-build-and-test/scripts/verify_vzxw_linux.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/vzxw_done.marker"; rm -f "$M"
fail() { echo "$1" >> "$M"; echo END >> "$M"; exit 1; }
cd "$HOME/chromium/src" || fail "NO_SRC"
git checkout -q verify-vzxw || fail "CHECKOUT_FAILED"
echo "HEAD=$(git log -1 --format=%h)" >> "$M"
gn gen out/cros > "$L/vzxw_gn.log" 2>&1 || fail "GN=$?"
rc=0; for t in '//chrome/browser/web_applications/*' '//ash:ash' '//remoting/host/chromeos/*' '//chrome/browser/ui/ash/shelf/*'; do
  gn check out/cros "$t" >> "$L/vzxw_gncheck.log" 2>&1 || rc=1; done; echo "GN_CHECK=$rc" >> "$M"
autoninja -C out/cros ash_unittests unit_tests remoting_unittests > "$L/vzxw_build.log" 2>&1
grep -q 'Build Succeeded' "$L/vzxw_build.log" || fail "BUILD=FAILED"
echo "BUILD=0" >> "$M"
testing/xvfb.py out/cros/ash_unittests --gtest_filter='GraphicsTabletPrefHandlerTest.*' \
  > "$L/vzxw_ash_test.log" 2>&1; echo "TEST_ASH=$?" >> "$M"
testing/xvfb.py out/cros/remoting_unittests --gtest_filter='*RemoteSupportHostAshTest*' \
  > "$L/vzxw_remoting_test.log" 2>&1; echo "TEST_REMOTING=$?" >> "$M"
testing/xvfb.py out/cros/unit_tests --gtest_filter='ChromeShelfPrefsTest.*:FileSystemProviderServiceTest.*' \
  > "$L/vzxw_unit_test.log" 2>&1; echo "TEST_UNIT=$?" >> "$M"
echo END >> "$M"
