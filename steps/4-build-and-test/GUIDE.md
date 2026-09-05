# 4단계 — 빌드 및 테스트

| | |
|---|---|
| **입력** | 수정된 워킹트리 ([3단계](../3-branch-and-fix/GUIDE.md)) |
| **출력** | `Build Succeeded` 로그 + 대상 테스트 통과 로그 |
| **완료 조건** | [`logs/`](logs/)에 빌드·테스트 로그가 남고 실패 0 |
| **원칙** | **빌드도 테스트도 전부 tmux 안에서** (세션 끊겨도 생존, 진행을 직접 봄) |
| **도구** | [`scripts/run.sh`](scripts/run.sh) 빌드+테스트 러너 · [`scripts/mutation_test.sh`](scripts/mutation_test.sh) 변이 테스트 · 로그·완료 마커는 [`logs/`](logs/) |
| **설정** | `config.env`의 `CHROMIUM_SRC` · `CHROMIUM_OUT` · `TEST_FLAGS` ([SETUP.md](../../SETUP.md) 3·4번) |
| **다음 단계** | [5단계 — 커밋 및 업로드](../5-commit-and-upload/GUIDE.md) |
| **현황** | [STATUS.md](STATUS.md) · 예시 [examples/status/4-build-and-test.md](../../examples/status/4-build-and-test.md) |

Chromium 풀빌드는 머신에 따라 수 시간에서 15시간 이상(예시 기록의 4코어 박스)까지 걸린다. **빌드를 최소화하는 것이 이 단계의 전부.**

---

## 빌드 최소화 사다리 — 위에서부터 시도

| 단계 | 명령 | 소요 (4코어 기준) |
|---|---|---|
| ① 문법만 검증 | `autoninja -C $CHROMIUM_OUT obj/.../<파일명>.o` | ~5분 |
| ② 테스트 바이너리 | `autoninja -C $CHROMIUM_OUT <타깃>` | 수십 분 ~ 수 시간 |
| ③ 클린/풀빌드 | (피할 것) | 15시간+ |

```bash
tmux new -s build                                                          # 이미 안이면 생략
$OSSCA/steps/4-build-and-test/scripts/run.sh cbuild components_unittests   # 빌드만 → logs/cbuild_build.log
# 진행 확인: tmux attach -t build (나올 땐 Ctrl+b d) / tail -f $OSSCA/steps/4-build-and-test/logs/cbuild_build.log
# 성공 판정: 로그 끝 "Build Succeeded" — 러너는 logs/cbuild_done.marker 에 OK / BUILD_FAILED 를 남긴다
# 수동으로 하려면: cd $CHROMIUM_SRC && autoninja -C $CHROMIUM_OUT components_unittests 2>&1 | tee <로그>
```

- 브랜치를 기존 빌드 트리와 같은 base에서 따면 증분 빌드로 끝난다 (545843242 예시). base를 점프하면 풀빌드가 난다
  (40681786: 50,579스텝, 16시간) — 업로드 전 리베이스는 그 뒤에 한다 (3단계)

## 테스트 실행

```bash
$OSSCA/steps/4-build-and-test/scripts/run.sh --test-only <이름> <타깃> '<필터>'   # 빌드된 바이너리로 테스트만
# 수동: cd $CHROMIUM_SRC && $CHROMIUM_OUT/<타깃> $TEST_FLAGS --gtest_filter='<필터>'
```

- **헤드리스 리눅스(SSH) 서버에서는 `--ozone-platform=headless`가 필수** — 없으면 `TestWebContents`를 만드는 테스트가
  전부 `DeviceDataManager was not created`로 CRASHED 된다. 코드 문제로 오인하기 쉬우니 실패가 무더기로 나오면
  이 플래그부터 확인. 러너는 `config.env`의 `TEST_FLAGS`를 붙인다
- AI 에이전트의 셸 도구에서 테스트를 직접 돌리면 `Check failed: !IsProcessBackgrounded()`로 전부 죽는 경우가 있다 — tmux 안에서 러너로

## 타깃 ↔ 작업 대응

