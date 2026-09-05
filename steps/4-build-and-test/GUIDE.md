# 4단계 — 빌드 및 테스트 (4코어 박스)

| | |
|---|---|
| **입력** | 수정된 워킹트리 ([3단계](../3-branch-and-fix/GUIDE.md)) |
| **출력** | `Build Succeeded` 로그 + 대상 테스트 통과 로그 |
| **완료 조건** | [`logs/`](logs/)에 빌드·테스트 로그가 남고 실패 0 |
| **원칙** | **빌드도 테스트도 전부 tmux 안에서** (세션 끊겨도 생존, 진행을 직접 봄) |
| **도구** | [`scripts/`](scripts/) — 빌드+테스트 러너 8개 (아래 표) · 로그·완료 마커는 [`logs/`](logs/) |
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
