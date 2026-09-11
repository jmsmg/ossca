# [자체 발굴] QuotaDatabase 테스트 클럭 전역이 댕글링으로 남는 문제

**상태: [CL 8377022](https://crrev.com/c/8377022) — evanstade@가 09-10 18:48에 «mock time으로 가라» 제안. 조사 결과 그가 옳다 → PS2를 다시 만든다. 어텐션 우리**

## 링크

- crbug: **없음** — 원 코드에도 버그가 등록돼 있지 않고, 우리가 직접 찾음. `Bug: none`
- Gerrit: https://crrev.com/c/8377022 (브랜치 `quota-db-test-clock-leak`, 커밋 `0bce70f9916b6`)
- OSSCA 이슈: 미등록 → **「직접 찾은 이슈 등록」 템플릿** 사용 (crbug가 없으므로)
- 발굴 경로: **다른 CL 검증 중 우연히** — quota M148 정리(`quota-expired-notfatal-m148`)의 테스트가 깨져 원인을 쫓다 발견

## 어떻게 찾았나

quota M148 CL을 검증하는데 `storage_unittests`가 SIGSEGV로 죽었다. 처음엔 우리 변경 탓으로 봤으나
**대조군을 잘못 잡았다** — 실패한 실행은 러너 필터로 321개를 돌렸는데, main과 비교할 때는 8개짜리 좁은
필터를 썼다. 같은 321개 필터로 main을 돌리자 **똑같이 크래시**했다. 사전 실패였다.
(그 사이 이분 탐색을 5회 돌렸고 결과가 서로 모순됐다 — 재현 조건이 흔들린다는 신호였는데 늦게 알아챘다.
자세한 교훈은 `steps/4-build-and-test/GUIDE.md` «테스트가 깨졌을 때 — 대조군은 «같은 필터»로»)

## 원인

```cpp
// quota_database.cc:77 — 파일 전역
const base::Clock* g_clock_for_testing = nullptr;
// :917
return g_clock_for_testing ? g_clock_for_testing->Now() : base::Time::Now();
```

```cpp
// quota_database_unittest.cc — 생성자에서 심고 되돌리지 않음
QuotaDatabaseTest() {
  clock_ = std::make_unique<base::SimpleTestClock>();
  QuotaDatabase::SetClockForTesting(clock_.get());
}
void TearDown() override { ASSERT_TRUE(temp_directory_.Delete()); }   // 되돌리기 없음
```

픽스처가 소멸하면 `clock_`이 해제되는데 전역은 그대로 남는다 → 이후 테스트가 `GetNow()`를 부르면
**해제된 객체에 가상 호출** → `SIGSEGV SEGV_MAPERR 0x10`.

증거가 전부 맞물렸다: 단독 실행은 통과(선행 테스트가 없으므로) · 배치에서만 크래시 ·
스택이 `QuotaDatabase` 생성자 근처(인라인된 `GetNow()`의 오귀속) · main에서도 동일.

## 수정 — 왜 한 줄이 아니라 API 변경인가

한 줄(`TearDown`에 `SetClockForTesting(nullptr)`)로도 이 크래시는 사라진다(검증함, 321/321).
그런데 **`quota_manager_unittest.cc`에 같은 set/reset 쌍이 7개 더 있고, 7쌍 모두 사이에 `ASSERT_*`가 있다.**
단언이 실패하면 early return으로 되돌리기를 건너뛰어 **테스트 실패 하나가 엉뚱한 곳의 크래시로 번진다** —
방금 우리가 한 시간 쫓은 그 현상이다.

그래서 API가 스스로 되돌리게 했다:

```cpp
// 반환값을 살려두는 동안만 클럭이 적용되고, 스코프를 벗어나면 복구된다
static base::AutoReset<const base::Clock*> SetClockForTesting(const base::Clock* clock);
```

- 픽스처는 멤버로 보관 — **선언 순서 덕에 소멸 순서도 자동으로 맞는다**
  (`clock_` 선언 → `clock_override_` 선언 → 역순 소멸로 전역 복구가 먼저)
- `quota_manager_unittest.cc` 7쌍은 `auto clock_override = ...` 한 줄로 바뀌고 reset 7줄이 사라진다
- `base::AutoReset`은 클래스 자체가 `[[nodiscard]]`라 **받지 않으면 컴파일 경고**

4파일 +24/−26.

## 설계 판단의 근거 (조사한 것)

| 항목 | 결과 |
|---|---|
| 스타일 가이드 | `ForTesting`은 **명명·테스트 전용 제한**만 규정. RAII 여부는 규정 없음 |
| 관행 분포 | `void SetXForTesting` **558** vs `AutoReset` 반환 **51** — 다수파는 void |
| 추세 | AutoReset 반환 표본이 전부 2025년(01·09·11월) — 최근 늘어나는 패턴 |
| 직접 선례 | `chrome/browser/apps/link_capturing/chromeos_reimpl_navigation_capturing_throttle.h` — **클럭에 대해 같은 형태** |
| 프로젝트 방침 | `docs/testing/identifying_tests_that_depend_on_order.md`: *"stamp out all the tests that have ordering dependencies"* |
| 파급 범위 | 호출처가 **quota 안에만** 있고 전부 테스트 → 프로덕션 위험 0 |

**443042812와의 대비**: 그 CL은 "널이 올 수 **없는데**" 가드를 넣어 거짓 정보를 남기고 불변식 위반을
숨기는 게 문제였고, 해법은 CHECK 승격이었다. 이번은 **나쁜 상태가 실제로 발생**하고(재현·검증됨)
댕글링은 검사할 수단이 없어 CHECK가 선택지가 아니다. 다만 그 CL의 진짜 교훈 —
**증상을 덮지 말고 결함 자체를 고쳐라** — 는 그대로 적용돼 API 변경을 지지한다.

**물러설 지점**: 리뷰어가 "다수파대로 최소 수정만"이라고 하면 픽스처 소멸자 한 줄로 되돌린다.

## 검증

- `storage_unittests --gtest_filter='Quota*:*Quota*:UsageTracker*:ClientUsageTracker*:StorageDirectory*'`
  → main: **크래시** / main+한 줄: **321/321** / 최종 AutoReset 판: **321/321**
- `verify 8377022 1` 서버=로컬 동일 ✓

## 진행

- [x] 원인 규명 + 재현 + 최소 수정 검증
- [x] 설계 조사 (스타일 가이드·관행 분포·선례) 후 AutoReset 채택
- [x] CL 8377022 업로드 (evanstade@ 리뷰어, stevebe@ CC)
- [ ] OSSCA 이슈 등록 — **「직접 찾은 이슈 등록」 템플릿** (crbug 없음)
- [ ] 7단계 기여 기록 PR


---

## 리뷰 결과 (2026-09-10 18:48) — 설계가 바뀐다

evanstade@가 표를 주지 않고 두 가지를 남겼다.

> `quota_database.h:235` — I think the best fix is probably to stop using a test
> clock and instead use a task environment with **mock time**.

> `/COMMIT_MSG:16` — if this is not hypothetical, does LUCI show some test or tests
> to be flaky and is there a bug filed for that?

### 조사해보니 그가 옳고, 우리가 본 것보다 더 옳다

`TaskEnvironment`의 `TimeSource::MOCK_TIME`은 **`base::Time::Now()` 자체**를 mock으로 바꾼다.
`GetNow()`는 전역이 비어 있으면 `base::Time::Now()`를 부르므로, MOCK_TIME만 켜면 테스트 클럭 장치가
아예 필요 없다.

그리고 결정적으로 — **`QuotaManagerImplTest`는 이미 MOCK_TIME이다** (`quota_manager_unittest.cc:588`).
`SetClockForTesting` 7쌍이 전부 그 픽스처 안에 있다.

| 호출처 | 지금 | MOCK_TIME 기준 |
|---|---|---|
| 2478, 2511 (`GetMockClock()`) | 전역을 **이미 `Time::Now()`가 따르는 클럭**으로 설정 | **no-op** |
| 874, 929, 1139, 3034, 3082 (`SimpleTestClock`) | `SetNow(Now())` 후 `Advance(X)` | `task_environment_.AdvanceClock(X)` |

`quota_database_unittest.cc`는 `SingleThreadTaskEnvironment`(SYSTEM_TIME)지만 **`task_environment_`를
선언만 하고 `RunLoop`도 `FastForward`도 안 쓴다** → MOCK_TIME으로 바꿔도 `Time::Now()`가 얼어붙는 것 외엔
영향이 없다.

→ **전역과 세터를 통째로 지운다.** 댕글링을 RAII로 «관리»하는 대신 **존재할 수 없게 만든다.**

```cpp
-const base::Clock* g_clock_for_testing = nullptr;
 base::Time QuotaDatabase::GetNow() {
-  return g_clock_for_testing ? g_clock_for_testing->Now() : base::Time::Now();
+  return base::Time::Now();
 }
-void QuotaDatabase::SetClockForTesting(const base::Clock* clock) { ... }
```

### 무엇을 잘못 봤나

AutoReset 판을 낼 때 «관행 분포 558 vs 51»까지 세어가며 **세터를 어떤 모양으로 만들 것인가**를 조사했다.
그런데 **세터가 필요한가**는 묻지 않았다. 호출처가 전부 테스트라는 사실은 확인해놓고도,
«그 테스트들이 이미 mock time을 쓰고 있는지»는 보지 않았다.

> 교훈: API의 **형태**를 고민하기 전에 **그 API가 필요한지**를 먼저 묻는다.
> 테스트 전용 후크를 고칠 때는 그 테스트의 `TaskEnvironment` 설정부터 읽는다 —
> `MOCK_TIME`이 켜져 있으면 클럭 후크는 대개 이미 불필요하다.

물러설 지점을 «최소 수정(한 줄)»로만 잡아둔 것도 좁았다. 리뷰어는 반대 방향, **더 큰 정리**를 원했다.

### 남은 확인 사항

- MOCK_TIME 시작 시각은 `Time::UnixEpoch()`(`task_environment.cc:114`). `Time::Now() - Days(401)`이
  1968년이 되는데 `base::Time`은 1601년 기준이라 음수는 아니다 → **실측 필요**
- `clock->Advance()`는 quota 클럭만, `AdvanceClock()`은 픽스처 시간 전체를 움직인다.
  확인한 2개(`UpdateOrCreateBucket_Expiration`, `EvictExpiredBuckets`)는 Advance 뒤 `Time::Now()`를
  다시 읽지 않아 동치 → **나머지 3개 확인 필요**
- `GetNow()`를 호출처 11곳에 인라인해 지울지는 **리뷰어에게 묻는다**(답글에 포함)
- 필터 없는 기본 `storage_unittests` 실행에서도 크래시가 나는지 — 봇의 배치 조건에 가장 가깝다

답글·계획 초안: `steps/6-review/drafts/8377022-mocktime.md`
