제목: [web_applications] Remove the Adobe Express OEM-to-default install migration (b/314865744, "remove in ~M134")

템플릿: **직접 찾은 이슈 등록** (공개 crbug 없음, 내부 b/314865744) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-23 만료 마일스톤 주석 스윕, 리눅스(ChromeOS) 전용 후보 W
- 배경: `chrome/browser/web_applications/ash/migrations/adobe_express_oem_to_default_migration.h` — Adobe Express 앱이 `kApsDefault` 지원 전 우회로 `kOem`으로 설치되던 것을 `kApsDefault`로 옮기는 일회성 마이그레이션(b/300529104). 주석: «TODO(b/314865744): Remove this migration in ~M134». 도입 CL `fd8978318166f`(tsergeant@, 2023-12), 2024-10 elkurin@가 지금 위치로 옮김
- 호출처는 `WebAppProvider`의 sync bridge 준비 직후 한 곳(`web_app_provider.cc:512-518`, `#if BUILDFLAG(IS_CHROMEOS)`). 트리는 M156
- 수정: `ash/migrations/` 디렉터리 전체(5파일: .h/.cc/browsertest/BUILD.gn/DEPS) 삭제, `web_app_provider.cc` include·호출 삭제, `web_applications/BUILD.gn` 참조 3곳 삭제 — 덤으로 «TODO(b/332804822): Resolve circular includes»의 `allow_circular_includes_from`도 사라진다. 약 −225줄, 7파일 (M)
- 트레일러: `Bug: b:314865744`
- 검증: ChromeOS 빌드 `gn gen` + `unit_tests` 링크(`web_app_provider.cc` 컴파일). 삭제되는 browsertest 외에 이 경로의 테스트는 없음. `browser_tests`는 4코어 박스에 너무 무거워 생략
- 선점: OSSCA 겹침 0
- 리뷰어: chrome/browser/web_applications/OWNERS(chromium-webapps-reviews@ 풀) — 원 CL 작성자 tsergeant@가 활동 중이면 먼저

**References**

- https://crsrc.org/c/chrome/browser/web_applications/ash/migrations/adobe_express_oem_to_default_migration.h
- https://crsrc.org/c/chrome/browser/web_applications/web_app_provider.cc;l=512
