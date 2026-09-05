#!/bin/bash
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"   # 이 스크립트 기준 ../logs
cd ~/chromium/src || exit 1
rm -f $L/quota_done.marker
autoninja -C out/Default storage_unittests > $L/quotabuild.log 2>&1
if grep -q "Build Succeeded" $L/quotabuild.log; then
  out/Default/storage_unittests --ozone-platform=headless --gtest_filter='*QuotaDatabase*' > $L/quota_test2.log 2>&1
  out/Default/storage_unittests --ozone-platform=headless --gtest_filter='*Quota*' > $L/quota_test3.log 2>&1
  echo "OK" > $L/quota_done.marker
else
  echo "BUILD_FAILED" > $L/quota_done.marker
fi
