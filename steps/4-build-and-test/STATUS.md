# 4단계 현황 — 빌드 및 테스트

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: 2026-09-05 · 출처: `../../README.md` 요약표 + `../../issues/*.md` 상단 상태 줄

| CL | 타깃 | 러너 (`scripts/`) | 로그 (`logs/`) | 상태 |
|---|---|---|---|---|
| 8264232 (372283556) | `services_unittests` | — (컴파일 검증) | — | ✅ |
| 8278112 (443042812) | `components_unittests` | — | `spcbuild.log`, `spc_test.log`, `restored_test.log` | ✅ 풀빌드 15h43m 경험 |
| 8282239 (40831207 A) | `storage_unittests` | `run_quota.sh`, `qbuild_runner.sh`, `qsync_build.sh`, `mutation_test.sh` | `quotabuild.log`, `quota_test2.log`, `quota_test3.log`, `mutation_*.log` | ✅ 변이 테스트 포함 |
| 8336867 (545645933) | `components_unittests` | `pmd_test.sh`, `pmd_wide.sh` | `pmd_build.log`, `pmd_test.log`, `pmd_wide.log`, `pmdw_test.log` | ✅ |
| 8349386 (545843242) | `components_unittests` | `pmd_test.sh` / `pmd_wide.sh` 재사용 | `pmd_*` | ✅ |
| 8351543 (40681786) | `components_unittests` | `pmp_test.sh` | `pmp_build.log`, `pmp_test.log` | ✅ 기존 파서 테스트 전원 통과로 검증 |
| CL B (favicon) | `components_unittests` 예상 | ⬜ 러너 미작성 | — | ⬜ |

**다음 액션** — CL B 착수 시 `pmd_test.sh`를 복사해 favicon 타깃/필터로 러너를 만든다.
공용 로그(`cbuild.log`, `gclient_sync.log`)와 완료 마커(`*_done.marker`)는 계속 재사용.
