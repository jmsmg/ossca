# 6단계 현황 — 리뷰 라운드

> 범례: ✅ 완료 · 🔄 진행 중 · ⏳ 대기(상대 응답) · ⬜ 미착수 · ➖ 해당 없음 · ❓ 원격 재확인 필요
> 갱신: YYYY-MM-DD · 출처: `../../BOARD.md` 요약표 + `../../issues/*.md` 상단 상태 줄
> 채워진 예시: [`../../examples/status/6-review.md`](../../examples/status/6-review.md)

| CL | crbug | 현재 상태 | 대기 대상 |
|---|---|---|---|
| | | | |

**다음 액션**

```bash
python3 $OSSCA/scripts/track.py cl <CL번호>        # 표 · attention · 최근 메시지
python3 $OSSCA/scripts/track.py comments <CL번호>  # 오늘 달린 코멘트
python3 $OSSCA/scripts/track.py crbug <crbug번호>  # 이슈 트래커 쪽 답변
```

- 오래 묵은 CL은 ToT 리베이스가 필요해진다 (예시 기록: 8282239는 5일 만에 충돌)
- 리뷰 라운드에서 바뀐 판단은 `../../issues/<crbug>.md`에 기록할 것
