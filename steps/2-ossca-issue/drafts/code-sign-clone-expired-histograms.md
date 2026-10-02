제목: [mac] Remove the expired Mac.AppCodeSignClone* histograms

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 10-02 «파일 전체 만료» 재스캔 (1단계 STATUS 후보 HJ). `chrome/browser/mac/code_sign_clone_manager.mm` 이 기록하는 `Mac.{AppHardLinkError, AppClonefileError, AppCodeSignCloneCount, AppCodeSignCloneExists, AppCodeSignCloneCreationTime}` 5개가 **모두** 2025-08-03 ~ 2025-10-05 에 만료. `expired_intentionally` 없음. 전부 이름이 그대로 적힌 literal, 테스트 참조 0
- **Mac 전용 코드**라 이 Mac 에서만 빌드·테스트 가능 (HD 와 같은 강점)
- 근거: `tools/metrics/histograms/README.md` — 만료된 히스토그램의 기록 코드는 죽은 코드이므로 지우고 histograms.xml 항목도 정리
- 지표 때문에만 하던 **실제 작업**도 함께 사라짐:
  - `RecordCloneCount()` — clone 이 만들어질 때마다 clone 임시 디렉터리에 `getattrlist()` 호출해 항목 수를 셈
  - clone 존재 확인 타이머 — 하루에 한 번 깨어나 clone 의 main executable 과 Info.plist 존재를 확인하고, 사라졌으면 기록한 뒤 멈춤. 기록 외에 하는 일 없음
- 수정: 기록 helper 4개와 호출, `RecordCloneCount()`, `MacCloneExists` enum·`CloneExists()`·타이머 3메서드와 멤버, clone 생성 시간 측정, 그 검사에만 쓰이던 `kContentsInfoPlist` 상수, 안 쓰게 된 include 5개 삭제(헤더는 `base/timer/timer.h` 대신 실제로 쓰는 `base/task/sequenced_task_runner.h`). histograms.xml 5항목과 `MacCloneExists` enum 삭제(`MacErrno` 는 다른 히스토그램이 써서 유지). 4파일 +1/−226, clone 생성·정리 동작 불변
- 검증: main `9143293`(10-01) 위 `unit_tests` 증분 13스텝 24초(경고 없이 컴파일 — 미리 지운 `kContentsInfoPlist` 확인), `--gtest_filter='CodeSignCloneManagerTest.*'` **10/10**. presubmit 통과, `pretty_print`·`validate_format` ✓
- 선점: 열린 CL 은 DO NOT SUBMIT 대량 CL 뿐 · OSSCA 0
- 리뷰어: avi@ (`chrome/browser/mac` → `ui/base/cocoa/OWNERS`, 그리고 `metadata/mac` OWNER — 한 명으로 전부. 히스토그램 owner 이기도 함). CC amoseui@

**References**

- https://crsrc.org/c/chrome/browser/mac/code_sign_clone_manager.mm
- https://crsrc.org/c/tools/metrics/histograms/README.md
