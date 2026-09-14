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


---

## PS2 로컬 완료 — Mac (2026-09-11)

서버 스크립트는 사라져서 Mac에서 변환을 다시 만들었다(`scratchpad/apply_mocktime.py`, 42개 편집 전부 기대 개수 일치, 잔여 참조 0).
브랜치 `quota-db-test-clock-leak`(`git cl patch -b`로 PS1을 받아 4파일을 origin/main으로 되돌린 뒤 적용, `--amend`로 커밋 교체, Change-Id 보존).
**업로드는 아직** — `cd ~/chromium/src && git checkout quota-db-test-clock-leak && git cl upload`.

계획과 달라진 것 2가지 — 둘 다 답글에 적는다:

1. **`task_environment_.GetMockClock()->Now()` 6곳 → `base::Time::Now()`.** simple_test_clock.h include를 지우자 `base::Clock`이 불완전 타입이 되어 컴파일 실패
   (`member access into incomplete type 'const Clock'`). clock.h를 다시 넣는 대신 MOCK_TIME 아래 같은 값인 `Time::Now()`로 통일.
2. **`QuotaDatabaseTest.Stale` 400일 경계.** 정체 판정은 `last_accessed < now - 400d`(exclusive). 옛 테스트는 엔트리를 `Now() - 399d`로 쓰고 `SetNow(Now() + 1d)`로 넘어갔는데,
   두 `Now()` 사이의 **실제 시계 드리프트(µs)** 덕에 우연히 통과하던 것. mock time에서는 드리프트가 0이라 정확히 400d = 정체 아님 → `Stale/0`·`/1` 실패(1137행 2U vs 1).
   `AdvanceClock(base::Days(1) + base::Seconds(1))`로 경계를 명시적으로 넘기고 주석을 달았다. 리뷰어에게 "테스트가 드리프트에 기대고 있었다"고 설명.

검증 (Mac, out/Default release component):
- 패치 전 main: `*Quota*` 305개 배치 → `[298/305] … ReportedQuotaConfigurability/Incognito_Static_FlagEnabled (CRASHED)`, SIGBUS BUS_ADRALN
- 패치 후: `*QuotaDatabase*` **57/57** · 321 필터(`Quota*:*Quota*:UsageTracker*:ClientUsageTracker*:StorageDirectory*`) **319/319** (Mac은 319개) · CRASHED **0**
- 로그: `steps/4-build-and-test/logs/mocktime_{build,qdb,batch}.log`

최종 diff: 4파일 **+30/−85** (PS1은 +24/−26). 커밋 메시지는 `scratchpad/8377022-ps2-msg.txt` = 브랜치 HEAD.

### 답글 수정본 — `quota_database.h:235`

```
Done in PS2 (PS3 only updates the description), and it turned out to be even simpler than that: QuotaManagerImplTest
already runs with TimeSource::MOCK_TIME, so base::Time::Now() is the mock clock
there. The two sites that installed task_environment_.GetMockClock() were no-ops
and the rest only advanced a SimpleTestClock, which AdvanceClock() does directly.
QuotaDatabaseTest never runs a RunLoop, so its SingleThreadTaskEnvironment just
switches to MOCK_TIME.

So g_clock_for_testing and SetClockForTesting() are gone and GetNow() is
base::Time::Now(). Two things worth a look:

- The GetMockClock()->Now() reads in the eviction tests became Time::Now() (same
  value under mock time; keeping them would have needed base/time/clock.h back).
- QuotaDatabaseTest.Stale was probing the 400-day cutoff at exactly 400 days and
  only passed because wall-clock time moved between its two Now() calls (the
  comparison is exclusive). With mock time that drift is gone, so the test now
  steps one second past the cutoff, with a comment.

GetNow() is now a one-liner; happy to inline it at the call sites here or in a
follow-up, whichever you prefer.
```

### 답글 수정본 — `/COMMIT_MSG:16`

```
Not hypothetical — it reproduces on ToT without this patch. Running the quota
tests as one batch:

  storage_unittests --gtest_filter='Quota*:*Quota*:UsageTracker*:ClientUsageTracker*:StorageDirectory*'

crashes in QuotaConfigs/QuotaManagerImplParamTest.ReportedQuotaConfigurability
with QuotaDatabase's constructor on the stack (SIGSEGV SEGV_MAPERR on Linux,
SIGBUS BUS_ADRALN on an arm64 Mac — the freed clock's vtable). The test passes
on its own; it only dies when QuotaDatabaseTest ran earlier in the same process
and freed the clock the global still pointed at. With PS2 the same batch passes.

I haven't been able to check LUCI: I don't have try-job access yet, so I can't
query the flakiness data. No bug is filed; I'm happy to file one if you'd like
it tracked.
```

