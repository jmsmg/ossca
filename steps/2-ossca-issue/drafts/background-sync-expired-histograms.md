제목: [Background Sync] Remove the expired BackgroundSync histograms

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-29 «만료된 히스토그램 기록 코드» 스캔 (1단계 STATUS 후보 HH). `content/browser/background_sync/background_sync_metrics.cc` 의 `BackgroundSyncMetrics` 가 기록하는 히스토그램 20개 중 **19개가 2022-07-31 ~ 2025-02-16 에 만료**. `expired_intentionally` 없음. 살아 있는 것은 `BackgroundSync.Event.OneShotResultPattern`(2027-01-31 만료) 하나
- 근거: `tools/metrics/histograms/README.md` — 만료된 히스토그램의 기록 코드는 죽은 코드이므로 지우고 histograms.xml 항목도 정리
- 수정:
  - 만료 히스토그램만 기록하던 함수 7개(`RecordEventStarted`, `RecordRegistrationComplete`, `RecordBatchSyncEventComplete`, `CountRegisterSuccess`, `CountRegisterFailure`, `CountUnregisterPeriodicSync`, `RecordEventsFiredFromWakeupTask`)와 `BackgroundSyncManager` 의 호출처 삭제
  - 지표에만 쓰이던 코드 삭제: `RegistrationCouldFire`·`RegistrationIsDuplicate` enum, 배치 시작 시각, 이벤트 시작 때의 main frame client 조회. `RecordFailureAndPostError()` → `PostError()`
  - 남는 함수는 `RecordOneShotEventResult()` — periodic 이벤트 완료 때는 조회 자체를 건너뜀
  - 이벤트 묶음이 끝나면 완료 콜백을 부르는 barrier 는 **동작에 필요하므로 유지**(`OnAllSyncEventsCompleted()` 대신 `BindPostTaskToCurrentDefault`)
  - `CountRegisterSuccess()` 안의 periodic `min_interval` CHECK 는 `Register()` 입구의 CHECK 가 같은 조건을 이미 보장해 함께 제거
  - histograms.xml 19항목(background 16 · others 3), 다른 곳에서 안 쓰게 된 enum 6개, `BACKGROUND_SYNC_STATUS_MAX` 삭제. `HistogramsRecordedAtCompletion` 테스트는 살아 있는 one-shot 결과 히스토그램을 검사하도록 변경
  - 10파일 +43/−638
- 범위 밖: 같은 `metadata/background` 의 `BackgroundSync.{LaunchTask.PlayServicesAvailable, NetworkObserver.HasPermission, Wakeup.DelayTime, Periodic.Wakeup.DelayTime}` 도 만료됐지만 다른 파일(Android 런처·네트워크 옵저버·wakeup)에서 기록 — 후속 후보
- 검증: 바뀐 소스 4개 개별 컴파일 ✓. `content_unittests` 는 이 Mac 에서 첫 빌드라 `hh_test_mac.sh`(tmux) 로 `*BackgroundSync*` 실행 예정. `pretty_print`·`validate_format` ✓ (처음엔 enum 3개 미사용 오류 → 같이 삭제)
- 선점: 열린 CL 은 대량 CL 뿐 — arthursonzogni@ 의 WIP 8419176(815파일, `NotFatalUntil` 제거)이 지우는 `CHECK_GE` 줄을 건드림 → 어느 쪽이 먼저든 리베이스 한 번. OSSCA 0
- 리뷰어: peter@ (components/background_sync OWNER = content/browser/background_sync). 히스토그램 owner nator@ 는 장기 휴가, rayankans@ 는 계정 없음. `metadata/background`·`metadata/others` histograms.xml 과 `enums.xml` 은 metrics 리뷰어 몫 → +1 뒤 chromium-metrics-reviews@google.com. CC amoseui@

**References**

- https://crsrc.org/c/content/browser/background_sync/background_sync_metrics.cc
- https://crsrc.org/c/tools/metrics/histograms/README.md