| 수정 위치 | 테스트 타깃 | 필터 예시 |
|---|---|---|
| `components/payments/**` | `components_unittests` | `*ManifestDownloader*`, `*PaymentManifestParser*` |
| `storage/browser/quota/**` | `storage_unittests` | `*QuotaDatabase*` |
| `services/network/**` | `services_unittests` | — |

다른 디렉토리는 그 폴더 `BUILD.gn`에서 `*_unittest.cc`가 속한 `sources`의 `test(...)` 타깃을 찾는다.

## 빌드 중에 다음 명령 예약 (직렬 대기 절약)

빌드가 이미 tmux에서 돌고 있으면 셸이 입력을 버퍼링했다가 빌드가 끝난 뒤 자동 실행한다:

```bash
L=$OSSCA/steps/4-build-and-test/logs
tmux send-keys -t build "grep -q OK $L/cbuild_done.marker && \
  $OSSCA/steps/4-build-and-test/scripts/run.sh --test-only pmd components_unittests '<필터>'" Enter
```

## 러너 스크립트 (`scripts/` — 이 폴더)

빌드+테스트를 한 번에 돌리고 로그와 완료 마커(`logs/<이름>_done.marker`)를 남긴다.
실제 CL에서 썼던 호출과 로그 이름은 [STATUS 예시](../../examples/status/4-build-and-test.md), 당시의 CL 전용 러너 원본은 [`examples/scripts/`](../../examples/scripts/).

| 스크립트 | 하는 일 (로그는 전부 `logs/`) |
|---|---|
| `run.sh [--sync] [--test-only] <이름> <타깃> [필터]` | (gclient sync →) 빌드 → 테스트. `<이름>_build.log` · `<이름>_test.log` · `<이름>_done.marker` (OK / BUILD_FAILED / TEST_FAILED / SYNC_FAILED) |
| `mutation_test.sh <이름> <타깃> <필터> <변이스크립트> <파일>...` | 변이 테스트 — 대상 파일 백업 → 변이 → 빌드·테스트(**실패해야 정상**) → 원복 → 재확인. 변이 스크립트 예시 [`examples/scripts/mutate_quota_commit.py`](../../examples/scripts/mutate_quota_commit.py) |

```bash
R=$OSSCA/steps/4-build-and-test/scripts
$R/run.sh pmd components_unittests 'PaymentMethodManifestDownloaderTest.*'                          # 빌드+테스트
$R/run.sh --test-only pmd_wide components_unittests '*ManifestDownloader*:*PaymentManifestParser*'  # 필터만 넓혀 재실행
$R/run.sh --sync quota storage_unittests '*Quota*'                                                   # 리베이스 후 sync 포함
$R/mutation_test.sh quota storage_unittests '*LongRunningTransactionIsReopenedAfterCommit*' \
    $OSSCA/examples/scripts/mutate_quota_commit.py storage/browser/quota/quota_database.cc          # 변이 테스트
```

**러너가 지키는 규약** (스크립트를 직접 쓸 때도 따른다):

- 첫 줄에서 `unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT` —
  AI 에이전트 환경변수가 남아 있으면 autoninja가 `--quiet`를 붙여 로그에 점만 찍힌다
- 시작할 때 `rm -f <이름>_done.marker`, 끝나면 마커 생성 → 완료 판정을 파일 하나로
- 로그 위치는 **스크립트 위치 기준** `../logs` — 폴더째 옮겨도 깨지지 않음. **홈(`~`) 최상위에는 파일을 만들지 않는다(폴더만)**
- 경로·플래그는 `config.env`에서 읽는다 (`CHROMIUM_SRC` · `CHROMIUM_OUT` · `TEST_FLAGS`). 없으면 `~/chromium/src` · `out/Default` · 빈 값

## 빌드 설정 메모

- `$CHROMIUM_OUT`(기본 `out/Default`) = release **component** build (`is_debug=false`, `is_component_build=true`, `symbol_level=0`)
- **DCHECK는 켜져 있다** — `dcheck_always_on`이 비-official 크로미움 빌드에서 기본 true
  (`build/config/dcheck_always_on.gni`). 즉 로컬 테스트는 DCHECK 위반도 잡아준다.
  유저에게 나가는 official 빌드에서만 DCHECK가 사라진다
- plain `ninja` 금지, `autoninja` 사용 (siso 백엔드)
