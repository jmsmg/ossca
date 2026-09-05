# 개인 세팅 — 처음 한 번

이 저장소를 내 작업 공간으로 만들기 위해 한 번만 하는 일. 위에서부터 순서대로 하면 끝난다.
개인 값(경로 · 계정 · 멘토)은 전부 `config.env` 한 파일에 모이고, 그 파일은 커밋되지 않는다.

## 0. 전제 조건

| 준비물 | 확인 |
|---|---|
| Chromium 체크아웃 + 빌드 디렉토리 | `ls <src>/out/Default/args.gn` — 없으면 [Chromium 빌드 가이드](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md) |
| `depot_tools` (`autoninja`, `git cl`, `gclient`) | `which autoninja gclient && git cl --help` |
| OSSCA contributions 저장소 fork + 로컬 클론 | `git -C <clone> remote -v` 에 origin(내 fork) · upstream(OSSCA-chromium) 둘 다 |
| `tmux` | `which tmux` — 빌드·테스트는 전부 tmux 안에서 돌린다 (4단계) |
| Python 3 (표준 라이브러리만 사용) | `python3 --version` |

## 1. 계정 — 업스트림 CONTRIBUTING 규칙 (1회성)

`$CONTRIBUTIONS_DIR/CONTRIBUTING.md` 원문이 기준. 요약:

- [ ] Google CLA 동의: https://cla.developers.google.com/about/google-individual
- [ ] chromium-review(Gerrit) 가입. **모든 건 실명(영문)으로**
- [ ] Chromium 체크아웃의 git 계정을 **Gerrit 가입 이메일과 동일**하게:
  ```bash
  cd <CHROMIUM_SRC>
  git config user.name  "Your Name"
  git config user.email "you@example.com"     # Gerrit 가입 이메일
  ```
- [ ] Gerrit 인증: `git cl creds-check` (gitcookies 인증 경고가 뜨면 이걸로 전환)
- [ ] 첫 CL을 올릴 때 `src/AUTHORS`에 이름·이메일 추가 (알파벳순, 위 이메일과 동일) — 5단계 GUIDE
- [ ] 멘토 이메일 확인 (CONTRIBUTING.md) → 아래 3번 `config.env`의 `MENTOR_EMAIL`
- tryjob(CQ Dry Run) 권한은 기본적으로 없다 → CQ는 리뷰어/멘토에게 부탁 (5·6단계). 머지 CL이 몇 개 쌓이면 신청: https://www.chromium.org/getting-involved/become-a-committer/

## 2. 저장소 위치 — `$OSSCA`

문서의 명령은 이 저장소를 `$OSSCA`로 부른다. 셸 설정(`~/.zshrc` 또는 `~/.bashrc`)에 추가:

```bash
export OSSCA=~/ossca                 # 클론한 위치
source "$OSSCA/config.env"           # 아래 3번에서 만든다 — $CHROMIUM_SRC 등을 셸에서도 쓰기 위함
```

## 3. `config.env` — 경로 · 계정

```bash
cd $OSSCA
cp config.env.example config.env
$EDITOR config.env
```

| 키 | 뜻 | 예 |
|---|---|---|
| `CHROMIUM_SRC` | Chromium 체크아웃의 `src` | `$HOME/chromium/src` |
| `CHROMIUM_OUT` | 빌드 출력 디렉토리 (`src` 기준 상대 경로) | `out/Default` |
| `CONTRIBUTIONS_DIR` | contributions 저장소 로컬 클론 | `$HOME/contributions` |
| `GITHUB_USER` | GitHub 계정 (fork 소유자) | `octocat` |
| `OSSCA_REPO` | 기여 기록 upstream 저장소 | `OSSCA-chromium/contributions` |
| `MENTOR_EMAIL` | 멘토 이메일 (CONTRIBUTING.md에서 확인) | — |
| `TEST_FLAGS` | 테스트 바이너리 공통 플래그 | `--ozone-platform=headless` (헤드리스 서버 필수, 데스크톱은 빈 값 가능) |

