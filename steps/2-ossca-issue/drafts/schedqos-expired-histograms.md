제목: [schedqos] Remove the expired Scheduling.DBusSchedQoS histograms and the PID reuse experiment (expired 2025-10/11)

템플릿: **직접 찾은 이슈 등록** (공개 crbug 없음, 실험 버그는 내부 b/328715424) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 만료 히스토그램 기록 코드 스캔 — 10-02 «리눅스 몫 후보» LD(ChromeOS 경로 «파일 전체 만료»). 리눅스에서 파일을 직접 다시 읽어 확인
- 근거: `tools/metrics/histograms/README.md` «Once a histogram has expired, the code that records it becomes dead code and should be removed from the codebase. You should also clean up the corresponding entry in histograms.xml.»
- 대상: `chrome/browser/ash/schedqos/dbus_schedqos_state_handler.cc`가 기록하는 `Scheduling.DBusSchedQoS.{PidReusedOnSetProcessState,PidReusedOnSetThreadState,SetProcessStateLatency,SetThreadStateLatency}`(**2025-10-26 만료**)·`ServiceConnectionSuccess`(**2025-11-02 만료**), 전부 literal
- PID 재사용 감지는 crrev.com/c/5366860(kawasin@, 2024-04)이 «to know how frequently the race happens in the field» 지표용으로 넣은 조사 코드 — 요청마다 `/proc/<pid>/stat`을 열고 끝난 뒤 다시 확인해 히스토그램과 에러 로그에만 씀 → 실험째 제거
- 수정: 히스토그램 5개·`GetPidReuseResult()`·`IsPidReused()`·지연 시간 `ElapsedTimer`(콜백 2개의 인자 포함)·`ProcStatFile` 인자·`PidReuseResult` enum 삭제, 지표 전용 테스트 6개와 그것만 쓰던 `LaunchFakeProcess()` 삭제, xml 5항목·enums.xml `PidReuseResult` 삭제. `system::ProcStatFile`(procfs_util) 자체는 `base/threading/thread_restrictions.h` friend 선언 때문에 후속 CL로 남김. PID 재사용 에러 로그 외 동작 불변. 5파일 +4/−370
- 트레일러: `Bug: b:328715424` (실험 버그)
- 검증: 리눅스 `out/cros`(`target_os="chromeos"`) `unit_tests` 증분 29스텝 2분 51초 · `gn check` ✓ · `validate_format.py` ✓ · `DBusSchedQOSStateHandlerTest.*` 수정 전 21/21 → 수정 후 **15/15**(빠진 6개 = 지운 지표 테스트, 이름 대조). 최신 main(ad845e3)과 충돌 없음
- 선점: 디렉터리 열린 CL은 DO NOT SUBMIT 실험·2024 방치 CL뿐 · 히스토그램 이름 검색 0 · OSSCA 겹침 0
- 리뷰어: `chrome/browser/ash/OWNERS`(schedqos 에 OWNERS 없음) oshima@ → +1 뒤 `metadata/scheduler` OWNER spvm@(원 실험 CL 리뷰어)

**References**

- https://crsrc.org/c/chrome/browser/ash/schedqos/dbus_schedqos_state_handler.cc
- 실험 CL: https://crrev.com/c/5366860
- https://chromium.googlesource.com/chromium/src/+/main/tools/metrics/histograms/README.md
