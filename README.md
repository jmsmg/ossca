# OSSCA Chromium 오픈소스 작업 공간

OSSCA Chromium 멘토링 프로그램(2026) 기여 작업의 진행 방식과 이슈별 상황을 기록하는 디렉토리.

## 구조

```
ossca/
├── README.md                 ← 이 파일: 이슈×단계 보드, CL 사이즈 이력
├── WORKFLOW.md               ← 워크플로우 지도 (8단계 개요 + 단계 횡단 규칙 + 도구)
├── scripts/track.py          ← 여러 단계(1·5·6·7)가 쓰는 공용 도구: 선점·겹침·CL 상태·코멘트·verify·리뷰어 근무일(who)
├── steps/                    ← 단계별 폴더 (가로축)
│   ├── 1-issue-hunting/      GUIDE.md · STATUS.md · scripts/hunt.py (후보 수집·triage)
│   ├── 2-ossca-issue/        GUIDE.md · STATUS.md · drafts/<crbug>.md (이슈 본문 문안)
│   ├── 3-branch-and-fix/     GUIDE.md · STATUS.md
│   ├── 4-build-and-test/     GUIDE.md · STATUS.md · scripts/*.sh (러너 8개) · logs/ (빌드·테스트 로그, 완료 마커)
│   ├── 5-commit-and-upload/  GUIDE.md · STATUS.md
│   ├── 6-review/             GUIDE.md · STATUS.md
│   ├── 7-contribution-record/GUIDE.md · STATUS.md
│   └── 8-after-merge/        GUIDE.md · STATUS.md
└── issues/<crbug>.md         ← 이슈별 진행 기록 (세로축) — 판단·오판·배운 것
```

- `steps/*/GUIDE.md` — 그 단계의 절차·명령어·함정 (입력/출력/완료 조건 표로 시작)
- `steps/*/STATUS.md` — 그 단계에 걸린 이슈가 진행 중인지·완료됐는지·기다리는지 + 다음 액션
- `issues/<crbug>.md` — 한 이슈가 8단계를 통과하며 남긴 기록. 단계 파일이 "지금 어디"라면 이슈 파일은 "왜 그렇게"
- 스크립트는 그 단계 폴더의 `scripts/`, 여러 단계가 쓰는 것은 최상위 `scripts/`. 빌드 로그·마커는 `steps/4-build-and-test/logs/` (홈 최상위 파일 금지 규칙)

## 관련 위치

- Chromium 체크아웃: `~/chromium/src` (빌드: `out/Default`, release component build)
- OSSCA 기여 기록 repo: `~/contributions` (fork: jmsmg, upstream: OSSCA-chromium)
- OSSCA 이슈 페이지: https://github.com/OSSCA-chromium/contributions/issues
- 기여 기록 사이트: https://ossca-chromium.github.io/contributions/

## 이슈 × 단계 보드 (2026-09-11 기준)

범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요

