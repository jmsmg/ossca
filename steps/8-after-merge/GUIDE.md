# 8단계 — 머지 후 마무리

| | |
|---|---|
| **입력** | MERGED 된 Gerrit CL ([6단계](../6-review/GUIDE.md)) |
| **출력** | 3곳의 상태가 전부 최신: crbug · contributions repo · OSSCA 이슈 |
| **완료 조건** | 아래 체크리스트 5개 전부 |
| **다음 단계** | 다음 사이클 [1단계](../1-issue-hunting/GUIDE.md) — 또는 시리즈의 다음 CL은 [3단계](../3-branch-and-fix/GUIDE.md)부터 |
| **현황** | [STATUS.md](STATUS.md) |

머지가 끝이 아니다. **여기서 안 닫으면 계속 열린 채로 남는다** — 실제로 가장 자주 밀리는 단계.

---

## 체크리스트

- [ ] **1. Gerrit CL 머지 확인** — 커밋 해시·날짜·최종 PS를 기록.
      `Fixed:` 트레일러였다면 crbug가 자동 close 됐는지 확인 (`Bug:`였다면 수동 close 여부 판단)
- [ ] **2. contributions repo 후속 PR** — frontmatter `status: merged`로 갱신,
      커밋 `contributions: Mark <CL번호> as merged`. 본문도 최종 형태로 다시 씀
      (443042812의 PR #348은 방향 전환 때문에 +44/−26으로 본문 전면 재작성).
      **PR 본문 맨 아래에 `Closes #<OSSCA이슈번호>`** — 머지되면 이슈가 자동으로 닫힌다 (아래 절)
- [ ] **3. OSSCA GitHub 이슈 Status → `반영 완료`** — 자동 닫기는 이슈를 close 할 뿐
      **프로젝트 Status 필드는 안 건드린다.** 이건 여전히 손으로
- [ ] **4. `issues/<crbug>.md` 마감** — 상단 상태 줄을 `✅ 완료`로, 진행 체크리스트 전부 체크,
      **«이 사이클에서 배운 것»** 섹션 작성
- [ ] **5. `../../README.md` 갱신** — 상태 요약표 + **CL 사이즈 이력** 표에 한 줄 추가
      (사이즈는 Gerrit 뱃지 기준: XS <10 · S 10–49 · M 50–249 · L 250–999 · XL ≥1000)

## 이슈 자동 닫기 — `Closes #<번호>`

`status: merged` PR 본문 맨 아래에 한 줄 넣는다. 머지되는 순간 OSSCA 이슈가 닫힌다.

```
Closes #400
```

- **키워드가 번호 앞에 온다.** `Closes #400` ⭕ / `#400 closes` ❌ (아무 일도 안 일어남).
  쓸 수 있는 키워드: `close`/`closes`/`closed`, `fix`/`fixes`/`fixed`, `resolve`/`resolves`/`resolved`
- **PR 본문(설명)에 넣는다.** 커밋 메시지에 넣어도 동작하지만 이 저장소는 squash merge라 본문이 확실하다
- fork(jmsmg)에서 보내는 PR이라도 **타깃이 이슈가 있는 저장소(OSSCA-chromium/contributions)면 동작한다**
- **어느 PR에 넣느냐가 핵심**: 7단계 기록 PR(`status: in review`)에 넣으면 CL이 아직 리뷰 중인데 이슈가 닫힌다.
  반드시 8단계의 `status: merged` PR에만
- **시리즈는 마지막 CL에서만.** 40831207(#342)처럼 CL A·B·C가 한 이슈에 걸려 있으면
  A의 merged PR에 `Closes`를 넣는 순간 이슈가 조기 종료된다. `Fixed:` 트레일러를 다는 CL과 같은 시점에 맞춘다
- 자동으로 닫혀도 **Status 필드는 그대로**다. `반영 완료`로 옮기는 건 별도 수작업 (체크리스트 3번)

## 회고 — 「배운 것」에 무엇을 적나

`issues/<crbug>.md` 맨 아래에 다음 CL에 실제로 적용될 것만 적는다. 지금까지 나온 것들:

- (372283556) 작은 CL로 전체 흐름을 한 바퀴 도는 것이 먼저. include 정리 CL은
  "사용처가 없다"를 스스로 증명하는 조사가 본 작업
- (443042812) 착수 전 호출처를 직접 따라가라. 같은 파일의 다른 가드와 크래시 스택은 근거가 아니다
- (8336867) payments 초기 리뷰는 개인이 아니라 `chrome-payments-reviews@` 알리아스로
- (8282239) 오래 묵힌 CL은 리베이스 충돌이 난다 (5일 만에 발생)

## 시리즈라면

CL A가 머지돼야 CL B가 성립하는 구조면, 8단계를 마치는 즉시 **3단계로 되돌아간다**
(1·2단계는 이미 통과한 이슈이므로 생략). 40831207이 이 모양: A(quota) ✅ → B(favicon) → C(sql 삭제).
