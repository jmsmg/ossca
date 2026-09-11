# 3단계 현황 — 브랜치 및 수정

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-10 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| crbug | 브랜치 | 상태 |
|---|---|---|
| 372283556 | `crypto-hash-services-network` | ✅ |
| 443042812 | `spc-delegate-guard-443042812` (base baf89c566) | ✅ — 리뷰 -1로 방향 전환 후 재작성 |
| 545645933 | — | ✅ |
| 40831207 | CL A (quota) | ✅ |
| 40831207 | **CL B (favicon)** | ⏸ **보류 (09-05)** — sql 팀 batching mode([8291668](https://crrev.com/c/8291668), grt 리뷰 중)가 장수 트랜잭션 자체를 대체할 예정. CL A 복사본으로 만들면 곧 다시 뜯김 → crbug에 방향 문의 후 결정 (`issues/40831207.md` 09-05 절) |
| 40831207 | **CL C (sql 메서드 삭제, `Fixed: 40831207`)** | ⬜ favicon + WebDatabase([8282599](https://crrev.com/c/8282599), jpgravel) 이행 후 — batching 랜딩 이후 |
| 40681786 | `parser-error-strings-40681786` | ✅ 시리즈 1/3 (`Bug:` 트레일러) |
| 545843242 | — | ✅ |
| 41396598 | — | ❌ 포기 (09-09) |
| 40176243 CL 1 | `history-column-time-40176243` | ✅ 09-08 — 커밋 `6df5b0645605d` (+14/−18, 3파일). history 10곳을 `ColumnTime`/`ColumnTimeDelta`/`BindTimeDelta`로. TDD 예외(동작 불변) |
| 438680281 | `expired-notfatal-prefs-438680281` | ✅ 09-07 — 커밋 `c263788e116dd` (+4/−5, 2파일). 만료 `NotFatalUntil::M143` 인자 4곳 + enum 항목 제거. TDD 예외(동작 불변) |
| (crbug 없음) quota 테스트 클럭 | `quota-db-test-clock-leak` | ✅ 09-10 — 커밋 `0bce70f9916b6` (+24/−26, 4파일). `SetClockForTesting`을 `base::AutoReset` 반환으로 |
| (crbug 없음) 만료 M148 quota | `quota-expired-notfatal-m148` | ✅ 09-10 — 커밋 `35bb0a1907705` (+154/−160, 10파일). `, base::NotFatalUntil::M148` 153곳 제거. TDD 예외(동작 불변) |
| (crbug 없음) 만료 M113 extensions | `extension-prefs-drop-installtime-migration` | ✅ 09-10 — 커밋 `134e015c8c3e4` (−82, 3파일). **순수 삭제**. 착수 시 범위가 2함수 → 1함수로 축소 |

**다음 액션** — extensions CL 검증 통과 후 업로드. 그 다음은 sql ColumnTime CL 1.5(journeys 5곳). 40831207 CL B는 보류. 사용자가 crbug 40831207에 방향 문의 게시 → 답변 오면 재정의. 그 전까지 «수정» 작업은 09-05 발굴한 **sql ColumnTime/ColumnTimeDelta 마이그레이션** (1단계 GUIDE 09-05 절) → 착수 가능.
