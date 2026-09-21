# 3단계 현황 — 브랜치 및 수정

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-15 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

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
| (crbug 없음) #440 kResetDecoderForNonIDR 킬스위치 | `reset-decoder-nonidr-killswitch` (**Mac**) | ✅ 09-15 — 1파일 +1/−10, gn check OK. 4단계 대기 |
| (crbug 없음) #443 extension_service M107 | `extension-service-force-install-workaround` (**리눅스**, base 233e625e) | ✅ 09-15 — 커밋 `7693492e59b10` → 리베이스 후 `455e826cf4aa7` (+11/−14, 2파일). 블록 −12 + 테스트를 `OnExternalExtensionUpdateUrlFound()` 실제 경로로 재작성. TDD: 삭제만으로 기존 테스트 실패 확인 → 재작성 후 통과 |
| 40216113 #442 startup Lacros 잔재 | `startup-no-window-recheck-40216113` (**리눅스**, 예정) | ✅ 09-15 — 커밋 `d0b436539c379` → 리베이스 후 `cc96915b87a16` (−8, 1파일). 재검사 블록 + 미사용 include 2개. TDD 예외(동작 불변) |
| (crbug 없음) #441 WebAuthn iCloud Keychain 플래그 3개 | `webauthn-icloud-keychain-flags` (**Mac**) | ✅ 09-16 — 커밋 `79633a3c0442d` (+8/−40, 3파일). 기본 켜진 플래그 3개 선언·정의 삭제 + `ShouldCreateInICloudKeychain()` 5분기 → «google.com ∨ iCloud Drive → true, 아니면 WithoutDrive 플래그 2개». gn check OK. TDD 예외(동작 불변) |
| 432367602 dropped-frame 플래그 | `dropped-frame-count-flag-432367602` (**Mac**) | ✅ 09-18 — +5/−25, 3파일. 플래그 선언·정의 삭제, 컴포지터 두 분기를 켜진 쪽만 남김, `feature_list.h`·`media_switches.h` include 제거(다른 사용 0, 컴파일로 확인). `Fixed: 432367602`. TDD 예외(동작 불변). OSSCA 등록은 허가 대기 |
| 41161335 frozen-frames 플래그 | `suspend-frozen-frames-flag-41161335` (**Mac**, base 09-15 b39241398) | ✅ 09-18 — 커밋 `654824f078296` (+8/−24, 4파일). 플래그 선언·정의 삭제, WebMediaPlayerImpl 세 사용처 켜진 분기만, 테스트 ScopedFeatureList 2줄 제거. 멤버 `was_suspended_for_frame_closed_or_frozen_`는 UpdatePlayState_ComputePlayState에서 읽으므로 유지. `Bug: 41161335`. TDD 예외(동작 불변). OSSCA 등록 허가 대기 |
| 474398415 WebCodecs flush 킬스위치 | `webcodecs-flush-killswitch-474398415` (**Mac**, base 09-21 main 2ca4848) | ✅ 09-21 — 커밋 `607ea058b77cc` (+4/−26, 7파일). 플래그 선언·정의 삭제, 브로커 2곳·템플릿 1곳 켜진 분기만, 테스트 2곳 플래그 켜기 제거, 미사용 include 5개 제거. `Bug: 474398415`. gn check는 gclient sync 뒤(러너). TDD 예외(동작 불변). OSSCA 등록 허가 대기 |
| 380105415 LCPP 킬스위치 | `lcpp-initiator-origin-killswitch-380105415` (**Mac**, base 09-21 main) | ✅ 09-21 — 커밋 `04c9cdc1e0524` (+6/−18, 1파일). 플래그 정의·TODO 삭제, `IsValidInitiatorOrigin()` 켜진 분기만. gn check OK. `Bug: 380105415`. TDD 예외(동작 불변). OSSCA 등록 허가 대기 |
| 486351442 A kMergeRangesDuringAppend 킬스위치 제거 | `merge-ranges-killswitch-486351442` (**Mac**, base 09-21 main) | ✅ 09-22 — 커밋 `5b16bc9fdf220` (+1/−7, 1파일). 패치 `patches/A-*.patch`. gn check OK. `Bug: 486351442`. 검증은 `verify-abec` 통합 빌드. OSSCA 등록 허가 대기 |
| 495852034 B kRejectInvalidChildRegions 킬스위치 제거 | `reject-invalid-child-regions-killswitch-495852034` (**Mac**, base 09-21 main) | ✅ 09-22 — 커밋 `2480f86111d07` (+1/−7, 1파일). 패치 `patches/B-*.patch`. gn check OK. `Bug: 495852034`. 검증은 `verify-abec` 통합 빌드. OSSCA 등록 허가 대기 |
| 524822746 E kValidatePromiseImageFormat 킬스위치 제거 | `validate-promise-image-format-killswitch-524822746` (**Mac**, base 09-21 main) | ✅ 09-22 — 커밋 `0738586ca2a34` (+3/−9, 1파일). 패치 `patches/E-*.patch`. gn check OK. `Bug: 524822746`. 검증은 `verify-abec` 통합 빌드. OSSCA 등록 허가 대기 |
| gaia-passkey-unlock-account-index C kSigninChromePasskeyUnlockUrlUsesAccountIndex 만료 플래그 제거 | `gaia-passkey-unlock-account-index-flag` (**Mac**, base 09-21 main) | ✅ 09-22 — 커밋 `16e163cb1f770` (+2/−45, 4파일). 패치 `patches/C-*.patch`. gn check OK. `Bug: none`. 검증은 `verify-abec` 통합 빌드. OSSCA 등록 허가 대기 |

**다음 액션** — extensions CL 검증 통과 후 업로드. 그 다음은 sql ColumnTime CL 1.5(journeys 5곳). 40831207 CL B는 보류. 사용자가 crbug 40831207에 방향 문의 게시 → 답변 오면 재정의. 그 전까지 «수정» 작업은 09-05 발굴한 **sql ColumnTime/ColumnTimeDelta 마이그레이션** (1단계 GUIDE 09-05 절) → 착수 가능.
