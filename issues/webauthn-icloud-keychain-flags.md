# [자체 발굴] WebAuthn iCloud Keychain 롤아웃 플래그 3개 제거 — device/fido + chrome/browser/webauthn

**상태: 4단계 검증 완료(09-16, Mac) — `unit_tests` 빌드 3h34m38s/37,212스텝 ✓, `ChromeAuthenticatorRequestDelegate*` 6/6 ✓ (`ShouldCreateInICloudKeychain` 포함). 브랜치 `webauthn-icloud-keychain-flags` 커밋 `79633a3c0442d` (+8/−40, 3파일). **CL 8412192 업로드 완료(09-16, PS3).** OSSCA #441 — 진행 코멘트·기록 PR 허가 대기.**

## 링크

- crbug: 없음 → `Bug: none`
- Gerrit: **https://crrev.com/c/8412192** (09-16; PS1은 `-s` 없이 올려 WIP → PS2 `-s`로 ready, PS3 설명 72자 재정렬)
- OSSCA 이슈: #441 (2026-09-15)
- 발굴 경로: 코드 상향 — 09-15 «Remove after M<n>» 만료 주석 스윕 중 `device/fido/public/features.cc`의 «Enabled in M118. Remove in or after M121» 셋

## 무엇을 지우나

- `device/fido/public/features.h` / `.cc`: `kWebAuthnICloudKeychainForGoogle`, `…ForActiveWithDrive`, `…ForInactiveWithDrive` (전부 `ENABLED_BY_DEFAULT`, M118 이후 기본 켜짐). `…ForActiveWithoutDrive`, `…ForInactiveWithoutDrive`는 «Not yet enabled by default»라 **남긴다**
- `chrome/browser/webauthn/chrome_authenticator_request_delegate.cc` `ShouldCreateInICloudKeychain()`: 5분기 결정 트리 → «google.com 요청 또는 iCloud Drive 켜짐 → `true`, 아니면 활성/비활성에 따라 남은 WithoutDrive 플래그 `IsEnabled`». `base::FeatureList`는 계속 쓰므로 include 유지
- 문자열 이름(`WebAuthenticationICloudKeychainFor…`) 포함 json/xml 잔여 참조 0, 테스트가 플래그를 직접 켜고 끄는 곳 없음(delegate_unittest.cc:1039 주석 «change detector»). 동작 불변

## 검증 계획

- 헤더 상태 함정: 현재 `out/Default`는 09-15 `unit_tests`(M144 브랜치, 59,127스텝) 뒤에 `media_unittests`(main 헤더, 7,917스텝)를 돌려 **섞인 상태**. `base/*.o`는 main 헤더(15:38), `chrome/browser/*`는 M144 헤더(14:37)
  → main 기반 브랜치로 `unit_tests`를 돌리면 chrome 쪽 ~5만 스텝 재빌드. 대신 검증 전용 브랜치 **`verify-441-with-m144`**(= #441 커밋 + M144 `6698162bab7d8` cherry-pick)에서 돌리면 base 쪽 ≤8천 스텝만 재빌드 **— 라고 예상했으나 실제 37,212스텝/3h34m**. 오늘 브랜치를 오가며 `base/not_fatal_until.h`의 mtime이 바뀐 탓에 `check.h`를 포함하는 파일이 전부 다시 빌드됐다(siso도 mtime 기준). 결론: M144 CL이 랜딩해 main에 들어오기 전엔 어느 브랜치든 `unit_tests`는 3.5시간
- 러너 `steps/4-build-and-test/scripts/webauthn_flags_test_mac.sh` (사용자 tmux) — verify 브랜치 checkout → `unit_tests` 증분 → `ChromeAuthenticatorRequestDelegate*` → 원 브랜치 복귀. 마커 `logs/webauthn_done.marker`
- 업로드는 깨끗한 `webauthn-icloud-keychain-flags`에서

## 리뷰어 (2명)

`chrome/browser/webauthn/OWNERS` = `file://device/fido/OWNERS` 라 한 세트로 두 파일 모두 커버.
최근 3개월 두 경로 커밋 수: derinel@ 19 · nsatragno@ 12 · kenrb@ 4 (martinkr@ 0)
- derinel@google.com
- nsatragno@chromium.org

## 진행 체크리스트

- [x] 발굴 + 선점 확인(플래그 이름 든 열린 CL 0) + OSSCA #441 (09-15)
- [x] 브랜치·수정·format·gn check·커밋 (09-16, `79633a3c0442d`)
- [x] 4단계 — ✅ 09-16 unit_tests 3h34m38s/37,212스텝, ChromeAuthenticatorRequestDelegate* 6/6
- [x] 5단계 업로드 — ✅ **CL 8412192** (09-16, 리뷰어 derinel@·nsatragno@, presubmit 0 경고)
- [ ] 7단계 기록 PR
