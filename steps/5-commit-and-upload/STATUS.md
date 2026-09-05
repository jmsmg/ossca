# 5단계 현황 — 커밋 및 업로드

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-05 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| CL | 제목 | 사이즈 | 트레일러 | 리뷰어 | 상태 |
|---|---|---|---|---|---|
| [8146619](https://crrev.com/c/8146619) | Fix broken links to removed docs/linux/suid_sandbox.md | S (+6/−5, 4파일) | — | — | ✅ 머지 2026-07-28 |
| [8264232](https://crrev.com/c/8264232) | services/network: remove stale crypto/sha2 and secure_hash includes | XS (+0/−9, 7파일) | — | ellyjones@, bashi@ | ✅ 머지 2026-08-22 |
| [8278112](https://crrev.com/c/8278112) | [payments] Upgrade delegate DCHECK to CHECK in SPC app factory | XS (+1/−1, 1파일) | — | smcgruer@ | ✅ 머지 2026-08-26 |
| [8282239](https://crrev.com/c/8282239) | [storage] Migrate QuotaDatabase to scoped sql::Transaction | M (+56/−15, 3파일) | `Bug:` (시리즈) | Evan Stade 외 | ✅ 머지 2026-09-04 |
| [8336867](https://crrev.com/c/8336867) | [payments] Match Link rel types case-insensitively in manifest download | S (+23/−7, 3파일) | — | chrome-payments-reviews@ | ✅ 머지 2026-09-02 |
| [8349386](https://crrev.com/c/8349386) | (545843242) Link 헤더 exactly-one 검증 | — | — | chrome-payments-reviews@ | ✅ 업로드 2026-09-04 |
| [8351543](https://crrev.com/c/8351543) | [payments] Move manifest parser error strings to native_error_strings | L (+221/−72, 3파일) | `Bug: 40681786` | chrome-payments-reviews@ | ✅ 업로드 2026-09-03 (PS1) |

사이즈 = Gerrit 뱃지 기준(변경 줄 수 합계): XS <10 · S 10–49 · M 50–249 · L 250–999 · XL ≥1000.

**궤적** — docs 링크 수정 → include 정리 → 불변식 강제(CHECK) → 자료구조 리팩토링(RAII 트랜잭션) →
컨벤션 이관(L). 점점 실제 로직에 가까워지는 중. 8278112은 리뷰에서 방향이 바뀌며 +23 → +1로 줄어든 사례.

**미해결** — gitcookies 인증 경고 (→ `git cl creds-check` 전환 필요), tryjob 권한 없음(CQ는 리뷰어/멘토가 실행).
