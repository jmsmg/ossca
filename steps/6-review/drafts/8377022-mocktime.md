# CL 8377022 — evanstade@ 설계 제안 대응 (2026-09-11)

**상태**: 표 없음(vote 안 함). 어텐션이 우리에게 있음. 미해결 2건.

## 받은 지적 2건

### ① `/COMMIT_MSG:16` — 진짜 있는 문제냐

> if this is not hypothetical, does LUCI show some test or tests to be flaky
> and is there a bug filed for that?

### ② `quota_database.h:235` — 다른 수정 방식

> I think the best fix is probably to stop using a test clock and instead use
> a task environment with [mock time](.../base/test/task_environment.h;l=123).

## 조사 결과 — 그의 말이 맞고, 우리가 아는 것보다 더 맞다

`base::test::TaskEnvironment`의 `TimeSource::MOCK_TIME`은 `base::Time::Now()` 자체를 mock으로
바꾼다. `QuotaDatabase::GetNow()`는 `g_clock_for_testing`이 없으면 `base::Time::Now()`를 부르므로,
**MOCK_TIME만 켜면 테스트 클럭 장치 없이도 시간이 제어된다.**

결정적인 사실 — **`QuotaManagerImplTest`는 이미 MOCK_TIME이다.**

```cpp
// quota_manager_unittest.cc:588
base::test::TaskEnvironment task_environment_{
    base::test::TaskEnvironment::TimeSource::MOCK_TIME};
```

`SetClockForTesting` 호출 7쌍이 **전부 이 픽스처 안**에 있다. 그래서:

| 호출처 | 지금 하는 일 | MOCK_TIME 기준으로 보면 |
|---|---|---|
| 2478, 2511 (`GetMockClock()` 전달) | 전역을 **이미 `Time::Now()`가 따르는 그 클럭**으로 설정 | **완전한 no-op.** 지워도 아무것도 안 바뀐다 |
| 874, 929, 1139, 3034, 3082 (`SimpleTestClock`) | `SetNow(Time::Now())` 후 `Advance(X)` | `task_environment_.AdvanceClock(X)` 한 줄과 동치 |

`quota_database_unittest.cc`는 `SingleThreadTaskEnvironment`(SYSTEM_TIME)라 MOCK_TIME으로 바꿔야 하는데,
**그 파일은 `task_environment_`를 선언만 하고 `RunLoop`·`FastForward`를 한 번도 안 쓴다**(grep 확인).
지연 작업이 없으니 MOCK_TIME은 `Time::Now()`를 얼려두는 것 외의 효과가 없다.

### 그래서 최종 모습

```cpp
// quota_database.cc — 전역과 세터가 통째로 사라진다
-const base::Clock* g_clock_for_testing = nullptr;
 base::Time QuotaDatabase::GetNow() {
-  return g_clock_for_testing ? g_clock_for_testing->Now() : base::Time::Now();
+  return base::Time::Now();
 }
-void QuotaDatabase::SetClockForTesting(const base::Clock* clock) { ... }
```

댕글링 포인터를 **RAII로 관리하는 대신 존재 자체를 없앤다.** AutoReset 판보다 낫다.

### 확인이 더 필요한 것

- MOCK_TIME의 시작 시각은 `Time::UnixEpoch()`(`task_environment.cc:114`). 테스트에 `Time::Now() - Days(401)`
  같은 식이 있어 1968년이 되는데, `base::Time`은 1601년 기준이라 음수가 아니다 → 문제없을 것으로 보이나 **실측 필요**
- `clock->Advance()`는 quota 클럭만 움직이고, `AdvanceClock()`은 픽스처 시간 전체를 움직인다.
  살펴본 테스트(`UpdateOrCreateBucket_Expiration`, `EvictExpiredBuckets`)는 Advance 뒤에
  `Time::Now()`를 다시 읽지 않아 차이가 없다. **나머지 3개도 같은지 확인 필요**
- `GetNow()`가 `base::Time::Now()` 한 줄이 되면 존재 이유가 없다 → 호출처 11곳을 치환해 지울지는 **리뷰어에게 묻는다**

## ①에 대한 답 — 정직하게

- 가설이 아니다. ToT에서 재현된다 (필터를 준 배치 실행)
- **LUCI는 확인하지 못했다** — 우리는 아직 try-job 권한이 없다. 이건 감추지 말고 그대로 말한다
- 버그는 등록돼 있지 않다. 등록하겠다고 제안한다
- 빌드가 끝나면 **필터 없는 기본 실행**으로도 재현되는지 확인한다 (봇의 배치 조건에 가장 가까움)

