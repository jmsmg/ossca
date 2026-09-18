# 4단계 현황 — 빌드 및 테스트

> 🔄 **진행 중 — 두 머신 (09-15)**
> - **Mac**: ✅ M144 signin(#439) 전 트리 재빌드 완료 4h46m, 테스트 전부 통과. CL 2 net/extras도 27/27 ✓. 둘 다 업로드 허가 대기
> - **리눅스**: #443 extension_service — `scripts/extsvc_force_test.sh extsvc_step1 'ExtensionServiceTest.ExternalExtension*'`,
>   로그 `logs/extsvc_step1_{build,test}.log`, 마커 `logs/extsvc_step1_done.marker`. base 233e625e 증분.
>   1단계 ✅ 05:15 — 422스텝 28m, 블록만 지우니 `ExternalExtensionBecomesEnabledIfForceInstalled` 1개만 실패(의존 증명) → 2단계 `extsvc_step2` ✅ 05:22 재작성 테스트 포함 5/5 → `extsvc_wide` ✅ 05:35 **191/191**. 이어서 #442 `startup_nw` ✅ 05:40 **14/14** (4스텝). **리눅스 두 건 검증 완료, 업로드 승인 대기.** ⚠️ 두 브랜치를 origin/main(345d761d)에 리베이스해서 이 박스의 `out/Default`는 이제 base 233e625e와 어긋남 — 다음 증분 빌드는 커진다
>
> ✅ 09-11 Mac: extensions M113(`extprefs`) 28/28 → CL 8397391
>
> ✅ 09-10 마친 것: 545843242 PS5 리베이스 검증(`pmd4` 52,085스텝, 44/44) · quota M148(`qm148` **313/313**) ·
> quota 테스트 클럭 AutoReset(**321/321**) · 40176243 CL 1 history ColumnTime(`hct` 30,065스텝, **281/281**)

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-15 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| CL | 타깃 | 러너 (`scripts/`) | 로그 (`logs/`) | 상태 |
|---|---|---|---|---|
| 8264232 (372283556) | `services_unittests` | — (컴파일 검증) | — | ✅ |
| 8278112 (443042812) | `components_unittests` | — | `spcbuild.log`, `spc_test.log`, `restored_test.log` | ✅ 풀빌드 15h43m 경험 |
| 8282239 (40831207 A) | `storage_unittests` | `run_quota.sh`, `qbuild_runner.sh`, `qsync_build.sh`, `mutation_test.sh` | `quotabuild.log`, `quota_test2.log`, `quota_test3.log`, `mutation_*.log` | ✅ 변이 테스트 포함 |
| 8336867 (545645933) | `components_unittests` | `pmd_test.sh`, `pmd_wide.sh` | `pmd_build.log`, `pmd_test.log`, `pmd_wide.log`, `pmdw_test.log` | ✅ |
| 8349386 (545843242) | `components_unittests` | `pmd_test.sh` / `pmd_wide.sh` → 리베이스 후 `pmd_sync_test.sh` (tmux `pmds`) | `pmd_*`, `pmds_build.log`, `pmds_test.log`, `pmds_done.marker` | ✅ 09-06 재검증 통과 (16h08m 빌드, 42/42) |
| 8351543 (40681786) | `components_unittests` | `pmp_test.sh` | `pmp_build.log`, `pmp_test.log` | ✅ 기존 파서 테스트 전원 통과로 검증 |
| (quota M148) | `storage_unittests` | `quota_m148_test.sh` (tmux `qm148`) | `qm148_build.log`, `qm148_test.log`, `qm148_done.marker` | ✅ 09-10 **313/313** — 사전 실패 테스트 1개 필터 제외 |
| (40176243 CL 1) | `components_unittests` | `history_coltime_test.sh` (tmux `hct`) | `hct_build.log`, `hct_test.log`, `hct_done.marker` | ✅ 09-08 통과 — 30,065스텝, **281/281** |
| (quota 테스트 클럭) | `storage_unittests` | `quota_m148_test.sh` 재사용 | `qm148_test_run1_preexisting.log` | ✅ 09-10 **321/321** — main이 같은 필터로 크래시하던 것을 고쳤다 |
| 8349386 PS5 (545843242) | `components_unittests` | `pmd4_sync_test.sh` (tmux `pmd4`) | `pmd4_build.log`, `pmd4_test.log`, `pmd4_done.marker` | ✅ 09-10 리베이스 재검증 — 52,085스텝, **44/44** |
| (extensions M113) | `unit_tests` | `extprefs_test.sh` (tmux `extprefs`) | `extprefs_build.log`, `extprefs_test.log`, `extprefs_done.marker` | ✅ 09-11 Mac 28/28 (리눅스 판은 09-11 06:35 완주, `unit_tests` 바이너리가 base 233e625e로 남아 있어 09-15 증분 빌드의 출발점) |
| (#443 extension_service M107) | `unit_tests` | `extsvc_force_test.sh <태그> <필터>` (리눅스) | `extsvc_step1_*`, `extsvc_step2_*` | 🔄 09-15 리눅스 — 1단계 ✅ 기존 테스트 실패 확인(28m) · 2단계 ✅ 5/5 · `ExtensionServiceTest.*` ✅ **191/191** — 검증 완료 |
| (#442 startup Lacros 잔재) | `unit_tests` (`StartupBrowserCreator*`) | `extsvc_force_test.sh startup_nw 'StartupBrowserCreator*'` (리눅스) | `startup_nw_*` | ✅ 09-15 05:40 — 4스텝 58s, **14/14** |
| (438680281) | `components_unittests` + `base_unittests` | `prefs_notfatal_test.sh` (tmux `pnf`) | `pnf_build.log`, `pnf_prefs_test.log`, `pnf_check_test.log`, `pnf_done.marker` | ✅ 09-07 통과 — 13h23m29s / 33,412스텝, 47/47 + 26/26 |
| (#441 WebAuthn 플래그, Mac) | `unit_tests` (`ChromeAuthenticatorRequestDelegate*`) | `webauthn_flags_test_mac.sh` (tmux `webauthn`) — **검증 전용 브랜치 `verify-441-with-m144`**(#441 + M144 cherry-pick)에서 증분 | `webauthn_build.log`, `webauthn_test.log`, `webauthn_done.marker` | ✅ 09-16 14:35 — **3h34m38s/37,212스텝**, `ChromeAuthenticatorRequestDelegate*` **6/6** |
| (432367602 dropped-frame 플래그, Mac) | `blink_unittests` (`WebMediaPlayerMSCompositor*`) — **이 Mac 첫 빌드**, dry-run 21,814스텝 | `dropped_frame_test_mac.sh` (tmux `dropped`) | `dropped_build.log`, `dropped_test.log`, `dropped_done.marker` | ✅ 09-18 12:45 — **2h47m03s/21,889스텝**(첫 빌드), `WebMediaPlayerMSCompositor*` **14/14** |
| CL B (favicon) | `components_unittests` 예상 | ⬜ 러너 미작성 | — | ⬜ |

**교훈 (438680281 → 40176243)** — `base/not_fatal_until.h`처럼 `base/check.h`가 include하는 헤더를 건드리면 **전 트리 재빌드**다
(`check.h`를 직접 include하는 파일만 5,179개). 한 줄 수정에 13시간이 든다.

**그리고 비용이 두 번 든다.** 그 브랜치를 떠나면 헤더가 원상복구되며 **다시 전 트리가 무효화**된다
(M143 33,412스텝 → 다음 CL 37,767스텝). siso 로컬 캐시는 도와주지 않았다.
→ **널리 include되는 base 헤더를 건드리는 CL은 그 사이클의 마지막에 배치**하거나,
  그 CL이 랜딩할 때까지 다른 작업을 시작하지 않는 편이 낫다. 같은 base(origin/main) 위의
  일반 컴포넌트 CL끼리는 브랜치를 오가도 증분 빌드로 끝난다.

**타깃이 `unit_tests`인 경우 (extensions)** — `extensions/browser/extension_prefs.cc`를 고쳤는데 테스트는
`chrome/browser/extensions/extension_prefs_unittest.cc`에 있다. 수정한 디렉터리가 아니라 **테스트가 사는
디렉터리**로 타깃을 고른다. `unit_tests`는 chrome 전체라 `components_unittests`보다 빌드가 크다.

**09-15** — Xcode 27.0/SDK 27 로 첫 빌드: `net_unittests` 14m56s(5,895스텝, `-j 6`) ✓, NEL store 27/27 ✓. `unit_tests`+`base_unittests` 전 트리 **4h46m/59,127스텝 ✓**, signin 95/95 ✓, CheckTest 26/26 ✓ (09-15 오후). 러너 `two_cls_mac.sh`, 마커 `two_cls_done.marker` 전부 0.

**Mac 첫 기록(09-11)** — `storage_unittests` 26분(기본 병렬도, 스왑 2GB) · `unit_tests` **3시간 23분**(`-j 6`, 36,619스텝) · 테스트는 러너 `extprefs_chain_mac.sh` 방식(사용자 tmux + 마커)으로. 4코어 리눅스(풀빌드 15h+)보다 훨씬 빠르지만 `unit_tests`급은 여전히 반나절 계획으로.


**09-16 헤더 섞임 대응(#441)** — 09-15에 `unit_tests`(M144 브랜치) 다음 `media_unittests`(main 브랜치)를 돌려 `out/Default`가 두 헤더 상태로 섞였다(`obj/base/*.o` 15:38 main, `obj/chrome/browser/*` 14:37 M144). main 기반 #441 브랜치로 `unit_tests`를 돌리면 chrome 쪽 ~5만 스텝을 다시 하므로, **#441 위에 M144 커밋을 cherry-pick한 검증 전용 브랜치**로 돌려 base 쪽 ≤8천 스텝만 재빌드할 생각이었으나 **실제 37,212스텝/3h34m — 효과 없음**. 브랜치를 오가며 헤더 mtime이 바뀌면 siso도 `check.h` 포함 파일 전부를 다시 돌린다. 업로드는 깨끗한 브랜치에서. siso `-n`(dry-run)은 전체 스텝 수만 찍어 증분량 추정에 못 쓴다 → 오브젝트 mtime으로 판단.

**09-18 `blink_unittests` 첫 기록** — 2h47m03s / 21,889스텝 (`-j 6`, 09-15 base 트리, `unit_tests` 캐시 위). 후반 600스텝(core/modules 큰 테스트 파일)이 30분을 먹는다. blink 쪽 후보는 이제 증분으로 돈다.

**다음 액션** — CL B 착수 시 `pmd_test.sh`를 복사해 favicon 타깃/필터로 러너를 만든다.
공용 로그(`cbuild.log`, `gclient_sync.log`)와 완료 마커(`*_done.marker`)는 계속 재사용.
