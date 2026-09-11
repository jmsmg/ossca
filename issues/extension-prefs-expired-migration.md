# [자체 발굴] extension_prefs의 만료된 install_time 마이그레이션 제거

**상태: 브랜치 `extension-prefs-drop-installtime-migration`, 커밋 `134e015c8c3e4` (3파일 −82) — 빌드·테스트 중 (tmux `extprefs`)**

## 링크

- crbug: **없음** — 코드 안 TODO에 버그 번호가 없다. `Bug: None`
- Gerrit: 미업로드
- OSSCA 이슈: 미등록 → **「직접 찾은 이슈 등록」 템플릿**
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
- [x] 커밋 `134e015c8c3e4` (AI 귀속 줄 없음 확인)
- [ ] 빌드 `unit_tests` + `--gtest_filter='ExtensionPrefs*'` — **업로드 전 필수**(CQ 권한 없음)
- [ ] 업로드 — 리뷰어 후보 `anunoy@chromium.org`(TODO 작성자, 이 파일 활동 중) 또는 `extensions/OWNERS`
- [ ] OSSCA 이슈 등록
- [ ] 7단계 기여 기록 PR
