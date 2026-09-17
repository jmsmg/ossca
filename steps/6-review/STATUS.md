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
