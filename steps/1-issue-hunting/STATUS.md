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
| **★ `kSuspendMediaForFrozenFrames` 제거 (crbug 41161335)** — 🔄 **09-18 착수 검증 ①~④ 통과 + 3단계 수정 완료**, OSSCA 등록 허가 대기 (`issues/41161335.md`) | S | "Remove in M143 after it goes stable". media_switches + blink WebMediaPlayerImpl(+unittest) 4파일. 버그에 CL 18건 이력(전부 옛것), 339일 무활동 |
| **★ `kWebCodecsDecoderFlushOptimizations` 킬스위치 제거** — 🔄 **09-21 착수 검증 ①~④ 통과 + 3단계 커밋**, OSSCA 등록 허가 대기 (`issues/474398415.md`) | S | "Kill-switch to be removed after M145 stable". blink/webcodecs 디코더 브로커+테스트 7파일. OWNERS webcodecs(dalecurtis·tguilbert·eugene) — media와 겹치는 사람들 |
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
| tryjob 권한 | ⏳ 09-07 smcgruer@ 요청 무응답(09-24 종결) → 다음 추천인 미정(멘토 제외) |

**보류(조건부 재검토):** 비활성 테스트 되살리기 — 링크된 버그가 닫힌 `DISABLED_` 테스트 찾기. 76개 후보를 뽑았으나 **대부분 플랫폼 조건부라 Linux에서 검증 불가**, 레거시 버그 번호는 상태 조회도 안 됨. **트라이잡 권한 확보 후 재검토** (GUIDE 09-09 절)

**범위에서 빠진 것(재조사 방지):** `MigrateDeprecatedDisableReasons()` — 선언부 TODO는 M89(66 경과)로 만료돼 보이지만 본문에 **만료되지 않은** ChromeOS post-Lacros 정리(`TODO(crbug.com/380780352)`)가 들어와 있다. 그 TODO가 풀릴 때까지 건드리지 않는다.

**탈락 기록(재조사 방지):** 41396598(의사 타진 무응답·Recharge-Cold, 09-09) · 507327886 · 40891923 · 473666511 · 377242771 · 433551601 · 396030877 · 40177656 · (sql 09-05) 40146017 · 40262539 · 40777743 · 40061775 · 40779018 · 477762546 · 413595430

## ★ 최우선 후속 (2026-09-22) — 545843242 WPT 수정

8349386 abandon의 후속. smcgruer@ 요청: WPT `link-header-selection.https.window.js`의 «Multiple … cause fetch to abort» 서브테스트를 스펙(첫 번째 일치 항목 사용)에 맞게 고치고, Chromium이 그 서브테스트를 알려진 실패로 둔 기대값 항목을 지운다. `Bug: 545843242`, 리뷰어 smcgruer@(요청자) → nikifork@. OSSCA #401 유지·재범위. 검증: `blink_web_tests`(wpt 러너) 해당 파일 실행. XS~S.

## 2026-09-21 재스윕 (트리 M156, gclient sync 후) — «이전 버전 지우기» 방향

