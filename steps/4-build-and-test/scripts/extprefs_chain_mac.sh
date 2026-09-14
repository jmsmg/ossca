#!/bin/bash
# extensions M113 검증 체인 (Mac): ① 오브젝트 2개 → ② unit_tests → ③ ExtensionPrefs* 테스트. 로그·마커는 ../logs
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
nice -n 5 autoninja -j 6 -C out/Default obj/extensions/browser/browser_sources/extension_prefs.o obj/chrome/browser/extensions/unit_tests/extension_prefs_unittest.o >> "$L/extprefs_obj.log" 2>&1
echo "OBJ=$?" >> "$L/extprefs_done.marker"
if grep -q 'Build Succeeded' "$L/extprefs_obj.log"; then
  nice -n 5 autoninja -j 6 -C out/Default unit_tests > "$L/extprefs_build.log" 2>&1
  echo "BUILD=$?" >> "$L/extprefs_done.marker"
  if grep -q 'Build Succeeded' "$L/extprefs_build.log"; then
    out/Default/unit_tests --gtest_filter='ExtensionPrefs*' > "$L/extprefs_test.log" 2>&1
    echo "TEST=$?" >> "$L/extprefs_done.marker"
  fi
fi
echo END >> "$L/extprefs_done.marker"
