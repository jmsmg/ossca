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

0. ~~**8377022 · 8377550 push + PR 생성**~~ ✅ **09-11 제출 — PR #424 (8377022, 이슈 #421) · #425 (8377550, 이슈 #422)**, CI 통과 → **둘 다 09-11 머지** (#417·#415 도 09-11 머지). extensions 기록 PR **#437**(8397391, 이슈 #423) 09-14 제출·CI pass → 멘토 리뷰 대기. 본문 «OSSCA 이슈» 줄에 번호 반영됨. 머지되면 8단계 규칙대로 CL 머지 시 `status: merged` PR에 `Closes #421` / `Closes #422`
1. **#405 머지 대기** (8366188). 본문에 OSSCA 이슈 **#403을 처음부터 적었다** — #385·#386은 등록이 밀려 «미등록»으로 나갔던 것과 대비된다
2. ~~8351543 / 8349386 기록 PR 제출·머지~~ ✅ #385 · #386 모두 머지 확인 (2026-09-06). 두 CL이 머지되면 8단계에서 `status: merged` PR
2. #385/#386 본문의 «OSSCA 이슈 미등록» 표기 → 2026-09-07 등록된 **#400**(8351543) · **#401**(8349386)로 갱신. CL 머지 시 `status: merged` PR에서 함께 반영
3. ~~8282239 기록/merged PR~~ ✅ 확인 완료 (#370, #378 모두 머지) — 8단계에서 OSSCA #342 Status 코멘트만 남음
4. ~~#375 머지 확인~~ ✅ 확인 완료 (2026-09-03 머지) → 545645933은 8단계, OSSCA #369 Status 코멘트만 남음

```bash
python3 ~/ossca/scripts/track.py ossca 8351543
python3 ~/ossca/scripts/track.py ossca 8349386
```

**09-16 (Mac)** — 8412192(#441) 기록 커밋을 `~/contributions` 브랜치 `260916-add-8412192`(upstream/main 21f5b0a63 기반)에 준비. 푸시·PR은 허가 대기. 같은 대기열: `260915-add-8409786` · `260915-add-8410045` · `260915-add-8410466` (옛 main 기반이지만 파일 추가뿐이라 충돌 없음). PR 본문 형식은 #437(Summary + 관련 이슈 crbug/OSSCA/Gerrit) 그대로.

**09-17 (Mac) — 기록 PR 4건 제출** (사용자 허가 «A 올려»): **#450** 8412192(#441) · **#451** 8409786(#439) · **#452** 8410045(#416) · **#453** 8410466(#440). 네 브랜치 모두 `npm run validate:data && npm run lint:md` 통과 후 푸시. 본문 #437 형식, `Closes` 없음. CI·멘토 리뷰 대기. 남은 대기열: 리눅스 몫 8410065(#443)·8410085(#442) 기록은 아직 없음.

**09-18 (Mac)** — 8429522(#464) 기록 커밋을 `~/contributions` 브랜치 `260918-add-8429522`(upstream/main 최신 기반)에 준비, validate·lint 통과. 푸시·PR은 허가 대기. 본문 초안 `drafts/8429522-pr-body.md`.

**09-21 (Mac)** — 8423128(#465) 기록 커밋을 `~/contributions` 브랜치 `260921-add-8423128`(upstream/main 최신 기반)에 준비, validate·lint 통과. 본문 초안 `drafts/8423128-pr-body.md`. 8429522(#464) 기록 브랜치 `260918-add-8429522`도 함께 푸시·PR 허가 대기.

**09-21 — 기록 PR 2건 제출** (사용자 «PR 올려»): **#475** 8429522(#464) · **#476** 8423128(#465). validate·lint 통과, 본문 #437 형식, `Closes` 없음. CI·멘토 리뷰 대기.

**09-21 (Mac)** — 8423462(#478) 기록 커밋을 `~/contributions` 브랜치 `260921-add-8423462`(upstream/main 최신 기반)에 준비, validate·lint 통과. 본문 초안 `drafts/8423462-pr-body.md`. 푸시·PR 허가 대기.
