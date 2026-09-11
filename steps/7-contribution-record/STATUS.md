# 7단계 현황 — 기여 기록 (contributions repo)

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-11 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| CL | 기록 PR (`status: in review`) | merged 표시 PR | 상태 |
|---|---|---|---|
| 8264232 | [#326](https://github.com/OSSCA-chromium/contributions/pull/326) 머지 | 동 PR에서 `merged` 반영 완료 | ✅ |
| 8278112 | [#338](https://github.com/OSSCA-chromium/contributions/pull/338) 머지 (2026-08-24) | [#348](https://github.com/OSSCA-chromium/contributions/pull/348) 머지 (+44/−26, 본문 전면 재작성) | ✅ |
| 8336867 | [#371](https://github.com/OSSCA-chromium/contributions/pull/371) 머지 | [#375](https://github.com/OSSCA-chromium/contributions/pull/375) 머지 (2026-09-03) | ✅ |
| 8282239 | [#370](https://github.com/OSSCA-chromium/contributions/pull/370) 머지 (2026-09-02) | [#378](https://github.com/OSSCA-chromium/contributions/pull/378) 머지 (2026-09-05) | ✅ |
| 8351543 | [#385](https://github.com/OSSCA-chromium/contributions/pull/385) 머지 (2026-09-06) | [#415](https://github.com/OSSCA-chromium/contributions/pull/415) 제출 (2026-09-09, **`Closes #400` 첫 적용**) — 머지 대기 | ⏳ |
| 8349386 | [#386](https://github.com/OSSCA-chromium/contributions/pull/386) 머지 (2026-09-06) | ➖ CL 머지 후 | ✅ |
| 8366188 | [#405](https://github.com/OSSCA-chromium/contributions/pull/405) **머지 (2026-09-09)** | ➖ CL 머지 후 | ✅ |
| 8382856 | [#417](https://github.com/OSSCA-chromium/contributions/pull/417) 제출 (2026-09-09) — 머지 대기 | ➖ CL 머지 후 | ⏳ |
| 8377022 | 🔄 브랜치 `260910-add-8377022` 커밋 완료, **push·PR 미제출** — 초안 `drafts/8377022-pr.md` | ➖ CL 머지 후 | 🔄 |
| 8377550 | 🔄 브랜치 `260910-add-8377550` 커밋 완료, **push·PR 미제출** — 초안 `drafts/8377550-pr.md` | ➖ CL 머지 후 | 🔄 |

**다음 액션**

0. **8377022 · 8377550 push + PR 생성** — 커밋·로컬 CI(`validate:data` ✓, `lint:md` 0 error ✓)까지 끝났고 원격 공개만 남았다. 명령과 본문은 `drafts/8377022-pr.md` · `drafts/8377550-pr.md`
1. **#405 머지 대기** (8366188). 본문에 OSSCA 이슈 **#403을 처음부터 적었다** — #385·#386은 등록이 밀려 «미등록»으로 나갔던 것과 대비된다
2. ~~8351543 / 8349386 기록 PR 제출·머지~~ ✅ #385 · #386 모두 머지 확인 (2026-09-06). 두 CL이 머지되면 8단계에서 `status: merged` PR
2. #385/#386 본문의 «OSSCA 이슈 미등록» 표기 → 2026-09-07 등록된 **#400**(8351543) · **#401**(8349386)로 갱신. CL 머지 시 `status: merged` PR에서 함께 반영
3. ~~8282239 기록/merged PR~~ ✅ 확인 완료 (#370, #378 모두 머지) — 8단계에서 OSSCA #342 Status 코멘트만 남음
4. ~~#375 머지 확인~~ ✅ 확인 완료 (2026-09-03 머지) → 545645933은 8단계, OSSCA #369 Status 코멘트만 남음

```bash
python3 ~/ossca/scripts/track.py ossca 8351543
python3 ~/ossca/scripts/track.py ossca 8349386
```
