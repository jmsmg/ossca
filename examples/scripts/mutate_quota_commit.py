#!/usr/bin/env python3
"""변이 스크립트 예시 — 범용 mutation_test.sh 에 넘기는 형태.

CL 8282239 (crbug 40831207) 의 회귀 테스트 LongRunningTransactionIsReopenedAfterCommit 가
정말 불변식을 지키는지 확인하기 위해, QuotaDatabase::Commit() 에서 트랜잭션 재-Begin 을 제거한다.
이 상태로 테스트가 **실패해야** 테스트에 이빨이 있는 것 (실제 결과: /0, /1 둘 다 FAILED → 원복 시 통과).

사용 (CHROMIUM_SRC 에서 실행됨):
  $OSSCA/steps/4-build-and-test/scripts/mutation_test.sh quota storage_unittests \
      '*LongRunningTransactionIsReopenedAfterCommit*' \
      $OSSCA/examples/scripts/mutate_quota_commit.py storage/browser/quota/quota_database.cc

같은 폴더의 mutation_test_quota.sh 는 이 변이를 셸 스크립트 안에 하드코딩했던 옛 형태.
"""
import pathlib

p = pathlib.Path("storage/browser/quota/quota_database.cc")
s = p.read_text()
old = """  transaction_.emplace(db_.get());
  if (!transaction_->Begin()) {
    // Statements run in autocommit until a later commit manages to start a new
    // transaction. They are still durable, just not batched.
    transaction_.reset();
  }
}"""
new = """  transaction_.reset();  // MUTATION: re-Begin removed
}"""
assert old in s, "변이 대상 코드가 없음 — 파일이 바뀌었는지 확인"
p.write_text(s.replace(old, new))
print("mutated:", p)
