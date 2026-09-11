#!/bin/bash
# 545843242 PS5 리베이스 검증 (base b24e51fe → origin/main 233e625e, 2,271 커밋)
#   DEPS 219줄 변경 → gclient sync 필요 · base/ 61파일 변경 → 전 트리 재빌드
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/pmd4_done.marker"
echo "===== [1/3] gclient sync ====="
gclient sync 2>&1 | tee "$L/pmd4_sync.log"
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "SYNC_FAILED" > "$L/pmd4_done.marker"; exit 1; fi
echo "===== [2/3] build components_unittests ====="
autoninja -C out/Default components_unittests 2>&1 | tee "$L/pmd4_build.log"
if ! grep -q "Build Succeeded" "$L/pmd4_build.log"; then echo "BUILD_FAILED" > "$L/pmd4_done.marker"; exit 1; fi
echo "===== [3/3] tests ====="
out/Default/components_unittests --ozone-platform=headless \
  --gtest_filter='PaymentMethodManifestDownloaderTest.*' 2>&1 | tee "$L/pmd4_test.log" | tail -6
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "TEST_FAILED" > "$L/pmd4_done.marker"; exit 1; fi
echo "DONE" > "$L/pmd4_done.marker"
echo "===== 완료 ====="