### 업로드 후 (09-11 14:27 KST)

PS2 커밋 `68ba8d1c03314`, 파일은 로컬 HEAD와 동일(`track.py verify 8377022 2` ✓). **단, `git cl upload`는 기존 CL의 Gerrit 설명을 그대로 재사용**해서 제목·본문이 PS1 것(AutoReset 판 설명)으로 남아 있다. 새 메시지로 바꾸는 명령:

```bash
cd ~/chromium/src && git cl description -n +     # + = 로컬 HEAD 커밋 메시지로 교체 (- 는 stdin)
```

(같은 내용이 `git log -1 --format=%B` 에도 있다. 교훈: 설계가 바뀐 PS를 올릴 땐 `git cl upload` 뒤에 `git cl description` 을 확인한다.)

→ **09-11 05:31 UTC 완료.** 설명 변경으로 Gerrit이 PS3을 만들었다(코드 동일, 메시지만). `verify 8377022 3`: 파일·메시지 완전 동일 ✓. 남은 것은 답글 2건뿐.


---

## 2라운드 (2026-09-11 16:24 evanstade@) — nit 3건 → PS4 준비 완료 (09-14, 커밋 `913199effda60`)

패치셋 레벨 "nice, thank you." + COMMIT_MSG 스레드에 **"yea, it's showing as flaky on the test history dashboard"** (LUCI 확인, 링크 첨부) → 가설 논란 종결.

| 위치 | 지적 | 반영 |
|---|---|---|
| `quota_database.h:37` | nit: remove (빈 `namespace base {}`) | 삭제 |
| `quota_database.h:233` | please remove now (just inline `base::Time::Now();`) | `GetNow()` 선언·정의 삭제, 호출처 13곳(h 1·cc 7·quota_manager_impl.cc 5) 인라인 |
| `quota_database_unittest.cc:1135` | nit: "...wait more than a day..." 로 짧게 — 주석이 diff 정당화처럼 읽힘 | 한 줄로 축약 |

검증: storage_unittests 증분 빌드 23s ✓ · `*QuotaDatabase*` 통과 · 321 필터 319/319 · CRASHED 0. 커밋 메시지도 갱신(GetNow 제거 반영, LUCI flaky 한 문장 추가). 4파일 → 현재 diff는 origin/main 대비 5파일(quota_manager_impl.cc 추가).

**업로드 (사용자)**: `cd ~/chromium/src && git checkout quota-db-test-clock-leak && git cl upload -t "Inline Time::Now(), drop GetNow(); address nits"`
→ 커밋 메시지가 바뀌었으므로 업로드 뒤 **`git cl description -n +`** 도 다시 (upload 는 서버 설명 재사용).

### 답글 (3 스레드 모두 Resolved 체크)

- `quota_database.h:37`: `Done.`
- `quota_database.h:233`: `Done — GetNow() is gone and the 13 call sites (quota_database.{h,cc}, quota_manager_impl.cc) call base::Time::Now() directly.`
- `quota_database_unittest.cc:1135`: `Done.`
- `/COMMIT_MSG:16` (이미 resolved, 답만): `Thanks for checking the dashboard — added a sentence about it to the description.`

### 두 번째 리뷰어 (비커미터 규칙: 커미터 2명 +1, `Code-Review` submit requirement 확인 09-14)

evanstade@ 한 명의 +1 로는 CQ 가 거부된다(8366188 에서 CV 가 "not satisfying Code-Review and Review-Enforcement" 로 실제 거부). PS4 업로드 때 **stevebe@microsoft.com** 을 리뷰어로 추가(`git cl upload -r stevebe@microsoft.com` 또는 UI) — storage/OWNERS, 7601393 리뷰어, 09-12 활동.

→ **09-14 06:45 UTC 완료 (에이전트, 사용자 지시 «1번 진행해»)**: `git cl upload -f -r stevebe@microsoft.com -t ...` → PS4, `git cl description -n +` → PS5, `verify 8377022 5` 동일 ✓. 답글은 Gerrit REST `POST /a/changes/8377022/revisions/3/review`(in_reply_to + unresolved:false, 커버 메시지 포함)로 게시 — 두 번째 리뷰어를 추가한 이유(비커미터 규칙)도 커버 메시지에 적음. 미해결 0/12, 어텐션 evanstade@·stevebe@.
