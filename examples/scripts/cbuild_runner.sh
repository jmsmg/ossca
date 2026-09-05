#!/bin/bash
# [예시] 실제 CL 에서 쓴 러너 원본 (원래 위치: steps/4-build-and-test/scripts/). 경로는 ~/chromium/src 하드코딩.
#        새 작업은 범용 steps/4-build-and-test/scripts/run.sh (또는 mutation_test.sh) 를 쓴다 — examples/README.md
# autoninja가 AI 에이전트 환경을 감지하면 --quiet 을 붙여 점만 찍으므로 해제
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"   # 이 스크립트 기준 ../logs
cd "$HOME/chromium/src" || exit 1
rm -f "$L/cbuild_done.marker"
echo "===== build components_unittests ($(date +%m-%d\ %H:%M)) ====="
autoninja -C out/Default components_unittests 2>&1 | tee "$L/cbuild.log"
if grep -q "Build Succeeded" "$L/cbuild.log"; then
  echo "OK" > "$L/cbuild_done.marker"
else
  echo "BUILD_FAILED" > "$L/cbuild_done.marker"
fi
echo "===== 완료: $(cat "$L/cbuild_done.marker") ====="
