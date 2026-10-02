#!/bin/bash
# sql 시리즈 CL 5(autofill payments 읽기 4 + DeclarativePerformanceObserverStore 읽기 1·쓰기 4 → ColumnTime/BindTime) 검증 (Mac).
# components_unittests·content_unittests 증분 빌드 → 두 파일의 테스트.
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/sql_cl5_test_mac.sh
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/sqlcl5_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q sql-columntime-payments-dpo-40176243 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
date "+START %T" >> "$M"
autoninja -C out/Default components_unittests content_unittests > "$L/sqlcl5_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/sqlcl5_build.log"; then
  out/Default/components_unittests --gtest_filter='PaymentsAutofillTableTest.*:*AutofillTableTest*:WebDatabaseMigrationTest.*' > "$L/sqlcl5_test_components.log" 2>&1
  echo "TEST_components=$?" >> "$M"
  out/Default/content_unittests --gtest_filter='*DeclarativePerformanceObserver*' > "$L/sqlcl5_test_content.log" 2>&1
  echo "TEST_content=$?" >> "$M"
fi
date "+DONE %T" >> "$M"
echo END >> "$M"
