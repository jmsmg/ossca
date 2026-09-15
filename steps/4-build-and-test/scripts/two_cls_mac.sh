#!/bin/bash
# 09-15 두 CL 검증 체인 (Mac, 사용자 tmux 에서 실행):
#   ① sql-columntime-nel-40176243  → gn gen → net_unittests → SQLitePersistentReportingAndNelStore*
#   ② expired-notfatal-m144-signin → unit_tests + base_unittests (base 헤더 변경 = 전 트리 재빌드) → 테스트
# 로그·마커는 ../logs/two_cls_*.log, two_cls_done.marker
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/two_cls_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
if [ -n "$(git status --short)" ]; then echo "DIRTY_TREE" >> "$M"; echo END >> "$M"; exit 1; fi

git checkout -q sql-columntime-nel-40176243 || { echo "CHECKOUT1_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
gn gen out/Default > "$L/two_cls_gn.log" 2>&1 || { echo "GN=1" >> "$M"; echo END >> "$M"; exit 1; }
nice -n 5 autoninja -j 6 -C out/Default net_unittests > "$L/two_cls_net_build.log" 2>&1
echo "NET_BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/two_cls_net_build.log"; then
  out/Default/net_unittests --gtest_filter='SQLitePersistentReportingAndNelStore*' > "$L/two_cls_net_test.log" 2>&1
  echo "NET_TEST=$?" >> "$M"
fi

git checkout -q expired-notfatal-m144-signin || { echo "CHECKOUT2_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
nice -n 5 autoninja -j 6 -C out/Default unit_tests base_unittests > "$L/two_cls_m144_build.log" 2>&1
echo "M144_BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/two_cls_m144_build.log"; then
  out/Default/unit_tests --gtest_filter='DiceWebSigninInterceptor*:TurnSyncOnHelper*' > "$L/two_cls_m144_unit_test.log" 2>&1
  echo "M144_UNIT_TEST=$?" >> "$M"
  out/Default/base_unittests --gtest_filter='CheckTest.*:CheckDeathTest.*' > "$L/two_cls_m144_base_test.log" 2>&1
  echo "M144_BASE_TEST=$?" >> "$M"
fi
echo END >> "$M"
