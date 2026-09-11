# 4단계 — 빌드 및 테스트 (4코어 박스)

| | |
|---|---|
| **입력** | 수정된 워킹트리 ([3단계](../3-branch-and-fix/GUIDE.md)) |
| **출력** | `Build Succeeded` 로그 + 대상 테스트 통과 로그 |
| **완료 조건** | [`logs/`](logs/)에 빌드·테스트 로그가 남고 실패 0 |
| **원칙** | **빌드도 테스트도 전부 tmux 안에서** (세션 끊겨도 생존, 진행을 직접 봄) |
| **도구** | [`scripts/`](scripts/) — 빌드+테스트 러너 8개 (아래 표) · 로그·완료 마커는 [`logs/`](logs/) |
| **러너 추가(09-05)** | `scripts/pmd_sync_test.sh` — 리베이스 후용: gclient sync → components_unittests → ManifestDownloader 테스트 (마커 `pmds_done.marker`) |
| **다음 단계** | [5단계 — 커밋 및 업로드](../5-commit-and-upload/GUIDE.md) |
| **현황** | [STATUS.md](STATUS.md) |

풀빌드 15시간+ 짜리 박스다. **빌드를 최소화하는 것이 이 단계의 전부.**

---

## 빌드 최소화 사다리 — 위에서부터 시도

| 단계 | 명령 | 소요 |
|---|---|---|
| ① 문법만 검증 | `autoninja -C out/Default obj/.../<파일명>.o` | ~5분 |
| ② 테스트 바이너리 | `autoninja -C out/Default <타깃>` | 수십 분 ~ 수 시간 |
| ③ 클린/풀빌드 | (피할 것) | 15시간+ |

```bash
L=~/ossca/steps/4-build-and-test/logs    # 로그·마커 위치 (러너들은 자기 위치 기준 ../logs 로 자동 계산)
cd ~/chromium/src
tmux new -s build                      # 이미 안이면 생략
autoninja -C out/Default components_unittests 2>&1 | tee $L/cbuild.log
# 진행 확인: tmux attach -t build (나올 땐 Ctrl+b d) / tail -f $L/cbuild.log
# 성공 판정: 로그 끝 "Build Succeeded"
```

## 테스트 실행 — ozone 플래그 필수

```bash
out/Default/<타깃> --ozone-platform=headless --gtest_filter='<필터>'
```

**헤드리스 SSH 서버라 `--ozone-platform=headless`가 없으면** `TestWebContents`를 만드는 테스트가
전부 `DeviceDataManager was not created`로 CRASHED 된다. 코드 문제로 오인하기 쉬우니 실패가
무더기로 나오면 이 플래그부터 확인.

## 타깃 ↔ 작업 대응

| 수정 위치 | 테스트 타깃 | 필터 예시 |
|---|---|---|
| `components/payments/**` | `components_unittests` | `*ManifestDownloader*`, `*PaymentManifestParser*` |
| `storage/browser/quota/**` | `storage_unittests` | `*QuotaDatabase*` |
| `services/network/**` | `services_unittests` | — |

## 빌드 중에 다음 명령 예약 (직렬 대기 절약)

빌드가 이미 tmux에서 돌고 있으면 셸이 입력을 버퍼링했다가 빌드가 끝난 뒤 자동 실행한다:

```bash
tmux send-keys -t build 'grep -q "Build Succeeded" $L/build.log && \
  out/Default/<타깃> --ozone-platform=headless --gtest_filter="<필터>" 2>&1 \
  | tee $L/test.log | tail -4' Enter
```

## 러너 스크립트 (`scripts/` — 이 폴더)

빌드+테스트를 한 번에 돌리고 로그와 완료 마커(`*_done.marker`)를 남기는 스크립트들.
새 작업은 가장 가까운 것을 복사해 쓴다.

