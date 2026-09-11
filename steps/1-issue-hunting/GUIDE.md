# 1단계 — 이슈 발굴

| | |
|---|---|
| **입력** | 없음 (사이클의 시작) |
| **출력** | crbug 번호 하나 + 착수 근거(선점 없음·겹침 없음·리뷰어 생존) |
| **완료 조건** | 아래 «착수 전 검증 파이프라인» 4개 항목 전부 통과 |
| **도구** | [`scripts/hunt.py`](scripts/hunt.py) (후보 수집·일괄 심사, 이 폴더) · [`../../scripts/track.py`](../../scripts/track.py) (선점·겹침 조회, 공용) |
| **다음 단계** | [2단계 — OSSCA 이슈 등록](../2-ossca-issue/GUIDE.md) |
| **현황** | [STATUS.md](STATUS.md) |

경로 다섯 개 + 공통 검증 + 판정 기준 + 함정.
지금까지의 이슈가 전부 이 다섯 경로 중 하나에서 나왔다 (맨 아래 사례 매핑 참고).

---

## 경로 1: 트래커 하향 검색 (이슈 → 코드)

https://issues.chromium.org 에서 쿼리로 거르고, 후보를 코드로 확인하는 기본 방식.

```
status:open componentid:1456412                  # Blink>Payments
status:open hotlistid:5483263                    # GoodFirstBug
status:open componentid:<NNN> modified<2026-01-01  # 오래 방치된 것부터
```

- **componentid 알아내는 법**: UI에서 컴포넌트 필터를 걸면 URL에 번호가 나타남
- 정렬은 modified 오름차순으로 → 방치된 것부터 보임
- 이슈 상세 페이지에서 볼 것:
  - 생성/수정 날짜, assignee 유무, 코멘트 톤(팀이 "patches welcome"이라 했는지)
  - **Blocking/Blocked-on 관계** — 지금 이슈가 뭘 막고 있으면 가치 근거가 되고,
    체인을 따라가면 더 굵직한 관련 작업이 보임 (40831207 → 40830473 체인처럼)
  - 크래시 리포트 첨부 여부 (실제 유저 영향 = CL 설명의 힘)
  - 트래커의 링크 섹션보다 Gerrit `bug:` 검색이 연결 CL 확인엔 더 정확함
- 장점: 후보가 많다. 단점: 경쟁 있음, 설명만으론 난이도를 못 잼 → 결국 코드를 열어봐야 함
- **스크립트**: 검색 자체는 UI에서 (결과 페이지가 로그인 XHR라 스크립트 추출 불가).
  번호만 모으면 → `python3 ~/ossca/steps/1-issue-hunting/scripts/hunt.py triage <번호>...` 로 선점CL/OSSCA겹침/마지막활동 일괄 심사

## 경로 2: 코드 상향 검색 (코드 → 이슈) — 백엔드 로직엔 최고

팀이 **이미 하겠다고 코드에 박아둔 일**을 찾는다. 클레임 불필요, "왜 하냐" 반박 원천 차단.

```bash
cd ~/chromium/src

# ① 번호 붙은 TODO — 이슈가 살아있는지 역추적
grep -rn "TODO(crbug.com/" sql/ storage/browser/ --include='*.h' --include='*.cc' | head -50

# ② deprecated 주석 — "deprecated and will be removed" 류
grep -rn -i "deprecated" --include='*.h' sql/ | grep -i "remove"

# ③ 만료된 milestone 인자 — chrome/VERSION의 MAJOR(현재 154)보다 작으면 이미 만료
grep -rn "NotFatalUntil::M1" --include='*.cc' --include='*.h' <디렉토리>
#   → M154 미만은 이미 fatal. "마이그레이션 끝났는데 정리 안 된 것"이 곧 이슈

# ④ 호출처 수 = 사이즈 추정
grep -rn "BeginTransactionDeprecated" --include='*.cc' | wc -l
```

**스크립트로 한 방에**: `python3 ~/ossca/steps/1-issue-hunting/scripts/hunt.py todos|deprecated|expired <디렉토리>...`
→ 나온 crbug 번호들을 `hunt.py triage <번호>...` 에 넣으면 1차 심사까지 끝

- TODO에서 crbug 번호를 얻으면 → 이슈가 열려 있는지, 다른 사람이 잡았는지 확인 후 직행
- 닫힌 버그를 가리키는 TODO(= stale TODO 삭제)는 XS로 가능하긴 하나 가치가 낮아 리뷰어 반응이 미지근할 수 있음 — 우선순위 낮게
- 40831207이 이 경로: sql/database.h의 deprecated 주석 → crbug 역추적 → 호출처 3곳 → CL 시리즈

## 경로 3: 표준 대조 (스펙 조항 vs 구현)

RFC/W3C 스펙의 MUST 조항을 구현과 대조. 파서·프로토콜 코드가 노다지.

- 잘 나오는 유형: **대소문자 처리**(case-insensitive 규정 vs 리터럴 비교), 공백/구분자 처리,
  개수 제한("exactly one"), 기본값 처리
- 방법: 대상 파일이 구현하는 스펙을 주석에서 찾고(RFC 번호가 보통 적혀 있음) →
  스펙 해당 절을 열고 → MUST/case-insensitive 문구마다 구현이 지키는지 체크
- 545645933이 이 경로: RFC 8288 §2.1 "case-insensitive" vs 소문자 리터럴 비교.
  근처의 공용 파서(link_header_util)가 이름만 정규화하고 값은 안 하는 것까지 원인으로 특정
- 이런 이슈는 **명세 인용 한 줄이 곧 정당성**이라 리뷰가 깔끔함. 쌍둥이 이슈가 붙어 나오는
  경우가 많으니(545843242) 범위는 CL 하나 = 조항 하나로 좁게 유지