읽는 곳: `scripts/track.py` · `steps/1-issue-hunting/scripts/hunt.py` (Python — 루트의 `config.env`를 직접 파싱) · `steps/4-build-and-test/scripts/*.sh` (source).
**파일이 진실이다** — `config.env` 값이 셸 환경변수보다 우선하고, 파일에 없는 키만 환경변수/기본값을 쓴다. 2번의 `source`는 문서의 명령을 복사해 쓰기 위한 편의일 뿐이니, `config.env`를 고쳤으면 셸도 다시 `source` 한다.

확인:

```bash
python3 $OSSCA/scripts/track.py config          # 읽힌 값 + 디렉토리 존재 여부
python3 $OSSCA/scripts/track.py bug 545645933   # Gerrit 조회가 되는지 (머지된 CL 8336867 이 나와야 함)
```

## 4. 빌드 환경 메모 — 내 머신에 맞게 판단할 것

- **빌드 설정**: release component build (`is_debug=false`, `is_component_build=true`, `symbol_level=0`)를 기준으로 쓴다.
  비-official 빌드는 `dcheck_always_on`이 기본 true라 **DCHECK가 켜져 있다** (`build/config/dcheck_always_on.gni`) — 로컬 테스트가 DCHECK 위반도 잡아준다
- **빌드 시간**은 머신에 따라 극단적으로 다르다 (예시 기록의 머신은 4코어, 풀빌드 15시간+). 4단계 GUIDE의 «빌드 최소화 사다리»가 이 문제를 다룬다
- **헤드리스 리눅스(SSH) 서버**: `--ozone-platform=headless` 없이는 `TestWebContents`를 만드는 테스트가 전부 `DeviceDataManager was not created`로 CRASHED → `TEST_FLAGS`에 넣어둔다
- **AI 에이전트의 셸 도구에서 테스트를 직접 돌리면** `Check failed: !IsProcessBackgrounded()`로 크래시하는 경우가 있다 → tmux 안에서 러너로 돌린다
- **autoninja 로그에 점만 찍히면** 에이전트 환경변수(`CLAUDECODE` 등) 때문이다 → 러너 첫 줄에서 `unset` 한다 (이미 들어 있음)
- plain `ninja` 금지, `autoninja` 사용 (siso 백엔드)

## 5. 내 상태 파일 시작하기

| 파일 | 하는 일 |
|---|---|
| `BOARD.md` | 날짜를 채우고 첫 이슈를 한 줄 추가 |
| `steps/*/STATUS.md` | 각 단계에 걸린 이슈를 표에 추가 (처음엔 비어 있어도 됨) |
| `issues/<crbug>.md` | `issues/TEMPLATE.md` 복사 — 1단계에서 이슈를 잡는 순간 만든다 |
| `steps/2-ossca-issue/drafts/<crbug>.md` | `drafts/TEMPLATE.md` 복사 — 2단계 이슈 본문 문안 |

채워진 모습은 [`examples/`](examples/README.md).

## 6. AI 에이전트를 쓴다면

Claude Code를 `$OSSCA`에서 열면 루트의 [`CLAUDE.md`](CLAUDE.md)가 자동으로 읽힌다 (다른 도구는 `AGENTS.md`, 같은 파일).
규칙 설명을 따로 붙일 필요 없이 지금 할 일만 말한다 — 첫 세션이면:

```
config.env 채웠어. track.py config로 확인하고 1단계 이슈 발굴부터 시작하자
```

에이전트가 원격 공개(`git cl upload`, 댓글, push, PR, 이슈 등록)를 하려 들면 거절하고 직접 한다. 상황별 한 줄은 [README](README.md#ai-코딩-에이전트와-함께-쓸-때).

## 7. 이 저장소를 다시 공유하려면

- `config.env`는 `.gitignore`에 있어 안 올라간다. `BOARD.md` · `steps/*/STATUS.md` · `issues/` · `drafts/`는 **내 기록이 담기는 파일**이니 공유 전에 비우거나 `examples/`처럼 분리한다
- 개인 식별자 점검 (이름 · 이메일 · 홈 경로 · GitHub 아이디):
  ```bash
  grep -rniE '<이름>|<이메일>|/home/<계정>|<github id>' --include='*.md' --include='*.py' --include='*.sh' .
  ```
- git 히스토리에도 남는다 — 이미 커밋된 개인 기록이 있으면 새 히스토리로 공개하는 편이 안전하다
