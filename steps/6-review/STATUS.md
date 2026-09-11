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
| 1 | 8377022 | mock time 판으로 다시 만든다 → 빌드·`storage_unittests` 검증 → PS2 + 답글 2건 | `unit_tests` 빌드 종료 |
| 2 | 8377550 | 커밋 메시지 2줄로 축소 → `git cl description` → 답글 | 브랜치 이동이 필요하므로 빌드 종료 후 |
| 3 | 8349386 · 8382856 · 8366188 | 상대 응답 대기 | — |

```bash
python3 ~/ossca/scripts/track.py cl 8377022
python3 ~/ossca/scripts/track.py cl 8377550
```

- 8282239는 5일 묵혀 리베이스 충돌이 났었다. **대기 중인 두 CL도 오래 묵으면 ToT 리베이스 필요.**
- 리뷰 라운드에서 바뀐 판단은 `../../issues/<crbug>.md`에 기록할 것.
