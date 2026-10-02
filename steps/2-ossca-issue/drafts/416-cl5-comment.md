CL 5: https://crrev.com/c/<번호>

- autofill 결제 메타데이터 읽기 4곳과 `DeclarativePerformanceObserverStore`의 읽기·쓰기 5곳을 `ColumnTime()`/`BindTime()`으로 옮겼습니다. 성능 관찰자 저장소 쪽은 CL 4 때 «이미 바뀌었다»고 잘못 판단해 빠졌던 곳입니다.
- 착수 전 전수 재검색에서 iOS 다운로드 기록 DB에 7곳이 더 나와, 시리즈를 CL 6(iOS)·CL 7(`statement.h` 설명·TODO 삭제, 이슈 종료)까지 늘립니다.
