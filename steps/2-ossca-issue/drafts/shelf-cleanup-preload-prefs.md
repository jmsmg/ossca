제목: [shelf] Remove ChromeShelfPrefs::CleanupPreloadPrefs() (TODO: "can be removed once M127 is no longer in stable … mid 2025 is ok")

템플릿: **직접 찾은 이슈 등록** (crbug 350769496은 접근 제한 — #443과 같은 처리) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-23 만료 마일스톤 주석 스윕, 리눅스(ChromeOS) 전용 후보 X
- `chrome/browser/ui/ash/shelf/chrome_shelf_prefs.cc:472-493`: «TODO(crbug.com/350769496): Fixes bug from M127 beta, can be removed once M127 is no longer in stable (end of 2024, or mid 2025 is ok)» 아래 `CleanupPreloadPrefs()` — `ShelfDefaultPinLayoutRolls`(와 태블릿용) 목록에 중복으로 쌓인 'preload' 값을 걸러내는 일회성 정리. 호출처는 `AttachProfile()` 한 곳
- 도입: joelhockey@ 2024-07 `00b457526ab5a`(원인 수정 — 'preload'를 한 번만 씀) · `4055be54598e2`(정리 호출 위치 조정). crbug 350769496은 접근 제한 이슈라 내용은 볼 수 없다
- 트리는 M156. 주석이 허용한 «mid 2025»를 1년 넘게 지났다. 원인 수정과 그 회귀 테스트는 그대로 남는다
- 수정: `.cc` 함수·호출·이제 안 쓰는 `#include <set>`, `.h` 선언, 테스트 `ChromeShelfPrefsTest.CleanupPreloadPrefs` 삭제. −64줄, 3파일 (S)
- 트레일러: `Bug: 350769496` (원인 수정은 2024년에 끝났고 이 CL은 남은 정리라 `Fixed:` 대신)
- 검증: ChromeOS 빌드(`target_os="chromeos"`) `unit_tests --gtest_filter='ChromeShelfPrefsTest.*'` — 수정 전 21/21 → 수정 후 20/20 ✓ (나머지 9개는 `GOOGLE_CHROME_BRANDING` 전용). 브랜치 `shelf-cleanup-preload-prefs-350769496`
- 선점: OSSCA 겹침 0. 같은 파일에 열린 CL 8382427(kGeminiAppPreinstall reland)이 있으나 겹치는 줄 없음, 최신 main(09-24)과 충돌 없음
- 리뷰어: chrome/browser/ui/ash/shelf/OWNERS — diwux@ (1차) → khmel@

**References**

- https://crsrc.org/c/chrome/browser/ui/ash/shelf/chrome_shelf_prefs.cc;l=472
