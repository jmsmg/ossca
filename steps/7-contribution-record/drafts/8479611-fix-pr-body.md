## Summary

CL 8479611(sql 시리즈 CL 4) 기록의 «발굴 과정»에 사실과 다른 문장이 있어 고칩니다. declarative_performance_observer는 «이미 바뀌어 있어» 범위에서 빠진 것이 아니라, 착수 때 잘못 판단해 빠졌습니다. 실제로는 바뀌지 않았고 다음 CL [8505857](https://crrev.com/c/8505857)에서 옮겼습니다. 배운 점에도 그 교훈을 한 문장 덧붙였습니다.

## 관련 이슈

- crbug: https://crbug.com/40176243
- Gerrit: https://crrev.com/c/8479611 · https://crrev.com/c/8505857
- OSSCA 이슈: #416
