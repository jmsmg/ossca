# 6단계 현황 — 리뷰 라운드

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-11 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| CL | crbug | 현재 상태 | 대기 대상 |
|---|---|---|---|
| [8351543](https://crrev.com/c/8351543) | 40681786 | ✅ **머지 2026-09-09 14:47** (커밋 `3f65cb3afb2d1`, PS4). 09-08 CQ가 GN deps 누락으로 실패 → BUILD.gn 한 줄(PS2)+설명(PS3) → **재승인 요청 없이 smcgruer가 스스로 CR+1(13:56)·CQ+2(14:32)**, nikifork +1(14:04) | — |
| [8349386](https://crrev.com/c/8349386) | 545843242 | ⏳ **PS5 리베이스 업로드(09-10 23:42)**, `mergeable: True`. smcgruer가 09-10 **CR+1 + "리베이스하면 CQ 돌려주겠다"** → 리베이스 후 **+1이 outdated로 제거됨**. **답글 필수**(재승인 요청 + attention 복구) | smcgruer@ |
| [8377550](https://crrev.com/c/8377550) | (자체 발굴) | 🔄 **evanstade@ `Code-Review +1` (09-10 18:44) + "thanks for the patch"**. 남은 건 커밋 메시지 nit 1건 — 본문 전체를 잡고 "none of this really seems necessary". → **PS2에서 2줄로 줄인다**. 초안 `drafts/8377550-ps2.md` | **우리** (attention) |
| [8377022](https://crrev.com/c/8377022) | (자체 발굴) | 🔄 **evanstade@가 다른 수정 방식 제안 (09-10 18:48, 표 없음)** — "stop using a test clock and instead use a task environment with mock time". **조사 결과 그가 옳다**: `QuotaManagerImplTest`가 이미 MOCK_TIME이라 7쌍 전부가 불필요하고, 전역·세터를 통째로 지울 수 있다. + "LUCI에 flaky 기록이 있나, 버그는 등록됐나" 질문. 초안 `drafts/8377022-mocktime.md` | **우리** (attention) |
| [8382856](https://crrev.com/c/8382856) | 40176243 | ⏳ **PS1 업로드 2026-09-09 16:20**, 표 없음·미해결 0. manukh@ 첫 리뷰 대기 (`components/history/OWNERS` + 선례 CL 7455767에 +1을 준 사람) | manukh@ (attention) |
| [8366188](https://crrev.com/c/8366188) | 438680281 | ⏳ **PS1 업로드 2026-09-08 02:15**, 표 없음·미해결 0/0. gab@ 첫 리뷰 대기 (`base/OWNERS`·`components/prefs/OWNERS` 양쪽 등재 + 원 CL 6845990 리뷰어) | gab@ (attention) |
| — | 40831207 CL B | ⏳ **방향 문의 대기** — crbug #16은 본인이 삭제, **유효 질문은 [8291668](https://crrev.com/c/8291668) 코멘트(09-07 07:08)뿐**. attention=jpgravel@, 그 CL이 08-31 이후 정체 중이라 답도 느림 | jpgravel@ · grt@ |
| — | 41396598 | ❌ **포기 (09-09)** — 의사 타진 16일 무응답, 이슈 Hotlist-Recharge-Cold. 리마인드 안 함 | — |
| [8282239](https://crrev.com/c/8282239) | 40831207 | ✅ 머지 2026-09-04 02:20 (커밋 dde49d70e51e1, PS11) | — |
| [8336867](https://crrev.com/c/8336867) | 545645933 | ✅ 머지 2026-09-02 16:09 (커밋 0404b8e003262, smcgruer CQ+2) | — |
| [8278112](https://crrev.com/c/8278112) | 443042812 | ✅ 머지 2026-08-26 — **PS1에 -1 → 방향 전환 후 통과** | — |
| [8264232](https://crrev.com/c/8264232) | 372283556 | ✅ 머지 2026-08-22 | — |

**다음 액션 — 어텐션이 우리에게 있는 CL이 2개다**

| 순위 | CL | 할 일 | 선행 조건 |
|---|---|---|---|
| 1 | 8377022 | ✅ **PS2 로컬 완성 (09-11, Mac)** — 브랜치 `quota-db-test-clock-leak` HEAD, 57/57·319/319. **PS2 업로드됨(09-11 14:27 KST, 서버=로컬 파일 동일 ✓)**. 설명도 갱신됨 → **PS3(설명만 변경, 05:31 UTC), 서버=로컬 파일·메시지 완전 동일 ✓**. 남은 것: 답글 2건(드래프트 하단) → 그러면 어텐션 evanstade@ | 없음 |
| 2 | 8377550 | evanstade@ 답글(09-11 16:20): enum 문장 남겨도 무방, 스레드 resolved, **CR+1 유지**. 미해결 0/4. 비커미터 규칙(커미터 2명 +1) → ✅ **09-14 stevebe@microsoft.com 리뷰어 추가 + 안내 메시지(사용자)**, 어텐션 stevebe@. stevebe@ +1 오면 evanstade@/stevebe@ 가 CQ | — |
| 3 | 8366188 | ✅ **머지 09-14 11:17 UTC** — battre@ 추가 후 3시간 만에 +1·CQ+2, CV 제출(`fdce3e159a88b`, PS2). → 8단계 | — |
| 4 | 8349386 | ⚠️ **nikifork@ 미해결 지적(09-15): 스펙에 «1개 아니면 실패» 없음, 첫 매치+break 가 스펙, crbug 는 Jetski 환각 의심** → 09-16 검증 결과 **지적이 맞음**(스펙 원문·2019년 이후 불변·crbug 본문에 «verify if spec bug or Chrome bug» 명시). WPT 단언만 모순. **사용자 결정 필요** (`issues/545843242.md` 하단 판단 후보 ①②③). 어텐션 우리 | — |
| 5 | 8382856 | **manukh@ 복귀 — +1 «lgtm» (09-14 18:03)**. 두 번째 +1은 mahmadi@ 차례(어텐션 mahmadi@·우리). 대기 | — |
| 9 | 8410466 | #440 킬스위치 — **eugene@ +1 (업로드 23분 뒤, 8400064 순서 언급 없음)**. dalecurtis@ +1 대기 → CQ | — |
| 7 | 8410045 | ColumnTime CL 2 — **nidhijaju@ +1 «lgtm, thanks» (업로드 19분 뒤)**. ricea@ +1 대기 → CQ | — |
| 8 | 8409786 | M144 signin — **gab@ +1 + Owners-Override+1 (09-15 13:38)**. alexilin@ +1 대기 | — |
| 6 | 8397391 | **rdevlin.cronin@ CR+1 LGTM (09-14 17:56 UTC)**, 어텐션 우리. ✅ 09-15 andreaorru@ 추가(사용자), 어텐션 andreaorru@. +1 오면 CQ | — |

```bash
python3 ~/ossca/scripts/track.py cl 8377022
python3 ~/ossca/scripts/track.py cl 8377550
```

- 8282239는 5일 묵혀 리베이스 충돌이 났었다. **대기 중인 두 CL도 오래 묵으면 ToT 리베이스 필요.**
- 리뷰 라운드에서 바뀐 판단은 `../../issues/<crbug>.md`에 기록할 것.

**09-17 06:09~06:13 — 제출 요청 댓글 5건 게시 (사용자 직접, Gerrit UI)** — 8382856 · 8409786 · 8397391 · 8410466 · 8410085. 전부 PATCHSET_LEVEL, 문안 «Thanks for the reviews! I don't have CQ access yet, so could one of you submit this when you get a chance?». attention set은 +1 준 리뷰어 둘에게 이동 확인. 8382856에서는 사용자가 Commit-Queue+2를 직접 눌렀으나 06:10 CQ 봇이 즉시 회수(비커미터) — 예상된 동작, 부작용 없음. 리눅스 세션 참고: 8410085도 포함됨.

**09-17 머지 5건** (제출 요청 댓글 → 리뷰어 CQ+2 → 당일 머지): 8409786 alexilin@ 62분 · 8410085 dgn@ 2h31m · 8397391 finnur@ 4h12m · 8382856 manukh@ 12h46m · 8410466 eugene@ 14h13m. 남은 열린 CL 6건: 8412192(리뷰 대기) · 8410045(ricea@ 대기) · 8377022·8377550(stevebe@ 대기) · 8410065(미해결 2, 답변 필요) · 8349386(smcgruer@ 대기).

**09-21 — 제출 요청 댓글 2건 게시 (사용자 직접)** — 8410045(nidhijaju@·ricea@) · 8429522(kron@·mfoltz@). 둘 다 Gerrit «Ready to Submit», attention set 리뷰어 둘로 이동 확인. 리뷰어 CQ 대기.

**09-21 02:31Z — 8410065 답글 2건 게시 (사용자 직접)**: rdevlin.cronin@ 인라인(4994행)에 «mock 정책 제공자 + CheckForExternalUpdates()로 실제 경로를 타는 유닛 테스트로 바꾸겠다, 브라우저 테스트를 원하면 그쪽으로» 제안 · solomonkinard@ 패치셋 코멘트에 «andreaorru@ OOO라 둘째 +1용, 테스트 방향 정해지면 attention 다시» 답변. attention → solomonkinard·rdevlin.cronin·andreaorru. 주의: 인라인 답글이 **Resolved**로 들어가 미해결 0 — 리뷰어가 다시 열 수 있으니 그대로 둠. 8412192 핑은 아직 미게시.

**09-21 02:36Z — 8412192 핑 게시 (사용자 직접)**: derinel@ 지명(활동 중이나 우리 CL만 미응답, 근무일 4일 경과), nsatragno@는 09-11 이후 전 CL 무활동이라 부재로 판단해 셋째 리뷰어 추가는 보류. 계획: derinel@ +1 → kenrb@ 둘째 추가(09-21 규칙) · 목요일까지 무응답이면 kenrb@ 추가.

**09-21 — quota CL 2건 둘째 리뷰어 추가 (사용자 직접)**: 8377550·8377022에 rakina@chromium.org 추가(storage OWNER, 당일 활동). stevebe@는 09-12 이후 전 CL 무활동 9일이라 부재 판단, 제거하지 않고 유지. 교훈: 둘째 리뷰어를 고를 때 OWNERS 여부만 보지 말고 **추가 직전 최근 1주 활동**을 확인한다(stevebe@는 추가 이틀 전부터 이미 조용했음). smcgruer@도 09-11 이후 무활동 → 8349386은 nikifork@에게 방향 질문 예정(미게시).

**09-21 오후 (UTC 07~10시) 리뷰 이벤트** — 8410045: nidhijaju@가 CQ+2 → ios-simulator 트라이잡 **인프라 실패**(`ensure xcode.install xcode`, retcode 1)로 CQ 제거. 우리 코드 문제 아님 → 재시도 요청 댓글 필요. · 8412192: derinel@ **+1** «overall LGTM, webauthn 팀에서 정리에 우려가 있었다고 들었음, Nina(nsatragno@)가 결정하도록 두겠다» → 둘째 리뷰어 추가 대신 **nsatragno@ 복귀 대기**(09-11 이후 부재). · 8429522: kron@ **CQ+2** (10:33Z), CV 실행 중.

**09-21 저녁~09-22 새벽** — 8410045 머지(CQ 재요청 댓글 → nidhijaju@ 재시도 성공) · 8377550 머지(stevebe@ 복귀, +1+CQ) · 8349386 abandon(smcgruer@ «버그·WPT 환각» 인정, WPT 수정 요청) · 8423462: eugene@ +1·dry-run, dalecurtis@ +1 → READY지만 dry-run이 **무관한 gn 오류**(chrome/test/data/webui composebox pixel test include, 당일 리랜드로 해결)로 실패 → CQ 재요청 필요 · 8377022: stevebe@ +1 → READY → 제출 요청 댓글 필요 · 8423128: dalecurtis@ +1 → 둘째 리뷰어 tmathmeyer@ 추가 필요.

**09-22 01:26Z — 8349386(abandoned)에 후속 답글 게시 (⚠️ 에이전트가 «하겠다고 해»를 게시 허가로 오해해 REST로 올림 — 사용자 지적 «니 맘대로 댓글 달지마». 앞으로 Gerrit 댓글은 사용자가 직접)**: «abandon했다, 같은 버그로 WPT 서브테스트를 first-match에 맞게 고치고 Chromium 쪽 기대값 항목도 지우는 후속 CL을 올리겠다, Jayden 고맙다». attention → smcgruer@.

**09-22 — 8377022 merge conflict** — 8377550 머지로 `quota_manager_impl.cc` 1곳 충돌(Gerrit mergeable=false). 로컬 리베이스·해결(`ea68ebcba6067`, 패치 동일). PS6 업로드 허가 대기. 교훈: 같은 파일을 건드리는 우리 CL 두 개가 나란히 리뷰 중이면 하나가 머지되는 순간 다른 하나는 리베이스가 필요하다 — 머지 알림을 받으면 남은 CL의 mergeable을 바로 본다.

**09-22 01:50Z — 8377022 PS6**(리베이스) 업로드. mergeable 회복, 그러나 REWORK 판정으로 +1 두 개 Outdated → 재+1 요청 댓글(사용자). `git cl upload -T -t`는 동시에 불가.

**09-22 01:53Z — 8377022 재+1 요청 댓글 게시 (사용자 직접)**: «PS6는 8377550 랜딩 뒤 순수 리베이스, diff는 PS5와 동일, +1 다시 주고 제출도 부탁». attention → evanstade@·stevebe@·rakina@.

**09-22 02:07~02:08Z (사용자 직접)** — 8423462: 재CQ 요청 댓글(«dry-run 실패는 무관한 gn 파손, 제출 부탁»), attention → eugene@·dalecurtis@ · 8423128: 둘째 리뷰어 tmathmeyer@ 추가 + 설명 댓글, attention → tmathmeyer@. Gerrit 쪽 대기 항목 전부 처리됨.

**09-22 03:11~03:59Z — 8423462 dry run 재실행 → PASS** (eugene@ CQ+1 → «This CL has passed the run»). attention → dalecurtis@·jmsmg1. 다음: CQ+2 요청 한 줄(사용자).

**09-22 17:17~22:56Z** — 8412192 nsatragno@ +1(«lgtm, sorry for the slow review») → **READY** · 8423128 tmathmeyer@ +1 → **READY** · 8410065 rdevlin.cronin@ «실제 흐름만 타면 유닛 테스트로 남겨도 좋다» → 1안(정책 mock 제공자 + CheckForExternalUpdates) 구현 예정 · 8377022 evanstade@·stevebe@ 재+1 → CQ → **머지**. WPT 검증 빌드는 09-22 18:32 KST 사용자 Ctrl+C로 92%에서 중단 → 재실행 필요(러너는 -j/nice 제거판).

**09-29 04:10 KST — 리눅스 전체 실측 점검** (Gerrit·GitHub 직접 조회)
- 제출 요청 가능(+1×2, submittable): **W 8460623**(mek·dmurph) · **sql CL 3 8474691**(ioanap·friedrichh — friedrichh 코멘트는 설명의 `R=` 줄이 낡은 관행이라는 지적, resolved)
- CQ 도는 중: D 8457502 · J 8457722 (dalecurtis CQ+2, 09-29 03:58) → 머지되면 merged PR + **#523·#524 수동 닫기**
- 두 번째 +1 대기: Q 8450670(yyanagisawa@, 활동 중) · X 8467023(khmel@ **12일 무활동** → 커미터 joelhockey@(원 코드 작성자) 추가 제안)
- 첫 리뷰 없음: K 8461862(ricea@ 활동 중인데 4.5일 무응답 → 핑 제안) · Z 8464683(michaelcheco@ **11일 무활동** → wangdanny@ 추가 제안) · V 8464722(joedow@ 09-25 이후 조용, 수요일까지 대기)
- 기록: Gerrit CL 37 = 기록 37, 불일치 0, 열린 기록 PR 0. 열린 OSSCA 이슈 10(#282는 공용 umbrella, #416 시리즈, 나머지 리뷰 중)
- 참고: 모든 CL 설명에 `git cl upload -r`가 넣은 `R=` 줄이 있음(friedrichh 지적). 무해하나 이후 업로드 방식 검토

**09-29 07:30 KST — 리눅스 재점검**
- **W 8460623 CQ 실패(07:23)** — 원인은 인프라: CV가 든 `linux-libfuzzer-asan-rel`·`linux_chromium_compile_dbg_ng`(+buildbucket상 `linux-chromeos-compile-dbg`)가 전부 **Task expired**(대기열 만료, 빌드 시작 전). 나머지 28개 SUCCESS, 변경은 ChromeOS 전용이라 리눅스 봇에선 무변화 → CQ 재시도 요청 필요(사용자 게시)
- D 8457502: 41 SUCCESS, `chromeos-amd64-generic-dbg`만 진행 중 · J 8457722: 48 SUCCESS, `gpu-fyi-cq-android-arm64` screenshot_sync «invalid results / shard fail early»(플레이크성) 1건 + `win_optional_gpu_tests_rel` 인프라 실패 후 재시도 중 — CV 아직 실패 판정 없음
- CL 3 8474691: 제출 요청 게시됨(사용자 05:08), CQ 대기 · CL 4 8479611: 05:14 업로드(jkarlin@), 기록 PR #567 열림(CI ✓)
- 변화 없음: Q(yyanagisawa@) · K(ricea@) · V(joedow@) · Z(michaelcheco@) · X(khmel@)
- **09-29 07:50 KST 재점검**: **D 8457502 머지 07:36 KST** (`c5f1089ef9935`, dalecurtis@ CQ) → 8단계 남음: `Mark 8457502 as merged` PR + **#523 수동 닫기** · J 8457722 CQ 진행 중 · W CQ 재시도 요청 아직 없음 · 나머지 변화 없음
- **09-30 09:05 KST — K 8461862 두 번째 리뷰어**: ricea@ +1(09-29 22:31 KST, «lgtm, thanks for the cleanup!»)이지만 ricea@는 두 파일 어느 OWNERS에도 없음 → 서버 판정 **Code-Owners UNSATISFIED**(두 파일 모두 INSUFFICIENT_REVIEWERS). 계획에 있던 chikamune@도 `chrome/browser/predictors/OWNERS`에 없음. **nhiroki@가 `chrome/browser/predictors/OWNERS`와 `tools/metrics/histograms/metadata/navigation/OWNERS` 양쪽에 있는 유일한 사람** → 한 명으로 OWNERS 둘 다 + 두 번째 커미터 +1 충족. 오늘도 활동(09-29 23:56Z). 대안: alexilin@(predictors) + toyoshim@(navigation 히스토그램)
- ✅ **09-30 09:10 KST — K 8461862 nhiroki@ 추가 + 댓글 게시**(에이전트, 사용자 지시 «추가하고 직접 올려», Gerrit REST 한 번에): «Thanks, Adam! Adding nhiroki@, who owns both chrome/browser/predictors and the navigation histograms, for an owner review.» → attention nhiroki@, code-owners 두 파일 INSUFFICIENT_REVIEWERS → **PENDING**

**10-01 03:30 KST — 리눅스 전체 재점검** (Gerrit·GitHub 실측)
- 제출 요청 가능: **K 8461862** — ricea@ +1 · nhiroki@ +1(«LGTM, thanks!», 09-30 09:16) → 제출 요청 댓글
- 두 번째 OWNER 필요: **sql CL 4 8479611** — jkarlin@ +1(09-30 23:56)은 `components/blocklist` 파일만 승인. `chrome/browser/extensions/activity_log/fullstream_ui_policy.cc`는 INSUFFICIENT_REVIEWERS → activity_log/OWNERS 유일 owner **rdevlin.cronin@**(18h 전 활동) 추가 제안(대안 andreaorru@)
- 리뷰어 교체·추가 필요: **Z 8464683** — michaelcheco@ 13일·wangdanny@ 5일 무활동, 작성자 dpad@ 58일 → 상위 ash/system/OWNERS **tbarzic@**(1일 전 활동) 추가 제안(대안 amehfooz@) · **V 8464722** — joedow@ 09-25 이후 무활동 → **yuweih@**(원 CL 6227399 리뷰어, 10h 전 활동) 추가 제안
- 대기: X 8467023 — **khmel@ 복귀**(09-30 17:25Z 활동), 하루 더 대기 · HB(ricea@)·HD(mattm@) 둘 다 활동 중, 업로드 ~42h · HA 8481931 — horo@ 5.5일·ericorth@(net/dns OWNER) 9일 무활동 → 금요일까지 없으면 net/OWNERS에서 대체
- 정리: 기록 불일치 4건은 전부 열린 Add PR(#567·#570·#572·#574, 멘토 머지 대기). 열린 OSSCA 이슈 9(#282 umbrella·#416 시리즈·나머지 리뷰 중). 머지된 CL 이슈는 모두 닫힘
- ✅ **10-01 03:45 KST — 4건 게시**(에이전트, 사용자 지시 «진행해 전부», Gerrit REST, 전부 patchset-level·resolved)
  - **K 8461862** 제출 요청 «Both approvals are in. Could one of you submit this? Thanks!» → attention이 비어 있어 ricea@·nhiroki@를 `POST /attention`으로 직접 지정
  - **sql CL 4 8479611** andreaorru@ 추가 «Thanks, Josh! Adding andreaorru@ as an extensions owner for the remaining activity log file.» — 제안했던 rdevlin.cronin@는 Gerrit 상태가 «Exceptionally swamped»라 대안으로 바꿈(extensions/OWNERS 경유 owner, activity_log/OWNERS에 noparent 없음) → fullstream_ui_policy.cc PENDING
  - **V 8464722** yuweih@ 추가 «Adding yuweih@, who reviewed the original oauth2 prefix removal (crrev.com/c/6227399), since this has been waiting a few days.» → code-owners PENDING
  - **Z 8464683** tbarzic@ 추가 «Adding tbarzic@ as an ash/system owner, since the input_device_settings owners seem to be away.» → code-owners PENDING
- **10-01 08:50 KST 재점검**: **V 8464722 yuweih@ +1**(04:59) → code-owners SATISFIED, Review-Enforcement·Code-Review 미충족(두 번째 커미터 +1 필요). joedow@ 5일 무활동 → remoting OWNER jamiewalch@·lambroslambrou@ 둘 다 방금 활동 → **jamiewalch@ 추가 제안** · K 8461862 **nhiroki@ CQ+2**(07:47), 24 SUCCESS 진행 중 · sql CL 4 8479611 **andreaorru@ +1·CQ+2**(07:18), 29 SUCCESS · `mac_chromium_compile_dbg_ng` bot_update 인프라 실패 1(재시도 여부 관찰) · Z(tbarzic@)·X(khmel@)·HA·HB·HD 반응 없음
- **10-01 09:20 KST 재점검**: **sql CL 4 8479611 CQ 실패(09:18)** — 원인은 인프라: `android-x86-rel`·`win-rel` **Task expired**(빌드 시작 전 만료) + `mac_chromium_compile_dbg_ng` bot_update 인프라 실패. 31 SUCCESS, 코드 실패 0 → CQ 재시도 요청 필요 · K 8461862 CQ 진행 중(24 SUCCESS, 실패 0) · V jamiewalch@ 추가 제안 유지 · 나머지 변화 없음
- ✅ **10-01 09:25 KST — 2건 게시**(에이전트, 사용자 지시 «둘 다 올려», Gerrit REST, patchset-level·resolved)
  - **sql CL 4 8479611** CQ 재시도 요청 «The CQ run failed only because android-x86-rel and win-rel hit "Task expired" before they started, …» → attention andreaorru@ + jkarlin@(직접 지정)
  - **V 8464722** jamiewalch@ 추가 «Thanks, Yuwei! Adding jamiewalch@ for a second owner review, since joedow@ seems to be away.» → attention joedow@·jamiewalch@
- **10-01 09:28 KST**: **V 8464722 jamiewalch@ +1**(09:26, 추가 1분 뒤, 댓글 없음) → yuweih@·jamiewalch@ +1 두 개, 제출 요건 전부 SATISFIED → 제출 요청 댓글 차례(게시 뒤 attention에 yuweih@·jamiewalch@ 직접 지정) · K CQ 진행 중 · CL 4 재시도 대기 · 나머지 변화 없음
- ✅ **10-01 09:31 KST — V 8464722 제출 요청 게시**(에이전트, 사용자 지시 «올려»): «Both approvals are in. Could one of you submit this? Thanks!» → attention yuweih@·jamiewalch@ 직접 지정(joedow@ 그대로)

**10-01 11:12 KST — Mac 점검 (HG 준비 중 발견)**
- **HA 8481931**: horo@ +1(10:53 KST, «LGTM — But please also get lgtm from bashi@ just in case.», bashi@는 horo@가 직접 추가) · bashi@ +1(10:59, «lgtm»). 그러나 **Code-Owners UNSATISFIED** — `net/dns/*` 2파일은 APPROVED, `tools/metrics/histograms/metadata/net/histograms.xml`만 INSUFFICIENT_REVIEWERS. metadata/net/OWNERS = csharrison@·dschinazi@·nidhijaju@·toyoshim@ → **nidhijaju@**(CL 2 8410045 리뷰어, 7일 21건 활동, 부재 표시 없음) 추가 제안. 승인 뒤 제출 요청
- 같은 함정 예고: HD 8482211 도 `metadata/net/histograms.xml`(위 4명), HB 8482191 은 `metadata/others/histograms.xml`(per-file → METRIC_REVIEWER_OWNERS, 보통 chromium-metrics-reviews@google.com 추가) — 각자 1차 리뷰어 +1 뒤 추가. HG 는 mdjones@ 한 명이 components/commerce 와 metadata/commerce 양쪽 OWNER 라 해당 없음
- **10-01 11:40 — HA 리뷰어 추가·댓글 REST 게시는 Claude Code 자동 모드 권한 검사(«External System Writes»)에 막힘** — 명령이 실행 전에 차단돼 원격 변화 없음. 사용자가 UI 에서 직접: nidhijaju@ 추가 + «Thanks, both! Adding nidhijaju@ as an owner of tools/metrics/histograms/metadata/net/histograms.xml.» (또는 Bash 권한 규칙 추가 후 에이전트 게시)

**10-01 12:40 KST — Mac 재점검** (Gerrit·GitHub·Buildbucket 실측)
- ✅ **K 8461862 머지 12:33 KST** (`f119de2fd37b3`, Cr-Commit-Position #1708572, nhiroki@ CQ+2 07:47 → 한 번에 통과, 제출 시 자동 리베이스로 PS2). `Bug:` 트레일러라 crbug 자동 닫힘 없음 → 8단계
- **V 8464722 CQ 실패 11:32 KST** — jamiewalch@ CQ+2(09:32) 로 돈 `android-x64-rel`·`linux-chromeos-rel`·`win-rel` 3개가 **전부 시작 못 하고 2시간 뒤 INFRA_FAILURE**(createTime 00:32Z → endTime 02:32Z, startTime 없음 = 대기열 만료). 코드 무관 → CQ 재시도 요청 필요(리눅스 몫)
- **CL 4 8479611** — 09:18 KST 실패도 같은 양상(`android-x86-rel`·`win-rel`, 22:18Z → 00:18Z, 미시작). 09:25 재시도 요청 게시 뒤 응답 없음(andreaorru@·jkarlin@ attention)
- HA 8481931: 변화 없음(attention = 나) — nidhijaju@ 추가·댓글 사용자 몫 · HB·HD: 업로드 ~2.5일 무응답 · HG 8496107: mdjones@ attention · Z·X: 변화 없음
- OSSCA: 열린 기록 PR #567·#570·#572·#574(멘토 머지 대기) · 09-30 머지 #568·#581·#582

**10-01 15:14 KST — Mac 재점검**
- **HA 8481931 제출 가능**: 사용자가 12:48 nidhijaju@ 추가 + «Thanks, both! Adding nidhijaju@ as an owner of …/net/histograms.xml.» → nidhijaju@ +1(13:01). Code-Owners SATISFIED, CR 3개(horo@·bashi@·nidhijaju@), attention = 나 → 제출 요청 댓글 필요
- **V 8464722**: 사용자 12:49 CQ 재시도 요청 → yuweih@ CQ+2(14:55). 이번 실행 7빌드(이전 성공분 재사용 추정): 성공 2 · 실행 중 2(`linux-chromeos-rel` + compilator) · **대기 3**(`android-x64-rel`·`win-rel`·`fuchsia-x64-cast-receiver-rel`, 14:55 생성 후 미시작) — 16:55 KST 까지 시작 못 하면 지난번처럼 만료
- CL 4 8479611: 09:25 재시도 요청 뒤 응답 없음(미국 아침 = 오늘 밤 KST 기대) · HG: mdjones@ 응답 없음(업로드 3.7h) · HB·HD: 2.6일 무응답 — 내일(10-02 금) 아침에도 없으면 핑/교체 검토 · Z·X 변화 없음
- OSSCA: 열린 PR 6개(#567·#570·#572·#574·#593·#594) 전부 멘토 머지 대기, 오늘 머지 0 · #536 열림(#594 머지 뒤 닫기)
- **10-01 16:29 KST — V 8464722 머지** (`43ef050a06230`, yuweih@ CQ 재실행 통과). 8단계(merged PR·#538 닫기)는 리눅스 몫

**10-02 08:35 KST — Mac 아침 점검** (Gerrit·GitHub 실측)
- ✅ **CL 4 8479611 머지 07:30 KST** (`7dd8d0f134d4c`) — andreaorru@ 가 05:04 CQ 재시도 → 8단계
- **HG 8496107**: mdjones@ +1(03:52, 코멘트 없음) → attention 나. 두 번째 커미터 +1 필요 → 계획했던 ayman@ 은 3일 0건(davidjm@ 1건) → **meiliang@** 제안(commerce 히스토그램 정리를 직접 하는 사람, 3일 19건)
- **HA 8481931**: 변화 없음 — CQ+2 대기(attention horo@·bashi@·nidhijaju@, 도쿄 근무 시간 10시 이후 기대)
- **HB 8482191**(ricea@ 3일 27건 활동) · **HD 8482211**(mattm@ 3일 6건): 둘 다 업로드 3일 무응답 → 핑 제안
- HH 8499654: peter@(3일 11건) 응답 대기 15h · Z·X 변화 없음
- OSSCA: 사용자가 #536·#538 닫음(08:32·08:33, 닫는 댓글 포함) · 열린 기록 PR 0
- 빌드: 사용자가 sync 러너를 `SKIP_SYNC` 없이 다시 돌려 main `9143293` 로 한 번 더 sync → `unit_tests` 19,551/80,436 진행 중
- **10-02 08:40 — HG meiliang@ 추가**(사용자, «Thanks, Matt! Adding meiliang@, who has been cleaning up the commerce histograms, for a second review.») → attention meiliang@. Code-Owners 8파일 모두 APPROVED(mdjones@), 남은 건 두 번째 +1. HB·HD 핑은 아직
- ✅ **10-02 10:45 KST — Z·X 리뷰어 추가**(에이전트, 사용자 «진행하자»): **Z 8464683** jamescook@ 추가(ash OWNER, tbarzic@ 10-01 추가 뒤 무응답) «Adding jamescook@ as an ash owner, since tbarzic@ and the input_device_settings owners seem to be busy. Thanks!» · **X 8467023** hidehiko@ 추가(두 번째 +1, khmel@ 7일 무응답) «Adding hidehiko@ for the second approval, since khmel@ seems to be busy. diwux@ has already approved this as the shelf owner. Thanks!»
- ✅ **10-02 11:22 KST — HG 8496107 제출 요청 게시**(리눅스 세션 에이전트, 사용자 «올려»): «Both approvals are in. Could one of you submit this? Thanks!» → attention mdjones@·meiliang@ 직접 지정. 다음 리눅스 작업 후보 LD(schedqos) — 사용자 지시 대기
- **10-02 11:01 — 8291668(jpgravel@, sql batching mode)에서 attention**: 09-07 우리 드라이브바이 질문에 답 — FaviconDatabase·deprecated API 삭제는 본인이 함, 대신 8282239 의 QuotaDatabase TODO 의도를 질문 → 답변 문안 전달(`issues/40831207.md`)
- ✅ **10-02 11:57 — 8291668 답변 게시**(에이전트, 사용자 «니가 달아줘») → attention jpgravel@·grt@. QuotaDatabase batching 이전 후속을 제안해 둠

**10-02 16:13 KST — Mac 점검**
- **HG 8496107**: meiliang@ +1 · mdjones@ +1 → 리눅스가 제출 요청 게시(11:22) → CQ+2 대기(attention 둘)
- **LD 8505916**(리눅스): oshima@ «+hidehiko@ to make sure we don't have to salvage this.»(12:47, resolved) → hidehiko@ 판단 대기, 우리 답변 불필요(attention 은 작성자 자동)
- 대기: HH(peter@) · HC(nhiroki@) · HJ(avi@) · HB(ricea@)·HD(mattm@, 09:50 핑) · LA(hidehiko@) · LB(blundell@) · LE(achuith@) · Z(jamescook@ 추가)·X(hidehiko@ 추가)
- OSSCA: 열린 PR 6개(#646·#649·#651·#653·#654·#656), 오늘 머지 0
- 빌드: `browser_tests` 성공 → main `9143293` 에서 6개 타깃 모두 빌드 완료
- **HH sync 후 점검 완료**: 새 main 에서 HH 가 지우는 enum 6개(`BackgroundSync{FiredEvents,Status,WakeupTask}`, `Boolean{CouldFireImmediately,InForeground,RegistrationIsDuplicate}`)를 쓰는 곳은 여전히 HH 가 지우는 히스토그램뿐(사용 수 09-24 와 동일) → 리베이스 불필요


**10-02 22:50 KST — 리눅스 전체 점검 (사용자 할 일 정리)**
- 코멘트 3건: **HC 8505477** nhiroki@ +1 «LGTM, thanks!»(17:43) — code-owners 세 파일 APPROVED, Review-Enforcement·Code-Review 미충족 → 두 번째 커미터 +1 필요(ricea@ 제안: 히스토그램 작성자·K 공동 리뷰어) · **LB 8505776** blundell@ «-> oshima@ as reviewer with more domain expertise»(18:11, 본인 제외) → oshima@ 대기 · **LD 8505916** oshima@ «+hidehiko@ to make sure we don't have to salvage this»(12:47) → hidehiko@ 판단 대기, 답변 불필요
- HG 8496107 제출 가능·CQ 대기 · 나머지(Z·X·LA·LE·HJ·HH·HB·HD) 반응 없음
- 기록: Gerrit 49 = upstream 기록 49, 불일치 0 · 열린 기록 PR 0(멘토가 20:26~20:33 KST 8건 머지: #646 #649 #651 #653 #654 #656 #660 #661) · 닫을 이슈 없음(열린 14 = umbrella #282·시리즈 #416·리뷰 중 12)
- **사용자 몫**: 보드 Status(09-27 보류) — 09-21 이후 닫힌 26건 → 반영 완료, 리뷰 중 12건 → gerrit 리뷰 중 (`gh auth refresh -s project` 받으면 에이전트 대행 가능) · `git cl creds-check`(gitcookies 폐지 경고, 양쪽 머신) · tryjob 추천인 결정(머지 36건, 07-28~; 커미터 지명 검토 가능) · Y 포기·LC/LF/LG 보류 확정
- README «밀린 것» E·G·I·6 은 종결된 항목 → 정리 필요
- ✅ **10-02 22:55 KST — HC 8505477 ricea@ 추가 + 댓글**(리눅스 세션 에이전트, 사용자 «HC에 ricea 추가하고 댓글 올려»): «Thanks, Hiroki! Adding ricea@, who added these histograms and reviewed the first prefetch_manager cleanup (crrev.com/c/8461862), for a second review.» → attention ricea@. +1 오면 제출 요청

**10-02 23:06 KST — Mac 점검** (리눅스 22:50 점검 이후 재조회)
- 변화 없음: HG 제출 가능·CQ+2 대기(제출 요청 11:22, 미국 금요일 아침 기대) · HC nhiroki@ +1 → ricea@ attention(리눅스 22:55 추가) · HJ avi@(3일 27건 활동) · HH peter@(30h, 3일 12건 활동 → 월요일까지 없으면 핑) · HB·HD 09:50 핑 뒤 무응답 → 월요일 재판단 · LA·LE·Z·X 대기
- 사용자 attention: LB(blundell@ → oshima@ 교체)·LD(oshima@ 가 hidehiko@ 추가) 두 곳뿐, 둘 다 답변 불필요
- 8291668: 우리 답글(11:57) 뒤 jpgravel@ 응답 없음
- OSSCA: 열린 기록 PR 0, 닫을 이슈 0, 우리 이슈 새 댓글 0
- README «밀린 것» E·G·I·6 원격 실측 뒤 종결 표시(리눅스 지적) · gitcookies 경고는 Mac 해당 없음


**10-03 08:25 KST — 리눅스 전체 점검** (미국 금요일 저녁 결과)
- **HG 8496107 머지 10-03 01:25 KST** (`308a20785a379`, mdjones@ CQ+2 00:14) → 8단계 남음: merged PR + **#591 손으로 닫기** (기록 1건 불일치: in review)
- **Z 8464683**: jamescook@ **+1**(01:27) → code-owners 두 파일 APPROVED, 두 번째 커미터 +1 필요 → oshima@ 제안(ash OWNER, 7일 14건, LB·LD 당일 반응)
- **LB 8505776**: oshima@ **+1**(08:09, PS2) → 코드 9파일 APPROVED, `chromeos_hps/histograms.xml` INSUFFICIENT_REVIEWERS → jimmyxgong@ 추가 제안(xml OWNER + 두 번째 +1 겸)
- **HB 8482191**(Mac): ricea@ **+1** «lgtm»(23:08) → 코드 APPROVED, `metadata/net/histograms.xml` INSUFFICIENT_REVIEWERS → nidhijaju@ 추가 제안(HA 전례)
- **HD 8482211**(Mac, Mac 전용 파일): mattm@ **+1**(07:28) + **미해결 코멘트** «you can add `Fixed: 41485528, 41485529` / `Bug: 330166367` to the commit message» → 설명 수정(서버 `PUT /message` 로 가능, Mac 로컬 amend 필요) + 답글·resolve + `metadata/net` xml OWNER(nidhijaju@) 추가
- 변화 없음: LD(hidehiko@ 판단 대기) · HC(ricea@ attention, 23:08 활동했으나 HC 미처리) · X·LA(hidehiko@) · LE(achuith@) · HJ(avi@) · HH(peter@) · CL 5 8505857(fleimgruber@)
- OSSCA: 열린 기록 PR 0(#677 포함 머지) · 새 댓글 0 · 사용자 몫(보드 Status·creds-check·tryjob 추천인·Y/LC 결정) 그대로
- ✅ **10-03 08:40 KST — 4건 게시**(리눅스 세션 에이전트, 사용자 «전부 진행해»)
  - **Z 8464683** oshima@ 추가 «Thanks, James! Adding oshima@ for a second review.» → attention oshima@(+tbarzic@·michaelcheco@ 잔존)
  - **LB 8505776** jimmyxgong@ 추가(`chromeos_hps` xml OWNER 겸 두 번째 +1) «Thanks, Mitsuru! Adding jimmyxgong@ as an owner of …/chromeos_hps/histograms.xml.» → attention jimmyxgong@. blundell@는 본인이 빠져 리뷰어 oshima@·jimmyxgong@
  - **HB 8482191** nidhijaju@ 추가(`metadata/net` xml OWNER) «Thanks, Adam! Adding nidhijaju@ as an owner of …/net/histograms.xml.» → attention nidhijaju@
  - **HD 8482211** mattm@ 요청대로 서버 설명 수정 → **PS2**(`PUT /a/changes/8482211/message`, `Bug: None` 없음 → Change-Id 앞에 `Fixed: 41485528, 41485529` / `Bug: 330166367` 삽입; mattm@ +1 PS2 로 승계) · PS1 COMMIT_MSG 스레드에 «Done, thanks!» resolve(미해결 0) · nidhijaju@ 추가 + «Thanks, Matt! Added the Fixed/Bug lines in PS2. Adding nidhijaju@ …» → attention nidhijaju@. **⚠️ Mac: 로컬 브랜치 `trust-store-mac-expired-histograms` 커밋 메시지도 같게 amend 필요**(서버 설명은 다음 업로드 때 재사용되므로 코드 PS 는 안전하나 `track.py verify` 메시지 비교가 어긋남). 머지 시 crbug 41485528·41485529 자동 close
- ✅ **10-03 09:12 KST — Z 8464683 제출 요청 게시**(리눅스 세션 에이전트, 사용자 «진행해»): oshima@ +1(08:47) → jamescook@·oshima@ +1 두 개, SR 전부 충족 → «Both approvals are in. Could one of you submit this? Thanks!» → attention jamescook@·oshima@ 직접 지정. HG merged PR #682 는 멘토가 09:02 머지(열린 기록 PR 0)
- ✅ **10-03 13:10 KST — 3건 게시**(리눅스 세션 에이전트, 사용자 «진행해»)
  - **LB 8505776** 제출 요청(jimmyxgong@ +1 09:33 → oshima@·jimmyxgong@, SR 전부 충족) → attention 둘 직접 지정
  - **HD 8482211** 제출 요청(nidhijaju@ +1 «lgtm, thanks» 12:54 → mattm@·nidhijaju@, SR 전부 충족) → attention 둘 직접 지정
  - **HB 8482191** nidhijaju@ «lgtm % nits»(13:00, +1) 의 수정 제안 2개(.cc 229행·242~243행 주석에서 «If loading was successful, also report metrics.» 삭제)를 **Gerrit 인라인 편집으로 적용 → PS2**(`PUT /a/changes/8482191/edit/<path>` + `POST edit:publish`, 커밋 `119cf72bea928`, −3/+2 주석만) · PS1 두 스레드에 «Done.» resolve(미해결 0/9) · «Done, thanks! Applied both comment fixes in PS2. PTAL.» → attention nidhijaju@·ricea@. **코드 PS 라 CR +1 둘 다 초기화** → 재승인 대기. **⚠️ Mac: 로컬 브랜치 `nel-store-expired-histograms-40054414` 를 PS2 로 동기화 필요**(`git cl patch -b <브랜치> 8482191` 또는 `git fetch https://chromium.googlesource.com/chromium/src refs/changes/91/8482191/2 && git reset --hard FETCH_HEAD`), HD 도 PS2 메시지로 amend
- **10-03 13:13 KST**: nidhijaju@ 즉시 반응 — **HD 8482211 CQ+2**(13:12, CV 진행 중 → 머지되면 8단계: merged PR + #573 닫기, crbug 41485528·41485529 `Fixed:` 자동 close) · **HB 8482191 PS2 재승인 +1 + CQ dry run**(13:13) → ricea@ 재승인 대기(attention ricea@) · LB 8505776 제출 요청 뒤 CQ 대기 · 기록 PR #687 CI ✓
