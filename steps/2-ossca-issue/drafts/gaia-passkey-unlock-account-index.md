제목: [google_apis/gaia] Remove the expired kSigninChromePasskeyUnlockUrlUsesAccountIndex flag (enabled in M150, "remove in or after M153")

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-21 «Remove … after M<n>» 만료 주석 재스윕. `google_apis/gaia/gaia_features.cc:11-14` «Intended as a Finch killswitch. Enabled by default in M150. Remove in or after M153» 아래 `BASE_FEATURE(kSigninChromePasskeyUnlockUrlUsesAccountIndex, ENABLED_BY_DEFAULT)`. 트리는 M156
- 내용: 패스키 잠금 해제 URL(`SigninChromePasskeyUnlockUrl`, `…DesktopEmbeddedUrl`)에 `authuser=<계정 인덱스>`를 붙이는 동작. 플래그가 꺼지면 인덱스 없는 옛 URL
- 수정: 선언(`gaia_features.h`)·정의(`gaia_features.cc`) 삭제, `gaia_urls.cc` 두 함수에서 꺼진 분기 제거, `gaia_urls_unittest.cc`의 `_FeatureDisabled` 테스트 2개 삭제·`_FeatureEnabled` 2개는 플래그 설정 없이 유지(이름에서 접미사 제거). 형제 플래그 `kSigninChromeSyncKeysUrlUsesAccountIndex`는 제거 지시가 없어 유지. 동작 불변
- 검증: `google_apis_unittests --gtest_filter='GaiaUrlsTest.*'` + 컴파일
- 선점: 플래그 이름 든 열린 CL 0 · 파일 열린 CL 0 · OSSCA 겹침 0
- 리뷰어: google_apis/gaia OWNERS(components/signin OWNERS + alexilin@) 중 1명 먼저. CC amoseui@

**References**

- https://crsrc.org/c/google_apis/gaia/gaia_features.cc;l=11
- https://crsrc.org/c/google_apis/gaia/gaia_urls.cc;l=279
