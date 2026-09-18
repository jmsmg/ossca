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
| **sql ColumnTime 시리즈** (32곳/12파일) | 🔄 **CL 1 업로드** [8382856](https://crrev.com/c/8382856) (history 3파일 10곳, manukh@ 리뷰 대기). **CL 1.5(journeys)는 소멸** — hempjudith@가 09-11 `[Journeys] Align journeys databases with SQL guidelines`(d993d98687d12)로 이미 옮김. **남은 것(09-15 origin/main 재스캔)**: net/extras/sqlite 4곳 → affiliations 1 → extensions activity_log 1·blocklist 1·declarative_performance_observer 3 → autofill payments 4 + `statement.h` TODO 삭제(`Fixed:`). password_manager 는 사라짐 |
| 만료 `NotFatalUntil` M143 `pref_service.cc` | ✅ **CL [8366188](https://crrev.com/c/8366188) 업로드**, gab@ 리뷰 대기 |
| **만료 M148 — `storage/browser/quota` 153곳/10파일** | ✅ **CL [8377550](https://crrev.com/c/8377550) 업로드** (커밋 `35bb0a1907705`, +154/−160, L), evanstade@ 리뷰 대기. **CL 2**(트리 잔여 4곳 + enum `M148 = 148,` 삭제)는 후속 |
| **만료 M113 — `extension_prefs` install_time 마이그레이션** | 🔄 **09-10 착수** — 브랜치 `extension-prefs-drop-installtime-migration`, 커밋 `134e015c8c3e4` (3파일 −82, 순수 삭제). 빌드·테스트 중(tmux `extprefs`). 범위가 **2개 → 1개**로 줄었다 → `issues/extension-prefs-expired-migration.md` |

### 착수 대기 — 우선순위 순

| 후보 | 크기 | 특징 |
|---|---|---|
| **★ `kResetDecoderForNonIDR` 킬스위치 제거** (✅ OSSCA **#440**, 09-15) — `media/gpu/mac/video_toolbox_h264_accelerator.cc` (09-15 «Remove after M<n>» 재스캔) | XS | "Kill-switch: Remove after M145 is stable", 10 마일스톤 경과. **Mac 전용 파일 1개**라 여기서 그대로 빌드·테스트. 버그 번호 없음(`Bug: none`). OWNERS media/gpu(dalecurtis·eugene·liberato·andrescj). ⚠️ eugene@가 같은 파일에 열린 CL 8400064(09-15) — 리뷰어로 eugene@ 지정하고 «같이 넣을지» 묻는 것도 방법 |
| **★ WebAuthn iCloud Keychain 플래그 3개 제거** (✅ OSSCA **#441**) — `device/fido/public/features.{cc,h}` + `chrome/browser/webauthn/chrome_authenticator_request_delegate.cc` | S | `kWebAuthnICloudKeychainForGoogle`·`ForActiveWithDrive`·`ForInactiveWithDrive` — "Enabled in M118. Remove in or after M121", 34 마일스톤 경과. about_flags·enums 등록 없음. OWNERS device/fido(kenrb·martinkr·nsatragno·derinel). delegate 파일은 활발(열린 CL 48건)이라 충돌 잦음 → 올린 뒤 오래 묵히지 말 것 |
| **★ `kMediaStreamAccurateDroppedFrameCount` 제거 (crbug 432367602)** — 🔄 **09-18 착수 검증 ①~④ 통과**, OSSCA 등록 허가 대기 (`issues/432367602.md`) | XS | "Remove after M143". media_switches.{cc,h} + blink mediastream compositor 1곳. 원 CL 6766143 머지됨, 열린 CL 0. OWNERS media + blink/mediastream(hbos·tommi) 2그룹 |
| `kSuspendMediaForFrozenFrames` 제거 (crbug 41161335) | S | "Remove in M143 after it goes stable". media_switches + blink WebMediaPlayerImpl(+unittest) 4파일. 버그에 CL 18건 이력(전부 옛것), 339일 무활동 |
| `kWebCodecsDecoderFlushOptimizations` 킬스위치 제거 | S~M | "Kill-switch to be removed after M145 stable". blink/webcodecs 디코더 브로커+테스트 7파일. OWNERS webcodecs(dalecurtis·tguilbert·eugene) — media와 겹치는 사람들 |
| `startup_browser_creator_impl.cc` Lacros 잔재 (crbug 40216113, ✅ OSSCA **#442**) | XS | TODO "Remove by M104" 붙은 `ShouldLoadProfileWithoutWindow` 재검사 + NOTREACHED. 버그는 FIXED(Lacros 온보딩), Lacros 자체가 사라짐. OWNERS chrome/browser/ui/startup(dgn·nicolaso·ydago) |
| `extension_service.cc` 강제설치 재활성화 우회 제거 (crbug 40144051 접근 제한, ✅ OSSCA **#443**) | XS | 2022-05 CL(nicolaso@) "safe to remove in M107" — 48 마일스톤 경과. crbug 내용은 미확인(파서 실패). rdevlin.cronin@ 관계 있음 |
| reading_list `distillation_size_` 제거 (crbug 40894644) | S~M | "Remove after M115" — 필드+접근자+생성자 인자+**proto 필드(reserved 처리 필요)**+테스트 5곳. 선점 0. 저장 포맷이 걸려 신중 |
| **★ sql ColumnTime 시리즈 CL 2 — `net/extras/sqlite/sqlite_persistent_reporting_and_nel_store.cc` 8곳** (09-15 재스캔) | XS~S | 읽기 4(`FromDeltaSinceWindowsEpoch(Microseconds(ColumnInt64))`→`ColumnTime`) + 쓰기 4(`BindInt64(…InMicroseconds())`→`BindTime`), 한 파일. per-file OWNER **ricea@**(09-11 활동) 단독 → 두 번째는 net/OWNERS nidhijaju@·bashi@(둘 다 09-14 활동). 열린 CL 충돌 없음(전부 2026-01 이전 stale). 타깃 `net_unittests`(Mac 미빌드). `Bug: 40176243` part 2 |
| **★ 만료 `NotFatalUntil` M144 — signin 3곳 + enum 항목** (09-15 재스캔) | XS | `dice_web_signin_interceptor.cc` 2곳 + `turn_sync_on_helper.cc` 1곳이 트리 전체 사용처의 전부 → **M143(8366188)과 같은 «인자 제거 + `M144 = 144,` 삭제» 완전 정리**. 원 CL 6842550(rsult@, 2025-08-14)의 TODO가 «crbug.com/435076172 — 크래시 없으면 일반 CHECK로»라고 직접 지시. OWNERS `components/signin/DESKTOP_OWNERS`. ⚠️ `base/` 헤더 변경 = 전 트리 재빌드(Mac에서도 수 시간) |
| 40284947 `PacResultElementToProxyServer` 제거 | M | 09-15 재확인: 프로덕션 호출처는 자기 래퍼 1곳, 나머지 **테스트 호출처 ~37곳**(net mac/win/공용 테스트, services/network, services/proxy_resolver_win — OWNER 3그룹). Mac 테스트는 이제 로컬 빌드 가능하나 **win 파일은 불가** → 여전히 트라이잡 권한 확보 후. 선점 0·OSSCA 0·823일 무활동 |
| 40831207 CL B (favicon) | M | ⏸ jpgravel@ 답변 대기 — batching mode(8291668)로 갈지 scoped Transaction으로 갈지 |
| 만료 `NotFatalUntil` M146 `varint_coding.cc` 2곳 | XS | crbug 459129408은 evanstade@의 IDB DCHECK→CHECK 프로젝트(ASSIGNED, CL 14건, 마지막 02-27). evanstade@가 지금 우리 리뷰어이니 **8377550 머지 뒤 답글 한 줄로 물어보면 됨** |
| 만료 `NotFatalUntil` M147 `actor_metrics.cc` 10곳 | XS | **공개 crbug 없음**(내부 `b:`), `chrome/browser/actor`는 신생·활발 |
| component_updater 만료 항목 6개 | XS | 안전하지만 가치가 작다. 리뷰어가 "놔둬도 무해"라 할 수 있음 |
| `SharedMemoryMapping::memory()` 제거 (355451178) | 대 | 선점 0·602일 휴면이나 **대체가 비기계적**이고 `base/` API라 호출처가 전 트리에 흩어짐 |
| 40199997 Recovery DCHECK · 40827336 chunk size 옵션 | XS·M | sql/ 09-05 발굴. 40827336은 설계 판단이 필요해 OWNER 문의 선행 |
| `sql/database.cc:675` 만료 M141 1곳 | XS | 단독으론 너무 작음 → 40831207 CL C에 동봉 |
| 41342247 converter 단위 테스트 · 40121328 sanity check 이동 | ? | triage 통과, 코드 진단 전 |
| ~~`g_clock_for_testing` 픽스처 누수~~ | — | ✅ **09-10 착수·업로드** [CL 8377022](https://crrev.com/c/8377022) → `issues/quota-test-clock-leak.md`. quota M148 검증 중 크래시로 드러남 |
| `kSandboxExternalProtocolBlocked` 플래그 제거 | 중 | M106 만료(49 경과)지만 **enterprise policy와 얽혀** 별도 절차 필요 |

**09-15 quota TODO 점검**: 40179024(`SetStorageKeyLastAccessTime` 제거)는 기본 버킷 경로가 히스토그램 때문에 일부러 쓰고 있어 기계적 제거 불가 → evanstade@에게 물어볼 거리 · 40273188(`DeleteHostData`)는 Android site settings가 아직 사용 → CookiesTreeModel 폐기 뒤 · 40184305는 SpecialStoragePolicy가 아직 Origin 기반 → 불가 · 40058632(CHECK→DCHECK 복귀)는 판단 필요.

**09-15 재스캔에서 제외한 것**: M139 5곳(viz·media/renderers·media/capture/chromeos — OWNER 3그룹, CrOS 전용 파일은 로컬 빌드 불가) · M142 6곳(5그룹) · M138/M140/M145 (10~13파일에 흩어짐) · journeys CL 1.5 (hempjudith@가 09-11 먼저 옮김)

### 별건

| | 상태 |
|---|---|
| tryjob 권한 | 🔄 09-07 smcgruer@에게 추천 요청 메일, **회신 대기** (이의 없으면 미 근무일 2일 승인) |

**보류(조건부 재검토):** 비활성 테스트 되살리기 — 링크된 버그가 닫힌 `DISABLED_` 테스트 찾기. 76개 후보를 뽑았으나 **대부분 플랫폼 조건부라 Linux에서 검증 불가**, 레거시 버그 번호는 상태 조회도 안 됨. **트라이잡 권한 확보 후 재검토** (GUIDE 09-09 절)

**범위에서 빠진 것(재조사 방지):** `MigrateDeprecatedDisableReasons()` — 선언부 TODO는 M89(66 경과)로 만료돼 보이지만 본문에 **만료되지 않은** ChromeOS post-Lacros 정리(`TODO(crbug.com/380780352)`)가 들어와 있다. 그 TODO가 풀릴 때까지 건드리지 않는다.

**탈락 기록(재조사 방지):** 41396598(의사 타진 무응답·Recharge-Cold, 09-09) · 507327886 · 40891923 · 473666511 · 377242771 · 433551601 · 396030877 · 40177656 · (sql 09-05) 40146017 · 40262539 · 40777743 · 40061775 · 40779018 · 477762546 · 413595430