| 스크립트 | 하는 일 (로그는 전부 `logs/`) |
|---|---|
| `cbuild_runner.sh` | `components_unittests` 빌드 → `cbuild.log` |
| `qbuild_runner.sh` / `qsync_build.sh` | quota 계열 빌드 (`gclient sync` 포함판 포함) |
| `run_quota.sh` | `storage_unittests` 빌드 + `*QuotaDatabase*` 실행 |
| `pmd_test.sh` / `pmd_wide.sh` | manifest downloader 빌드 / 넓은 필터 재실행 |
| `pmp_test.sh` | manifest parser 빌드 + 실행 |
| `mutation_test.sh` | 변이 테스트 — 대상 파일 백업 → 코드 제거 → 테스트 실패 확인 → 복원 |

**러너를 새로 쓸 때의 규약:**

- 첫 줄에서 `unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT` —
  AI 에이전트 환경변수가 남아 있으면 autoninja가 `--quiet`를 붙여 로그에 점만 찍힌다
- 시작할 때 `rm -f <이름>_done.marker`, 끝나면 마커 생성 → 완료 판정을 파일 하나로
- 로그 위치는 `L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"` 한 줄로 **스크립트 위치 기준** 잡는다 —
  폴더째 옮겨도 깨지지 않음. 러너는 이 폴더의 `scripts/`, 로그·마커는 `logs/`. **홈(`~`) 최상위에는 파일을 만들지 않는다(폴더만)**

## 빌드 설정 메모

- `out/Default` = release **component** build (`is_debug=false`, `is_component_build=true`, `symbol_level=0`)
- **DCHECK는 켜져 있다** — `dcheck_always_on`이 비-official 크로미움 빌드에서 기본 true
  (`build/config/dcheck_always_on.gni:25`). 즉 로컬 테스트는 DCHECK 위반도 잡아준다.
  유저에게 나가는 official 빌드에서만 DCHECK가 사라진다
- plain `ninja` 금지, `autoninja` 사용 (siso 백엔드)

## 빌드 중간에 다른 브랜치로 잠깐 나갔다 오기

**같은 base를 공유하는 브랜치끼리는 증분 상태가 보존된다.** 2026-09-09에 실측했다.

상황: `pmd3` 빌드가 10시간 41분 돌아 55,388스텝 중 35,847까지 갔는데,
다른 브랜치(40176243 CL 1)의 업로드가 그 워킹트리에 막혀 있었다.

```bash
# 1) 두 브랜치가 같은 base인지, 어떤 파일이 다른지 먼저 확인
git log -1 --format=%h $(git merge-base origin/main <A>)   # 둘이 같아야 한다
git diff --name-only <A> <B>                                # 무거운 디렉토리가 없어야 한다
# 2) siso에 인터럽트 (죽이지 말고 C-c)
tmux send-keys -t <세션> C-c        # pgrep -c siso 가 0이 될 때까지 확인
tmux kill-session -t <세션>
# 3) 브랜치 전환 → 업로드(컴파일 안 함) → 복귀 → 러너 재시작
```

**결과**: 재개 시 siso가 처음엔 `[0/71854]`를 표시하지만 이는 가지치기 전 그래프 크기이고,
1분 안에 **`[n/19542]`** 로 정착했다 — 55,388 − 35,847 = 19,541, 즉 **한 스텝도 잃지 않았다.**

**조건**: 두 브랜치의 diff에 `content/browser`·`base/` 같은 대형·광범위 디렉토리가 없어야 한다.
이번엔 11개 파일(payments 5 · history 3 · WPT baseline · histograms.xml)뿐이었다.
반대로 base가 다른 브랜치로 나갔다 오면 전 트리가 무효화된다 (08-26 base ↔ ToT를 오가며 55,388스텝을 만든 것이 그 예).

**로그**: 재시작하면 러너가 로그를 덮어쓰므로 이전 로그를 `*_part1.log`로 옮겨두고 시작한다.

