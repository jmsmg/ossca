#!/bin/bash
# 8349386 PS3 (Feature 게이트 + 히스토그램): components_unittests 빌드 → PaymentMethodManifestDownloaderTest
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/pmd3_done.marker"
echo "===== [1/2] build components_unittests ====="
autoninja -C out/Default components_unittests 2>&1 | tee "$L/pmd3_build.log"
if ! grep -q "Build Succeeded" "$L/pmd3_build.log"; then echo "BUILD_FAILED" > "$L/pmd3_done.marker"; exit 1; fi
echo "===== [2/2] tests ====="
out/Default/components_unittests --ozone-platform=headless \
  --gtest_filter='PaymentMethodManifestDownloaderTest.*' 2>&1 | tee "$L/pmd3_test.log" | tail -6
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "TEST_FAILED" > "$L/pmd3_done.marker"; exit 1; fi
echo "DONE" > "$L/pmd3_done.marker"
echo "===== 완료 ====="
