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

- Chromium 체크아웃: `~/chromium/src` (빌드: `out/Default`, release component build) — **2026-09-15부터 두 머신에서 빌드·테스트.** Mac(M5 10코어, 09-11~)과 리눅스 박스(`seonggoc`, 4코어 16GB, 09-15 복귀 — ssh 불통이었던 그 서버). 체크아웃·브랜치는 머신별로 따로다(Gerrit 경유로만 합쳐짐)
- **두 머신 운용 규칙 (09-15)**: 어느 머신에서 무엇을 돌리는지는 **이 저장소(README 보드 + `steps/*/STATUS.md` + `issues/*.md`)가 유일한 공유 상태**다. 착수·빌드 시작·검증 결과·커밋 해시가 생길 때마다 **바로 커밋하고 push**한다(`git pull --rebase` 먼저). 보드의 «지금 어디» 칸에 머신 이름(Mac/리눅스)을 적는다
  - Mac: M144 signin 전 트리 빌드(`unit_tests`+`base_unittests`) → 끝나면 #440 킬스위치, CL 2 net/extras 업로드
  - 리눅스: XS 이슈 두 건 검증 완료(09-15 05:40) — #443 `455e826cf4aa7` · #442 `cc96915b87a16`, **업로드 완료** — CL 8410065 · 8410085 (05:50). 다음 후보 #441 WebAuthn(device/fido, S)
- OSSCA 기여 기록 repo: `~/contributions` (fork: jmsmg, upstream: OSSCA-chromium)
- OSSCA 이슈 페이지: https://github.com/OSSCA-chromium/contributions/issues
- 기여 기록 사이트: https://ossca-chromium.github.io/contributions/