## 경로 4: OSSCA 큐레이션

멘토·운영진이 모아둔 이슈 묶음. 검증은 돼 있지만 멘티 선착순 경쟁.

- 예: #282(crypto/hash 마이그레이션 → 8264232), #102(StrongAlias)
- 반드시 해당 모음 이슈의 규칙(파일 분배, 커밋 컨벤션)을 먼저 읽을 것

## 경로 5: 작업 파생 (하다가 발견)

이미 확보한 도메인 지식을 재활용 — 가성비 최고.

- 리뷰/감사/테스트 중 발견한 부산물은 그 자리에서 고치지 말고(스코프 오염)
  **기록해뒀다가 별도 이슈/CL로** (g_clock_for_testing 누수가 그 예)
- 쌍둥이·인접 이슈(545843242), 시리즈 후속(CL B favicon, CL C sql 삭제)도 여기 포함

---

## 공통: 착수 전 검증 파이프라인

**전부 `~/ossca/scripts/track.py` 원커맨드로 가능** (아래 raw 명령은 참고용):

```bash
python3 ~/ossca/scripts/track.py bug <번호>       # ① 선점 CL
python3 ~/ossca/scripts/track.py ossca <검색어>   # ② OSSCA 겹침
python3 ~/ossca/scripts/track.py file <경로>      # ③ 같은 파일 열린 CL
python3 ~/ossca/scripts/track.py crbug <번호>     # 이슈 상태(NEW/FIXED…)·P·유형·제목 + 마지막 활동(답변 왔는지)
python3 ~/ossca/scripts/track.py cl <CL번호>      # CL 상태 요약 (PS/표/attention/미해결)
python3 ~/ossca/scripts/track.py comments <CL> [날짜]  # 새 코멘트
python3 ~/ossca/scripts/track.py verify <CL> <PS> # 서버=로컬 검증 (해당 브랜치 체크아웃 상태에서)
```

```bash
# ① 선점 CL (Gerrit)
curl -s 'https://chromium-review.googlesource.com/changes/?q=bug:<번호>' | tail -c +6

# ② OSSCA 겹침 (검색 API가 살아있는지 아는 번호로 먼저 검증)
curl -s 'https://api.github.com/search/issues?q=repo:OSSCA-chromium/contributions+<번호>'
#    + 키워드 변형 몇 개 (제목이 crbug 번호 없이 등록됐을 수 있음)

# ③ 같은 파일을 건드리는 열린 CL — 다른 버그라도 리베이스 충돌 예보
curl -s 'https://chromium-review.googlesource.com/changes/?q=file:<경로>+status:open' | tail -c +6

# ④ 리뷰어 생존 확인 — OWNERS ∩ 최근 활동자
cat <디렉토리>/OWNERS
git log --format='%ad %an <%ae>' --date=short -8 -- <파일>
```

## 판정 기준 — 좋은 이슈의 조건

1. **테스트로 증명 가능한가** — TDD가 되는 이슈(수정 전 실패를 보여줄 수 있는 것)가
   리뷰 통과가 빠르다. "재현 불가 + 테스트 불가" 조합은 피할 것
2. **정당성이 한 줄로 서는가** — 스펙 조항 / 코드의 TODO / 크래시 리포트 / blocking 체인
3. **리뷰어가 살아있는가** — 그 파일에 올해 커밋한 OWNERS가 있는가
4. **사이즈가 전략에 맞는가** — Gerrit 뱃지 기준 XS<10 · S 10–49 · M 50–249.
   호출처 수를 세면 대략 나옴. 지금 단계는 S~M로 로직 깊은 곳
5. 휴면 판정: 미할당 + 연결 CL 없음 + 수개월 무활동 → 클레임 없이 직행.
   팀이 활발히 보는 이슈면 의사 타진 댓글 먼저 (무응답 ~2주면 직행 가능, CL 설명에 명시)

## 함정 — 피할 것

- **타인이 이행 중인 영역**: 플래그를 걸어두고 옮기는 중이면 건드리지 않기
  (web_database의 `use_scoped_transaction_` 사례)
- **대형 열린 CL이 같은 파일을 갈아엎는 중**: 착수 전 ③에서 발견되면 충돌 각오하거나 회피
  (8280660이 unittest를 +311/−148 하는 걸 업로드 전에 확인한 사례)
- **버그 번호 없는 순수 리팩토링**: 팀 승인 근거가 없으면 리뷰에서 방향 자체가 반박됨
- **`git cl split` 대량 치환 CL의 결과물에 over-index 하지 말 것**: 기계 치환은 라인별 의도가
  아님 (Evan이 8281077에 대해 준 교훈)
- **이슈 설명을 그대로 믿지 말 것**: 코드를 열어 재진단부터. 443042812는 이슈의 크래시
  스택 해석이 실제 호출 구조와 달랐고, 리뷰에서 방향이 뒤집혔다

## 사례 매핑

