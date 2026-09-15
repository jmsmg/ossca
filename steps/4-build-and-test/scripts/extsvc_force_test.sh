#!/bin/bash
# extension_service.cc의 만료된 강제설치 재활성화 우회(M107, OSSCA #443) 제거 검증
#   테스트는 chrome/browser/extensions 쪽이라 unit_tests 타깃. 리눅스 4코어 박스, base 233e625e 증분 빌드
#   사용법: extsvc_force_test.sh [태그] [gtest 필터]   (기본 태그 extsvc, 필터 ExtensionServiceTest.*Force*)
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
TAG="${1:-extsvc}"; FILTER="${2:-ExtensionServiceTest.*Force*}"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/${TAG}_done.marker"
echo "===== [1/2] build unit_tests ($(date +%H:%M:%S)) ====="
autoninja -C out/Default unit_tests 2>&1 | tee "$L/${TAG}_build.log" | tail -3
if ! grep -q "Build Succeeded\|build finished successfully" "$L/${TAG}_build.log"; then echo "BUILD_FAILED" > "$L/${TAG}_done.marker"; exit 1; fi
echo "===== [2/2] unit_tests --gtest_filter='$FILTER' ($(date +%H:%M:%S)) ====="
out/Default/unit_tests --gtest_filter="$FILTER" --ozone-platform=headless 2>&1 | tee "$L/${TAG}_test.log" | tail -8
if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "TEST_FAILED" > "$L/${TAG}_done.marker"; exit 1; fi
echo "DONE" > "$L/${TAG}_done.marker"
echo "===== 완료 ($(date +%H:%M:%S)) ====="
