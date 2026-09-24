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

| [8410466](https://crrev.com/c/8410466) | [media/gpu/mac] Remove the kResetDecoderForNonIDR kill switch | XS (+1/−10, 1파일) | `Bug: 451536366` | eugene@, dalecurtis@ | ✅ 업로드 2026-09-15 (Mac; `-m` 오용으로 PS1 설명 오염 → PS2 복구) |
| [8412192](https://crrev.com/c/8412192) | [webauthn] Remove the expired iCloud Keychain rollout flags | S (+8/−40, 3파일) | `Bug: none` | derinel@, nsatragno@ | ✅ 업로드 2026-09-16 (Mac; `-s` 없이 올려 PS1이 **WIP** → PS2 `-s`로 ready+알림, PS3 `git cl description -n +`로 72자 재정렬) |
| [8429522](https://crrev.com/c/8429522) | [mediastream] Remove expired kMediaStreamAccurateDroppedFrameCount flag | S (+5/−25, 3파일) | `Fixed: 432367602` | kron@, mfoltz@ | ✅ 업로드 2026-09-18 (Mac; GUIDE대로 `-s -T` → PS1부터 ready) |
| [8423128](https://crrev.com/c/8423128) | [media] Remove the expired kSuspendMediaForFrozenFrames flag | S (+8/−24, 4파일) | `Bug: 41161335` | dalecurtis@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-21 (Mac; 09-21 규칙 첫 적용 — 리뷰어 1명 + 멘토 CC) |
| [8423462](https://crrev.com/c/8423462) | [WebCodecs] Remove the kWebCodecsDecoderFlushOptimizations kill switch | S (+4/−26, 7파일) | `Bug: 474398415` | eugene@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-21 (Mac; gclient sync 후 첫 CL) |
| [8410045](https://crrev.com/c/8410045) | [net] Migrate the reporting/NEL store to sql::Statement time accessors | S (+27/−40, 1파일) | `Bug: 40176243` | ricea@, nidhijaju@ | ✅ 업로드 2026-09-15 (Mac, presubmit 0 경고) |
| [8409786](https://crrev.com/c/8409786) | [signin] Remove expired NotFatalUntil::M144 from signin CHECKs | XS (+3/−12, 3파일) | `Bug: 435076172` | alexilin@, gab@(base) | ✅ 업로드 2026-09-15 (Mac, 전 트리 빌드 검증) |
| [8397391](https://crrev.com/c/8397391) | [extensions] Remove the expired install_time pref migration | S (−82, 3파일) | `Bug: none` | rdevlin.cronin@ (CC anunoy@) | ✅ 업로드 2026-09-14 (Mac 커밋 `e54665a5dd6bd`, presubmit 0 경고, `--send-mail`) |
| [8449690](https://crrev.com/c/8449690) | [media] Remove the kMergeRangesDuringAppend kill switch | XS (+1/−7, 1파일) | `Bug: 486351442` | tmathmeyer@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-23 (Mac; 리뷰어 1명 규칙) |
| [8449710](https://crrev.com/c/8449710) | [viz] Remove the kRejectInvalidChildRegions kill switch | XS (+1/−7, 1파일) | `Bug: 495852034` | jonross@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-23 (Mac; 리뷰어 1명 규칙) |
| [8464722](https://crrev.com/c/8464722) | [remoting] Remove the leftover oauth2: prefix DCHECK and legacy test | S (+0/−14, 2파일) | `Bug: b:309958013` (OSSCA #538) | joedow@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-25 02:04 KST (리눅스; verify PS1=로컬 ✓) |
| [8464683](https://crrev.com/c/8464683) | [ash] Remove the expired graphics tablet pen button trimming | M (+0/−126, 2파일) | `Bug: None` (OSSCA #539) | michaelcheco@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-25 02:05 KST (리눅스; verify PS1=로컬 ✓) |
| [8449730](https://crrev.com/c/8449730) | [payments] Fix the WPT for multiple payment-method-manifest Link headers | S (+16/−11, 2파일) | `Bug: 545843242` | smcgruer@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-23 (Mac; 8349386 abandon 후속, run_wpt_tests -p chrome 9/9) |
| [8450670](https://crrev.com/c/8450670) | [LCPP] Remove the kMultipleLcppKeyInitiatorOriginFix kill switch | S (+6/−18, 1파일) | `Bug: 380105415` | chikamune@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-23 (Mac) |
| [8450690](https://crrev.com/c/8450690) | [viz] Remove the kValidatePromiseImageFormat kill switch | XS (+3/−9, 1파일) | `Bug: 524822746` | kylechar@ (1차, 플래그 작성자) · CC amoseui@ | ✅ 업로드 2026-09-23 (Mac) |
| [8447532](https://crrev.com/c/8447532) | [gaia] Remove kSigninChromePasskeyUnlockUrlUsesAccountIndex | S (+2/−45, 4파일) | `Bug: none` | alexilin@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-23 (Mac) |
| [8453023](https://crrev.com/c/8453023) | [webview] Remove the kWebviewScriptFileOriginCheck kill switch | XS (+2/−9, 1파일) | `Bug: 496016840` | mcnee@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-24 (Mac) |
| [8453762](https://crrev.com/c/8453762) | [actor] Remove the kBackgroundActorTaskPopupsOpenInBackground kill switch | XS (+1/−8, 1파일) | `Bug: 489205993` | tluk@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-24 (Mac) |
| [8457502](https://crrev.com/c/8457502) | [media] Remove the kStrictFFmpegCodecs kill switch | XS (+1/−7, 1파일) | `Bug: 379418979` | tmathmeyer@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-24 (Mac; 중단된 D·J 명령에서 D 만 올라감) |
| [8457722](https://crrev.com/c/8457722) | [media] Remove the kAccurateVideoFrameConverterColorSpace flag | S (−37, 4파일) | `Bug: 467555325` | dalecurtis@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-24 (Mac) |
| [8461862](https://crrev.com/c/8461862) | [predictors] Remove the expired Navigation.Prefetch.*BodySize histograms | S (−45, 2파일) | `Bug: 335524391` | ricea@ (1차) · CC amoseui@ | ✅ 업로드 2026-09-24 (Mac) |
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


**8412192 (09-16) — GUIDE 50행에 이미 있던 `--send-mail`을 빼먹고 올려 PS1이 WIP로 갔다.** git cl은 새 CL을 기본 WIP로 올린다(`git_cl.py` 2208행 주석). PS2를 `-s`로 올려 `%ready,notify=ALL`로 풀었고, 재업로드가 서버 설명을 재사용하는 것(GUIDE 54행)도 알면서 다시 겪어 PS3를 `git cl description -n +`로 밀었다. **교훈: 단계 명령을 만들기 전에 그 단계 GUIDE를 먼저 연다.**


**함정 (8429522, 09-18) — `git fetch origin` 뒤 presubmit이 50건 `AttributeError: 'InputApi' object has no attribute 'AffectedExtensions'`로 전멸.** 원인은 트리가 아니라 **depot_tools가 오래됨**(09-14판) — 새 main의 PRESUBMIT.py가 depot_tools 09-17판에 추가된 API를 쓴다. `~/depot_tools/update_depot_tools` 한 번이면 끝. `git cl upload`는 presubmit 실패 시 아무것도 올리지 않으므로(`git cl issue` = None) 부작용은 없다. 교훈: **origin/main을 당겼으면 depot_tools도 같이 갱신**한다.

**미해결** — gitcookies 인증 경고 (→ `git cl creds-check` 전환 필요).
**tryjob 권한** — 09-07 smcgruer@ 요청은 09-24 무응답 종결 → 다음 추천인 미정(멘토 제외). 그때까지 CQ는 리뷰어가 실행.
