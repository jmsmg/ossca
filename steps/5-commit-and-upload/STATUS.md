# 5단계 현황 — 커밋 및 업로드

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-08 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| CL | 제목 | 사이즈 | 트레일러 | 리뷰어 | 상태 |
|---|---|---|---|---|---|
| [8146619](https://crrev.com/c/8146619) | Fix broken links to removed docs/linux/suid_sandbox.md | S (+6/−5, 4파일) | — | — | ✅ 머지 2026-07-28 |
| [8264232](https://crrev.com/c/8264232) | services/network: remove stale crypto/sha2 and secure_hash includes | XS (+0/−9, 7파일) | — | ellyjones@, bashi@ | ✅ 머지 2026-08-22 |
| [8278112](https://crrev.com/c/8278112) | [payments] Upgrade delegate DCHECK to CHECK in SPC app factory | XS (+1/−1, 1파일) | — | smcgruer@ | ✅ 머지 2026-08-26 |
| [8282239](https://crrev.com/c/8282239) | [storage] Migrate QuotaDatabase to scoped sql::Transaction | M (+56/−15, 3파일) | `Bug:` (시리즈) | Evan Stade 외 | ✅ 머지 2026-09-04 |
| [8336867](https://crrev.com/c/8336867) | [payments] Match Link rel types case-insensitively in manifest download | S (+23/−7, 3파일) | — | chrome-payments-reviews@ | ✅ 머지 2026-09-02 |
| [8349386](https://crrev.com/c/8349386) | [payments] Fail manifest download on multiple manifest Link headers | M (+105/−38, 5파일) | `Fixed:` | chrome-payments-reviews@ → gwsq가 smcgruer@로 확정 | ✅ PS1 2026-09-04 → 리베이스 → **PS2 업로드 2026-09-07** (커밋 `4aa401c79f25c`, presubmit 0 errors, verify 동일 ✓) |
| [8351543](https://crrev.com/c/8351543) | [payments] Move manifest parser error strings to native_error_strings | L (+221/−72, 3파일) | `Bug: 40681786` | chrome-payments-reviews@ | ✅ 업로드 2026-09-03 (PS1) |

| [8366188](https://crrev.com/c/8366188) | [prefs] Remove expired NotFatalUntil::M143 from PrefService type checks | XS (+4/−5, 2파일) | `Bug:` | gab@ | ✅ 업로드 2026-09-08 (커밋 `8093501aac651`, verify 동일 ✓) |

| [8382856](https://crrev.com/c/8382856) | [history] Migrate to sql::Statement time accessors | XS (+14/−18, 3파일) | `Bug:` 2개 | manukh@ (CC grt@) | ✅ 업로드 2026-09-09 (커밋 `b5f15eb36b2ea`, verify 동일 ✓) |

| [8377022](https://crrev.com/c/8377022) | [storage] Make QuotaDatabase::SetClockForTesting() restore the clock | S (+24/−26, 4파일) | `Bug: none` | evanstade@ (CC stevebe@) | ✅ 업로드 2026-09-10 (커밋 `ee6b2fd5b8367`, verify 동일 ✓) |

| [8377550](https://crrev.com/c/8377550) | [storage] Remove expired NotFatalUntil::M148 from quota CHECKs | L (+154/−160, 10파일) | `Bug: none` | evanstade@ (CC stevebe@) | ✅ 업로드 2026-09-10 (커밋 `cee29292ec148`, verify 동일 ✓) |

사이즈 = Gerrit 뱃지 기준(변경 줄 수 합계): XS <10 · S 10–49 · M 50–249 · L 250–999 · XL ≥1000.

**궤적** — docs 링크 수정 → include 정리 → 불변식 강제(CHECK) → 자료구조 리팩토링(RAII 트랜잭션) →
컨벤션 이관(L). 점점 실제 로직에 가까워지는 중. 8278112은 리뷰에서 방향이 바뀌며 +23 → +1로 줄어든 사례.

**함정 — `git cl upload`의 대화형 프롬프트 두 가지.** 둘 다 비대화형으로 돌리면 **presubmit을 통과한 뒤에 죽어서 성공처럼 보이지만 아무것도 안 올라간다.**

1. **패치셋 제목** — 2회차 패치셋부터 묻는다. `-t "<제목>"`으로 주거나, 초회 업로드는 `-T`(커밋 메시지를 제목으로)
2. **presubmit 경고 확인** — `There were presubmit warnings. Are you sure you wish to continue? (y/N)`.
   `printf 'y\n' | git cl upload ...`로 답한다. 경고를 읽고 오탐인지 먼저 판단할 것 (아래 사례)

**오탐 사례 (8366188)** — `components/prefs/pref_service.cc`에서 줄을 지우면 presubmit이
«Discovered possible removal of preference registrations»를 띄운다. 삭제된 줄에 `PrefRegistry::RegisteredPrefType::kInt64`가
들어 있어서인데, 실제로는 `CHECK_EQ`의 인자를 뺀 것이고 등록은 건드리지 않았다. 경고문 자체가 "This may be a false positive"라고 적고 있다.

**미해결** — gitcookies 인증 경고 (→ `git cl creds-check` 전환 필요).
**tryjob 권한** — 2026-09-07 smcgruer@에게 추천 요청 메일 발송, 회신 대기. 그때까지 CQ는 리뷰어가 실행.