**⚠️ NotFatalUntil 경로 종료** — arthursonzogni@가 새 도구 `base/tools/clean-up-not-fatal-until.py`로 **M153 이하 전부**를 지우는 CL [8421522](https://crrev.com/c/8421522)·[8425399](https://crrev.com/c/8425399)(244파일, 09-17)를 올림. 우리 큐의 M146 varint·M147 actor_metrics·M148 잔여·M149 omnibox 전부 포함, **8377550(quota M148)의 10파일도 100% 겹침** → 8377550에 FYI 댓글 후 그쪽이 먼저 랜딩하면 abandon. 이후 만료 NotFatalUntil은 후보에서 제외(스크립트가 주기적으로 처리할 것).

**도구 함정** — macOS `git grep -E`는 `\b`를 모름(0건). `-P`(PCRE)로 후보를 넓게 모은 뒤 파이썬에서 «지워라» 동사·과거형 제외로 거른다.

### 1차: 만료 «Remove … M<n>» 주석 (148건 중 살아 있는 지시·Mac 빌드 가능·겹침 0)

| 후보 | 만료 | 크기 | OWNERS | 타깃 |
|---|---|---|---|---|
| A `kMergeRangesDuringAppend` 킬스위치 — media/filters/source_buffer_stream.cc (crbug 486351442) — 🔄 09-21 패치 `patches/A-*.patch`·초안 `drafts/486351442.md` 준비 | M147 | XS 1파일 | media | media_unittests |
| B `kRejectInvalidChildRegions` — components/viz/service/hit_test/hit_test_aggregator.cc (crbug 495852034) — 🔄 09-21 패치 `patches/B-*.patch`·초안 `drafts/495852034.md` 준비 | M150 | XS 1파일 | viz | viz_unittests |
| C `kSigninChromePasskeyUnlockUrlUsesAccountIndex` — google_apis/gaia (features.cc·gaia_urls.cc 2곳·unittest 4곳) — 🔄 09-21 패치 `patches/C-*.patch`·초안 `drafts/gaia-passkey-unlock-account-index.md` 준비 | M153 | XS~S | gaia | google_apis_unittests |
| D `kStrictFFmpegCodecs` — media/ffmpeg/ffmpeg_common.cc (crbug 379418979, «security sensitive» 주석) | M133 | XS | media | media_unittests |
| E `kValidatePromiseImageFormat` — viz image_context_impl.cc (crbug 524822746) — 🔄 09-21 패치 `patches/E-*.patch`·초안 `drafts/524822746.md` 준비 | M152 | XS | viz | viz_unittests |
| F startup 설치 관리자 URL 우회 블록 — startup_tab_provider.cc (crbug 379999327, «or if it stops being reached» → UMA 근거 필요) | M143 | XS | startup | unit_tests |
| G `kWebviewScriptFileOriginCheck` — extensions webview API (crbug 496016840) | M151 | XS | extensions | unit_tests |
| H `kBackgroundActorTaskPopupsOpenInBackground` — chrome/browser/ui (crbug 489205993) | M150 | XS | chrome/ui | unit_tests |
| I `kSandboxExternalProtocolBlocked(Warning)` — browser_features.cc (엔터프라이즈 정책 연결) | **M106** | M | security | browser_tests |
| J `kAccurateVideoFrameConverterColorSpace` — media/base (converter + unittest) | M153 | S | media | media_unittests |

제외: 원 CL/버그가 없는 iOS·Android·CrOS·Windows 전용(omnibox_popup_view_views kill switch는 `#if IS_WIN`), device/fido 추가 플래그 3개(8412192 리뷰어 무반응 중이라 보류), page_node_impl visible_url(선점 7건).

### 2차: 날짜 기반 만료 TODO (10건 중 Mac 빌드 가능)

| 후보 | 만료 | 크기 | 비고 |
|---|---|---|---|
| K prefetch_manager.cc `Navigation.Prefetch.(Un)CompressedBodySize` 히스토그램 제거 (TODO(ricea) Oct 2024, crbug 335524391 열림) | 2024-10 | XS + histograms.xml obsolete | ricea@(빠름) + metrics 리뷰어 |
| ~~L components/metrics/demographics 폐기 pref~~ **✗ 탈락(09-21)** — 헤더의 «Delete after 2023/09»는 낡은 주석이고, asvitkine@가 2025-12에 CL 7243638로 `ClearPref()`를 넣으며 «Remove these after **2026/12**»로 갱신함. 아직 3개월 남음. 2027-01 이후 재검토 | — | — | — |
| M net/http no_vary_search legacy 디렉터리 이동 코드 (crbug 421927600 FIXED; «kSourceDidNotExist 100%면 제거») | 2025-12 | S | ricea@가 UMA 확인 필요 |
| N extensions 2013 preinstalled apps 마이그레이션 (`kProvideLegacyPreinstalledApps`, TODO(grv) Q1-2013) 2파일 | **2013** | S~M, pref 상태 연결 | extensions |
| O blink array_buffer_contents `OOM_CRASH` 예비 검사 (crbug 369653504 FIXED, «크래시 없으면 2025-03 제거») | 2025-03 | XS | 크래시 데이터 확인 필요 |
| P services/preferences pref_hash_filter Windows 폐기 pref 목록 (Oct 2024) | 2024-10 | XS | `#if IS_WIN`, Mac 검증 불가 |

### 3차: 킬스위치 주석이 붙은 ENABLED_BY_DEFAULT 플래그 128개 → blame 2025-12 이전 65개 → 도입일·제거 의도 확인

blame 날짜는 2025-09 BASE_FEATURE 2-인자 마이그레이션 커밋에 오염돼 있어 `git log -S`로 도입일을 다시 잰다. «Keep indefinitely»·API 킬스위치(kBackgroundFetch·kWebOTP·kBrowsingTopics·kNtp*)는 제외.

| 후보 | 도입 | 크기 | 비고 |
|---|---|---|---|
| **★ Q `kMultipleLcppKeyInitiatorOriginFix`** — lcp_critical_path_predictor_util.cc (crbug 380105415 FIXED) — 🔄 **09-21 착수 검증 ①~④ 통과**(선점 0·OSSCA 0·파일 열린 CL은 DO-NOT-SUBMIT 실험뿐·chikamune@ 활동) → OSSCA 초안 `drafts/380105415.md`, 브랜치는 baseline 확인 뒤 | 2024-11 | XS 1파일 | 제거 의도 명시 |
| R `kDesktopCapturePermissionCheckerKillSwitch` — chrome/browser/ui/views/desktop_capture/screen_capture_permission_checker_mac.mm | 2024-06 | XS 1파일, **Mac 전용** | 제거 약속 없는 킬스위치 → OWNER에 먼저 물을 것 |
| S `kHttpsFirstModeForAdvancedProtectionUsers` — chrome_features + chrome/browser/ssl 8파일 («Kill switch for crbug 40892208») | 2023-02 | M | ssl/security OWNERS, uitest 포함 |
| T `kOptimizationGuideFetchingForSRP` — optimization_guide 3파일(browsertest 포함) | 2023-07 | S | browser_tests 필요 |
| U `kSearchesFindUngroupedVisits` — history_clusters 4파일(unittest 포함, «left here as a killswitch») | 2024-01 | S | components_unittests |

제외: kEnableRendererNavigationTimeline(2025-06, 너무 최근) · kIgnorePermissionForDeviceChangedEventForChromeApps(«Chrome Apps가 사라진 뒤») · Windows/iOS 전용.

## 2026-09-23 리눅스(우분투) 전용 후보 — ChromeOS 코드 (Mac 빌드 불가)

만료 마일스톤 제거 주석 105건 중 리눅스·ChromeOS 전용 파일/`#if BUILDFLAG(IS_CHROMEOS)` 블록만 추림. 순수 리눅스 전용은 0건(ozone·gtk·sandbox 쪽 킬스위치는 2026-08 도입이거나 컴포지터 조건부). **ChromeOS 는 리눅스 호스트에서만 빌드 가능** → 우분투 몫.
선점: 각 파일의 열린 CL 은 전부 2021~2025 방치 CL 이거나 무관(shelf 는 8382427 kGeminiAppPreinstall 이 같은 파일) · OSSCA 0.
빌드 주의: 별도 out 디렉터리 `target_os="chromeos"` 가 필요해 첫 빌드는 처음부터(4코어면 수 시간~). 먼저 해당 `.o` 만 컴파일 확인 → 작은 테스트 바이너리 순.

| 후보 | 만료 | 크기 | 테스트 | 비고 |
|---|---|---|---|---|
| V CRD `DCHECK(!access_token.starts_with("oauth2:"))` — remoting/host/chromeos/remote_support_host_ash.cc:173 (b/309958013) | M122 | XS 1줄 | remoting_unittests (`remote_support_host_ash_unittest.cc`) | 가장 쉬움. 트레일러 `Bug: b:309958013` |
| W Adobe Express OEM→default 마이그레이션 — chrome/browser/web_applications/ash/migrations/ (b/314865744) | ~M134 | S (.h/.cc + 호출처) | 없음 | web_applications OWNERS |
| X `ChromeShelfPrefs::CleanupPreloadPrefs()` — chrome/browser/ui/ash/shelf/chrome_shelf_prefs.cc:472 (crbug 350769496) | M127 («mid 2025 ok») | S (+unittest 수정) | chrome_shelf_prefs_unittest (CrOS unit_tests, 무거움) | 같은 파일에 8382427 진행 중 |
| Y file_system_provider smbprovider 공유 정리 — chrome/browser/ash/file_system_provider/service.cc:396 (crbug 1258424) | M108 | XS~S | 없음 | 4년 경과 |
| Z 그래픽 태블릿 펜 버튼 트리밍 — ash/system/input_device_settings/pref_handlers/graphics_tablet_pref_handler_impl.cc:28 | M139 (07/2025) | XS~S | 없음 | TODO(dpad) |

제외: ui/gfx/linux/fontconfig_util.cc M119 가변 폰트(기기 이미지 사실 확인 필요 + 09-16 revert 등 활발) · ash url_constants m100(조건부) · ARC net.mojom(ARC 쪽 저장소 연동).

**리눅스 박스 재확인 (09-23, 트리 345d761d)** — 다섯 곳 모두 그대로 있다. 리눅스 데스크톱 전용 경로 재스캔도 fontconfig M119(위 제외분) 1건뿐 → «순수 리눅스 전용 0건» 맞음. 표 정정:
- **V**: 접두어 호환 코드는 joedow@가 2025-02 `b7482bc0cf6ee`(CL 6227399, 같은 Bug 309958013)로 이미 지웠고 이 DCHECK와 테스트 `ValidLegacyAccessTokenFormatSucceeds`(TODO «oauth 접두어 로직을 지우면 이 테스트도 삭제»)만 남았다 → **둘 다 삭제**, S(~13줄). 리뷰어 joedow@ + yuweih@(remoting/OWNERS). ⚠️ CrOS의 `remoting_unittests`는 `//chrome/browser`에 의존(browser_interop) → 작은 바이너리가 아니다
- **W**: 테스트 있음 — `adobe_express_oem_to_default_migration_browsertest.cc`. 디렉터리 5파일 210줄 + `web_app_provider.cc` include·호출 + `web_applications/BUILD.gn` 3곳 → **M(~−220줄)**. 검증은 gn gen + `unit_tests` 링크(browser_tests는 4코어에 너무 무겁다)
- **X**: 테스트 `ChromeShelfPrefsTest.CleanupPreloadPrefs`도 같이 삭제
- **Y**: **죽은 코드가 아니다** — `SmbProvider`가 아직 `@smb` 제공자로 등록된다(`smb_client/smb_service.cc:583`). 조건문을 지우면 남아 있는 옛 `@smb` 항목이 «잊기» 대신 `SmbFileSystem` 마운트 경로로 간다 → CL 설명에 동작 변화를 적고 OWNER 판단을 받는다
- **Z**: 테스트 `TrimPenButtonList`·`TrimPenButtonListWithDefaultAction`(unittest 439–519)도 같이 삭제 → S. 타깃 `ash_unittests`(//chrome 불필요, 셋 중 가장 가볍다)

권장 순서 V → Z → X → Y → W. 빌드는 `.gclient` `target_os` 추가 + sync 후 `out/cros` 첫 빌드부터 → 4단계 STATUS «V~Z CrOS» 행.

### 09-23 G·H 착수 (Mac)

- **G** `kWebviewScriptFileOriginCheck` (crbug 496016840, 원 CL 7714099 mcnee@) — 착수 검증: 열린 CL 0 · OSSCA 0. 브랜치 `webview-script-origin-killswitch-496016840` 커밋 `871237cd7ab6c` (+2/−9, 1파일, include 포함). 원 CL 테스트: browser_tests `WebUIWebViewBrowserTest.ExecuteScriptBadUrlFromOtherWebUi`
- **H** `kBackgroundActorTaskPopupsOpenInBackground` (crbug 489205993, 원 CL 7758931 mcnee@) — 착수 검증: 열린 CL 0 · OSSCA 0. 브랜치 `actor-popups-background-killswitch-489205993` (+1/−8, 1파일; 파일에 다른 FeatureList 사용 남아 include 유지). 원 CL 테스트: browser_tests `ActorAttemptLoginToolFederatedTest.*`
- ⚠️ 함정 재발: `git new-branch` 는 origin/main(f5e8d) 에서 브랜치를 따서, 2ca4848 로 sync 된 체크아웃에서 `commit -a` 하면 서브모듈 포인터 32개가 딸려 들어간다 → 새 브랜치는 반드시 `git reset --hard 2ca4848` 후 작업, 커밋은 파일 지정 `git add <file>`
- **OSSCA 등록 09-24: G #517 · H #518**
- 검증: 통합 브랜치 `verify-gh` (2ca4848+G+H), 러너 `scripts/gh_test_mac.sh` (browser_tests 빌드 → 두 필터)

### 09-24 D·J 착수 (Mac)

- **D** `kStrictFFmpegCodecs` (crbug 379418979, 원 CL 6040303 dalecurtis@) — 열린 CL 0 · OSSCA 0. 브랜치 `strict-ffmpeg-codecs-killswitch-379418979` 커밋 `6887bba07f672` (+1/−7). 엄격 모드(AV_EF_EXPLODE)를 고정하는 방향
- **J** `kAccurateVideoFrameConverterColorSpace` (crbug 467555325, 원 CL 7821801 → revert → reland 8265191, M154) — 열린 CL 0 · OSSCA 0. TODO 는 «M153 stable» 이지만 실제 출시는 M154 → chromiumdash 로 Stable=155 확인 후 착수. 브랜치 `accurate-frame-converter-color-space-467555325` 커밋 `d59604f146afa` (−37, 4파일)
- 검증: 통합 브랜치 `verify-dj`, 러너 `scripts/dj_test_mac.sh` (media_unittests). `media_switches.h` 를 건드려 media 전반 재컴파일 예상
- OSSCA 초안: `drafts/379418979.md`, `drafts/467555325.md`
- **09-24 검증 완료**: media_unittests 27m50s / 9,482 스텝. D FFmpeg 계열 **219/219**, J `*VideoFrameConverter*` **1460/1460** (ColorSpaceConversion 포함, 꺼진 상태 테스트는 삭제됨). presubmit 두 브랜치 0 경고. 업로드 허가 대기 — 리뷰어 D tmathmeyer@(원 CL 리뷰어) · J dalecurtis@(원 작성자)
- **09-24 D 업로드됨 — 8457502** (tmathmeyer@ · CC amoseui@, hashtag media). 사용자가 D·J 업로드 명령을 중단시켰으나 D 는 이미 올라간 뒤였음(브랜치에 gerritissue 가 안 남아 `git cl issue 8457502` 로 연결). **J 는 미업로드.** OSSCA 이슈 D·J 미등록 상태에서 D 가 먼저 올라감
- **09-24 D OSSCA #523 등록** · **J 업로드 8457722** (dalecurtis@ · CC amoseui@, hashtag media). J 의 OSSCA 이슈는 아직 미등록(초안 `drafts/467555325.md`)

### 09-24 K·U 착수 검증 (Mac)

- **K ✅ 착수 가능** — `chrome/browser/predictors/prefetch_manager.cc` `OnPrefetchFinished()` 의 `Navigation.Prefetch.{Compressed,Uncompressed}BodySize` 기록 블록(«TODO(ricea): Remove these histograms in October 2024 and make a note of the results in crbug.com/335524391»). 원 CL 5465402 (ricea@, 2024-04). 두 히스토그램 모두 `expires_after="2025-04-27"` 로 **이미 만료**(기록 안 됨). `tools/metrics/histograms/README.md` «Once a histogram has expired, the code that records it becomes dead code and should be removed … clean up the histograms.xml entry», 만료 히스토그램은 obsoletion 메시지 생략 가능, «reviewed by all current owners» → 리뷰어 ricea@·chikamune@(histograms.xml owner 둘). 테스트 참조 0, 열린 CL 0(파일·이름), OSSCA 0. 검증: unit_tests(09-23 빌드) 증분 + `PrefetchManager*`. 변경: .cc 블록 삭제 + navigation/histograms.xml 두 항목 삭제. crbug 에 «결과 기록»은 ricea@ 몫(UMA 접근 불가) — CL 설명에 명시
- **U ⏸ 보류** — `kSearchesFindUngroupedVisits` 주석은 «flag left here as a killswitch» 로 **제거 지시가 없음**(R 과 같은 부류) → OWNER 에게 먼저 물어야 함. Journeys 팀이 해당 디렉터리에서 활발히 작업 중(8176345 등). 착수하지 않음
- **09-24 K 검증 완료**: 브랜치 `prefetch-body-size-histograms-335524391` (2ca4848 기준, −45, 2파일). unit_tests 4h03m / 31,858 스텝(J 헤더 되돌림 여파), `PrefetchManager*:*LoadingPredictor*` **114/114** (PrefetchManager 44). presubmit 0 경고(histograms.xml 검사 포함). OSSCA **#536** 등록 · **업로드 8461862** (09-24, ricea@ · CC amoseui@). 범위는 TODO 의 2개(나머지 만료 3개는 별건 후보)
