# 4단계 현황 — 빌드 및 테스트

> 🔄 **진행 중 (09-10 23:53~)**: extensions 만료 마이그레이션 제거 검증 — tmux `extprefs`, `scripts/extprefs_test.sh`, 마커 `logs/extprefs_done.marker`.
> 타깃은 `unit_tests`(테스트가 `chrome/browser/extensions` 쪽), 필터 `ExtensionPrefs*`
>
> ✅ 09-10 마친 것: 545843242 PS5 리베이스 검증(`pmd4` 52,085스텝, 44/44) · quota M148(`qm148` **313/313**) ·
> quota 테스트 클럭 AutoReset(**321/321**) · 40176243 CL 1 history ColumnTime(`hct` 30,065스텝, **281/281**)

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-10 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

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
| (extensions M113) | `unit_tests` | `extprefs_test.sh` (tmux `extprefs`) | `extprefs_build.log`, `extprefs_test.log`, `extprefs_done.marker` | 🔄 09-10 23:53~ 빌드 중 |
| (438680281) | `components_unittests` + `base_unittests` | `prefs_notfatal_test.sh` (tmux `pnf`) | `pnf_build.log`, `pnf_prefs_test.log`, `pnf_check_test.log`, `pnf_done.marker` | ✅ 09-07 통과 — 13h23m29s / 33,412스텝, 47/47 + 26/26 |
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

**다음 액션** — CL B 착수 시 `pmd_test.sh`를 복사해 favicon 타깃/필터로 러너를 만든다.
공용 로그(`cbuild.log`, `gclient_sync.log`)와 완료 마커(`*_done.marker`)는 계속 재사용.