## 이슈 × 단계 보드 (2026-09-15 기준)

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
| [438680281](https://crbug.com/438680281) (만료 M143 정리) | ✅ 09-07 | ✅ #403 | ✅ | ✅ | ✅ | ✅ | ✅ #405 | 🔄 | 8 — **CL 8366188 머지(09-14, `fdce3e159a88b`)**. `status: merged` PR **#438** 제출(`Closes #403`), 멘토 머지 대기 |
| (자체 발굴) quota 테스트 클럭 댕글링 | ✅ 09-10 | ✅ #421 | ✅ | ✅ | ✅ PS3 | ⏳ | ✅ #424 | ⬜ | **PS2 로컬 완성(09-11, Mac)** — mock time 판, 57/57·319/319, 크래시 0. **PS2/PS3 업로드 + 답글 2건 게시(09-11)** → evanstade@ 응답 대기. OSSCA 이슈는 여전히 미등록 |
| (자체 발굴) quota 만료 M148 153곳 | ✅ 09-09 | ✅ #422 | ✅ | ✅ 313/313 | ✅ 8377550 | ⏳ | ✅ #425 | ⬜ | 6 — **PS2(설명 축소) + 답글 완료(09-11)**, CR+1 유지. 어텐션 수동 추가 필요. 남은 것: 리뷰어 CQ · 기록 PR 미제출 · OSSCA 이슈 미등록 |
| [40176243](https://crbug.com/40176243)·40251269 (sql ColumnTime) CL 1 | ✅ 09-05 | ✅ #416 | ✅ | ✅ 281/281 | ✅ 8382856 | ✅ 머지 09-17 | ⏳ #417 | 🔄 | 8 — CL 1 **머지 09-17** (`2c16217b7e515`, manukh@ CQ). merged PR **#462**(Closes 없음, 시리즈) 제출 09-18. CL 2 8410045 리뷰 중 |
| 40176243 (sql ColumnTime) CL 2 net/extras | ✅ 09-15 | ✅ #416 | ✅ `a3c7d4d` | ✅ 27/27 | ✅ 8410045 | ⏳ | ✅ #452 | ⬜ | 6 — **CL 8410045**(09-15) nidhijaju@ +1, ricea@ 대기. 기록 PR **#452**(09-17). #416 코멘트 09-17 |
| (자체 발굴) 만료 M144 signin 3곳+enum | ✅ 09-15 | ✅ #439 | ✅ `bb98018` | ✅ 95/95·26/26 | ✅ 8409786 | ✅ 머지 09-17 | ✅ #451 | 🔄 | 8 — **머지 09-17** (`37ac4ebc43de5`, alexilin@ CQ). 기록 PR #451 머지. merged PR **#459**(`Closes #439`) 제출 09-18 |
| (자체 발굴) `kResetDecoderForNonIDR` 킬스위치 (media/gpu/mac) | ✅ 09-15 | ✅ #440 | ✅ | ✅ 8/8 | ✅ 8410466 | ✅ 머지 09-17 | ✅ #453 | 🔄 | 8 — **머지 09-17** (`0a61d4d13c9e4`, eugene@ CQ). 기록 PR #453 머지. merged PR **#461**(`Closes #440`) 제출 09-18 |
| (자체 발굴) WebAuthn iCloud Keychain 플래그 3개 (device/fido) | ✅ 09-15 | ✅ #441 | ✅ 09-16 | ✅ 09-16 | ✅ 8412192 | ⬜ | ✅ #450 | ⬜ | 6 리뷰 대기 — **Mac** 09-16 **CL 8412192** PS3 (derinel@·nsatragno@). #441 코멘트 09-17 (S) |
| [432367602](https://crbug.com/432367602) dropped-frame 플래그 (media/base + blink mediastream) | ✅ 09-18 | ✅ #464 | ✅ `ee435a2` | ✅ 14/14 | ✅ 8429522 | ✅ 머지 09-21 | ✅ #475 | 🔄 | 8 — **머지 09-21** (`24cd108dc57b6`, kron@ CQ). 기록 PR #475 머지. merged PR 허가 대기 · #464 수동 닫기 · 보드 Status |
| [41161335](https://crbug.com/41161335) frozen-frames 플래그 (media/base + blink platform/media) | ✅ 09-18 | ✅ #465 | ✅ `654824f` | ✅ 78/78 | ✅ 8423128 | ⏳ | ✅ #476 | ⬜ | 6 — **Mac** 09-21 **CL 8423128** PS1 (dalecurtis@ 1차, CC amoseui@). +1 오면 tmathmeyer@ 추가. #465 코멘트 허가 대기 (S) |
| [474398415](https://crbug.com/474398415) WebCodecs flush 킬스위치 (media/base + blink webcodecs) | ✅ 09-21 | ✅ #478 | ✅ `607ea05` | ✅ 24/24 | ✅ 8423462 | ⏳ | ✅ #480 | ⬜ | 6 — **Mac** 09-21 **CL 8423462** PS1 (eugene@ 1차, CC amoseui@). +1 오면 tguilbert@ 추가. #478 코멘트·기록 PR #480 09-21 (S) |
| [380105415](https://crbug.com/380105415) LCPP initiator-origin 킬스위치 (chrome/browser/predictors) | ✅ 09-21 | ⬜ 초안 | ✅ `04c9cdc` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | 2 — OSSCA 등록 허가 대기 · unit_tests 빌드(4~5h, G·H와 묶기 검토). 리뷰어 chikamune@ → alexilin@ (XS) |
| [40216113](https://crbug.com/40216113) Lacros 잔재 (ui/startup) | ✅ 09-15 | ✅ #442 | ✅ | ✅ 14/14 | ✅ 8410085 | ✅ 머지 09-17 | ✅ #463 | 🔄 | 8 — **머지 09-17** (`1e5c4ad3d899d`, dgn@ CQ, 리눅스 CL). 기록 PR **#463**(`Add`, status merged, `Closes #442`) 제출 09-18 |
| (자체 발굴) extension_service 강제설치 우회 (extensions) | ✅ 09-15 | ✅ #443 | ✅ | ✅ 191/191 | ✅ 8410065 | ⬜ | ⬜ | ⬜ | 6 — **리눅스** 09-15 **CL 8410065** PS1 업로드(rdevlin.cronin@·andreaorru@, CC nicolaso@). 커밋 `455e826cf4aa7`. 1단계: 블록만 지우면 기존 테스트 실패(의존 증명) ✓ · 2단계: 테스트를 `OnExternalExtensionUpdateUrlFound` 경로로 재작성 5/5 ✓ · `ExtensionServiceTest.*` **191/191** ✓ — 검증 완료, 리베이스·업로드 승인 대기 (`issues/extension-service-force-install-workaround.md`) |
| (자체 발굴) extensions 만료 M113 마이그레이션 | ✅ 09-10 | ✅ #423 | ✅ | ✅ 28/28 | ✅ 8397391 | ✅ 머지 09-17 | ✅ #437 | 🔄 | 8 — **머지 09-17** (`7a77a41779ef2`, finnur@ CQ). 기록 PR #437 머지. merged PR **#460**(`Closes #423`) 제출 09-18 |

**밀린 것 (2026-09-14 실측)**

A. ~~**8377022 PS4 업로드**~~ ✅ 09-14 — PS4/PS5 업로드, stevebe@ 추가, 답글·Resolved 완료. 이제 +1 두 개 대기
B. ~~**두 번째 커미터 +1 확보**~~ ✅ 09-14 리뷰어 추가 완료 — 8366188 battre@ · 8377550 stevebe@ · 8377022 stevebe@. 이제 +1 대기
C. ~~**extensions M113 업로드**~~ ✅ 09-14 CL 8397391 → 당일 LGTM +1. 기록 PR #437 제출. andreaorru@ 추가 완료(09-15)
D. 8단계 40681786 마무리 — #415 머지·#400 자동 종료 ✓, «배운 것» ✅ 09-15 작성. 남은 것 보드 Status `반영 완료`(사용자)
E. 저장소 변경 커밋 (09-11~14 작업 기록 27개 파일)

F. ~~sql ColumnTime CL 1.5(journeys)~~ **소멸** — 09-11 hempjudith@ 가 먼저 옮김. 시리즈 다음은 CL 2 net/extras/sqlite 4곳

G. **8349386 전제 붕괴 대응** — 리뷰어가 스펙 근거 없음을 지적, 검증 결과 맞음(crbug 인용이 AI 환각). 답글·방향 결정 필요 (`issues/545843242.md`)
H. ~~**OOO 리뷰어**~~ ✅ 09-16 추가(교체 아님): 8397391 +finnur@ · 8410065 +solomonkinard@, andreaorru@ 유지
I. **OSSCA 이슈 정리** — #403 은 PR #438 머지에도 안 닫힘(수동 close 필요) · #443 은 CL 리뷰 중인데 09-15 02:13 UTC 에 jmsmg 계정으로 닫힘(리눅스 세션?) → 재오픈 검토

**(09-11 목록)**

1. ~~**8377022 재작성**~~ ✅ 09-11 완료 — mock time 판 PS2/PS3 + 답글 2건, evanstade@ 대기
2. ~~**8377550 PS2**~~ ✅ 09-11 완료 — 설명 축소·답글, 어텐션 추가만 확인
3. ~~**기록 PR 2건 push·생성**~~ ✅ 09-11 제출 — #424(8377022) · #425(8377550), 멘토 리뷰 대기
4. ~~**OSSCA 이슈 등록 3건**~~ ✅ 09-11 등록 — #421(8377022) · #422(8377550) · #423(extensions). 프로젝트 Status만 손으로
5. **try-job 추천 회신 확인** — smcgruer@에게 09-07 발송, 09-11 현재 무응답 (4일)
6. **서버 퇴역에 따른 회수 (09-11)** — 서버에만 있던 것: extensions M113 커밋 `134e015c8c3e4`(미업로드), 8377022 재작성 진행분(있다면), `~/contributions`의 기록 PR 로컬 커밋 2건(미push). ssh가 거부돼 이 Mac에서 확인 불가 → 서버를 켤 수 있으면 `git cl upload`/push로 건지고, 아니면 Mac에서 다시 만든다

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
| [8366188](https://crrev.com/c/8366188) | [prefs] Remove expired NotFatalUntil::M143 from PrefService type checks | XS | +4/−5 (9줄) | 2 | 머지 (2026-09-14) |
| [8377550](https://crrev.com/c/8377550) | [storage] Remove expired NotFatalUntil::M148 from quota CHECKs | L | +154/−160 (314줄) | 10 | 리뷰 중 (PS2, evanstade +1, stevebe 대기) |
| [8377022](https://crrev.com/c/8377022) | [storage] Drop QuotaDatabase's test clock in favor of mock time | M | +41/−107 (148줄) | 5 | 리뷰 중 (PS5, evanstade +1, stevebe 대기) |
| [8382856](https://crrev.com/c/8382856) | [history] Migrate to sql::Statement time accessors | S | +14/−18 (32줄) | 3 | 머지 (2026-09-17) |
| [8397391](https://crrev.com/c/8397391) | [extensions] Remove the expired install_time pref migration | S | +0/−82 (82줄) | 3 | 머지 (2026-09-17) |
| [8409786](https://crrev.com/c/8409786) | [signin] Remove expired NotFatalUntil::M144 from signin CHECKs | S | +3/−12 (15줄) | 3 | 머지 (2026-09-17) |
| [8410085](https://crrev.com/c/8410085) | [startup] Remove the expired --no-startup-window re-check | XS | +0/−8 (8줄) | 1 | 머지 (2026-09-17) |
| [8410466](https://crrev.com/c/8410466) | [media/gpu/mac] Remove the kResetDecoderForNonIDR kill switch | S | +1/−10 (11줄) | 1 | 머지 (2026-09-17) |
| [8412192](https://crrev.com/c/8412192) | [webauthn] Remove the expired iCloud Keychain rollout flags | S | +8/−40 (48줄) | 3 | 리뷰 중 (PS3, derinel·nsatragno 대기) |
| [8429522](https://crrev.com/c/8429522) | [mediastream] Remove expired kMediaStreamAccurateDroppedFrameCount flag | S | +5/−25 (30줄) | 3 | 머지 (2026-09-21) |

사이즈 = Gerrit 뱃지 기준 (변경 줄 수 합계): XS <10 · S 10–49 · M 50–249 · L 250–999 · XL ≥1000.
docs 링크 수정 → include 정리 → 불변식 강제(CHECK) → 자료구조 리팩토링(RAII 트랜잭션) 순으로
점점 실제 로직에 가까워지는 중. 8278112는 리뷰에서 방향이 바뀌며 +23 → +1로 줄어든 사례.

자세한 내용은 `issues/` 아래 각 파일과 `steps/*/STATUS.md` 참고.
