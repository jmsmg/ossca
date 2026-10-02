#!/bin/bash
# HC(Navigation.Prefetch 남은 만료 3개) + HJ(Mac.AppCodeSignClone* 만료 5개) 검증 (Mac). 두 브랜치를 차례로 unit_tests 증분 빌드 → 테스트.
# 전제: sync 러너(sync_rebuild_mac.sh)가 돌고 있지 않을 것 — 같은 out/Default 를 동시에 빌드하면 안 된다 (돌고 있으면 바로 멈춤).
# 사용자 tmux에서 (전원 연결):  caffeinate -s -i bash ~/Desktop/ossca/steps/4-build-and-test/scripts/hc_hj_test_mac.sh
# 로그는 «다른» tmux 창에서: tail -f ~/Desktop/ossca/steps/4-build-and-test/logs/hchj_done.marker
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/hchj_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
if pgrep -f "sync_rebuild_mac.sh" > /dev/null; then echo "SYNC_RUNNER_STILL_RUNNING" >> "$M"; echo END >> "$M"; exit 1; fi
for pair in "prefetch-manager-expired-histograms:*PrefetchManager*" "code-sign-clone-expired-histograms:CodeSignCloneManagerTest.*"; do
  b="${pair%%:*}"; f="${pair#*:}"
  git checkout -q "$b" || { echo "CHECKOUT_FAILED $b" >> "$M"; continue; }
  date "+START $b %T" >> "$M"
  autoninja -C out/Default unit_tests > "$L/hchj_build_$b.log" 2>&1
  echo "BUILD_$b=$?" >> "$M"
  if grep -q 'Build Succeeded' "$L/hchj_build_$b.log"; then
    out/Default/unit_tests --gtest_filter="$f" > "$L/hchj_test_$b.log" 2>&1
    echo "TEST_$b=$?" >> "$M"
  fi
done
git checkout -q main
echo END >> "$M"
