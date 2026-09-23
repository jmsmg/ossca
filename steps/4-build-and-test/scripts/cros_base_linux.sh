#!/bin/bash
# 리눅스 박스 첫 linux-chromeos 빌드 — 1단계 V~Z 후보(ChromeOS 코드, Mac 빌드 불가)의 베이스 + 대조군
#   origin/main → 브랜치 cros-base → gclient sync(chromeos deps 포함) → gn gen out/cros
#   → ash_unittests(Z) → unit_tests(X·Y·W) + remoting_unittests(V) → 수정 전 대조군 테스트(xvfb)
#   수정 브랜치는 이 cros-base 에서 딴다(origin/main 아님) — base가 같아야 다음 빌드가 증분으로 끝난다
# 사전 1회: ~/chromium/.gclient 끝에  target_os = ['chromeos']
# 사용자 tmux 에서:  tmux new -s cros  →  bash ~/ossca/steps/4-build-and-test/scripts/cros_base_linux.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/cros_base_done.marker"; rm -f "$M"
fail() { echo "$1" >> "$M"; echo END >> "$M"; exit 1; }
cd "$HOME/chromium/src" || fail "NO_SRC"
grep -q "^target_os.*chromeos" ../.gclient || fail "NO_TARGET_OS"

if git rev-parse -q --verify cros-base > /dev/null; then
  git checkout -q cros-base || fail "CHECKOUT_FAILED"
else
  git fetch origin && git checkout -q -b cros-base origin/main || fail "CHECKOUT_FAILED"
fi
echo "BASE=$(git log -1 --format='%h %cs')" >> "$M"

gclient sync > "$L/cros_sync.log" 2>&1 || fail "SYNC=$?"
echo "SYNC=0" >> "$M"

if [ ! -f out/cros/args.gn ]; then
  gn gen out/cros --args='target_os="chromeos" is_debug=false is_component_build=true symbol_level=0 blink_symbol_level=0 v8_symbol_level=0' \
    > "$L/cros_gn.log" 2>&1 || fail "GN=$?"
fi

autoninja -C out/cros ash_unittests > "$L/cros_ash_build.log" 2>&1
grep -q 'Build Succeeded' "$L/cros_ash_build.log" || fail "BUILD_ASH=FAILED"
echo "BUILD_ASH=0" >> "$M"
testing/xvfb.py out/cros/ash_unittests --gtest_filter='GraphicsTabletPrefHandlerTest.*' \
  > "$L/cros_base_ash_test.log" 2>&1; echo "TEST_ASH=$?" >> "$M"

autoninja -C out/cros unit_tests remoting_unittests > "$L/cros_build.log" 2>&1
grep -q 'Build Succeeded' "$L/cros_build.log" || fail "BUILD_CHROME=FAILED"
echo "BUILD_CHROME=0" >> "$M"
testing/xvfb.py out/cros/remoting_unittests --gtest_filter='*RemoteSupportHostAshTest*' \
  > "$L/cros_base_remoting_test.log" 2>&1; echo "TEST_REMOTING=$?" >> "$M"
testing/xvfb.py out/cros/unit_tests --gtest_filter='ChromeShelfPrefsTest.*:FileSystemProviderServiceTest.*' \
  > "$L/cros_base_unit_test.log" 2>&1; echo "TEST_UNIT=$?" >> "$M"
echo END >> "$M"
