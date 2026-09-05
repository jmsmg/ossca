# CLAUDE.md — 이 저장소에서 에이전트가 지킬 것

이 저장소는 OSSCA Chromium 멘토링 프로그램의 **기여 워크플로우 작업 공간**이다. 사람(멘티)이 Chromium 이슈 하나를
8단계(발굴 → OSSCA 등록 → 브랜치·수정 → 빌드·테스트 → 업로드 → 리뷰 → 기여 기록 → 머지 후 마무리)로 진행하고,
에이전트는 조사 · 코드 수정 · 문안 작성 · 기록 갱신을 돕는다. 실제 코드는 `$CHROMIUM_SRC`(Chromium 체크아웃)에 있다.

## 세션을 시작하면

1. `BOARD.md`(전체 보드)와 관련 `steps/*/STATUS.md`를 읽어 지금 어디까지 왔는지 파악한다
2. 진행 중인 이슈가 있으면 `issues/<crbug>.md`(그 이슈의 판단·기록)를 읽는다
3. 어느 단계 작업이든 시작 전에 그 단계의 `steps/<n>-*/GUIDE.md`를 먼저 읽고 그대로 따른다
4. 경로·계정은 `config.env`에서 온다 — `python3 scripts/track.py config`로 확인. 문서의 `$OSSCA`는 이 저장소, `$CHROMIUM_SRC` 등은 config.env 값
5. 전체 흐름·규칙은 `WORKFLOW.md`, 처음 세팅은 `SETUP.md`, 채워진 예시는 `examples/`

## 절대 규칙 (WORKFLOW.md 「단계를 가로지르는 규칙」)

- **원격 공개는 사람이 직접 한다.** `git cl upload`, Gerrit 댓글 Send·답글 게시, `git push`, PR 생성, OSSCA 이슈 등록·댓글, crbug 댓글은
  사용자의 명시적 승인 없이 실행하지 않는다. 에이전트는 문안·드래프트(`steps/2-ossca-issue/drafts/`, 커밋 메시지, 답글 초안)까지만 만든다
- **커밋 메시지에 AI 흔적 금지.** `Co-authored-by`, `Claude`, `Generated` 라인을 넣지 않는다 — Chromium CL도, 이 저장소의 커밋도.
  업로드 전 `git log -1 --format=%B | grep -iE 'co-authored|claude|generated'`가 비어 있어야 한다
- **빌드·테스트는 tmux 안에서 러너로.** `steps/4-build-and-test/scripts/run.sh`(빌드+테스트) · `mutation_test.sh`(변이 테스트).
  에이전트 셸에서 테스트 바이너리를 직접 돌리지 않는다(`IsProcessBackgrounded` 크래시). 로그·마커는 `steps/4-build-and-test/logs/`,
  **홈(`~`) 최상위에 파일을 만들지 않는다**
- **판단이 바뀌면 기록한다.** 리뷰로 뒤집힌 전제·오판은 지우지 말고 `issues/<crbug>.md`에 남긴다 (예: `examples/issues/443042812.md`)
- **이슈 설명을 그대로 믿지 않는다.** 코드를 열어 재진단하고, 착수 전에 호출처를 `git grep`으로 직접 따라간다 (3단계 GUIDE)
- **리뷰 지적은 수용도 반박도 하기 전에 스스로 코드를 읽어 독립 검증한다** (6단계 GUIDE)

## 기록 갱신 — 작업 단위가 끝날 때마다

- `issues/<crbug>.md`: 상단 상태 줄 · 진행 체크리스트 · 바뀐 판단 · 배운 것 (새 이슈는 `issues/TEMPLATE.md` 복사)
- 해당 단계의 `steps/*/STATUS.md`: 표 한 줄 + 「다음 액션」
- `BOARD.md`: 이슈×단계 보드, 머지되면 CL 사이즈 이력 한 줄 (8단계 체크리스트 ⑤)
- `examples/`는 과거 기록이다 — 참고만 하고 수정하지 않는다

## 도구

| 명령 | 용도 |
|---|---|
| `python3 scripts/track.py config` | config.env 확인 |
| `python3 scripts/track.py bug <crbug>` · `ossca <검색어>` · `file <경로>` | 선점 CL · OSSCA 겹침 · 같은 파일의 열린 CL (착수 전 검증) |
| `python3 scripts/track.py cl <CL>` · `comments <CL> [날짜]` · `crbug <crbug>` | CL 상태 · 새 코멘트 · 이슈 트래커 활동 (리뷰 대기 중) |
| `python3 scripts/track.py verify <CL> <PS>` | 업로드 후 서버 패치셋 = 로컬 HEAD 검증 |
| `python3 steps/1-issue-hunting/scripts/hunt.py todos\|deprecated\|expired <디렉토리>` → `triage <번호>...` | 후보 수집 → 일괄 심사 |
| `steps/4-build-and-test/scripts/run.sh [--sync] [--test-only] <이름> <타깃> [필터]` | 빌드+테스트 (tmux 안에서) |

## 커밋 메시지 컨벤션 — 두 저장소가 반대다

- **Chromium CL** (5단계 GUIDE): `[모듈] 현재형 동사 …` 제목, semantic prefix 금지, 제목 뒤 빈 줄, 72자 본문, `Fixed:`(이슈 종결) 또는 `Bug:`(시리즈·부수 항목)
- **contributions repo** (7단계 GUIDE): semantic prefix 사용 — `contributions: Add <CL번호>`, `feat:` / `fix:` / `docs:` 등

## 문서 톤

기록 파일(issues · STATUS · BOARD)은 한국어로 짧게, 사실(날짜 · CL · PS · 커밋 해시 · 테스트 수)을 남긴다. 판단 근거와 반대 근거를 함께 적는다.
