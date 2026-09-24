제목: [ash] Remove the expired graphics tablet pen button trimming migration (TODO "remove after 07/2025 (M139)")

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-23 만료 마일스톤 주석 스윕, 리눅스(ChromeOS) 전용 후보 Z
- 배경: `ash/system/input_device_settings/pref_handlers/graphics_tablet_pref_handler_impl.cc:25-62` 의 `TrimButtonRemappingListForGraphicsTabletPen()` — 잘못 들어간 메타데이터 때문에 저장된 펜 버튼 목록에 생긴 가짜 버튼을 잘라내는 일회성 정리. 주석: «TODO(dpad): Remove after 07/2025 (M139) as this trimming will no longer be needed». 도입 CL `b8d424aeb4089`(dpad@, 2024-07-19)
- 호출처는 `InitializeGraphicsTabletSettings()` 한 곳. 정리 결과는 곧바로 `UpdateGraphicsTabletSettings()`로 prefs에 저장되므로 M139까지 한 번이라도 태블릿을 연결한 기기는 이미 정리됐다. 트리는 M156
- 수정: 함수(와 그것만 담은 익명 namespace)·호출 삭제, 이 정리만 검사하던 테스트 `TrimPenButtonList`·`TrimPenButtonListWithDefaultAction` 삭제. 약 −125줄, 2파일
- 트레일러: 버그 없음 → `Bug: None`
- 검증: ChromeOS 빌드 `ash_unittests --gtest_filter='GraphicsTabletPrefHandlerTest.*'` (수정 전 대조군 7/7 ✓ 09-24)
- 선점: OSSCA 겹침 0
- 리뷰어: ash/system/input_device_settings/OWNERS — michaelcheco@ · wangdanny@. 작성자 dpad@가 활동 중이면 함께

**References**

- https://crsrc.org/c/ash/system/input_device_settings/pref_handlers/graphics_tablet_pref_handler_impl.cc;l=25
