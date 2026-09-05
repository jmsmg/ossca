#!/bin/bash
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"   # 이 스크립트 기준 ../logs
cd "$HOME/chromium/src" || exit 1
rm -f "$L/pmp_done.marker"
autoninja -C out/Default components_unittests 2>&1 | tee "$L/pmp_build.log"
if ! grep -q "Build Succeeded" "$L/pmp_build.log"; then
  echo "BUILD_FAILED" > "$L/pmp_done.marker"; exit 1
fi
out/Default/components_unittests --ozone-platform=headless \
  --gtest_filter='*ManifestParser*' 2>&1 | tee "$L/pmp_test.log" | tail -6
echo "DONE" > "$L/pmp_done.marker"
