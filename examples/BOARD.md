# 이슈 × 단계 보드 — 채워진 예시 (2026-09-05 기준)

> 루트 [`BOARD.md`](../BOARD.md) 템플릿이 실제로 어떻게 채워졌는지. 이슈 7건이 동시에 진행 중이던 시점의 스냅샷.
> 각 이슈의 기록은 [`issues/`](issues/), 단계별 현황은 [`status/`](status/).

## 이슈 × 단계 보드 (2026-09-05 기준)

범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요

| crbug | 1 발굴 | 2 등록 | 3 수정 | 4 빌드 | 5 업로드 | 6 리뷰 | 7 기록 | 8 마무리 | 지금 어디 |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|---|
| 372283556 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 종료 |
| 443042812 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | 8 — OSSCA #334 Status 확인만 |
| 545645933 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | 8 — #375 머지 확인(09-03), OSSCA #369 Status `반영 완료` 코멘트만 남음 |
| 40831207 (CL A) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | 8 — `status: merged` PR #378 머지 확인(09-05), OSSCA #342 Status 코멘트만 남음 |
| 40831207 (CL B·C) | ➖ | ➖ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | 3 — CL B(favicon) 착수 가능 |
| 40681786 | ✅ | ⬜ | ✅ | ✅ | ✅ | ⏳ | 🔄 | ➖ | 6 — +1 ×2, smcgruer 제출 대기 · 7단계 브랜치 push 완료(09-05), PR 생성 남음 · 2단계 등록 밀림 |
| 545843242 | ✅ | ⬜ | ✅ | ✅ | ✅ | ⏳ | 🔄 | ➖ | 6 — 리뷰 대기 · 7단계 브랜치 커밋 완료, push 전 · 2단계 미등록 확인(09-05) |
| 41396598 | ✅ | ⏳ | ➖ | ➖ | ➖ | ➖ | ➖ | ➖ | 2 — crbug 의사 타진 답변 대기 |

**밀린 것 (오래된 순):** 8351543 기록 PR 생성(push는 09-05 완료) → 8349386 브랜치 push+PR → 40681786·545843242 OSSCA 등록 → #334/#369 Status 반영 코멘트.
단계별 다음 액션은 각 [`status/*.md`](status/) 하단.

## 현재 상태 요약 (2026-09-05 기준)

| crbug | 내용 | 상태 |
|---|---|---|
| [443042812](https://crbug.com/443042812) | SPC 팩토리 delegate DCHECK→CHECK 승격 (리뷰 -1 후 방향 전환) | ✅ 완료 (CL 8278112 머지, 기록 PR #348 머지) |
| [545645933](https://crbug.com/545645933) | manifest downloader rel 대소문자 매칭 | ✅ 완료 (CL 8336867 2026-09-02 머지, OSSCA #369, 기록 PR #371 · merged 표시 PR #375 모두 머지) — #369 Status 코멘트만 남음 |
| [41396598](https://crbug.com/41396598) | CurrencyFormatter를 ICU UnitWidth::HIDDEN으로 재작성 (M) | 의사 타진 댓글 게시, 답변 대기 |
| [40831207](https://crbug.com/40831207) | sql 수동 트랜잭션 제거 — CL 시리즈 (quota→favicon→삭제) | ✅ CL A 머지 (8282239, 2026-09-04), 기록 PR #370·merged 표시 PR #378 모두 머지 → OSSCA #342 Status 코멘트 남음 → CL B(favicon) 착수 가능 → CL C(sql 삭제) 남음 |
| [40681786](https://crbug.com/40681786) | payments 매니페스트 파서 에러 문자열 → native_error_strings (시리즈 1/3) | CL 8351543 +1 ×2 (xuehuichen·nikifork), smcgruer OWNERS 승인·제출 대기 · 기록 브랜치 push 완료(09-05) |
| [545843242](https://crbug.com/545843242) | Link 헤더 exactly-one 검증 (545645933 쌍둥이) | CL 8349386 업로드(09-04), 리뷰 대기 |
| [372283556](https://crbug.com/372283556) | crypto/hash 마이그레이션 services/network include 정리 | ✅ 완료 (CL 8264232, 2026-08-22 머지) |

## CL 사이즈 이력

| CL | 제목 | 사이즈 | 크기 | 파일 | 상태 |
|---|---|---|---|---|---|
| [8146619](https://crrev.com/c/8146619) | Fix broken links to removed docs/linux/suid_sandbox.md | S | +6/−5 (11줄) | 4 | 머지 (2026-07-28) |
| [8264232](https://crrev.com/c/8264232) | services/network: remove stale crypto/sha2 and secure_hash includes | XS | +0/−9 (9줄) | 7 | 머지 (2026-08-22) |
| [8278112](https://crrev.com/c/8278112) | [payments] Upgrade delegate DCHECK to CHECK in SPC app factory | XS | +1/−1 (2줄) | 1 | 머지 (2026-08-26) |
| [8282239](https://crrev.com/c/8282239) | [storage] Migrate QuotaDatabase to scoped sql::Transaction | M | +56/−15 (71줄) | 3 | 머지 (2026-09-04) |
| [8336867](https://crrev.com/c/8336867) | [payments] Match Link rel types case-insensitively in manifest download | S | +23/−7 (30줄) | 3 | 머지 (2026-09-02) |
| [8351543](https://crrev.com/c/8351543) | [payments] Move manifest parser error strings to native_error_strings | L | +221/−72 (293줄) | 3 | 리뷰 대기 (PS1) |

사이즈 = Gerrit 뱃지 기준 (변경 줄 수 합계): XS <10 · S 10–49 · M 50–249 · L 250–999 · XL ≥1000.
docs 링크 수정 → include 정리 → 불변식 강제(CHECK) → 자료구조 리팩토링(RAII 트랜잭션) 순으로
점점 실제 로직에 가까워지는 중. 8278112는 리뷰에서 방향이 바뀌며 +23 → +1로 줄어든 사례.

자세한 내용은 [`issues/`](issues/)와 [`status/`](status/) 아래 각 파일 참고.
