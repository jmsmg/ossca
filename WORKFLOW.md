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
- **판단이 바뀌면 기록**: 리뷰로 뒤집힌 전제·오판은 `issues/<crbug>.md`에 남긴다 (443042812 참고)
- **시리즈**: 한 crbug에 CL 여러 개면 8단계 후 1·2 건너뛰고 3단계로 복귀 (40831207: A ✅ → B → C)

## 도구 한눈에

| 도구 | 쓰는 단계 | 용도 |
|---|---|---|
| [`steps/1-issue-hunting/scripts/hunt.py`](steps/1-issue-hunting/scripts/hunt.py) | 1 | 후보 수집(todos / deprecated / expired) + 일괄 triage |
| [`scripts/track.py`](scripts/track.py) (공용) | 1 · 5 · 6 · 7 | 선점·겹침·충돌 조회, CL 상태, 코멘트, 서버=로컬 verify |
| [`steps/4-build-and-test/scripts/*.sh`](steps/4-build-and-test/scripts/) | 4 | 빌드+테스트+로그+완료 마커 |
| [`steps/4-build-and-test/scripts/mutation_test.sh`](steps/4-build-and-test/scripts/mutation_test.sh) | 3 · 4 | 변이 테스트 |
| `~/contributions` (`npm run validate:data`, `lint:md`) | 7 | 기여 기록 검증 |

## 계정 · 환경 메모

- git 계정: Seonggon Cho <jmsmg1@me.com> (Gerrit 가입 이메일과 동일해야 함)
- gitcookies 인증 경고 뜨는 중 → 언젠가 `git cl creds-check`로 전환 필요
- tryjob 권한 없음 → CQ Dry Run은 리뷰어/멘토에게 부탁. 신청: https://www.chromium.org/getting-involved/become-a-committer/
- Chromium 체크아웃 `~/chromium/src`, 빌드 `out/Default` (release component build, DCHECK 켜짐)
