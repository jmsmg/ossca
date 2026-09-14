제목: [extensions] Remove the expired install_time pref migration from ExtensionPrefs (TODO: Remove in M113)

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `self-issues` (템플릿이 자동 부착) · self-assign
Status: **`멘티 작업 진행 중`** (CL 미업로드 — 커밋은 만들어졌으나 리눅스 서버에만 있어 Mac에서 다시 만든 뒤 `unit_tests` 검증 후 업로드)
`## Issue` 헤딩과 맨 아래 안내문은 지운다.

**Description**

- 발견 경로: 코드 상향 — «Remove in M\<n\>» 형태의 만료 주석을 트리 전체에서 스윕해 나온 후보 큐 1순위. crbug에는 대응 이슈가 없고 코드의 TODO에도 버그 번호가 없다
- `extensions/browser/extension_prefs.h:777`의 `// TODO(anunoy): Remove this in M113.` 아래 `BackfillAndMigrateInstallTimePrefs()`는 옛 `install_time` pref 키가 남아 있으면 `last_update_time`·`first_install_time`으로 옮기고 옛 키를 지우는 **일회성 이행**이다(`extension_prefs.cc:2550`). `ExtensionPrefs` 생성자(`:2216`)에서 프로필을 열 때마다 호출된다
- M113은 2023년 4월 브랜치이고 트리는 현재 M155(`chrome/VERSION`)라 **42개 마일스톤**이 지났다. 그 사이 열린 프로필은 전부 이행을 마쳤으므로 함수는 매 시작마다 확장 목록을 훑고 아무것도 하지 않는다. `kPrefDeprecatedInstallTime`(`:201`)의 유일한 사용처가 이 함수라 상수도 함께 제거 대상이다
- 수정 내용: 선언·주석·`friend class ExtensionPrefsMigratesToLastUpdateTime;`(`.h`), 상수·생성자 호출·함수 정의(`.cc`), 그 이행만 검사하는 픽스처와 `TEST_F`(`chrome/browser/extensions/extension_prefs_unittest.cc:663–708`)를 삭제한다. 3파일 −82줄, 순수 삭제. `git grep`으로 잔여 참조 0
- 범위 주의: 같은 파일의 `MigrateDeprecatedDisableReasons()`도 선언부 TODO는 M89로 낡았지만, 본문에 만료되지 않은 ChromeOS 정리 코드(`crbug.com/380780352`)가 붙어 있어 **제외**했다. 선언부 TODO만 보고 지우면 살아 있는 코드를 날린다
- 검증: 동작 불변(이행할 데이터가 남아 있지 않음)이라 `unit_tests --gtest_filter='ExtensionPrefs*'` 기존 테스트 통과가 검증. 업로드 전 로컬에서 수행(try-job 권한 없음)
- 리뷰어 후보: TODO 작성자 anunoy@chromium.org(이 파일에서 활동 중) 또는 `extensions/OWNERS`

**References**

- TODO와 선언: https://crsrc.org/c/extensions/browser/extension_prefs.h;l=777
- 함수 정의: https://crsrc.org/c/extensions/browser/extension_prefs.cc;l=2550 · 생성자 호출: https://crsrc.org/c/extensions/browser/extension_prefs.cc;l=2216 · 상수: https://crsrc.org/c/extensions/browser/extension_prefs.cc;l=201
- 제거 대상 테스트: https://crsrc.org/c/chrome/browser/extensions/extension_prefs_unittest.cc;l=663
- 제외한 이웃 함수의 살아 있는 코드: https://crbug.com/380780352
