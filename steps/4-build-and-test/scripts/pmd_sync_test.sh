#!/bin/bash
# 리베이스 후: gclient sync → components_unittests 빌드 → PaymentMethodManifestDownloaderTest
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/pmds_done.marker"
echo "===== [1/3] gclient sync ====="
gclient sync 2>&1 | tee "$L/pmds_sync.log"
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "SYNC_FAILED" > "$L/pmds_done.marker"; exit 1; fi
echo "===== [2/3] build components_unittests ====="
autoninja -C out/Default components_unittests 2>&1 | tee "$L/pmds_build.log"
if ! grep -q "Build Succeeded" "$L/pmds_build.log"; then echo "BUILD_FAILED" > "$L/pmds_done.marker"; exit 1; fi
echo "===== [3/3] tests ====="
out/Default/components_unittests --ozone-platform=headless \
  --gtest_filter='PaymentMethodManifestDownloaderTest.*' 2>&1 | tee "$L/pmds_test.log" | tail -6
echo "DONE" > "$L/pmds_done.marker"
echo "===== 완료 ====="
