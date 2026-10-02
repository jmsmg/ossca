제목: [arc] Remove the expired Arc.NearbyShare histograms (all six expired 2025-03-28)

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 만료 히스토그램 기록 코드 스캔 — 10-02 «리눅스 몫 후보» LA(ChromeOS 경로 «파일 전체 만료»). 리눅스에서 파일을 직접 다시 읽어 조합 이름이 없는지 확인
- 근거: `tools/metrics/histograms/README.md` «Once a histogram has expired, the code that records it becomes dead code and should be removed from the codebase. You should also clean up the corresponding entry in histograms.xml.»
- 대상: `chrome/browser/ash/arc/nearby_share/arc_nearby_share_uma.{h,cc}` — 기록 함수 6개가 `Arc.NearbyShare.{ArcBridgeFailure,DataHandlingFailure,IOFailure,WindowFound,FileStreamFailure,FileStreamComplete.TimeDelta}`를 기록. **6개 모두 `expires_after="2025-03-28"`**(`expired_intentionally` 아님), 이름은 전부 literal. XML의 `Arc.NearbyShare.*` 항목은 이 6개뿐
- 수정: helper 파일 2개 삭제(BUILD.gn 2줄), 호출 20곳 삭제(bridge 2 · session 3 · share_info_file_handler 11 · stream adapter 4), 지속 시간 히스토그램만을 위한 `file_streaming_started_` 멤버·기록·주석 삭제, histograms.xml 6항목과 이 히스토그램들만 쓰는 enum 3개(enums.xml) 삭제. 동작 불변. 10파일 −253
- 트레일러: `Bug: None`
- 검증: 리눅스 `out/cros`(`target_os="chromeos"`) 증분 29스텝 4분 · `gn check` ✓ · `validate_format.py` ✓ · `unit_tests --gtest_filter='*NearbyShare*:ShareInfoFileStreamAdapterTest.*'` **149/149**(ARC nearby_share 테스트 7개 포함). 최신 main(ad845e3)과 충돌 없음
- 선점: 파일 열린 CL 0 · 히스토그램 이름 검색 열린 CL 0 · OSSCA 겹침 0. 같은 디렉터리의 열린 CL 8302314(09-11, NearbyShareOverlayView)가 `nearby_share_session_impl.cc`를 함께 건드리지만 병합 충돌 없음(확인)
- 리뷰어: 코드 — ARC OWNER hidehiko@ → +1 뒤 histograms.xml OWNER(`metadata/arc`: batoon@·youkichihosoi@·lingyufeng@, 최근 7일 활동 없음 → 그대로면 `METRICS_OWNERS`). 히스토그램 owner alanding@도 최근 활동 없음

**References**

- https://crsrc.org/c/chrome/browser/ash/arc/nearby_share/arc_nearby_share_uma.cc
- https://chromium.googlesource.com/chromium/src/+/main/tools/metrics/histograms/README.md
