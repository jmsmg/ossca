제목: [glanceables] Remove four expired Ash.Glanceables.Api.Tasks histograms (expired 2025-12-31)

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 만료 히스토그램 기록 코드 스캔 — 10-02 «리눅스 몫 후보» LE(ChromeOS 경로). 리눅스에서 파일을 직접 다시 읽어 확인
- 근거: `tools/metrics/histograms/README.md` «Once a histogram has expired, the code that records it becomes dead code and should be removed from the codebase. You should also clean up the corresponding entry in histograms.xml.»
- 대상: `chrome/browser/ash/api/tasks/tasks_client_impl.cc`(Glanceables 의 Google Tasks API 클라이언트)가 기록하는 `Ash.Glanceables.Api.Tasks.{ProcessedTasksCount,RawTasksCount,SimultaneousMarkAsCompletedRequestsCount,TaskListsCount}` — 4개 모두 **2025-12-31 만료**(`expired_intentionally` 아님), 이름 전부 literal
- 범위 밖: 같은 클래스가 기록하는 `Ash.Glanceables.Api.{Method}.{Latency,PagesCount,Status}`는 xml 에 `{Method}` 패턴으로 따로 정의(Classroom 과 공유, 만료 2026-03/05 — 스캔 기준 2026-01-01 이전에 해당 안 함, «Tasks API 로 일반화» TODO 가 붙은 운영 지표) → 이 CL 에서는 건드리지 않음
- 수정: 기록 4곳 삭제(두 곳은 같은 TODO 주석 아래 PagesCount 가 남아 주석을 단수로), 이 4개만 검사하던 테스트 문장 7개 삭제(테스트 자체는 전부 유지), xml 4항목 삭제. 동작 불변. 3파일 +2/−88
- 트레일러: `Bug: None`
- 검증: 리눅스 `out/cros`(`target_os="chromeos"`) `unit_tests` 증분 14스텝 1분 46초 · `gn check '//chrome/browser/ash/api/tasks/*'` ✓ · `validate_format.py` ✓ · `TasksClientImpl*` 수정 전 36/36 → 수정 후 **36/36** (테스트 삭제 없음, 이름 집합 동일). 최신 main(ad845e3)과 충돌 없음
- 선점: 디렉터리 열린 CL 은 무관(Bluedog 로깅·Clank 프로토타입·검색) · 히스토그램 이름 검색 0 · OSSCA 겹침 0
- 리뷰어: **achuith@** — `chrome/browser/ash/OWNERS`(코드)와 `metadata/ash/OWNERS`(xml) 양쪽 OWNER, 최근 7일 리뷰 5건, 우리 CL 미담당. glanceables OWNER 중 활동하는 jamescook@는 Z 담당 중이라 피함

**References**

- https://crsrc.org/c/chrome/browser/ash/api/tasks/tasks_client_impl.cc
- https://chromium.googlesource.com/chromium/src/+/main/tools/metrics/histograms/README.md