| 이슈/CL | 경로 |
|---|---|
| 8146619 (docs 링크) | 1. 트래커 하향 |
| 8264232 (crypto/hash include) | 4. OSSCA 큐레이션 (#282) |
| 443042812 / 8278112 (SPC) | 1. 트래커 하향 (크래시 리포트 첨부 휴면 이슈) |
| 545645933 / 8336867 (rel 대소문자) | 3. 표준 대조 (RFC 8288 §2.1) |
| 40831207 / 8282239 시리즈 (sql 트랜잭션) | 2. 코드 상향 (deprecated 주석 역추적) |
| 41396598 (CurrencyFormatter) | 1. 트래커 하향 (M 사이즈 탐색) |
| g_clock 누수, 545843242 | 5. 작업 파생 |

## ✗ 시도했다가 보류한 경로 — 비활성 테스트 되살리기 (2026-09-09)

**아이디어**: `DISABLED_` 테스트 중 **비활성화 사유였던 버그가 이미 닫힌 것**을 찾으면
"사유가 사라졌으니 되살린다"는 명확한 근거가 생긴다. 신호가 기계적으로 검증 가능하다는 점이 매력.

**스캔 결과** (`components/` `storage/` `sql/` `net/` 의 `*unittest*.cc`):
`DISABLED_` **298곳**, 그중 **버그가 링크된 것 76개**. 상위: 40939899(8건) · 725685(6) · 524801761(6) · 672917(5) · 79365(4).

**그런데 두 가지가 막는다.**

1. **거의 전부 플랫폼 조건부다.** 표본을 열어보면 이런 모양이다:
   ```cpp
   // Crashing on Windows, see http://crbug.com/79365
   #if BUILDFLAG(IS_WIN)
   #define MAYBE_TestEnsureHtmlExtension DISABLED_TestEnsureHtmlExtension
   ```
   되살리려면 **그 플랫폼에서 통과하는지 확인**해야 하는데 로컬은 Linux뿐이다.
   상태 조회에 성공한 닫힌 버그 두 개도 40939899(VERIFIED, mac 8건)·40221266(OBSOLETE, fuchsia 2건)로 전부 타 플랫폼이었다.
2. **레거시 버그 번호는 상태를 못 읽는다.** Monorail 시절 번호(79365·396392·672917·725685·856145 등)는
   익명 페이지에 jspb 메타가 안 실려 `track.py crbug`가 "타임스탬프 추출 실패"를 낸다.
   **가장 오래돼서 가장 유망한 후보들이 정확히 이 부류**라 자동 선별이 안 된다.

**판정: 보류.** 다만 **트라이잡 권한이 생기면 다시 볼 가치가 있다** — CQ가 플랫폼 검증을 대신해주면
1번 장벽이 사라지고, 76개 중 사유가 닫힌 것을 골라내는 작업만 남는다.
(트라이잡 추천은 2026-09-07 요청, 회신 대기 중 — WORKFLOW 계정 메모)

**재현 스크립트** (버그 링크 추출):
```bash
git grep -n -B4 "DISABLED_" -- ':(glob)components/**/*unittest*.cc' | \
  awk '/crbug/{b=$0} /DISABLED_/{if(b) print b" => "$0; b=""}'
```

## 새 발굴 경로 — 만료된 «Remove in M<n>» 주석 (2026-09-09 추가)

`NotFatalUntil`과 같은 원리인데 **자유 형식 주석**이라 도구가 안 잡아준다.
"이 코드를 M<n>에 지워라"라고 적어두고 그 마일스톤이 지난 자리를 찾는다.

```bash
cd ~/chromium/src
git grep -nEi "(remove|delete|clean ?up|drop)[^.]{0,40}\bin M1[0-4][0-9]\b" -- '*.cc' '*.h' '*.mm' \
  | grep -viE "not_fatal|NotFatalUntil"
```

**히트의 대부분은 «과거에 지웠다»는 기록**(`// Removed FOO in M107`)이라 작업 대상이 아니다.
**«이것을 M<n>에 지워라»** 형태만 고른다. 상한(`M1[0-4][0-9]`)은 현재 MAJOR에 맞춰 조정한다.

### 이 경로로 나온 후보 (2026-09-09)

| 후보 | 위치 | 크기 | 판정 |
|---|---|---|---|
| **★ extensions 프로필 마이그레이션 2개 제거** | `extensions/browser/extension_prefs.h:777` `BackfillAndMigrateInstallTimePrefs()` — "Remove this in **M113**"(42 경과) · 바로 아래 `MigrateDeprecatedDisableReasons()` — "Remove this around **M89**"(66 경과) | S — 함수 2 + 호출 2(`extension_prefs.cc:2216,2218`, 무조건 호출) + 테스트 2 | **유력.** `extensions/` OWNERS 한 그룹. 판단 포인트: "M89 이후 한 번도 안 켠 프로필의 마이그레이션을 포기해도 되는가" — 주석 자체가 지시하고 있고 5년 이상 지남 |
| component_updater 만료 항목 정리 | `chrome/browser/component_updater/registration.cc` `DeleteOldComponents()` — M146+ ×3 · M147+ · M148+ · M153+ (**6개 만료**, M156·M158은 아직) | XS (~8줄) | 안전하지만 **가치가 작다.** 이력을 보면 항목 삭제는 그 컴포넌트를 없앤 팀이 해왔고 만료 기준 일괄 정리는 아무도 안 했다. 리뷰어가 "놔둬도 무해"라 할 수 있음 |
| `kSandboxExternalProtocolBlocked`(+`Warning`) 플래그 제거 | `chrome/browser/browser_features.cc:155,157` — "Enabled in M103. Flag to be removed in **M106**" (**49 경과**) | 12곳 / 6파일 | ⚠️ **enterprise policy와 얽혀 있다** (`configuration_policy_handler_list_factory.cc` 2곳, `pref_names.h`). 정책 제거는 별도 절차(deprecation 기간·policy_templates)가 필요해 겉보기보다 위험. 49 마일스톤이나 남아 있는 이유가 아마 이것 |
| omnibox 킬 스위치 (M145) | `omnibox_popup_view_views.cc:54` | XS | `BUILDFLAG(IS_WIN)` 안이라 **Linux에서 빌드 불가** |
| `page_node_impl.cc` visible_url (40121561) | — | — | ✗ **선점 CL 7건** |

**교훈**: 만료 표식은 형식이 통일돼 있지 않다. `NotFatalUntil`(enum), `expires_after`(histograms.xml),
자유 주석(`Remove in M<n>`)이 각각 다른 방식으로 "기한이 지났다"를 말한다. 도구가 없는 쪽이 경쟁도 적다.

### 착수하며 배운 것 — 선언부 TODO는 «찾는 근거»일 뿐이다 (2026-09-10)

위 표에서 ★ 후보를 **함수 2개**로 적어뒀는데, 실제로 착수해 ToT에서 본문을 읽으니 **1개만 제거 가능**했다.

```cpp
// 선언부 — 만료돼 보인다
// TODO(archanasimha): Remove this around M89.
void MigrateDeprecatedDisableReasons();

// 정의부 — 그 뒤에 «만료되지 않은» 코드가 들어와 있다
#if BUILDFLAG(IS_CHROMEOS)
  // TODO(crbug.com/380780352): Delete this after the stepping stone and then
  // remove DEPRECATED_DISABLE_NOT_ASH_KEEPLISTED from the disable_reason enum.
```

`git grep`은 선언부 주석만 보여주고 멈춘다. 그 함수가 **원래 목적 말고 다른 일을 더 하게 됐는지**는
정의부를 처음부터 끝까지 읽어야 나온다. 오래된 마이그레이션 함수는 «만료된 정리 코드를 넣어두는 자리»로
재활용되기 쉬워서 특히 그렇다.

**규칙**: 만료 주석 스윕에서 후보가 잡히면, 지우기 전에 **정의부 전체 + 그 함수의 모든 `#if` 분기**를 읽는다.
`awk '/^void Class::Func\(\)/,/^}/' file.cc` 한 줄이면 된다.

이걸 놓쳤으면 살아 있는 ChromeOS 정리 코드를 날렸고, 리뷰에서 -1을 받거나 더 나쁘게는 통과해서
`DEPRECATED_DISABLE_NOT_ASH_KEEPLISTED`가 영영 남았을 것이다.

## 현재 후보 큐 (2026-09-09 만료 NotFatalUntil 2차 — content/·base/·storage/·chrome/browser/)

09-07 세션이 `components/`·`net/`·`services/`만 봤기에 나머지를 훑었다. **만료 마커가 885곳**으로 늘었고,
`deprecated` 스캔도 `sql/`·`base/`·`storage/`·`components/sync/`로 확장했다.

### ★ 1순위 — storage/browser/quota 의 만료 M148 (153곳 / 10파일)

**M148은 사실상 quota 전용 마일스톤이다.** 전 트리 157곳 중 **153곳이 `storage/browser/quota/`**,
나머지는 단발 4곳(signin 1 · media/audio/win 2 · resource_coordinator 1)뿐이다.

| 파일 | 곳수 |
|---|---:|
| `quota_manager_impl.cc` | 84 |
| `quota_manager_proxy.cc` | 30 |
| `quota_database.cc` | 13 |
| `usage_tracker.cc` | 10 |
| `quota_temporary_storage_evictor.cc` · `client_usage_tracker.cc` · `quota_task.cc` · 그 외 3파일 | 16 |

**왜 지금 강한가 — 우리 CL에 이미 선례가 있다**

- 원 커밋: `0bcc9167e01e9` (2026-02-26, **Evan Stade**, "Quota: change DCHECK to CHECK in //storage/browser/quota",
  [CL 7601393](https://crrev.com/c/7601393), 리뷰어 Evan Stade + **Steve Becker**) — **우리 8282239의 리뷰어 두 명 그대로**
- **머지된 우리 커밋 `dde49d70e51e1`(8282239)이 이미 quota_database.cc에서 M148 마커 3개를 제거**했고
  커밋 메시지에 "as it is long past"라고 적었으며 그대로 승인·머지됐다. 같은 디렉토리·같은 리뷰어의 in-tree 선례다
- 현재 M155 — 넣은 지 7개 마일스톤 경과. 되돌리거나 마일스톤을 미룬 흔적 없음
- 선점: `message:"NotFatalUntil" status:open` 검색 9건 중 **M148 정리 CL은 없음**(우리 8366188 포함)

**CL 구성 (빌드 비용까지 고려)**

- **CL 1**: quota 153곳 / 10파일 — `storage/browser/quota/OWNERS` 한 그룹. **`base/` 헤더를 안 건드리므로 증분 빌드**로 끝난다
- CL 2: 나머지 4곳 + `not_fatal_until.h`의 `M148 = 148,` 삭제 — OWNER 3그룹, `media/audio/win`은 Linux 빌드 불가,
  그리고 **enum 삭제 때 전 트리 재빌드**(438680281에서 13시간 실측). 그래서 **비싼 쪽을 마지막에 둔다**
- 사이즈: CL 1은 인자 제거 153곳 → **L** 예상. 기계적이라 리뷰 부담은 낮다

### ✗ 탈락 — content/browser/renderer_host 의 M152 (759곳 / 65파일)

가장 큰 덩어리지만 **활발한 프로젝트의 일부**다. 원 커밋 `b1b4324462d30` (2026-06-10, Yuki Shiino,
"**[dcheck-to-check]** Convert DCHECKs in content/browser/renderer_host/ **[4/n]**")이고
같은 저자의 열린 CL(7849874)도 있다. 넣은 지 3개 마일스톤밖에 안 됐고 정리도 그쪽이 할 일이다.
→ **M148과의 차이**: M148은 storage 팀의 일회성 작업이고 7개 마일스톤이 지났으며 우리 선례가 있다.

### deprecated 스캔 결과 (`sql/ base/ storage/ components/sync/`)

| 후보 | triage | 판정 |
|---|---|---|
| 355451178 — `SharedMemoryMapping::memory()` 제거 (`base/memory/shared_memory_mapping.h:135`) | CL 0 · OSSCA 0 · **602일** | ⚠️ 선점은 없으나 **대체가 비기계적**: 호출처마다 `span(mapping)`/`GetMemoryAs<T>()`/`data()` 중 골라야 하고 `base/` API라 전 트리에 호출처가 흩어져 있다. 컴포넌트별 시리즈로만 가능 |
| 479750481 — `Pickle::WithUnownedBuffer` | **CL 15건** | ✗ 활발히 이행 중 |
| 478784025 — `Pickle::size()` | **CL 10건** | ✗ 활발히 이행 중 |
| 40262598 — `SyncService` deprecated 메서드 | CL 1건 | ✗ 선점 |
| 416394845 — `base/compiler_specific.h` | CL 4건 | ✗ 선점 |

**재현 명령**
```bash
python3 ~/ossca/steps/1-issue-hunting/scripts/hunt.py expired content/ base/ storage/ chrome/browser/
cd ~/chromium/src && git grep -c "NotFatalUntil::M148" -- storage/browser/quota/   # 마일스톤이 한 디렉토리에 몰렸는지
git log -1 --format="%an %s" -L <행>,<행>:<파일>                                    # 누가 왜 넣었는지 → 정리해도 되는지의 근거
```

## 현재 후보 큐 (2026-09-07 백엔드 영역 확장 세션)

지금까지 payments 4 · storage/sql 2 · net 1로 payments에 몰려 있었다. **백엔드 결이 강한 영역**
(`net/`, `storage/`, `components/services/storage/`, `content/browser/indexed_db/`)을 `hunt.py todos`로 훑고
`hunt.py triage`로 일괄 심사한 결과.

| 후보 | 내용 | triage | 판정 |
|---|---|---|---|
| **★ 40284947** | `net/base/proxy_string_util.h:50` "Remove method once all calls are updated to use `PacResultElementToProxyChain`" | CL 0 · OSSCA 0 · **816일** | **1순위** — 아래 상세 |
| 40203587 | `net/dns/host_resolver.h:139` `GetAddressResults()` 제거, `GetEndpointResults()`로 대체 | CL 0 · OSSCA 0 · **1206일** | ⚠️ 순수 가상 API 제거 + `AddressList`→`HostResolverEndpointResult` 타입 변경 → 구현체·호출처 전반 수정. **비커미터에겐 큼**, 후순위 |
| 40184305 | `storage/browser/quota/client_usage_tracker.cc:227` Origin→StorageKey 변환 제거 | CL 0 · OSSCA 0 · **1587일** | ⚠️ "storage policy API가 StorageKey를 쓰게 되면" 이 선행 조건이라 우리가 못 끝냄 |
| 40855748 | `content/browser/indexed_db/file_path_util.cc:67` first-party 버킷을 새 경로로 마이그레이션 | CL 0 · OSSCA 0 · 682일 | ⚠️ 사용자 데이터 마이그레이션 → 위험도 높음 |
| 40058632 | `storage/browser/quota/quota_manager_impl.cc:669` "Convert back into DCHECKs once issue is resolved" | CL 0 · OSSCA 0 | ✗ **부적합** — "이슈가 해결됐는지"를 내부 크래시 데이터로 판단해야 함. NotFatalUntil과 같은 함정 |

**탈락(선점)**: 498738402(CL 2건) · 372879072(CL 4건) · 40511450(CL 54건)

### ★ 40284947 상세 — 프로덕션은 이미 끝났고 테스트만 남았다

TODO 문구는 "모든 호출이 `PacResultElementToProxyChain`을 쓰도록 바뀌면 이 메서드를 지워라"인데,
**프로덕션 호출처를 세어보니 단 한 곳**이고 그마저 자기 래퍼다:

```
net/base/proxy_string_util.cc:97:  return ProxyChain(PacResultElementToProxyServer(pac_result_element));
```

즉 **끝내는 조건이 이미 충족돼 있고**, 남은 건 테스트 ~20곳(6파일):
`proxy_string_util_unittest.cc` 2 · `client_socket_pool_base_unittest.cc` 2 ·
`system_proxy_resolution_service_unittest-inl.h` 7 · `mac_system_proxy_resolution_service_unittest.cc` 5 ·
`windows_system_proxy_resolution_service_unittest.cc` 2

**CL 모양**: 테스트 호출처를 `PacResultElementToProxyChain`으로 바꾸고, 함수를 `.cc`의 익명 네임스페이스로
내려 헤더에서 제거 + TODO 삭제. S~M.

**⚠️ 이 후보의 진짜 위험 — 로컬 검증이 반쪽이다.**
6개 테스트 파일 중 `mac_*`·`windows_*`와 둘이 공유하는 `system_proxy_resolution_service_unittest-inl.h`는
**Linux에서 빌드되지 않는다.** 로컬로 검증 가능한 건 `proxy_string_util_unittest.cc`와
`client_socket_pool_base_unittest.cc`뿐이고, 나머지는 CQ가 돌려야 안다. **tryjob 권한이 없으므로 리뷰어에게
CQ dry run을 부탁해야 한다**(8278112에서 해본 방식). 이 사실을 CL 설명에 먼저 밝히는 편이 낫다.

**주의**: 같은 버그 번호를 다는 다른 TODO 7곳(`http_network_transaction.cc` 3 · `http_proxy_connect_job.cc` ·
`http_stream_factory_job_controller.cc` 2 · `proxy_list.h`)은 **multi-proxy chain 지원**이라는 별개의 큰 작업이다.
이 CL로 버그가 닫히지 않으므로 `Fixed:`가 아니라 **`Bug: 40284947`**.

## 현재 후보 큐 (2026-09-07 만료 NotFatalUntil 발굴 세션)

`hunt.py expired components/ net/ services/` → 61곳 → **마일스톤 단위로 전 트리 재집계**해서 후보 3개 확정.

**근거 (경로 2, 코드 상향 — 헤더가 정리를 지시하는 유형)** — `base/not_fatal_until.h:14`:

> To clean up old entries **remove the already-fatal argument from CHECKs** as well as from this list.
> This generates better-optimized CHECKs in official builds.

`base/check.h:42`는 이 인자의 목적을 "CHECK를 롤아웃하기 전 한두 마일스톤 동안 would-be 실패를 탐색"이라고 적어둠.
즉 마일스톤이 지나면 인자 제거가 **원래 계획의 완료**다. 40831207("deprecated and will be removed" 헤더)과 같은 결이라 **클레임 없이 직행 가능**.

**CL 모양** — 인자 제거 + `not_fatal_until.h`의 enum 항목 삭제 = 마일스톤 하나를 통째로 끝냄.
아래 셋은 전부 **그 마일스톤이 트리에서 그 파일에만 남아 있어** enum 항목까지 지울 수 있다 (재확인 필수: `git grep "NotFatalUntil::M<n>"`).

| | 파일 | 곳수 | 원 CL (작성/리뷰) | 버그 | 판정 |
|---|---|:-:|---|---|---|
| **★ M143** | `components/prefs/pref_service.cc` | 4 | James Lee / gab@ (2025-08-28, `6158315baad57`) | [438680281](https://crbug.com/438680281) **NEW·미할당·375일 무활동** | **1순위 — 직행 가능** |
| M146 | `components/services/storage/indexed_db/scopes/varint_coding.cc` | 2 | **Evan Stade / Steve Becker** (2026-01-09, `5ebfdb2e2f68e`, "Reapply IDB: DCHECK->CHECK") | [459129408](https://crbug.com/459129408) **ASSIGNED**, 192일 무활동 | 리뷰어 정렬 완벽(8282239와 동일 2인)이나 **이슈가 assigned → 선점 문의 먼저** |
| M147 | `chrome/browser/actor/actor_metrics.cc` | 10 | David Bokan / dtapuska@ (2026-01-12, `60b812185d368`) | `b:465817642` (**내부 버그, 공개 crbug 없음**) | 제일 크지만 참조할 공개 이슈가 없고 `chrome/browser/actor`는 신생·활발 |

**공통 검증 (2026-09-07)**: 선점 CL 0 (varint_coding은 2021년 WIP 하나뿐) · OSSCA 겹침 0 (`NotFatalUntil`·번호 검색 모두 0건) ·
세 마일스톤 모두 해당 파일 밖 참조 없음 (M146의 다른 히트는 전부 무관한 주석·SVG 경로 문자열)

**한계 (CL 설명에 정직하게)** — `NotFatalUntil`의 취지는 "크래시 리포트를 모아 확신이 서면 fatal로"인데
**외부 기여자는 내부 크래시 텔레메트리를 못 본다.** 그래서 근거는 "마일스톤이 N개 지났고 헤더가 정리를 지시한다"까지이고,
남겨야 할 이유가 있으면 OWNER가 안다. 되돌리자는 리뷰가 오면 정보 있는 사람의 판단이므로 받아들인다 (443042812에서 배운 것).

**만료 마일스톤 전체 집계 (MAJOR=155 기준)** — 아래는 대형이라 별건:
M148 157곳(= 기존 큐 «quota 만료 M148 정리»와 같은 뿌리) · M152 759곳 · M153 70 · M151 64 · M154 62 · M150 48 · M145 31.
**대형 마일스톤은 한 CL로 묶지 말 것** — OWNER 그룹이 갈려 승인 수집이 병목(sql ColumnTime 분석에서 배운 것).
소형 중 남는 것: M144 2파일 3곳(chrome/browser/signin) · M139 4파일(viz·media) · M142 6파일(signin·sync 등) — 파일이 갈려 enum 삭제엔 여러 OWNER 필요.

**재현 명령**
```bash
python3 ~/ossca/steps/1-issue-hunting/scripts/hunt.py expired components/ net/ services/
cd ~/chromium/src && git grep -oh "NotFatalUntil::M[0-9]*" -- '*.cc' '*.h' '*.mm' | sort | uniq -c   # 마일스톤별 집계
git grep -l "NotFatalUntil::M143" -- '*.cc' '*.h' '*.mm'                                            # 그 마일스톤이 몇 파일에 남았나
```

## 현재 후보 큐 (2026-09-05 sql/ 발굴 세션 갱신)

`hunt.py todos|deprecated|expired sql/` → crbug 11개 + deprecated 1 + 만료 M141 1 → triage + CL 상태 추적 결과.
sql/ 최근 커밋은 jpgravel@ 25건(5월 이후)으로 압도적. OWNERS: evanstade · etienneb · grt · olivierli.

- **★ ① `sql::Statement` 시간 역직렬화 마이그레이션 (ColumnTime / ColumnTimeDelta)** — 코드 상향, **1순위** → 상세 분석·시리즈 설계는 **`issues/40176243.md`**
  - `sql/statement.h:225,234`의 TODO(crbug 40176243, 40251269): "Migrate all time serialization to this method, and then remove the migration details above"
  - grt@가 2026-01 **CL 7455767**로 `Bind{Time,TimeDelta}` 쪽만 이행하고 `Fixed: 40176243,40251269`로 **두 이슈를 닫음**. Column 읽기 쪽은 안 건드려 TODO·잔여 호출처 그대로.
    TDR 봇의 TODO 삭제 CL 7460993은 "reviewer addressed todo"로 abandon됐지만 TODO는 ToT에 여전히 남아 있음
  - 잔여 호출처 **읽기 23곳 + 쓰기 9곳 = 32곳 / 12파일** (09-05 재검증, origin/main 다중행 스캔 — 단일행 grep은 쓰기 0으로 오판했었음).
    grt의 CL은 단일행 `BindInt64(N, x.ToInternalValue())`만 잡고 **다중행 `BindInt64(\n N, x.ToDeltaSinceWindowsEpoch().InMicroseconds())` 9곳을 놓침**
    - 읽기: history 9(download_database 3, journeys 3, keyword_search_term 1, visit_annotations 2) · autofill/payments_autofill_table 5 · net/extras reporting_and_nel_store 4 ·
      extensions activity_log 1 · affiliations 1 · blocklist opt_out_store 1(`base::Time() + Microseconds(...)` 형태) · password_notes_table 1 · declarative_performance_observer_store 1
    - 쓰기: journeys 2 · visit_annotations 4(TimeDelta `.InMicroseconds()` → `BindTimeDelta`) · insecure_credentials_table 1 · declarative_performance_observer_store 2
    - 등가성 확인: `Time::FromInternalValue(us)` = `Time(us)`, `FromDeltaSinceWindowsEpoch(d)` = `Time(d.InMicroseconds())`, `ColumnTime` = `FromDeltaSinceWindowsEpoch(Microseconds(int64))`, `ColumnTimeDelta` = `Microseconds(int64)` → 전부 비트 동일
  - **제외 1곳**: `payments_autofill_table.cc:1493`은 `Milliseconds` 직렬화라 `ColumnTime`(µs)과 불일치 → 손대면 안 됨. 나머지는 전부 `FromInternalValue` 또는 `FromDeltaSinceWindowsEpoch(Microseconds(...))` = `ColumnTime` 구현과 동일.
    bare `base::Microseconds(ColumnInt64)` 3곳(opt_out_store 276, visit_annotations 456·457)은 TimeDelta 값인지 확인 후 `ColumnTimeDelta`
  - 검증: 선점 CL 0(두 이슈 모두 grt CL만) · OSSCA 0(번호·ColumnTime·BindTime 검색) · 리뷰어 grt@ 생존(sql OWNER, 선례 저자) → **CL 설명에 7455767을 "part 1"로 인용**
  - 이슈 상태 **확인 완료 (09-05, `track.py crbug`에 상태 추출 추가)**: 40176243·40251269 둘 다 **FIXED, P3** (7455767의 `Fixed:` 트레일러로 닫힘). 제목이 각각 "Migrate to sql::Statement::BindTime() and **ColumnTime()**", "...BindTimeDelta() and ColumnTimeDelta()" — 이슈 제목 자체가 Column 쪽까지 포함하므로 "Fixed가 이르게 찍혔다"는 근거가 명확. → CL 설명에서 이 점을 짚고 `Bug:`로 참조하거나 grt에게 재오픈 요청
  - OWNERS 지도(리뷰어 수 추정): history 5명(manukh — grt 선례 리뷰어) · journeys 3명 · password_manager 5명(mamir — 선례 리뷰어) · affiliations 2명 · autofill/payments(file://payments) ·
    net/reporting+NEL(per-file) · extensions activity_log(rdevlin.cronin) · blocklist→heavy_ad_intervention · declarative_performance_observer(sisidovski) → **OWNER 그룹 8개**.
    선례는 5파일·리뷰어 4명이었음. 비커미터가 12파일·8그룹을 한 CL로 묶으면 승인 수집이 병목 → **컴포넌트별 시리즈 권장**: ① history 4파일 15곳(읽기 9+쓰기 6, OWNER 1그룹+journeys) → ② net/extras 4곳 → ③ password_manager+affiliations 3곳 → ④ 나머지 소형 4곳 → ⑤ autofill 4곳(활발한 CL 잦아 마지막). statement.h TODO 제거는 마지막 CL에 `Fixed:`와 함께
  - 이슈가 닫혀 있으므로 `Bug:` 트레일러로 닫힌 번호 참조하거나 grt에게 재오픈 요청. Chromium은 닫힌 버그 참조 허용
  - 사이즈: 전체 32곳 + statement.h 주석 정리 → 합계 M(약 80~100줄), 시리즈로 나누면 각 XS~S
  - **충돌 예보**: `payments_autofill_table.cc`에 활발한 CL 다수 — 특히 **8331527 "[autofill] Inline column definitions in PaymentsAutofillTable" (09-04)** 이 같은 줄을 만질 가능성 큼.
    `journeys_database.cc` ← 8267362(08-19), `visit_annotations_database.cc` ← 8332578(09-04). **autofill 5곳은 2차 CL로 빼는 게 안전**
- **② 40199997** — 이슈 본문(pwnall 2021): "SQLite errors are handled in `Database::OnSqliteError()` … DCHECKs on unhandled errors … discourages efficient SQL patterns (UPDATE-or-fail) … rework: ① 손수 만든 corruption 복구 대신 에러 핸들링에서 플래그 ② corruption일 수 있는 SQL 에러엔 절대 DCHECK 금지". **sql 에러 처리 전면 재설계 이슈**라 개인이 잡을 크기가 아님. 테스트 TODO는 곁가지 — `Recovery::RecoverDatabase()` 인자 검증 — `recovery_unittest.cc:867,885` TODO 두 개 중 **null db 쪽은 이미 해결**(`recovery.cc:79` 생성자 `CHECK(db_)`, 09-05 재검증). 남은 건 in-memory DB 검증 하나(recovery.cc에 in-memory 검사 없음) + 테스트 TODO 정리. 0 CL / OSSCA 0 / 1222일 무활동. 이슈 실제 제목은 **"Rework SQLite error handling"(NEW, P2, Feature)** — 테스트 TODO는 그 큰 이슈의 곁가지. **XS, 가치 낮음 → 후순위로 강등**
- **③ 40827336 chunk size 파일크기 휴리스틱 → `DatabaseOptions` 멤버** — `database.cc:2419`. 본문: "`SQLITE_FCNTL_CHUNK_SIZE` 힌트를 sql::Database 안의 휴리스틱(16KB↑→4KB, 128KB↑→32KB)으로 계산 중 → `DatabaseOptions` 멤버로 노출하자". 해당 블록은 2018년 이후 무변경, 열린 CL 없음(8291668 batching은 다른 줄). **설계 질문 2개를 OWNER가 정해야 함**: 옵션 기본값에 휴리스틱을 남길지 / 임시 DB에도 적용할지(TODO 문구). XS 코드지만 결정 없인 리뷰가 안 끝남 → grt 또는 jpgravel에게 한 줄 문의 후 착수. 이슈 제목 "Add DatabaseOptions member for filesystem chunk size" (**NEW, P3, Feature**, 미할당). 0 CL / OSSCA 0 / 1222일 무활동. 설계 변경(전 DB 영향)이라 **sql OWNER 의사 타진 먼저**. M
- **④ `sql/database.cc:675` 만료 `NotFatalUntil::M141`** — Evan의 2025-06 CL 6647287(Bug 425322236, 닫힘) 잔여물: `CHECK_NE(sqlite3_close 결과, kBusy, M141)` "statement/blob이 살아 있는 채 close". 현재 M155라 이미 fatal → 인자만 떼면 되는 XS. Evan 커밋 메시지가 "거의 확실하지만 100%는 아니라 M141까지 유예"였으니, 14개 마일스톤 동안 크래시 보고가 없었다는 것이 제거 근거. **단독 CL로는 너무 작음 → CL C(deprecated 메서드 삭제)에 동봉**
- 탈락(연결 CL 머지·진행 중): 40146017(Evan 7584144 머지) · 40262539(7224510 머지) · 40777743(4건) · 40061775(Evan 2024 정리 완료, 남은 TODO 7곳은 재시도 설계 → 논의 필요) · 40779018(3건) · 477762546(grt 열린 CL 2건, 3월) · 413595430(테스트 플래그, 저가치)

## 현재 후보 큐 (2026-09-02 발굴 세션 갱신)

- **① 545843242** (Link 헤더 exactly-one, 545645933 쌍둥이) — **진단 완료 → `~/ossca/issues/545843242.md`**, 선점 없음 (OSSCA 히트는 우리 #369의
  본문 언급). ToT `link-header-selection.https.window-expected.txt`가 이 버그의 [FAIL] 기록 중 →
  수정+baseline 삭제 한 세트, 8336867과 동일 패턴. **8336867 머지 후 착수 추천** (같은 함수 충돌 방지)
- **② quota 만료 M148 정리 (~156곳)** — Evan Stade가 2026-02 CL 7601393(리뷰 Steve Becker)로 넣은
  DCHECK→CHECK 이행 잔여물. 현재 M155라 전부 만료. dcheck-to-check 프로젝트가 활발하고 deadline bump
  CL도 존재 → 함부로 지우지 말고 **8282239 머지 즈음 Evan에게 "제거 CL 환영이냐" 한 줄 문의 후 진행**
  (리뷰어 정렬 완벽: 넣은 사람 = 우리 리뷰어 2명)
- **③ payments 신규 후보 3건** (triage 통과, 코드 진단 전):
  40681786 에러 문자열 이동(3곳·594일) / 41342247 converter 단위 테스트(1730일) /
  40121328 sanity check 이동(2361일)
- **④ sql/database.cc:675 만료 M141 1곳** — Evan의 2025-06 커밋(Bug 425322236) 잔여물. CL C에 동봉 후보
- **⑤ g_clock_for_testing 픽스처 누수** — 크로미움 트래커에 새 이슈 등록부터 (원인 규명 완료)
- tryjob 권한 신청 — 머지 3개 확보로 자격 됨

**탈락 기록** (재조사 방지): 507327886 플래그 미런칭 게이트 / 40891923 리버트 반복 지뢰밭 /
473666511·377242771 활발한 팀 프로젝트(CL 73·146건) / 433551601·396030877·40177656 선점 CL 존재

## 이전 후보 큐

- **545843242** — 545645933 쌍둥이 (Link 헤더 exactly-one 검증). 픽스처 이미 숙지
- **g_clock_for_testing 누수** — quota_database_unittest.cc:68, 원인 규명 완료. 이슈 신규 등록감
- CL B (favicon, 호출처 5곳) / CL C (sql 메서드 삭제, `Fixed: 40831207`) — 8282239 머지 후
- tryjob 권한 신청 — 머지 3개 확보로 자격 됨
- (2026-09-01 hunt.py 발굴) **storage/browser/quota의 만료 NotFatalUntil::M148 157곳** —
  quota_manager_impl.cc 84곳 등. M154에서 이미 fatal이라 인자 제거가 정리 수순.
  단, 착수 전 git blame으로 원 bug 번호와 팀의 제거 방침(일괄 제거 CL이 이미 도는지) 확인 필요
