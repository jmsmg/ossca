# 1단계 — 이슈 발굴

| | |
|---|---|
| **입력** | 없음 (사이클의 시작) |
| **출력** | crbug 번호 하나 + 착수 근거(선점 없음·겹침 없음·리뷰어 생존) |
| **완료 조건** | 아래 «착수 전 검증 파이프라인» 4개 항목 전부 통과 |
| **도구** | [`scripts/hunt.py`](scripts/hunt.py) (후보 수집·일괄 심사, 이 폴더) · [`../../scripts/track.py`](../../scripts/track.py) (선점·겹침 조회, 공용) |
| **다음 단계** | [2단계 — OSSCA 이슈 등록](../2-ossca-issue/GUIDE.md) |
| **현황** | [STATUS.md](STATUS.md) · 예시 [examples/status/1-issue-hunting.md](../../examples/status/1-issue-hunting.md) |

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
  번호만 모으면 → `python3 $OSSCA/steps/1-issue-hunting/scripts/hunt.py triage <번호>...` 로 선점CL/OSSCA겹침/마지막활동 일괄 심사

## 경로 2: 코드 상향 검색 (코드 → 이슈) — 백엔드 로직엔 최고

팀이 **이미 하겠다고 코드에 박아둔 일**을 찾는다. 클레임 불필요, "왜 하냐" 반박 원천 차단.

```bash
cd $CHROMIUM_SRC

# ① 번호 붙은 TODO — 이슈가 살아있는지 역추적
grep -rn "TODO(crbug.com/" sql/ storage/browser/ --include='*.h' --include='*.cc' | head -50

# ② deprecated 주석 — "deprecated and will be removed" 류
grep -rn -i "deprecated" --include='*.h' sql/ | grep -i "remove"

# ③ 만료된 milestone 인자 — chrome/VERSION의 MAJOR보다 작으면 이미 만료 (hunt.py expired 가 자동 계산)
grep -rn "NotFatalUntil::M1" --include='*.cc' --include='*.h' <디렉토리>
#   → MAJOR 미만은 이미 fatal. "마이그레이션 끝났는데 정리 안 된 것"이 곧 이슈

# ④ 호출처 수 = 사이즈 추정
grep -rn "BeginTransactionDeprecated" --include='*.cc' | wc -l
```

**스크립트로 한 방에**: `python3 $OSSCA/steps/1-issue-hunting/scripts/hunt.py todos|deprecated|expired <디렉토리>...`
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

**전부 `$OSSCA/scripts/track.py` 원커맨드로 가능** (아래 raw 명령은 참고용):

```bash
python3 $OSSCA/scripts/track.py bug <번호>       # ① 선점 CL
python3 $OSSCA/scripts/track.py ossca <검색어>   # ② OSSCA 겹침
python3 $OSSCA/scripts/track.py file <경로>      # ③ 같은 파일 열린 CL
python3 $OSSCA/scripts/track.py crbug <번호>     # 이슈 트래커 마지막 활동(답변 왔는지)
python3 $OSSCA/scripts/track.py cl <CL번호>      # CL 상태 요약 (PS/표/attention/미해결)
python3 $OSSCA/scripts/track.py comments <CL> [날짜]  # 새 코멘트
python3 $OSSCA/scripts/track.py verify <CL> <PS> # 서버=로컬 검증 (해당 브랜치 체크아웃 상태에서)
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
   호출처 수를 세면 대략 나옴. 처음엔 XS~S로 흐름을 한 바퀴 돌고, 그 다음 S~M로 로직 깊은 곳으로
5. 휴면 판정: 미할당 + 연결 CL 없음 + 수개월 무활동 → 클레임 없이 직행.
   팀이 활발히 보는 이슈면 의사 타진 댓글 먼저 (무응답 ~2주면 직행 가능, CL 설명에 명시)

## 함정 — 피할 것

- **타인이 이행 중인 영역**: 플래그를 걸어두고 옮기는 중이면 건드리지 않기
  (web_database의 `use_scoped_transaction_` 사례)
- **대형 열린 CL이 같은 파일을 갈아엎는 중**: 착수 전 ③에서 발견되면 충돌 각오하거나 회피
  (8280660이 unittest를 +311/−148 하는 걸 업로드 전에 확인한 사례)
- **버그 번호 없는 순수 리팩토링**: 팀 승인 근거가 없으면 리뷰에서 방향 자체가 반박됨
- **`git cl split` 대량 치환 CL의 결과물에 over-index 하지 말 것**: 기계 치환은 라인별 의도가
  아님 (8282239 리뷰어가 8281077에 대해 준 교훈)
- **이슈 설명을 그대로 믿지 말 것**: 코드를 열어 재진단부터. 443042812는 이슈의 크래시
  스택 해석이 실제 호출 구조와 달랐고, 리뷰에서 방향이 뒤집혔다

## 사례 매핑 — 예시 이슈 7건 ([`examples/issues/`](../../examples/issues/))

| 이슈/CL | 경로 |
|---|---|
| 8146619 (docs 링크) | 1. 트래커 하향 |
| 8264232 (crypto/hash include) | 4. OSSCA 큐레이션 (#282) |
| 443042812 / 8278112 (SPC) | 1. 트래커 하향 (크래시 리포트 첨부 휴면 이슈) |
| 545645933 / 8336867 (rel 대소문자) | 3. 표준 대조 (RFC 8288 §2.1) |
| 40831207 / 8282239 시리즈 (sql 트랜잭션) | 2. 코드 상향 (deprecated 주석 역추적) |
| 41396598 (CurrencyFormatter) | 1. 트래커 하향 (M 사이즈 탐색) |
| g_clock 누수, 545843242 | 5. 작업 파생 |

## 후보 큐

착수 안 한 후보와 **탈락 기록(재조사 방지)**은 이 단계의 [STATUS.md](STATUS.md) «후보 큐»에 적는다. 발굴 세션마다 갱신.
실제로 쌓였던 모습: [`examples/status/1-issue-hunting.md`](../../examples/status/1-issue-hunting.md) 하단.
