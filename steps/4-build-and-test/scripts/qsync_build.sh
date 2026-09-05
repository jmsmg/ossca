#!/bin/bash
# autoninja가 AI 에이전트 환경을 감지하면 --quiet 을 붙여 점만 찍으므로 해제
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"   # 이 스크립트 기준 ../logs
cd "$HOME/chromium/src" || exit 1
rm -f "$L/quota_done.marker"

echo "===== [1/3] gclient sync ====="
gclient sync 2>&1 | tee "$L/gclient_sync.log"
if [ "${PIPESTATUS[0]}" -ne 0 ]; then
  echo "SYNC_FAILED" > "$L/quota_done.marker"; exit 1
fi

echo "===== [2/3] build storage_unittests ====="
autoninja -C out/Default storage_unittests 2>&1 | tee "$L/quotabuild.log"
if ! grep -q "Build Succeeded" "$L/quotabuild.log"; then
  echo "BUILD_FAILED" > "$L/quota_done.marker"; exit 1
fi

echo "===== [3/3] tests ====="
out/Default/storage_unittests --ozone-platform=headless \
  --gtest_filter='*QuotaDatabase*' 2>&1 | tee "$L/quota_test2.log" | tail -5
out/Default/storage_unittests --ozone-platform=headless \
  --gtest_filter='*Quota*' 2>&1 | tee "$L/quota_test3.log" | tail -5
echo "OK" > "$L/quota_done.marker"
echo "===== 완료 ====="
