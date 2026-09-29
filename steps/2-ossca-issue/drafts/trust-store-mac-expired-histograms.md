제목: [net/cert] Remove the expired Net.CertVerifier.Mac* histograms from TrustStoreMac

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-29 «만료된 히스토그램 기록 코드» 스캔 (1단계 STATUS 후보 HD). `net/cert/internal/trust_store_mac.cc` 가 기록하는 `Net.CertVerifier.Mac*` 히스토그램 7개(`MacTrustDomainCertCount.{Domain}`, `MacTrustDomainCacheInitTime`, `MacTrustImplCacheInitTime`, `MacKeychainCerts.{IntermediateCacheInitTime,IntermediateCount,TotalCount,TrustCount}`)가 **모두** 2024-02-01 또는 2024-04-28 에 만료. `expired_intentionally` 없음. 원 CL 55822f8 (mattm@, 2022-12)
- 근거: `tools/metrics/histograms/README.md` — 만료된 히스토그램의 기록 코드는 죽은 코드이므로 지우고 histograms.xml 항목도 정리
- 수정: 기록 전용 함수 3개(`HistogramTrustDomainCertCount`, `RecordCachedIntermediatesHistograms`, `RecordHistograms`)와 호출 7곳, 시간 측정용 `ElapsedTimer` 3개, 안 쓰게 된 include 4개 삭제. `TrustStoreMacImplTest.SystemCerts` 의 히스토그램 검사 블록 삭제(인증서 검사는 유지). histograms.xml 7항목 삭제. 3파일 −224, 캐시 동작 불변
- **Mac 전용 코드**라 Mac 에서만 빌드·테스트 가능 — 이 Mac 에서 검증
- 검증: `net_unittests --gtest_filter='*TrustStoreMac*'` 4/4 (`SystemCerts` 두 구현 포함)
- 선점: 히스토그램 이름 기준 열린 CL 0 · 파일의 열린 CL 은 방치 CL · OSSCA 0
- 리뷰어: mattm@ (net/cert OWNER, 히스토그램 owner·원 작성자). README 상 owner 전원 → +1 뒤 hchao@. CC amoseui@

**References**

- https://crsrc.org/c/net/cert/internal/trust_store_mac.cc
- https://crsrc.org/c/tools/metrics/histograms/README.md
