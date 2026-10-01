제목: [Commerce] Remove the expired Commerce.Heuristics.* histograms

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-29 «만료된 히스토그램 기록 코드» 스캔 (1단계 STATUS 후보 HG). `components/commerce/core/commerce_heuristics_data_metrics_helper.cc` 가 기록하는 `Commerce.Heuristics.*Source` 히스토그램 6개(`CartExtractionScriptSource`, `CheckoutURLGeneralPatternSource`, `MerchantNameSource`, `PartnerMerchantPatternSource`, `ProductIDExtractionPatternSource`, `SkipProductPatternSource`)가 **모두** 2023-02-19 ~ 2024-07-21 에 만료. `expired_intentionally` 없음. 원 CL 07aa207 · 7a71f76 · 470ca36 (yuezhanggg@, 2022)
- 기록 함수 6개 중 4개는 ChromeCart 삭제 때 이미 호출처가 사라짐 — crrev.com/c/5932823 (renderer, 2024-10: CartExtractionScript·ProductIDExtraction·SkipProduct), crrev.com/c/5990619 (chrome/browser/cart, 2024-11: MerchantName). 남은 호출은 `commerce_feature_list.cc` 2곳, `commerce_heuristics_provider.cc` 2곳
- 근거: `tools/metrics/histograms/README.md` — 만료된 히스토그램의 기록 코드는 죽은 코드이므로 지우고 histograms.xml 항목도 정리
- 수정: helper 클래스(.h/.cc)와 BUILD.gn 항목 삭제, 호출 4곳과 include 삭제, `CommerceFeatureListTest` 의 히스토그램 검사 4개와 `HistogramTester` 삭제(패턴 선택 검사는 유지). histograms.xml 6항목과 다른 곳에서 안 쓰는 `CommerceHeuristicsDataSource` enum 삭제. 8파일 −223, 동작 불변
- 범위 밖: `chrome/renderer/DEPS` 에 삭제된 헤더를 가리키는 include 규칙이 남음(ChromeCart renderer 삭제 때의 잔재, 같은 블록의 커머스 규칙 3개도 미사용). chrome/ OWNER 가 필요해 후속 CL 로 분리
- 검증: `components_unittests --gtest_filter='CommerceFeatureListTest.*:CommerceHeuristicsDataTest.*'` **31/31** (증분 12스텝 24초), presubmit 0 경고, histograms `pretty_print`·`validate_format` 통과
- 선점: 히스토그램 이름·파일 기준 열린 CL 0 · OSSCA 0
- 리뷰어: mdjones@ (components/commerce OWNER 이자 metadata/commerce 히스토그램 OWNER). 히스토그램 owner yuezhanggg@·wychen@ 는 최근 14일 활동 0. +1 뒤 ayman@. CC amoseui@

**References**

- https://crsrc.org/c/components/commerce/core/commerce_heuristics_data_metrics_helper.cc
- https://crsrc.org/c/tools/metrics/histograms/README.md
