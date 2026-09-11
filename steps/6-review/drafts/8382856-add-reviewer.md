# CL 8382856 — 리뷰어 추가 (2026-09-11)

## 문제

manukh@는 **2026-08-15가 마지막 활동**이다. 27일째 Gerrit에 나타나지 않는다.
CL을 올린 09-09 이후 어떤 반응도 없고, 앞으로도 없을 가능성이 높다(휴가/전배).

원래 manukh@를 고른 근거는 «`components/history/OWNERS` + 선례 CL 7455767에 +1» 이었는데,
**그 사람이 지금 자리에 없다**는 조건을 못 봤다.

## `components/history/OWNERS` 5명 실측 (2026-09-11 금요일 기준)

| 사람 | 마지막 활동 | 금요일 활동 | 이 3파일 리뷰 이력 |
|---|---|---:|---|
| manukh@ | **2026-08-15 (27일 전)** | 23 | 2026-03, 2025-09, 2025-06, 2025-04 — **가장 많음** |
| **mahmadi@** | 2026-09-10 (6시간 전) | **40** | 없음 |
| romanarora@ | 2026-09-10 (7시간 전) | 31 | 없음 |
| treib@ | 2026-09-10 (7시간 전) | **0** (목 71/85) | 2026-04, 2026-03 |
| sophiechang@ | 2026-09-04 (6일 전) | 16 | 2026-04 |

## 판단 — mahmadi@를 추가한다

- 이 CL은 **동작이 바뀌지 않는 기계적 치환**이다(`Time::FromInternalValue(ColumnInt64(c))` → `ColumnTime(c)`).
  history 도메인 지식보다 «`sql::Statement`의 두 접근자가 정말 같은 값을 읽는가»를 확인해줄 OWNER면 된다
  → **도메인 적합성보다 가용성이 중요하다**
- treib@가 이 파일들의 최근 리뷰어지만 **목요일에 85건 중 71건**이 몰린 사람이다. 오늘은 금요일 →
  빨라야 다음 주 수·목. 6일을 더 기다리게 된다
- mahmadi@는 **6시간 전 활동 + 금요일 활동량 1위**. 오늘 안에 볼 가능성이 가장 높다

**manukh@는 빼지 않는다.** 돌아왔을 때 볼 수 있게 두고, 승인은 먼저 보는 쪽에서 받는다.

## 실행

Gerrit UI에서 리뷰어에 `mahmadi@chromium.org` 추가 후 답글:

```
Adding mahmadi@ as a second components/history OWNER — manukh@ hasn't been
active on Gerrit since Aug 15, so this may be sitting in front of someone
who is away.

This is a behavior-preserving migration: sql::Statement::ColumnTime() and
ColumnTimeDelta() read the same int64 that the current
Time::FromInternalValue(ColumnInt64(...)) and
base::Microseconds(ColumnInt64(...)) calls do, so the only change is which
accessor does the conversion. HistoryBackendDBTest and the other history
tests pass (281/281).
```

## 물러설 지점

mahmadi@도 3영업일 안에 반응이 없으면 **treib@를 목요일(2026-09-17)에 맞춰 추가**한다.
그 사람의 리듬을 아는 이상, 아무 날에나 붙여놓고 기다리는 것보다 낫다.
