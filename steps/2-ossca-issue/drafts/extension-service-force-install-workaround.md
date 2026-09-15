제목: [extensions] Remove the expired force-installed re-enable workaround in ExtensionService (TODO: safe to remove in M107)

템플릿: **직접 찾은 이슈 등록** (crbug 40144051 은 접근 제한) · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 2026-09-15 «Remove … in M<n>» 만료 주석 스윕. `chrome/browser/extensions/extension_service.cc:640-649`: 관리 정책상 반드시 켜져 있어야 하는(`MustRemainEnabled`) 확장에서 `DISABLE_EXTERNAL_EXTENSION` disable reason을 제거하는 블록에 «TODO(crbug.com/40144051): This won't be needed after a few milestones. It should be safe to remove in M107»
- 2022-05 [CL f5602db82c56a](https://crrev.com/f5602db82c56a) (nicolaso@, «Re-enable force-installed extensions»)이 넣은 코드로, 정상 경로는 `OnExternalExtensionUpdateUrlFound()`가 처리하고 이 블록은 «이전 버전에서 이미 깨진 프로필을 고치는» 임시 조치였다. 트리는 M155라 48개 마일스톤이 지났다. crbug 40144051은 접근 제한 이슈라 내용은 볼 수 없다
- 수정: 해당 `if` 블록(주석 포함 10줄) 삭제. `DISABLE_EXTERNAL_EXTENSION`의 다른 처리 경로는 그대로
- 검증: `unit_tests --gtest_filter='ExtensionService*'` (이미 빌드된 `unit_tests` 캐시 활용)
- 선점: 연결 CL 0 · OSSCA 겹침 0. 파일에 열린 CL 29건(anunoy@·dft@ 등)이나 이 블록과 무관 — 착수 전 재확인
- 리뷰어(2명): extensions OWNERS — rdevlin.cronin@(8397391 리뷰어) + andreaorru@

**References**

- https://crsrc.org/c/chrome/browser/extensions/extension_service.cc;l=640
- 원 CL: https://crrev.com/f5602db82c56a · crbug(접근 제한): https://crbug.com/40144051
