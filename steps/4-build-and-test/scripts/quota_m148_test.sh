#!/bin/bash
# quota 만료 NotFatalUntil::M148 정리 (153곳/10파일) 검증
#   storage/browser/quota만 건드리므로 base 헤더 무효화 없음 → 증분 빌드 기대
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/qm148_done.marker"
echo "===== [1/2] build storage_unittests ====="
autoninja -C out/Default storage_unittests 2>&1 | tee "$L/qm148_build.log"
if ! grep -q "Build Succeeded" "$L/qm148_build.log"; then echo "BUILD_FAILED" > "$L/qm148_done.marker"; exit 1; fi
echo "===== [2/2] quota 테스트 ====="
out/Default/storage_unittests --gtest_filter='Quota*:*Quota*:UsageTracker*:ClientUsageTracker*:StorageDirectory*-QuotaConfigs/QuotaManagerImplParamTest.ReportedQuotaConfigurability/*' \
  2>&1 | tee "$L/qm148_test.log" | tail -8
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "TEST_FAILED" > "$L/qm148_done.marker"; exit 1; fi
echo "DONE" > "$L/qm148_done.marker"
echo "===== 완료 ====="
