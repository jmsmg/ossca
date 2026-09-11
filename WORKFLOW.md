# Chromium 기여 표준 진행 방식 — 지도

한 사이클: **이슈 발굴 → OSSCA 등록 → 브랜치 → 수정+테스트 → 업로드 → 리뷰 → 기여 기록 → 머지 후 마무리.**
브랜치 하나 = CL 하나. 단계별 상세는 `steps/<n>-*/GUIDE.md`, 그 단계에 걸린 이슈 현황은 같은 폴더의 `STATUS.md`.

```
 ┌──────────────────────────────────────────────────────────────────────────┐
 │  1 발굴 → 2 OSSCA 등록 → 3 브랜치·수정 → 4 빌드·테스트 → 5 커밋·업로드   │
 │                                                        │                 │
 │                                   ┌────────────────────┴──────────┐      │
 │                                   ▼                               ▼      │
 │                              6 리뷰 라운드                  7 기여 기록  │
 │                                   │  (MERGED)                     │      │
 │                                   └──────────► 8 머지 후 마무리 ◄─┘      │
 │                                                        │                 │
 │              시리즈(CL B, C…)면 3으로 ◄────────────────┘──► 아니면 1로   │
 └──────────────────────────────────────────────────────────────────────────┘
```

| # | 단계 | 입력 → 출력 | 상세 | 현황 |
|---|---|---|---|---|
| 1 | 이슈 발굴 | — → 검증 통과한 crbug 번호 | [GUIDE](steps/1-issue-hunting/GUIDE.md) | [STATUS](steps/1-issue-hunting/STATUS.md) |
| 2 | OSSCA 이슈 등록 | crbug → OSSCA 이슈 번호 + self-assign | [GUIDE](steps/2-ossca-issue/GUIDE.md) · [drafts/](steps/2-ossca-issue/drafts/) | [STATUS](steps/2-ossca-issue/STATUS.md) |
| 3 | 브랜치 및 수정 | 이슈 → 브랜치(=CL) + 회귀 테스트 + 수정 | [GUIDE](steps/3-branch-and-fix/GUIDE.md) | [STATUS](steps/3-branch-and-fix/STATUS.md) |
| 4 | 빌드 및 테스트 | 워킹트리 → `Build Succeeded` + 테스트 통과 로그 | [GUIDE](steps/4-build-and-test/GUIDE.md) | [STATUS](steps/4-build-and-test/STATUS.md) |
| 5 | 커밋 및 업로드 | 브랜치 → Gerrit CL + 리뷰어 지정 | [GUIDE](steps/5-commit-and-upload/GUIDE.md) | [STATUS](steps/5-commit-and-upload/STATUS.md) |
| 6 | 리뷰 라운드 대응 | CL → 새 PS + 답글 … MERGED | [GUIDE](steps/6-review/GUIDE.md) | [STATUS](steps/6-review/STATUS.md) |
| 7 | 기여 기록 | CL 번호 → contributions repo PR | [GUIDE](steps/7-contribution-record/GUIDE.md) | [STATUS](steps/7-contribution-record/STATUS.md) |
| 8 | 머지 후 마무리 | MERGED → crbug·기록·OSSCA 상태 전부 최신 | [GUIDE](steps/8-after-merge/GUIDE.md) | [STATUS](steps/8-after-merge/STATUS.md) |

## 단계를 가로지르는 규칙

- **원격 공개는 사용자가 직접**: `git cl upload`, Gerrit 댓글 Send, `git push`, PR 생성, OSSCA 이슈 등록·댓글.
  문안·드래프트까지만 만든다 (2·5·6·7단계 GUIDE 상단 경고)