| crbug | 1 발굴 | 2 등록 | 3 수정 | 4 빌드 | 5 업로드 | 6 리뷰 | 7 기록 | 8 마무리 | 지금 어디 |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|---|
| 372283556 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 종료 |
| 443042812 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 종료 (#334 닫음 09-07) |
| 545645933 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 종료 (#369 닫음 09-07) |
| 40831207 (CL A) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | 8 — #378 머지(09-05). 시리즈라 #342는 CL C 머지까지 열어둠 |
| 40831207 (CL B·C) | ➖ | ➖ | ⏸ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | 3 — CL B 보류: batching mode 8291668과 방향 충돌, **09-07 문의 게시 → jpgravel·grt 답변 대기** |
| 40681786 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | 8 — **CL 8351543 머지(09-09 14:47, `3f65cb3afb2d1`)**. `status: merged` PR **#415**(`Closes #400`) 제출, 머지 대기 |
| 545843242 | ✅ | ✅ | ✅ | ✅ | ✅ | ⏳ | ✅ | ➖ | 6 — **PS5 리베이스 업로드(09-10 23:42)**, `mergeable`. 리베이스로 +1이 outdated 처리됨 → 재승인·CQ 대기. smcgruer@ attention |
| 41396598 | ✅ | ❌ | ➖ | ➖ | ➖ | ➖ | ➖ | ➖ | 포기 (09-09) — 의사 타진 16일 무응답, Recharge-Cold 라벨 |
| [438680281](https://crbug.com/438680281) (만료 M143 정리) | ✅ 09-07 | ✅ #403 | ✅ | ✅ | ✅ | ⏳ | ⏳ | ⬜ | 6 — CL 8366188(09-08) gab@ 리뷰 대기 · 기록 PR #405 제출 |
| (자체 발굴) quota 테스트 클럭 댕글링 | ✅ 09-10 | ⬜ | 🔄 | 🔄 | 🔄 | 🔄 | 🔄 | ⬜ | **6 → 3으로 되돌아감** — evanstade@가 mock time 방식 제안(09-10 18:48), 조사 결과 타당 → **전역·세터를 통째로 삭제하는 판으로 재작성**. 어텐션 우리 |
| (자체 발굴) quota 만료 M148 153곳 | ✅ 09-09 | ⬜ | ✅ | ✅ 313/313 | ✅ 8377550 | 🔄 | 🔄 | ⬜ | 6 — **evanstade@ `CR+1`(09-10 18:44)**. 커밋 메시지 nit 1건만 남음 → PS2로 축소. 기록 PR 미제출(초안 준비됨) |
| [40176243](https://crbug.com/40176243)·40251269 (sql ColumnTime) CL 1 | ✅ 09-05 | ✅ #416 | ✅ | ✅ 281/281 | ✅ 8382856 | ⏳ | ⏳ #417 | ⬜ | 6 — CL 8382856(09-09) manukh@ 리뷰 대기 **(26일 무활동 리뷰어 — OWNERS 추가 검토)** · 기록 PR #417 제출 |
| (자체 발굴) extensions 만료 M113 마이그레이션 | ✅ 09-10 | ⬜ | ✅ | 🔄 | ⬜ | ⬜ | ⬜ | ⬜ | 4 — 커밋 `134e015c8c3e4` (3파일 −82, 순수 삭제). `unit_tests` 빌드 중(09-10 23:53~) |

**밀린 것 (2026-09-11)**

1. **8377022 재작성** — 리뷰어가 더 나은 방식을 제시했다. 빌드 끝나면 착수 (`steps/6-review/drafts/8377022-mocktime.md`)
2. **8377550 PS2** — 커밋 메시지만 줄이면 됨 (`steps/6-review/drafts/8377550-ps2.md`)
3. **기록 PR 2건 push·생성** — 8377022 · 8377550, 로컬 CI 통과 (`steps/7-contribution-record/drafts/`)
4. **OSSCA 이슈 등록 3건** — quota 2건 + extensions 1건 (사용자가 미루기로 함)
5. **try-job 추천 회신 확인** — smcgruer@에게 09-07 발송, 09-11 현재 무응답 (4일)

(이전 기록)  (09-07: 40831207 방향 문의를 crbug #16 + CL 8291668 양쪽에 게시 — 트래커 CC 권한이 없어 Gerrit으로 알림 우회)
(09-07 해소: 545843242 PS2 업로드·답글 · OSSCA 등록 #400·#401 · #334·#369 닫아 443042812·545645933 완전 종료)
앞으로 OSSCA 이슈는 8단계 `status: merged` PR 본문의 `Closes #<번호>`로 자동 종료한다 (WORKFLOW 규칙).
단계별 다음 액션은 각 `steps/*/STATUS.md` 하단.

## 현재 상태 요약 (2026-09-08 기준)

| crbug | 내용 | 상태 |
|---|---|---|
| [443042812](https://crbug.com/443042812) | SPC 팩토리 delegate DCHECK→CHECK 승격 (리뷰 -1 후 방향 전환) | ✅ 완전 종료 (CL 8278112 머지, 기록 PR #348 머지, OSSCA #334 닫음 09-07) |
| [545645933](https://crbug.com/545645933) | manifest downloader rel 대소문자 매칭 | ✅ 완전 종료 (CL 8336867 2026-09-02 머지, 기록 PR #371 · merged 표시 PR #375 머지, OSSCA #369 닫음 09-07) |
| [41396598](https://crbug.com/41396598) | CurrencyFormatter를 ICU UnitWidth::HIDDEN으로 재작성 (M) | ❌ 포기 (09-09). 08-24 의사 타진 댓글 16일 무응답, 이슈 Hotlist-Recharge-Cold. 재조사 금지 |
| [40831207](https://crbug.com/40831207) | sql 수동 트랜잭션 제거 — CL 시리즈 (quota→favicon→삭제) | ✅ CL A 머지 (8282239, 2026-09-04), 기록 PR #370·merged 표시 PR #378 모두 머지 → OSSCA #342 Status 코멘트 남음 → CL B(favicon) ⏸ 보류: sql 팀 batching mode(8291668)가 장수 트랜잭션 대체 예정, crbug 방향 문의 → CL C는 batching 랜딩 후 |
| [40681786](https://crbug.com/40681786) | payments 매니페스트 파서 에러 문자열 → native_error_strings (시리즈 1/3, OSSCA #400) | ✅ **CL 8351543 머지 (2026-09-09 14:47, 커밋 `3f65cb3afb2d1`, PS4)** — 기록 PR #385 머지 → **8단계 남음**: `status: merged` PR(`Closes #400`) |
| [545843242](https://crbug.com/545843242) | Link 헤더 exactly-one 검증 (545645933 쌍둥이, OSSCA #401) | CL 8349386 PS1(09-04) → 8280660과 충돌 → 09-05 리베이스 → 09-06 빌드·테스트 통과(42/42) → **PS2 업로드+설명 답글(09-07, 커밋 `4aa401c79f25c`)**, smcgruer@ 리뷰 대기 · 기록 PR #386 머지(09-06) |
| [372283556](https://crbug.com/372283556) | crypto/hash 마이그레이션 services/network include 정리 | ✅ 완료 (CL 8264232, 2026-08-22 머지) |

## CL 사이즈 이력

| CL | 제목 | 사이즈 | 크기 | 파일 | 상태 |
|---|---|---|---|---|---|
| [8146619](https://crrev.com/c/8146619) | Fix broken links to removed docs/linux/suid_sandbox.md | S | +6/−5 (11줄) | 4 | 머지 (2026-07-28) |
| [8264232](https://crrev.com/c/8264232) | services/network: remove stale crypto/sha2 and secure_hash includes | XS | +0/−9 (9줄) | 7 | 머지 (2026-08-22) |
| [8278112](https://crrev.com/c/8278112) | [payments] Upgrade delegate DCHECK to CHECK in SPC app factory | XS | +1/−1 (2줄) | 1 | 머지 (2026-08-26) |
| [8282239](https://crrev.com/c/8282239) | [storage] Migrate QuotaDatabase to scoped sql::Transaction | M | +56/−15 (71줄) | 3 | 머지 (2026-09-04) |
| [8336867](https://crrev.com/c/8336867) | [payments] Match Link rel types case-insensitively in manifest download | S | +23/−7 (30줄) | 3 | 머지 (2026-09-02) |
| [8351543](https://crrev.com/c/8351543) | [payments] Move manifest parser error strings to native_error_strings | L | +222/−72 (294줄) | 4 | 머지 (2026-09-09) |
| [8349386](https://crrev.com/c/8349386) | [payments] Fail manifest download on multiple manifest Link headers | M | +105/−38 (143줄) | 5 | 리뷰 대기 (PS2, 09-07 리베이스 업로드) |
| [8366188](https://crrev.com/c/8366188) | [prefs] Remove expired NotFatalUntil::M143 from PrefService type checks | XS | +4/−5 (9줄) | 2 | 리뷰 대기 (PS1, 09-08) |

사이즈 = Gerrit 뱃지 기준 (변경 줄 수 합계): XS <10 · S 10–49 · M 50–249 · L 250–999 · XL ≥1000.
docs 링크 수정 → include 정리 → 불변식 강제(CHECK) → 자료구조 리팩토링(RAII 트랜잭션) 순으로
점점 실제 로직에 가까워지는 중. 8278112는 리뷰에서 방향이 바뀌며 +23 → +1로 줄어든 사례.

자세한 내용은 `issues/` 아래 각 파일과 `steps/*/STATUS.md` 참고.
