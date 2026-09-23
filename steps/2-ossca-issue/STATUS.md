# 2단계 현황 — OSSCA 이슈 등록

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-07 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| crbug | OSSCA 이슈 | 드래프트 | 상태 |
|---|---|---|---|
| 372283556 | #282 (전체 규칙) / #307 (담당분) | — | ✅ |
| 443042812 | #334 | — | ✅ |
| 40831207 | #342 (2026-08-24) | — | ✅ |
| 545645933 | #369 (2026-09-02) | [drafts/545645933.md](drafts/545645933.md) | ✅ |
| 545843242 | [#401](https://github.com/OSSCA-chromium/contributions/issues/401) (2026-09-07) | [drafts/545843242.md](drafts/545843242.md) | ✅ 등록·self-assign·`self-issues` 확인 |
| 40681786 | [#400](https://github.com/OSSCA-chromium/contributions/issues/400) (2026-09-07) | [drafts/40681786.md](drafts/40681786.md) | ✅ 등록·self-assign·`self-issues` 확인 |
| 41396598 | 미등록 | — | ❌ 포기 (09-09) — 의사 타진 16일 무응답, 등록 안 함 |
| 438680281 | [#403](https://github.com/OSSCA-chromium/contributions/issues/403) (2026-09-07) | [drafts/438680281.md](drafts/438680281.md) | ✅ **CL 업로드 전 등록 — 순서 정상** |
| 40176243·40251269 CL 1 | [#416](https://github.com/OSSCA-chromium/contributions/issues/416) (2026-09-09) | [drafts/40176243.md](drafts/40176243.md) | ✅ **CL 업로드 전 등록** |

**다음 액션**

- ✅ **09-15 4건 추가 등록** (사용자 지시 «1, 2랑 XS 다 추가»): **#440** kResetDecoderForNonIDR 킬스위치(media/gpu/mac) · **#441** WebAuthn iCloud Keychain 플래그 3개(device/fido) · **#442** [40216113] Lacros 잔재(chrome/browser/ui/startup, crbug 템플릿) · **#443** extension_service 강제설치 우회(extensions). 전부 Status `멘티 작업 진행 중`으로 놓을 것(보드). 드래프트 `drafts/{reset-decoder-nonidr-killswitch,webauthn-icloud-keychain-flags,40216113,extension-service-force-install-workaround}.md`

- ✅ **#439** 등록(09-15, 직접 찾은 이슈 템플릿) — 만료 M144 signin 정리. Status `멘티 작업 진행 중`으로 놓을 것(보드). ColumnTime CL 2(net/extras)는 시리즈 이슈 **#416**에 진행 코멘트로

- ✅ **직접 찾은 이슈 3건 등록 완료 (2026-09-11, `gh issue create`, 라벨 2026+self-issues, self-assign)**:
  - **#421** `drafts/quota-test-clock-leak.md` → CL 8377022 — Status `gerrit 리뷰 중`으로 놓을 것
  - **#422** `drafts/quota-expired-notfatal-m148.md` → CL 8377550 — Status `gerrit 리뷰 중`으로 놓을 것
  - **#423** `drafts/extension-prefs-expired-migration.md` → ✅ CL 8397391 업로드(09-14), 진행 코멘트 게시 — Status **`gerrit 리뷰 중`으로 변경할 것**
  본문에 CL 링크·상태가 이미 들어 있어 진행 코멘트는 다음 변화(PS/머지/기록 PR) 때부터 남긴다

**진행 코멘트 해소 (2026-09-10).** CONTRIBUTING의 «진행하며 작업 내용을 이슈 댓글로 남기기»를
그동안 한 번도 안 하다가 #400·#401·#403·#416 네 곳에 한꺼번에 남겼다.

- **CL 링크는 본문 References가 아니라 진행 코멘트로** 남긴다. 본문은 등록 시점의 진단 기록으로 두고,
  그 뒤 진행(업로드·리뷰 대응·머지)은 댓글이 시간순 기록이 된다
- 형식은 `CL: <crrev 링크> (상태)` 한 줄 + 요지 2~3문장. 길게 쓰면 본문과 중복된다
- **밀리지 않게 하려면 업로드 직후가 자연스럽다** — 5단계 끝나면 바로 남긴다

- **40176243 등록** — `drafts/40176243.md` 문안으로 템플릿 등록 (라벨 `self-issues` 수동, self-assign). 제목은 crbug 원제 그대로. CL 시리즈라 이슈는 마지막 CL(`Fixed:`)까지 열어둠
- **밀린 등록 2건 해소 완료 (2026-09-07)** — #400·#401
- ~~438680281 신규 등록~~ ✅ #403 (2026-09-07) — **CL 업로드 전에 등록해 순서를 되돌린 첫 사례.** Status `멘티 작업 진행 중` → 업로드 후 `gerrit 리뷰 중`
- 두 이슈의 Status는 **`gerrit 리뷰 중`**으로 (등록이 밀려 CL이 먼저 올라간 케이스라 기본값 `멘티 작업 진행 중`은 실제와 어긋남)
- 기록 PR #385·#386 본문의 «OSSCA 이슈 미등록» 표기는 CL 머지 시 `status: merged` PR에서 #400·#401로 갱신

**교훈** — 두 건 다 CL을 먼저 올리고 등록이 밀렸다. 밀리면 드래프트가 낡는다:
545843242는 등록 직전에 리베이스로 설계가 바뀌어 드래프트를 다시 써야 했다. **3단계 들어가기 전에 등록하는 편이 싸다.**

- ✅ **09-17 진행 코멘트 4건** (사용자 직접, CL 링크 한 줄씩): #441 → 8412192 · #439 → 8409786 · #440 → 8410466 · #416 → CL 2 8410045. 남은 OSSCA 원격: #403 닫기 · #443 재오픈 판단.
- ✅ **09-17 06:27 #403 닫음**(completed, 코멘트 «CL 8366188 머지 완료») · **#443 재오픈**(CL 8410065 리뷰 중인데 09-15 02:13에 잘못 닫혀 있던 것). 둘 다 사용자 직접. OSSCA 원격 대기열 비움.
- ✅ **09-18 #464 등록** (사용자 «이슈 올려»): [432367602] kMediaStreamAccurateDroppedFrameCount 만료 플래그 제거. crbug 템플릿(라벨 2026·chromium-issues), self-assign, 본문은 `drafts/432367602.md`에서 `--body-file`로 → 등록 직후 본문 길이 확인(2,023자, 09-15 빈 본문 재발 방지). 코드는 이미 브랜치에 있어 4단계 뒤 업로드 시 Status `gerrit 리뷰 중`으로.
- ✅ **09-18 #465 등록** (사용자 «이슈 올려»): [41161335] kSuspendMediaForFrozenFrames 만료 플래그 제거. crbug 템플릿, self-assign, `--body-file` → 본문 1,928자 확인. 코드는 이미 브랜치 `654824f`에 있음.
- ✅ **09-21 #478 등록** (사용자 «이슈 올려»): [474398415] kWebCodecsDecoderFlushOptimizations 킬스위치 제거. crbug 템플릿, self-assign, 본문 1,700자 확인. 코드는 브랜치 `607ea05`에 있음.

- ✅ **09-21 #439·#423·#440·#442 수동 닫음** (사용자 직접, 코멘트 «CL … 머지 완료, 기록 PR … 머지»). `Closes`가 이 저장소에서 안 먹는 것 재확인 → 8단계 GUIDE에 기록됨. 보드 Status `반영 완료`는 사용자.
- ✅ **09-21 #478 진행 코멘트** (사용자 «1 올려», 에이전트 게시 274자): CL 8423462 링크·검증 결과. 보드 Status `gerrit 리뷰 중`은 사용자.


- ✅ **09-21 #464 수동 닫음** (사용자, 8429522 머지·#475/#483). 보드 Status는 사용자.
- ✅ **09-22 00:37Z #422 수동 닫음**(사용자, «CL 8377550 머지 완료»). · ⚠️ **#342(40831207)는 09-21 13:30Z 멘토(amoseui)가 닫음** — CL B/C 보류 종결. · 09-22 02:15Z 기준 열린 내 이슈: #478·#465·#443·#441·#421·#416·#401 (7건). 열린 기록 PR: #486·#487.
- ✅ **09-23 #494·#495 등록** (사용자 «2, 3 올려»): [486351442] kMergeRangesDuringAppend(media) · [495852034] kRejectInvalidChildRegions(viz). crbug 템플릿, self-assign, 본문 1,106자·1,075자 확인. 남은 등록 대기: Q(380105415)·E(524822746)·C(gaia).

