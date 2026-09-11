#!/bin/bash
# sql ColumnTime 마이그레이션 CL 1 (40176243, history 3파일 10곳) 검증
#   components_unittests → HistoryBackendDB(다운로드) · URLDatabase/HistoryBackend/HistoryService(keyword search term)
#   · VisitAnnotationsDatabase(context annotations 읽기·쓰기)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/hct_done.marker"
echo "===== [1/2] build components_unittests ====="
autoninja -C out/Default components_unittests 2>&1 | tee "$L/hct_build.log"
if ! grep -q "Build Succeeded" "$L/hct_build.log"; then echo "BUILD_FAILED" > "$L/hct_done.marker"; exit 1; fi
echo "===== [2/2] history 테스트 ====="
out/Default/components_unittests --ozone-platform=headless \
  --gtest_filter='HistoryBackendDBTest.*:URLDatabaseTest.*:VisitAnnotationsDatabaseTest.*:HistoryBackendTest.*:HistoryServiceTest.*' \
  2>&1 | tee "$L/hct_test.log" | tail -8
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "TEST_FAILED" > "$L/hct_done.marker"; exit 1; fi
echo "DONE" > "$L/hct_done.marker"
echo "===== 완료 ====="
