#!/bin/bash
# M143 만료 NotFatalUntil 정리 (438680281) 검증:
#   base/not_fatal_until.h 변경 → 사실상 전 트리 재빌드 (check.h 경유, 직전 풀빌드 16h08m)
#   components_unittests(PrefService*) + base_unittests(Check*) 두 타깃
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
cd "$HOME/chromium/src" || exit 1
rm -f "$L/pnf_done.marker"
echo "===== [1/3] build components_unittests base_unittests ====="
autoninja -C out/Default components_unittests base_unittests 2>&1 | tee "$L/pnf_build.log"
if ! grep -q "Build Succeeded" "$L/pnf_build.log"; then echo "BUILD_FAILED" > "$L/pnf_done.marker"; exit 1; fi
echo "===== [2/3] components_unittests PrefService* ====="
out/Default/components_unittests --ozone-platform=headless \
  --gtest_filter='PrefService*' 2>&1 | tee "$L/pnf_prefs_test.log" | tail -6
p1=${PIPESTATUS[0]}
echo "===== [3/3] base_unittests Check* (enum 변경 검증) ====="
out/Default/base_unittests --gtest_filter='CheckTest.*:CheckDeathTest.*' 2>&1 \
  | tee "$L/pnf_check_test.log" | tail -6
p2=${PIPESTATUS[0]}
if [ "$p1" -ne 0 ] || [ "$p2" -ne 0 ]; then echo "TEST_FAILED" > "$L/pnf_done.marker"; exit 1; fi
echo "DONE" > "$L/pnf_done.marker"
echo "===== 완료 ====="
