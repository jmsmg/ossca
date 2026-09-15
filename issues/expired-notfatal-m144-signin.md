# [자체 발굴] 만료 NotFatalUntil::M144 — signin 3곳 + enum 항목 삭제

**상태: 4단계 검증 완료(09-15, Mac) — `unit_tests`+`base_unittests` 전 트리 빌드 4h46m/59,127스텝 ✓ · `DiceWebSigninInterceptor*:TurnSyncOnHelper*` 95/95 ✓ · `CheckTest.*:CheckDeathTest.*` 26/26 ✓. 브랜치 `expired-notfatal-m144-signin` 커밋 `bb98018e65923`. **CL 8409786 업로드 완료(09-15).** OSSCA #439 — 진행 코멘트 허가 대기.**

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
- [ ] 7단계 기록 PR
