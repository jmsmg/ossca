# [자체 발굴] extension_prefs의 만료된 install_time 마이그레이션 제거

**상태: 09-11 Mac에서 재작성 — 브랜치 `extension-prefs-drop-installtime-migration`, 커밋 `e54665a5dd6bd` (3파일 −82, 서버 판 134e015c8c3e4와 동일 규모). **검증 완료(09-11 21:31)**: 오브젝트 컴파일 ✓ · `unit_tests` 빌드 ✓ (3시간 23분, 36,619스텝, `-j 6`) · `unit_tests --gtest_filter='ExtensionPrefs*'` **28/28** ✓ (로그 `steps/4-build-and-test/logs/extprefs_*.log`). **업로드 대기.**

## 링크

- crbug: **없음** — 코드 안 TODO에 버그 번호가 없다. `Bug: None`
- Gerrit: **https://crrev.com/c/8397391** (PS1 2026-09-14, 리뷰어 rdevlin.cronin@, CC anunoy@)
- OSSCA 이슈: **#423** (2026-09-11 등록)
- 발굴 경로: **2. 코드 상향** — 09-09 «Remove in M\<n\>» 만료 주석 스윕에서 나온 후보 큐 1순위

## 착수 시점에 범위가 줄었다

큐에는 **함수 2개**(`BackfillAndMigrateInstallTimePrefs` M113 만료 · `MigrateDeprecatedDisableReasons` M89 만료)로
적어뒀지만, ToT에서 본문을 다시 읽으니 **1개만 제거 가능**하다.

```cpp
void ExtensionPrefs::MigrateDeprecatedDisableReasons() {
  ...
#if BUILDFLAG(IS_CHROMEOS)
  // Perform a post-Lacros cleanup by clearing the old Ash keeplist enforcement.
  // TODO(crbug.com/380780352): Delete this after the stepping stone and then
  // remove DEPRECATED_DISABLE_NOT_ASH_KEEPLISTED from the disable_reason enum.
```

선언부 주석은 `// TODO(archanasimha): Remove this around M89.`로 **낡았지만**, 본문에는 그 뒤에 들어온
**만료되지 않은 ChromeOS 정리 코드**가 있다. 선언부 TODO만 보고 지웠으면 살아 있는 코드를 날렸다.

> 교훈: 만료 주석 스윕에서 «선언부의 TODO 마일스톤»은 후보를 **찾는** 근거일 뿐,
> 지워도 되는지는 **본문을 처음부터 끝까지** 읽고 판단한다. (`steps/1-issue-hunting/GUIDE.md`)

## 무엇을 지웠나

| 위치 | 내용 |
|---|---|
| `extension_prefs.h` | 선언 + 주석 4줄, `friend class ExtensionPrefsMigratesToLastUpdateTime;` |
| `extension_prefs.cc` | `kPrefDeprecatedInstallTime` 상수(+주석 3줄), 생성자의 호출 1줄, 함수 정의 22줄 |
| `chrome/browser/extensions/extension_prefs_unittest.cc` | `ExtensionPrefsMigratesToLastUpdateTime` 픽스처 + `TEST_F` 47줄 |

3파일 **−82줄, 순수 삭제**(추가 0줄). `git grep`으로 잔여 참조 0 확인.

`kPrefDeprecatedInstallTime`은 이 함수가 **유일한 사용처**라 같이 나간다.

## 왜 지워도 되나

- `// TODO(anunoy): Remove this in M113.` — M113은 **2023년 4월** 브랜치. 트리는 지금 **M155**(`chrome/VERSION`) → **42 마일스톤 경과**
- 하는 일이 «옛 `install_time` 키가 남아 있으면 `first_install_time`/`last_update_time`으로 옮기고 옛 키를 지운다»라
  **한 번 돌면 끝나는 일회성 이행**이다. M113 이후 프로필은 전부 이미 통과했다
- 프로덕션 호출처는 `ExtensionPrefs` 생성자 1곳, 테스트 호출처는 제거하는 그 테스트 1곳

## 진행

- [x] 범위 재확인 (2개 → 1개)
- [x] 수정 + `git cl format` + 잔여 참조 0 확인
- [x] 커밋 `134e015c8c3e4` (서버, 소실) → **Mac 재작성 커밋 `e54665a5dd6bd`** (09-11, AI 귀속 줄 없음)
- [x] 빌드 `unit_tests` + `--gtest_filter='ExtensionPrefs*'` — ✅ 09-11 Mac, 3h23m 빌드, **28/28**
- [x] 업로드 — ✅ 09-14 **CL 8397391**, 리뷰어 rdevlin.cronin@(extensions OWNER, 올해 이 파일 8커밋), CC anunoy@(TODO 작성자), presubmit 0 경고
- [x] OSSCA 이슈 등록 — #423 (09-11)
- [x] 7단계 기여 기록 PR — ✅ **#437** (사용자 09-14 23:22 KST 제출, CI pass; 제목의 줄바꿈 오타는 에이전트가 `gh pr edit`로 수정)
- [x] 리뷰 1라운드: **rdevlin.cronin@ CR+1 «Thank you for the cleanup! LGTM!»** (09-14 17:56 UTC, 9시간 만에)
- [x] 두 번째 리뷰어 andreaorru@chromium.org 추가 (09-15, 사용자) → 어텐션 andreaorru@. +1 오면 CQ 요청
- [ ] OSSCA #423 Status → `gerrit 리뷰 중` (보드, 사용자)
