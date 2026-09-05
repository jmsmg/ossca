#!/bin/bash
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"   # 이 스크립트 기준 ../logs
cd "$HOME/chromium/src" || exit 1
rm -f "$L/mutation_done.marker"
F=storage/browser/quota/quota_database.cc
cp "$F" /tmp/quota_database.cc.orig

# 변이: Commit()에서 트랜잭션 재시작을 제거 -> 새 테스트가 반드시 실패해야 함
python3 - <<'PY'
import pathlib
p = pathlib.Path('storage/browser/quota/quota_database.cc'); s = p.read_text()
old = """  transaction_.emplace(db_.get());
  if (!transaction_->Begin()) {
    // Statements run in autocommit until a later commit manages to start a new
    // transaction. They are still durable, just not batched.
    transaction_.reset();
  }
}"""
new = """  transaction_.reset();  // MUTATION: re-Begin removed
}"""
assert old in s
p.write_text(s.replace(old, new))
PY

autoninja -C out/Default storage_unittests > "$L/mutation_build.log" 2>&1
out/Default/storage_unittests --ozone-platform=headless \
  --gtest_filter='*LongRunningTransactionIsReopenedAfterCommit*' \
  > "$L/mutation_test.log" 2>&1
echo "mutation_exit=$?" > "$L/mutation_done.marker"

# 원복
cp /tmp/quota_database.cc.orig "$F"
autoninja -C out/Default storage_unittests >> "$L/mutation_build.log" 2>&1
out/Default/storage_unittests --ozone-platform=headless \
  --gtest_filter='*LongRunningTransactionIsReopenedAfterCommit*' \
  > "$L/restored_test.log" 2>&1
echo "restored_exit=$?" >> "$L/mutation_done.marker"
