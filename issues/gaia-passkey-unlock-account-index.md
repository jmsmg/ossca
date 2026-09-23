# [C] kSigninChromePasskeyUnlockUrlUsesAccountIndex 만료 플래그 제거 — google_apis/gaia

**상태: ✅ 5단계 업로드(09-23, Mac) — [8447532](https://crrev.com/c/8447532) PS1 ready, 리뷰어 alexilin@ · CC amoseui@, hashtag signin. 이전: 4단계 검증 완료(09-22 01:40, Mac) — verify-abec 통합 빌드 12m29s/623스텝 ✓ · google_apis_unittests GaiaUrlsTest.* 20/20 (이름 바꾼 passkey 테스트 2개 포함) · presubmit ✓. 3단계 완료(09-22 01:05) — 브랜치 `gaia-passkey-unlock-account-index-flag` (base 2ca4848 = 09-21 main) 커밋 `16e163cb1f770` (+2/−45, 4파일), gn check OK. 검증은 통합 브랜치 `verify-abec`(A+B+E+C)에서 한 번에(러너 `abec_test_mac.sh`). OSSCA 이슈 등록 허가 대기(초안 `steps/2-ossca-issue/drafts/gaia-passkey-unlock-account-index.md`).**

## 링크

- crbug: 없음 (직접 발굴; «Enabled by default in M150. Remove in or after M153»)
- Gerrit: https://crrev.com/c/8447532 (PS1 09-23, 리뷰어 alexilin@ · CC amoseui@)
- OSSCA 이슈: **#498** (2026-09-23, 라벨 2026·chromium-issues·self-issues, self-assign)
- 발굴 경로: 코드 상향 — 09-21 «Remove … M<n>» 만료 주석 재스윕 (1단계 STATUS 후보 C)

## 무엇을 지우나

패치 `steps/3-branch-and-fix/patches/C-*.patch` 참고. 플래그 정의(+선언)와 TODO 삭제, 사용처의 플래그 항 제거(켜진 분기 유지), 파일에서 유일했던 `FeatureList`/`ScopedFeatureList` 사용이 사라진 include 제거. 동작 불변.

## 검증 계획

- 타깃: google_apis_unittests `GaiaUrlsTest.*`. `verify-abec`에서 media_unittests·viz_unittests·google_apis_unittests를 `-j 4`로 한 번에 빌드
- 마커 `logs/abec_done.marker` (BUILD / TEST_MEDIA / TEST_VIZ / TEST_GAIA)

## 리뷰어 (순차, 09-21 규칙)

- google_apis/gaia OWNERS(components/signin + alexilin@) 1명 → 1명. CC amoseui@chromium.org

## 트레일러

`Bug: none`

## 진행 체크리스트

- [x] 1단계 착수 검증 (09-21: 선점 0·OSSCA 0·파일 열린 CL 무관)
- [x] 2단계 OSSCA 이슈 등록 — ✅ **#498** (09-23)
- [x] 3단계 브랜치·수정·format·gn check·커밋 `16e163cb1f770` (09-22)
- [x] 4단계 — ✅ 09-22 verify-abec 통합 빌드 12m29s/623스텝, google_apis_unittests GaiaUrlsTest.* 20/20 (이름 바꾼 passkey 테스트 2개 포함), presubmit OK
- [ ] 5단계 업로드 (리뷰어 1명 + `--cc amoseui@chromium.org`)
- [ ] 7단계 기록 PR
