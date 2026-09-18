# [자체 발굴] 만료 NotFatalUntil::M144 — signin 3곳 + enum 항목 삭제

**상태: ✅ 완료 — CL 8409786 머지 (2026-09-17 08:16 UTC, PS2, `37ac4ebc43de5`, alexilin@ CQ). 기록 PR #451 머지. 8단계: merged PR(`Closes #439`) 허가 대기 · 보드 Status `반영 완료`(사용자).**

## 링크

- crbug: 435076172 — **접근 제한(보안) 이슈**라 열람 불가. 원 CL 6842550의 TODO가 인용. CL에는 `Bug: 435076172`로 참조(허용됨)
- Gerrit: **https://crrev.com/c/8409786** (09-15 PS1, 리뷰어 alexilin@ signin + gab@ base OWNER)
- OSSCA 이슈: #439 (2026-09-15, 「직접 찾은 이슈 등록」)
- 발굴 경로: 2. 코드 상향 — 09-15 ToT 재스캔에서 «M144 = 트리 전체 3곳, 전부 signin» 확인

## 이슈 실체

- `chrome/browser/signin/dice_web_signin_interceptor.cc` 2곳: `CHECK(!account_info_update_observation_.IsObserving(), NotFatalUntil::M144)` + TODO(crbug.com/435076172) «크래시 없으면 일반 CHECK로»
- `chrome/browser/ui/webui/signin/turn_sync_on_helper.cc` 1곳: `CHECK(!syncer::IsReplaceSyncPromosWithSignInPromosEnabled(), NotFatalUntil::M144)`
- `base/not_fatal_until.h`의 `M144 = 144,` — 위 3곳이 유일한 사용처 → 항목 삭제 가능(M143 선례 8366188과 동일 구조)
- 트리 M155 → 11개 마일스톤째 이미 fatal. 인자 제거는 동작 불변, 공식 빌드에서 로그 문자열이 버려지는 코드 생성 변화만

## 수정 (커밋 bb98018e65923)

- 세 CHECK에서 인자 제거, 해결된 TODO 주석 2개 삭제, interceptor 의 `base/not_fatal_until.h` include 삭제(다른 사용 없음), enum `M144` 삭제

## 검증 계획

- `base/` 헤더 변경 → 사실상 전 트리 재빌드. Mac `-j 6`로 수 시간. 사용자 tmux에서 러너로
- `unit_tests --gtest_filter='DiceWebSigninInterceptor*:TurnSyncOnHelper*'` + `base_unittests --gtest_filter='CheckTest.*:CheckDeathTest.*'`

## 리뷰어

- `components/signin/DESKTOP_OWNERS`: chrome-signin-desktop-reviews@google.com 알리아스 + LAST_RESORT 개인들(alexilin@, droger@ …). 원 CL 작성자 rsult@google.com. **두 명 규칙** — 알리아스가 한 명만 배정하면 개인 한 명 추가. base/ OWNER 승인이 별도로 필요한지 확인(M143 때는 gab@이 겸임)

## 진행 체크리스트

- [x] 발굴 + 선점(연결 CL: 원 CL 1건뿐) + OSSCA 겹침 0
- [x] OSSCA #439 등록 (09-15)
- [x] 브랜치·수정·format·커밋
- [x] 4단계 빌드·테스트 — ✅ 09-15 Mac 전 트리 4h46m, signin 95/95, CheckTest 26/26
- [x] 5단계 업로드 — ✅ **CL 8409786** (09-15, presubmit 0 경고, `-r alexilin@,gab@ --send-mail`)
- [x] 7단계 기록 PR — ✅ **#451** (09-17, `contributions: Add 8409786`)
- [x] 6단계 — gab@·alexilin@ +1 (09-15~16) · 제출 요청 댓글 09-17 06:09 → alexilin@ CQ+2 07:11 → 머지 08:16 UTC (`37ac4ebc43de5`)
- [ ] 8단계 — merged PR(`Closes #439`) 허가 대기 · 보드 Status `반영 완료`(사용자)

## 이 사이클에서 배운 것

- `base/check.h`가 include하는 헤더(`not_fatal_until.h`)를 건드리는 CL은 전 트리 재빌드가 **두 번** 든다(브랜치를 떠날 때 다시). 이번엔 #441 검증까지 3.5시간을 더 냈다. 다음부터 이런 CL은 사이클 마지막에 두고, 랜딩 전엔 `unit_tests` 계열 다른 작업을 시작하지 않는다.
- +1 둘이 모인 뒤 «CQ 권한이 없으니 제출해 주세요» 한 줄이면 리뷰어가 1시간 안에 눌러 준다(alexilin@ 62분). +1이 모이자마자 바로 남긴다.
- alexilin@가 크래시 대시보드에서 «이 CHECK 크래시는 M149에 고쳐졌다»를 확인해 줬다. NotFatalUntil 제거 CL 설명엔 «해당 CHECK가 지금도 크래시하는가»를 한 줄 넣을 거리다.
