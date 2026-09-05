#!/bin/bash
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"   # 이 스크립트 기준 ../logs
rm -f "$L/pmdw_done.marker"
cd ~/chromium/src || exit 1
out/Default/components_unittests --ozone-platform=headless \
  --gtest_filter='*ManifestDownloader*:*PaymentManifestParser*' 2>&1 | tee "$L/pmdw_test.log" | tail -4
echo "DONE" > "$L/pmdw_done.marker"
