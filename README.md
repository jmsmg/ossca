# OSSCA Chromium 기여 워크플로우

OSSCA Chromium 멘토링 프로그램에서 Chromium 이슈 하나를 **발굴 → OSSCA 등록 → 브랜치·수정 → 빌드·테스트 → 업로드 → 리뷰 → 기여 기록 → 머지 후 마무리**의 8단계로 굴리는 작업 공간 템플릿.
단계별 절차·명령어·함정을 적은 가이드, 선점·겹침·CL 상태를 조회하는 스크립트, 빌드·테스트 러너, 그리고 실제로 진행한 이슈 7건(2026)의 기록 예시가 들어 있다.

이 저장소를 클론해서 **내 작업 공간**으로 쓰는 것을 전제로 한다. 가이드는 읽고, 상태 파일(BOARD · STATUS · issues)은 내 진행에 맞춰 채운다.

## 시작하기

1. 클론 → [`SETUP.md`](SETUP.md)를 따라 개인 설정 (계정, 경로, `config.env`) — 처음 한 번
2. [`WORKFLOW.md`](WORKFLOW.md)로 8단계 전체 그림과 단계 횡단 규칙을 읽는다
3. [1단계 GUIDE](steps/1-issue-hunting/GUIDE.md)부터 시작. 이슈를 잡으면 [`issues/TEMPLATE.md`](issues/TEMPLATE.md)를 복사해 기록을 시작한다
4. 막히면 [`examples/`](examples/README.md)에서 같은 자리의 채워진 예시를 본다

## 구조

```
ossca/
├── README.md                 ← 이 파일
├── SETUP.md                  ← 개인 세팅 (계정 · 경로 · config.env · 빌드 환경) — 처음 한 번
├── CLAUDE.md (= AGENTS.md)   ← AI 에이전트가 세션마다 자동으로 읽는 규칙·읽기 순서
├── WORKFLOW.md               ← 워크플로우 지도 (8단계 개요 + 단계 횡단 규칙 + 도구)
├── BOARD.md                  ← 내 이슈×단계 보드, CL 사이즈 이력 (템플릿 — 채워 쓴다)
├── config.env.example        ← 경로·계정 설정 예시 → 복사해 config.env (커밋되지 않음)
├── scripts/track.py          ← 여러 단계(1·5·6·7)가 쓰는 공용 도구: 선점·겹침·CL 상태·코멘트·verify
├── steps/                    ← 단계별 폴더 (가로축)
│   ├── 1-issue-hunting/      GUIDE.md · STATUS.md · scripts/hunt.py (후보 수집·triage)
│   ├── 2-ossca-issue/        GUIDE.md · STATUS.md · drafts/TEMPLATE.md (이슈 본문 문안)
│   ├── 3-branch-and-fix/     GUIDE.md · STATUS.md
│   ├── 4-build-and-test/     GUIDE.md · STATUS.md · scripts/run.sh, mutation_test.sh · logs/
│   ├── 5-commit-and-upload/  GUIDE.md · STATUS.md
│   ├── 6-review/             GUIDE.md · STATUS.md
│   ├── 7-contribution-record/GUIDE.md · STATUS.md
│   └── 8-after-merge/        GUIDE.md · STATUS.md
├── issues/TEMPLATE.md        ← 이슈별 진행 기록 템플릿 → issues/<crbug>.md (세로축)
└── examples/                 ← 채워진 예시: 실제 이슈 7건의 BOARD · STATUS · issues · drafts · 러너
```

세 층으로 읽는다:

- `steps/*/GUIDE.md` — 그 단계의 **절차·명령어·함정** (입력/출력/완료 조건 표로 시작). 사람이 바뀌어도 그대로 쓰는 부분
- `BOARD.md`, `steps/*/STATUS.md` — **지금 어디**. 어느 이슈가 진행 중인지·완료됐는지·기다리는지 + 다음 액션
- `issues/<crbug>.md` — **왜 그렇게**. 한 이슈가 8단계를 통과하며 남긴 판단·오판·배운 것

스크립트는 그 단계 폴더의 `scripts/`, 여러 단계가 쓰는 것은 최상위 `scripts/`. 빌드 로그·완료 마커는 `steps/4-build-and-test/logs/` (git에 올라가지 않음).

## AI 코딩 에이전트와 함께 쓸 때

이 워크플로우는 Claude Code 같은 에이전트에게 GUIDE를 읽히고 같이 작업하는 방식으로 만들어졌다.
에이전트가 지킬 규칙과 읽기 순서는 [`CLAUDE.md`](CLAUDE.md)에 있고, Claude Code는 이 파일을 세션마다 **자동으로 읽는다**
(`AGENTS.md`는 같은 파일의 심볼릭 링크 — Codex · Cursor 등 다른 도구용). 그래서 에이전트에게는 지금 하고 싶은 일만 말하면 된다:

| 상황 | 이렇게 말한다 |
|---|---|
| 세팅 직후 첫 세션 | `config.env 채웠어. track.py config로 확인하고 1단계 이슈 발굴부터 시작하자` |
| 이어서 하는 세션 | `BOARD.md와 STATUS 보고 지금 어디까지 왔는지 파악한 뒤 다음 액션 제안해` |
| 특정 단계로 바로 | `crbug 12345678을 3단계부터 진행해` |
| 리뷰 코멘트가 왔을 때 | `track.py comments <CL>로 새 코멘트 읽고, 지적을 코드로 직접 검증한 뒤 답글 문안 만들어` |
| 머지된 뒤 | `CL <번호> 머지됐어. 8단계 체크리스트대로 정리하고 BOARD 갱신해` |

에이전트가 지키는 규칙 (혼자 써도 무해하다):

- **원격 공개는 사람이 직접** — `git cl upload`, Gerrit 댓글 Send, `git push`, PR 생성, OSSCA 이슈 등록·댓글. 에이전트는 문안·드래프트까지만 만든다
- **커밋 메시지에 AI 흔적 금지** — `Co-authored-by` / `Claude` / `Generated` 라인 없음 (5단계에 검사 명령)
- 러너 스크립트 첫 줄의 `unset CLAUDECODE ...` — 에이전트 환경변수가 남아 있으면 autoninja가 `--quiet`로 돌아 로그에 점만 찍힌다

## 관련 링크

- OSSCA 기여 기록 저장소: https://github.com/OSSCA-chromium/contributions (이슈 등록 · 기여 기록 PR)
- 기여 기록 사이트: https://ossca-chromium.github.io/contributions/
- Chromium 이슈 트래커: https://issues.chromium.org · Gerrit: https://chromium-review.googlesource.com
