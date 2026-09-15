# [자체 발굴] extension_service의 만료된 강제설치 재활성화 우회 제거 (M107)

**상태: 09-15 리눅스 박스에서 착수 — 브랜치 `extension-service-force-install-workaround` (base 233e625e, 빌드 트리와 일치). 검증 진행 중.**

## 링크

- crbug: **40144051** (접근 제한 — 원 CL의 `Bug: 1114778`과 같은 이슈) → `Bug: 40144051`
- 원 CL: https://crrev.com/c/3665201 (nicolaso@, 2022-05-25, M104) «[Extensions] Re-enable force-installed extensions»
- Gerrit: (미업로드)
- OSSCA 이슈: **#443** (2026-09-15 등록)
- 발굴 경로: **2. 코드 상향** — 09-15 «Remove … in M<n>» 만료 주석 스윕

## 무엇을 지우나

`chrome/browser/extensions/extension_service.cc` `CheckManagementPolicy()` 안의 12줄:
`MustRemainEnabled()`이면 `DISABLE_EXTERNAL_EXTENSION`을 `to_remove`에 넣는 블록 + 주석.

## 왜 지워도 되나 (호출처 5분 확인 결과)

- 원 CL이 두 군데를 고쳤다. **정상 경로**는 `ExternalProviderManager::OnExternalExtensionUpdateUrlFound()`
  (지금은 `external_provider_manager.cc:374-396`): 정책 provider가 더 높은 우선순위 위치로 확장을 보고하면
  `DISABLE_USER_ACTION`·`DISABLE_EXTERNAL_EXTENSION`·`DISABLE_PERMISSIONS_INCREASE`를 지우고 활성화.
  이 블록은 «이전 버전에서 이미 깨진 프로필» 용 일회성 보정이라고 작성자가 직접 적었다
- M107 → 트리 M155, 48 마일스톤 경과. `CheckManagementPolicy()`는 시작 시(`Init`) 항상 돌므로 깨진 프로필은 이미 전부 거쳤다

## 테스트가 이 블록에 기대고 있었다

`ExtensionServiceTest.ExternalExtensionBecomesEnabledIfForceInstalled`(원 CL이 같이 추가)는
포스리스트 pref만 바꾼다 → `OnExtensionManagementSettingsChanged()` → `CheckManagementPolicy()`.
단위 테스트에는 실제 정책 external provider가 없어서 `OnExternalExtensionUpdateUrlFound()`는 호출되지 않는다.
→ 블록만 지우면 이 테스트가 깨진다(1단계 빌드에서 확인 예정). 테스트를 지우지 않고
`external_provider_manager()->OnExternalExtensionUpdateUrlFound(info, true)`를 직접 호출하는
기존 패턴(`UserInstalledExtensionThenRequiredByPolicyOnRestart`)으로 옮겨 **실제 경로를 커버**하게 바꾼다.

## 진행

- [x] 호출처·이력 확인 (원 CL 3665201, 정상 경로 external_provider_manager.cc)
- [x] 블록 삭제 (−12)
- [ ] 1단계: 삭제만 하고 기존 테스트 실행 → 실패 확인 (`logs/extsvc_step1_*`)
- [ ] 2단계: 테스트를 실제 경로로 재작성 → 통과 (`logs/extsvc_step2_*`)
- [ ] 넓은 필터 `ExtensionServiceTest.*` 통과
- [ ] `git cl format` + 커밋 (AI 흔적 0)
- [ ] origin/main 리베이스 후 업로드 — 리뷰어 rdevlin.cronin@ + andreaorru@ (extensions OWNERS), CC nicolaso@(원 작성자)

## 충돌 예보

파일에 열린 CL 29건(anunoy@ 8081840 등, `track.py file` 09-15). 이 블록을 건드리는 것은 없음.