## Gerrit 답글 (그대로 복사) — 파일 코멘트 ②에 답하는 것부터

**`quota_database.h:235` 쪽**

```
Agreed, and it turns out to be even simpler than that: QuotaManagerImplTest
already runs with TimeSource::MOCK_TIME, so base::Time::Now() is the mock
clock there already. All seven SetClockForTesting() pairs live in that
fixture, and the two that pass task_environment_.GetMockClock() are no-ops
today.

So the test clock isn't needed at all:

- switch QuotaDatabaseTest's SingleThreadTaskEnvironment to MOCK_TIME (it
  declares task_environment_ but never runs a RunLoop, so nothing else is
  affected),
- replace clock->Advance(d) with task_environment_.AdvanceClock(d),
- delete g_clock_for_testing and SetClockForTesting() entirely.

GetNow() then reduces to base::Time::Now(). Do you want me to inline it at
its eleven call sites in this CL, or leave that for a follow-up?

I'll upload that as PS2 once I've built and run storage_unittests against
it locally.
```

**`/COMMIT_MSG:16` 쪽**

```
Not hypothetical — it reproduces on ToT. Running the quota tests as one
batch:

  out/Default/storage_unittests --gtest_filter='Quota*:*Quota*:UsageTracker*:ClientUsageTracker*:StorageDirectory*'

dies with SIGSEGV SEGV_MAPERR 0x10 in
QuotaConfigs/QuotaManagerImplParamTest.ReportedQuotaConfigurability, with
QuotaDatabase's constructor on the stack. Running that test on its own
passes; it only fails when QuotaDatabaseTest has run first in the same
process and freed the clock the global still points at.

I haven't checked LUCI for this — I don't have try-job access yet, so I
can't query the flakiness data. And no, there's no bug filed; I can file
one if you'd like it tracked.
```

---

## 패치 준비 완료 (빌드 대기 중 작성, 2026-09-11)

브랜치를 옮기면 돌고 있는 `unit_tests` 빌드가 깨지므로, `git show origin/main:`으로 읽어
**변환 스크립트를 먼저 만들고 사본으로 검증**했다.

```
/tmp/claude-1000/-home-seonggoc-ossca/4d469cec-db58-4abd-afdf-44ce7710419d/scratchpad/apply_mocktime.py
```

4파일을 origin/main으로 되돌린 뒤 17개 편집을 적용한다. **사본 대상 드라이런에서 17개 패턴이
기대 개수와 전부 일치**했고, 적용 후 `storage/`에 `SetClockForTesting`·`g_clock_for_testing`·
`SimpleTestClock`·`clock()`·`clock->` **잔여 참조 0**이다.

| 파일 | 편집 |
|---|---|
| `quota_database.h` | 세터 선언 1줄 삭제 |
| `quota_database.cc` | 전역 1줄 · 세터 정의 4줄 삭제, `GetNow()`를 `base::Time::Now()` 한 줄로 |
| `quota_database_unittest.cc` | 생성자·`clock()`·멤버 삭제, `SingleThreadTaskEnvironment`를 **MOCK_TIME**으로, 시간 이동 3곳을 `AdvanceClock`으로, include 1줄 삭제 |
| `quota_manager_unittest.cc` | 셋업 5쌍(15줄) 삭제 · `GetMockClock()` 2줄 삭제 · `nullptr` 되돌리기 7줄 삭제 · `clock->Now()` 8곳 → `base::Time::Now()` · `clock->Advance` 4곳 → `task_environment_.AdvanceClock` · include 1줄 삭제 |

`SingleThreadTaskEnvironment`가 `TimeSource`를 받는지도 확인했다 —
`task_environment.h:550`이 `template <class... ArgTypes> SingleThreadTaskEnvironment(ArgTypes... args)`
로 전달하고, 트리에 `SingleThreadTaskEnvironment task_environment_{...TimeSource::MOCK_TIME}` 용례가 있다.

**남은 것은 빌드·테스트뿐이다.** `unit_tests` 빌드가 끝나면:

```bash
cd ~/chromium/src && git checkout quota-db-test-clock-leak
python3 /tmp/claude-1000/-home-seonggoc-ossca/4d469cec-db58-4abd-afdf-44ce7710419d/scratchpad/apply_mocktime.py
~/ossca/steps/4-build-and-test/scripts/quota_m148_test.sh   # 같은 321개 필터
```
