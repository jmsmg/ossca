제목: [storage/browser/quota] QuotaDatabase test clock is left dangling after QuotaDatabaseTest, crashing later tests in the same process

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `self-issues` (템플릿이 자동 부착) · self-assign
Status: **`gerrit 리뷰 중`** (등록이 밀려 CL이 이미 올라가 있음 — CL 8377022 PS3, evanstade@ 리뷰 중)
`## Issue` 헤딩과 맨 아래 안내문은 지운다.

**Description**

- 발견 경로: 다른 CL(quota 만료 `NotFatalUntil::M148` 정리, https://crrev.com/c/8377550)을 검증하던 중 `storage_unittests`가 크래시했다. 처음엔 내 변경 탓으로 보고 이분 탐색을 반복했으나 결과가 모순됐고, 대조군을 **같은 필터**로 main에서 돌리자 똑같이 죽어 사전 실패임을 확인했다. crbug에는 등록된 버그가 없다
- `storage/browser/quota/quota_database.cc`는 파일 전역 `const base::Clock* g_clock_for_testing`을 두고 `QuotaDatabase::GetNow()`가 이 값이 있으면 그 클럭을, 없으면 `base::Time::Now()`를 반환한다. `SetClockForTesting()`은 전역에 포인터를 대입만 한다
- `quota_database_unittest.cc`의 `QuotaDatabaseTest`는 생성자에서 `SimpleTestClock`을 만들어 전역에 심고 `TearDown()`에서 되돌리지 않는다. 픽스처가 소멸하면 클럭은 해제되지만 전역은 그대로 남아, 같은 프로세스에서 뒤이어 `QuotaDatabase`를 만드는 테스트가 해제된 객체에 가상 호출을 한다
- ToT 재현: `storage_unittests --gtest_filter='Quota*:*Quota*:UsageTracker*:ClientUsageTracker*:StorageDirectory*'` 배치에서 `QuotaConfigs/QuotaManagerImplParamTest.ReportedQuotaConfigurability`가 CRASHED (Linux `SIGSEGV SEGV_MAPERR 0x10`, arm64 Mac `SIGBUS BUS_ADRALN`, 스택은 `QuotaDatabase` 생성자). 같은 테스트를 단독으로 돌리면 통과 — 순서 의존 수명 버그라 flaky처럼 보인다
- 수정 방향: 첫 판은 `SetClockForTesting()`이 `base::AutoReset`을 반환해 스코프를 벗어나면 복구되게 하는 것이었으나(PS1), 리뷰어(evanstade@)의 제안대로 **테스트 클럭 장치를 없애고 `TaskEnvironment`의 mock time을 쓰는 판(PS2)** 으로 재작성했다. `QuotaManagerImplTest`는 이미 `TimeSource::MOCK_TIME`이라 `Time::Now()`가 곧 mock 클럭이고, `QuotaDatabaseTest`는 `RunLoop`을 쓰지 않아 MOCK_TIME으로 바꿔도 영향이 없다. 전역과 세터를 삭제하고 `GetNow()`는 `base::Time::Now()`가 된다. 4파일 +30/−85
- 검증: 패치 전 배치 크래시 재현 → 패치 후 `*QuotaDatabase*` 57/57, 위 필터 319/319(Mac), 크래시 0. mock time으로 바꾸자 `QuotaDatabaseTest.Stale`이 400일 정체 경계(exclusive 비교)를 두 `Now()` 호출 사이의 실제 시계 드리프트에 기대어 통과하고 있던 것이 드러나, 경계를 명시적으로 넘기도록 함께 고쳤다

**References**

- Gerrit: https://crrev.com/c/8377022
- 전역 클럭과 `GetNow()`: https://crsrc.org/c/storage/browser/quota/quota_database.cc;l=77 · https://crsrc.org/c/storage/browser/quota/quota_database.cc;l=916
- 되돌리지 않는 픽스처: https://crsrc.org/c/storage/browser/quota/quota_database_unittest.cc;l=69
- mock time: https://crsrc.org/c/base/test/task_environment.h;l=123
- 순서 의존 테스트 방침: https://crsrc.org/c/docs/testing/identifying_tests_that_depend_on_order.md
- 발견 계기 CL: https://crrev.com/c/8377550