- **빌드·테스트는 tmux 안에서** (4단계). 러너는 `steps/4-build-and-test/scripts/`, 로그·마커는 같은 단계의 `logs/`, **홈 최상위엔 파일 금지**
- **AI 흔적 금지**: Chromium 커밋 메시지에 `Co-authored-by` / `Claude` / `Generated` 라인 없음 (5단계 검사 명령)
- **냉동된 crbug엔 질문이 도달하지 않는다**: 사람 댓글이 수년째 없는 이슈는 코멘트만 남겨선 아무도 안 본다.
  **외부 계정은 트래커 CC·필드 편집이 막혀 있으므로**, 답할 사람이 활동 중인 **Gerrit CL에 같은 질문을 한 번 더** 건다
  (crbug는 기록, Gerrit은 알림. 40831207 09-07 사례 · 41396598이 같은 실패 구조)
- **OSSCA 이슈 자동 닫기**: 8단계 `status: merged` PR 본문에 `Closes #<이슈번호>` (키워드가 번호 앞).
  7단계 기록 PR에는 넣지 않는다 — CL이 리뷰 중인데 이슈가 닫힌다. 시리즈는 마지막 CL에서만 (8단계 GUIDE)
- **판단이 바뀌면 기록**: 리뷰로 뒤집힌 전제·오판은 `issues/<crbug>.md`에 남긴다 (443042812 참고)
- **시리즈**: 한 crbug에 CL 여러 개면 8단계 후 1·2 건너뛰고 3단계로 복귀 (40831207: A ✅ → B → C)

## 도구 한눈에

| 도구 | 쓰는 단계 | 용도 |
|---|---|---|
| [`steps/1-issue-hunting/scripts/hunt.py`](steps/1-issue-hunting/scripts/hunt.py) | 1 | 후보 수집(todos / deprecated / expired) + 일괄 triage |
| [`scripts/track.py`](scripts/track.py) (공용) | 1 · 5 · 6 · 7 | 선점·겹침·충돌 조회, CL 상태, 코멘트, 서버=로컬 verify, **리뷰어 근무일 분포(`who`)** |
| [`steps/4-build-and-test/scripts/*.sh`](steps/4-build-and-test/scripts/) | 4 | 빌드+테스트+로그+완료 마커 |
| [`steps/4-build-and-test/scripts/mutation_test.sh`](steps/4-build-and-test/scripts/mutation_test.sh) | 3 · 4 | 변이 테스트 |
| `~/contributions` (`npm run validate:data`, `lint:md`) | 7 | 기여 기록 검증 |

## 계정 · 환경 메모

- git 계정: Seonggon Cho <jmsmg1@me.com> (Gerrit 가입 이메일과 동일해야 함)
- gitcookies 인증 경고 뜨는 중 → 언젠가 `git cl creds-check`로 전환 필요
- **CL에 멘토를 리뷰어·CC로 넣지 않는다** (2026-09-08). 리뷰어는 OWNERS 근거로 직접 정한다
- **tryjob 권한: 2026-09-07 smcgruer@chromium.org에게 추천 요청 메일 발송, 회신 대기.** 그때까지 CQ Dry Run은 리뷰어에게 부탁
  - 절차([문서](https://www.chromium.org/getting-involved/become-a-committer/)): @chromium.org 주소가 없으면 **본인이 신청할 수 없다.**
    같이 일하는 리뷰어가 `accounts@chromium.org`로 추천 메일을 보내야 하고, 이의가 없으면 **미국 근무일 2일** 내 승인
  - 필요 항목: 이메일 주소 + 간단한 이유(필수) · 이름·소속(helpful) · **이미 랜딩된 패치(very helpful — 현재 5개)**
  - 문안: `steps/5-commit-and-upload/GUIDE.md` «트라이잡 권한 요청» 절
  - 일주일 무응답이면 백업 추천인: evanstade@microsoft.com · stevebe@microsoft.com
  - **커미터는 별개·상위 단계** — 커미터 3명 보증(1명은 OWNERS 등재). 얻는 것: CQ 직접 제출 + 새 PS에도 +1 유지 +
    **비커미터에게 요구되는 «커미터 2명 +1»이 1명으로 줄어듦**(`docs/contributing.md:320`). 목표 시점은 큐의 CL 3개 랜딩 후(1~2개월)
- Chromium 체크아웃 `~/chromium/src`, 빌드 `out/Default` (release component build, DCHECK 켜짐)
