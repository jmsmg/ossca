# 1단계 현황 — 이슈 발굴

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-10 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| crbug | 내용 | 발굴 경로 | 상태 |
|---|---|---|---|
| 372283556 | crypto/hash include 정리 | 4. OSSCA 큐레이션 (#282) | ✅ |
| 443042812 | SPC delegate DCHECK→CHECK | 1. 트래커 하향 (크래시 리포트 첨부 휴면) | ✅ |
| 545645933 | Link rel 대소문자 매칭 | 3. 표준 대조 (RFC 8288 §2.1) | ✅ |
| 40831207 | sql 수동 트랜잭션 제거 | 2. 코드 상향 (deprecated 주석 역추적) | ✅ |
| 41396598 | CurrencyFormatter 재작성 | 1. 트래커 하향 (M 사이즈 탐색) | ❌ 포기 09-09 (의사 타진 16일 무응답) |
| 40681786 | 파서 에러 문자열 이동 | 2. 코드 상향 (`hunt.py todos components/payments`) | ✅ |
| 545843242 | Link 헤더 exactly-one | 5. 작업 파생 (545645933 쌍둥이) | ✅ |
| 438680281 | 만료 `NotFatalUntil::M143` 정리 | 2. 코드 상향 (`hunt.py expired` → 마일스톤별 재집계) | ✅ 09-07 |

## 후보 큐 (2026-09-10 정리)

발굴 근거·검증 내역은 GUIDE.md의 «현재 후보 큐» 절들(09-02 · 09-05 sql · 09-07 백엔드 · 09-07 만료 NotFatalUntil · 09-09 2차 · 09-09 «Remove in M<n>»)에 있다.

### 착수함 (진행 중)

| 후보 | 상태 |
|---|---|
| **sql ColumnTime 시리즈** (32곳/12파일) | 🔄 **CL 1 업로드** [8382856](https://crrev.com/c/8382856) (history 3파일 10곳, manukh@ 리뷰 대기). **CL 1.5~5 남음**: journeys 5곳 → net/extras 4 → password_manager·affiliations 3 → 소형 4 → autofill 4 + `statement.h` TODO 삭제(`Fixed:`) |
| 만료 `NotFatalUntil` M143 `pref_service.cc` | ✅ **CL [8366188](https://crrev.com/c/8366188) 업로드**, gab@ 리뷰 대기 |
| **만료 M148 — `storage/browser/quota` 153곳/10파일** | ✅ **CL [8377550](https://crrev.com/c/8377550) 업로드** (커밋 `35bb0a1907705`, +154/−160, L), evanstade@ 리뷰 대기. **CL 2**(트리 잔여 4곳 + enum `M148 = 148,` 삭제)는 후속 |
| **만료 M113 — `extension_prefs` install_time 마이그레이션** | 🔄 **09-10 착수** — 브랜치 `extension-prefs-drop-installtime-migration`, 커밋 `134e015c8c3e4` (3파일 −82, 순수 삭제). 빌드·테스트 중(tmux `extprefs`). 범위가 **2개 → 1개**로 줄었다 → `issues/extension-prefs-expired-migration.md` |

### 착수 대기 — 우선순위 순

| 후보 | 크기 | 특징 |
|---|---|---|
| **★ 40284947 `PacResultElementToProxyServer` 제거** | S~M | 프로덕션 호출처가 이미 1곳(자기 래퍼)뿐이라 «끝내는 조건» 충족, 816일 무활동. ⚠️ mac/win 테스트가 Linux 빌드 불가 → **트라이잡 권한 확보 후가 유리** |
| 40831207 CL B (favicon) | M | ⏸ jpgravel@ 답변 대기 — batching mode(8291668)로 갈지 scoped Transaction으로 갈지 |
| 만료 `NotFatalUntil` M146 `varint_coding.cc` 2곳 | XS | 리뷰어 정렬 완벽(Evan Stade·Steve Becker)이나 **crbug 459129408이 ASSIGNED** → 선점 문의 먼저 |
| 만료 `NotFatalUntil` M147 `actor_metrics.cc` 10곳 | XS | **공개 crbug 없음**(내부 `b:`), `chrome/browser/actor`는 신생·활발 |
| component_updater 만료 항목 6개 | XS | 안전하지만 가치가 작다. 리뷰어가 "놔둬도 무해"라 할 수 있음 |
| `SharedMemoryMapping::memory()` 제거 (355451178) | 대 | 선점 0·602일 휴면이나 **대체가 비기계적**이고 `base/` API라 호출처가 전 트리에 흩어짐 |
| 40199997 Recovery DCHECK · 40827336 chunk size 옵션 | XS·M | sql/ 09-05 발굴. 40827336은 설계 판단이 필요해 OWNER 문의 선행 |
| `sql/database.cc:675` 만료 M141 1곳 | XS | 단독으론 너무 작음 → 40831207 CL C에 동봉 |
| 41342247 converter 단위 테스트 · 40121328 sanity check 이동 | ? | triage 통과, 코드 진단 전 |
| ~~`g_clock_for_testing` 픽스처 누수~~ | — | ✅ **09-10 착수·업로드** [CL 8377022](https://crrev.com/c/8377022) → `issues/quota-test-clock-leak.md`. quota M148 검증 중 크래시로 드러남 |
| `kSandboxExternalProtocolBlocked` 플래그 제거 | 중 | M106 만료(49 경과)지만 **enterprise policy와 얽혀** 별도 절차 필요 |

### 별건

| | 상태 |
|---|---|
| tryjob 권한 | 🔄 09-07 smcgruer@에게 추천 요청 메일, **회신 대기** (이의 없으면 미 근무일 2일 승인) |

**보류(조건부 재검토):** 비활성 테스트 되살리기 — 링크된 버그가 닫힌 `DISABLED_` 테스트 찾기. 76개 후보를 뽑았으나 **대부분 플랫폼 조건부라 Linux에서 검증 불가**, 레거시 버그 번호는 상태 조회도 안 됨. **트라이잡 권한 확보 후 재검토** (GUIDE 09-09 절)

**범위에서 빠진 것(재조사 방지):** `MigrateDeprecatedDisableReasons()` — 선언부 TODO는 M89(66 경과)로 만료돼 보이지만 본문에 **만료되지 않은** ChromeOS post-Lacros 정리(`TODO(crbug.com/380780352)`)가 들어와 있다. 그 TODO가 풀릴 때까지 건드리지 않는다.

**탈락 기록(재조사 방지):** 41396598(의사 타진 무응답·Recharge-Cold, 09-09) · 507327886 · 40891923 · 473666511 · 377242771 · 433551601 · 396030877 · 40177656 · (sql 09-05) 40146017 · 40262539 · 40777743 · 40061775 · 40779018 · 477762546 · 413595430
