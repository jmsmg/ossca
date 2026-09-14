#!/bin/bash
# 선행 빌드 (Mac): components_unittests → base_unittests. 테스트는 안 돌림. 로그·마커는 ../logs
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools:/opt/homebrew/bin:/usr/local/bin"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/components_build_done.marker"
nice -n 5 autoninja -j 6 -C out/Default components_unittests > "$L/components_build.log" 2>&1
echo "COMPONENTS=$?" >> "$L/components_build_done.marker"
nice -n 5 autoninja -j 6 -C out/Default base_unittests > "$L/base_build.log" 2>&1
echo "BASE=$?" >> "$L/components_build_done.marker"
echo END >> "$L/components_build_done.marker"
