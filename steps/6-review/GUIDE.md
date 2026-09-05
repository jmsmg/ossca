# 6단계 — 리뷰 라운드 대응

| | |
|---|---|
| **입력** | 리뷰 대기 중인 CL ([5단계](../5-commit-and-upload/GUIDE.md)) |
| **출력** | 새 PS + 답글, 최종적으로 CQ+2 / 머지 |
| **완료 조건** | Gerrit CL이 MERGED |
| **다음 단계** | [8단계 — 머지 후 마무리](../8-after-merge/GUIDE.md) |
| **현황** | [STATUS.md](STATUS.md) |

> ⚠️ **Gerrit 댓글 게시(Send)는 원격 공개다. 사용자 승인 없이 실행하지 않는다.**

---

## 한 라운드의 루프

```
코멘트 해석 → 지적이 맞는지 주변 코드까지 읽고 독립 검증 → 수정
  → 빌드/테스트(tmux, 4단계) → git commit --amend → 새 PS 업로드 → 답글 Send
```

## 답글 규칙

- 반영한 스레드는 **Done** 체크 (자동으로 Resolved 처리) + 상단 Reply에 요약,
  **Send 한 번에 전부 게시**
- 드래프트는 Send 전까지 나만 보인다
- **게시된 댓글은 삭제 불가** (관리자만). 실수로 두 번 올려도 그냥 둔다
- 요청받지 않은 변경을 제안할 땐 **공손한 질문 형식**으로

## -1을 받았을 때 — 태도가 결과를 바꾼 사례

443042812에서 Stephen McGruer(payments OWNER)가 PS1에 Code-Review **-1**.
요지는 "수정 방식뿐 아니라 **원래 버그 리포트 자체가 틀렸다**"였다.

리뷰어가 든 근거:

1. **호출처 분석으로 null 불가능 입증** — `Create()`의 호출처는 `PaymentAppService::Create` 하나뿐이고,
   그 호출처는 데스크톱/안드로이드 두 곳인데 **둘 다 살아있는 객체가 자기
   `weak_ptr_factory_.GetWeakPtr()`을 동기 fan-out에 즉시 넘긴다.** 무효화될 틈이 없음
2. **버그 리포트가 오귀속(misattribution)** — 크래시 스택에 무관한 프레임이 붙어 있어
   시그니처가 엉뚱한 함수에 매핑된 것
3. **가드가 오히려 나쁜 이유** — 주석이 "null일 수 있다"는 거짓 정보를 남기고,
   진짜 불변식 위반이 생겨도 크래시도 로그도 없이 **숨겨버린다**.
   스타일가이드는 불변식 위반을 크래시율 무관 P1로 다루라고 함

대응: 지적을 **직접 grep으로 재확인**(5분)한 뒤 방향을 바꿔 `DCHECK` → `CHECK` 승격으로 재작성,
회귀 테스트는 "일어날 수 없는 상태를 검증하므로" 삭제. PS1 +23/−1 → 최종 **+1/−1**로 머지.
crbug에도 오귀속 분석을 코멘트로 남겼다.

**규칙:** 지적은 수용도 반박도 하기 전에 **스스로 코드를 읽어 독립 검증한다.**
검증해보고 리뷰어가 맞으면 전제를 버리는 게 정답이고, 그 과정에서 바뀐 내 판단(오판 포함)은
`issues/<crbug>.md`에 남긴다.

## Gerrit 메커니즘

- 코드가 바뀐 새 PS가 올라가면 **기존 Code-Review 표는 outdated로 무효화**된다.
  유지되는 copy 조건은 `NO_CHANGE` / `NO_CODE_CHANGE` / `TRIVIAL_REBASE` 등뿐 → 리뷰어가 다시 +1해야 함
- **attention set** = 지금 볼 차례인 사람. 답글을 Send하면 리뷰어로 넘어간다
- CQ가 `REBASE_ALWAYS`라 평소 리베이스는 불필요하지만, Gerrit에 **merge conflict가 표시되면 직접 ToT 리베이스**:
  `git fetch origin && git rebase origin/main && gclient sync` → 재빌드/재테스트.
  오래 묵힐수록 충돌 위험 증가 (8282239는 5일 만에 충돌)
- 머지는 리뷰어의 **CQ+2**로 들어간다 (컨트리뷰터는 CQ 권한 없음)

## 대기 중 확인

```bash
python3 ~/ossca/scripts/track.py cl <CL번호>            # 표·attention·최근 메시지
python3 ~/ossca/scripts/track.py comments <CL번호>      # 오늘 달린 코멘트
python3 ~/ossca/scripts/track.py crbug <crbug번호>      # 이슈 트래커 쪽 답변
```
