#!/bin/bash
# extension_prefs의 만료된 install_time 마이그레이션 제거 (M113, 42 마일스톤 경과) 검증
#   테스트는 chrome/browser/extensions 쪽이라 unit_tests 타깃
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/extprefs_done.marker"
echo "===== [1/2] build unit_tests ====="
autoninja -C out/Default unit_tests 2>&1 | tee "$L/extprefs_build.log"
if ! grep -q "Build Succeeded" "$L/extprefs_build.log"; then echo "BUILD_FAILED" > "$L/extprefs_done.marker"; exit 1; fi
echo "===== [2/2] ExtensionPrefs 테스트 ====="
out/Default/unit_tests --gtest_filter='ExtensionPrefs*' 2>&1 | tee "$L/extprefs_test.log" | tail -8
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "TEST_FAILED" > "$L/extprefs_done.marker"; exit 1; fi
echo "DONE" > "$L/extprefs_done.marker"
echo "===== 완료 ====="
