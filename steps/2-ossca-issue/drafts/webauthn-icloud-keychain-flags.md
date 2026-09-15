제목: [device/fido] Remove the expired WebAuthn iCloud Keychain rollout flags (enabled in M118, "remove in or after M121")

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 2026-09-15 «Remove … M<n>» 만료 주석 스윕. `device/fido/public/features.cc`에 «Enabled in M118. Remove in or after M121» 주석이 붙은 플래그가 셋 있다: `kWebAuthnICloudKeychainForGoogle`, `kWebAuthnICloudKeychainForActiveWithDrive`, `kWebAuthnICloudKeychainForInactiveWithDrive`. 트리는 M155라 34개 마일스톤이 지났다
- 사용처는 `chrome/browser/webauthn/chrome_authenticator_request_delegate.cc`의 `ShouldCreateInICloudKeychain()` 한 곳. 요청이 google.com이면 / 활성 사용자+iCloud Drive / 비활성 사용자+iCloud Drive 조합마다 플래그를 골라 `IsEnabled`를 묻는데, 위 셋은 전부 기본 켜짐이다. 같은 결정 트리의 나머지 둘(`…ForActiveWithoutDrive`, `…ForInactiveWithoutDrive`)은 «Not yet enabled by default»라 **남긴다**
- 수정: 세 플래그의 선언(`features.h`)·정의(`features.cc`)를 지우고, 결정 트리를 «google.com 또는 iCloud Drive 켜짐 → true, 아니면 남은 두 플래그» 로 단순화. about_flags·enums·flag-metadata 등록 없음, 테스트가 플래그를 직접 켜고 끄는 곳 없음(`ICloudKeychainFor` grep 0). 동작 불변
- 검증: `unit_tests --gtest_filter='ChromeAuthenticatorRequestDelegate*'` (delegate_unittest.cc:1039의 `ShouldCreateInICloudKeychain` 테스트 포함)
- 선점: 플래그 이름이 든 열린 CL 0. delegate 파일은 열린 CL 48건으로 활발 → 올린 뒤 오래 묵히지 않는다
- 리뷰어(2명): device/fido OWNERS — kenrb@ · nsatragno@ · martinkr@ · derinel@ 중 최근 활동 둘

**References**

- 플래그: https://crsrc.org/c/device/fido/public/features.cc;l=66
- 사용처: https://crsrc.org/c/chrome/browser/webauthn/chrome_authenticator_request_delegate.cc;l=1161
