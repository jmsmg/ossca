제목: [predictors] Remove the remaining expired Navigation.Prefetch histograms

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: K(8461862, `Navigation.Prefetch.*BodySize` 제거, 10-01 머지) 작업 때 같은 파일에서 본 나머지 만료 히스토그램 (1단계 STATUS 후보 HC, 10-02 재스캔에서 «파일 전체 만료» 확인). `chrome/browser/predictors/prefetch_manager.cc` 가 기록하는 `Navigation.Prefetch.{IsHttps, PrefetchJobQueueLength, PrefetchJobQueueingTime}` 3개가 각각 2025-04-27 · 2023-03-19 · 2023-03-19 에 만료. `expired_intentionally` 없음
- 근거: `tools/metrics/histograms/README.md` — 만료된 히스토그램의 기록 코드는 죽은 코드이므로 지우고 histograms.xml 항목도 정리
- 수정: 기록 코드 3곳과 그 설명 주석(큐 길이 주석은 히스토그램을 추가한 2022 CL 에서 함께 들어온 것), 대기 시간 측정에만 쓰이던 `PrefetchJob::creation_time` 삭제. 파일의 마지막 히스토그램들이라 `histogram_functions.h`·`histogram_macros.h` include 도 삭제. 두 큐 히스토그램만 검사하던 `QueueingMetricsRecorded` 테스트와 `HistogramTester` include 삭제. histograms.xml 3항목 삭제. 3파일 −87, 동작 불변
- 검증: `unit_tests --gtest_filter='*PrefetchManager*'` (빌드 후, `scripts/hc_hj_test_mac.sh`)
- 선점: 열린 CL 은 오래된 무관 CL 뿐 · OSSCA 0
- 리뷰어: nhiroki@ (`chrome/browser/predictors` 와 `metadata/navigation` 양쪽 OWNER — K 와 같은 구성). CC amoseui@

**References**

- https://crsrc.org/c/chrome/browser/predictors/prefetch_manager.cc
- https://crrev.com/c/8461862
- https://crsrc.org/c/tools/metrics/histograms/README.md