## 테스트가 깨졌을 때 — 대조군은 «같은 필터»로

2026-09-10에 값비싸게 배웠다. quota M148 정리(153곳) 후 `storage_unittests`에서 크래시가 났고,
`origin/main`과 비교해 «우리가 깨뜨렸다»고 결론 냈다. **틀렸다.**

- 실패한 실행: 러너 필터 `'Quota*:*Quota*:UsageTracker*:...'` → **321개** 테스트
- 대조군으로 돌린 것: `'...ReportedQuotaConfigurability/*'` → **8개**

**필터가 달랐다.** 8개짜리로는 main이 통과하니 "우리 탓"으로 보였지만,
**같은 321개 필터로 main을 돌리자 똑같이 크래시**했다 — 사전 실패였다.
그 사이 이분 탐색을 5회(파일 단위 2회 + 파일 내 3회) 돌렸고 결론도 서로 모순됐다
(«9까지 통과, 10 추가하면 실패»인데 «10만 적용하면 통과»).

**규칙**

1. 실패를 보면 **가장 먼저** `git checkout <base> -- <디렉토리>` 후 **똑같은 명령**으로 재현한다.
   필터·플래그·병렬도를 한 글자도 바꾸지 않는다
2. 결과가 같으면 **사전 실패**다. 내 변경과 무관하니 러너 필터에서 제외하고 그 사실을 기록한다
3. 이분 탐색은 **재현이 결정적임을 확인한 뒤**에 시작한다. 결과가 서로 모순되면
   재현 조건이 흔들리고 있다는 신호이니 탐색을 멈추고 조건부터 고정한다

**이번 사전 실패**: `QuotaConfigs/QuotaManagerImplParamTest.ReportedQuotaConfigurability/*`
(`quota_manager_unittest.cc:3331`) — 이 환경의 `origin/main`(b24e51fe)에서 SIGSEGV.
러너 필터에 `-QuotaConfigs/QuotaManagerImplParamTest.ReportedQuotaConfigurability/*`로 제외해 두었다.

## 리베이스도 검증한다 — CQ 권한이 없으면 로컬이 유일한 검증

2026-09-10. 8349386이 머지 컨플릭트가 나서 ToT로 리베이스했다. 수동 해결은
`features.{h,cc}`에 업스트림 플래그와 우리 플래그를 나란히 두는 **순수 추가**뿐이었고,
`native_error_strings`는 자동 병합에 중복 정의도 없었다.

그래서 "CQ가 봇에서 컴파일할 테니 바로 올리자"고 판단했는데 **틀렸다.**

> **트라이잡 권한이 없으면 CQ를 우리가 못 돌린다.** 리뷰어에게 부탁해야 하고,
> 거기서 컴파일이 깨지면 **그 사람 시간을 버리고 CL 신뢰도가 떨어진다.**
> 즉 «CQ가 잡아줄 것»은 권한이 있는 사람에게만 성립하는 논리다.

**규칙**: 리베이스 후에도 base가 크게 움직였으면(아래 지표 중 하나라도) 로컬 풀 검증을 한다.

```bash
git rev-list --count <이전base>..origin/main          # 커밋 수
git diff --stat <이전base> origin/main -- DEPS        # DEPS 변경 → gclient sync 필요
git diff --name-only <이전base> origin/main -- base/ | wc -l   # base/ 변경 → 전 트리 재빌드
```

이번 수치: 2,271 커밋 · DEPS 219줄 · `base/` 61파일 → sync + 전 트리 재빌드.
러너 `scripts/pmd4_sync_test.sh`(tmux `pmd4`).

**반대로 검증을 건너뛸 수 있는 경우**: 같은 base 위에서 파일 몇 개만 다른 브랜치를 오갈 때
(그때는 증분 빌드로 끝난다 — 위 «빌드 중간에 다른 브랜치로 잠깐 나갔다 오기» 참고).

