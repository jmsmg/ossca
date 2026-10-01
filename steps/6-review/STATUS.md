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
