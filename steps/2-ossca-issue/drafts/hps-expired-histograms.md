제목: [ash] Remove the expired HPS snooping protection and quick dim histograms (expired 2023-05 / 2024-03)

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 만료 히스토그램 기록 코드 스캔 — 10-02 «리눅스 몫 후보» LB(ChromeOS 경로 «파일 전체 만료»). 리눅스에서 파일을 직접 다시 읽어 확인
- 근거: `tools/metrics/histograms/README.md` «Once a histogram has expired, the code that records it becomes dead code and should be removed from the codebase. You should also clean up the corresponding entry in histograms.xml.»
- 대상: `ash/system/human_presence/human_presence_metrics.h`의 이름 상수로 크롬이 기록하는 HPS(사람 감지 센서) 히스토그램 6개 — `ChromeOS.HPS.SnoopingProtection.{Enabled,FlakeyDetection,Positive.Duration,Negative.Duration}`·`ChromeOS.HPS.SnoopingProtectionNotificationSuppression.Enabled`(**2023-05-31 만료**), `ChromeOS.HPS.QuickDim.Enabled`(**2024-03-24 만료**). 같은 xml의 `TurnOn`·`Update`·`Image` 히스토그램은 크롬 밖(플랫폼 데몬)에서 기록하므로 범위 밖
- 수정: 헤더 삭제(BUILD.gn 1줄), `SnoopingProtectionController`의 기록 3곳·`LogPresenceWindow()`·`last_presence_report_time_`(지표 전용), `SnoopingProtectionNotificationBlocker::OnBlockingPrefChanged()`의 지표 전용 pref 읽기, `PowerPrefs`의 QuickDim 변경 추적(`quick_dim_pref_enabled_`·`UpdatePowerPolicyFromPrefsChange()`) — 이 함수는 2022 지표 CL(crrev.com/c/3361618)이 끼워 넣은 것이라 콜백을 원래대로 `UpdatePowerPolicyFromPrefs()`에 직접 연결. 지표만 검사하던 테스트 6개(`SnoopingProtectionControllerTestMetrics` 5 · `PowerPrefsTest.QuickDimMetrics`)와 xml 5항목 삭제. 동작 불변. 10파일 +1/−448
- 트레일러: `Bug: None`
- 검증: 리눅스 `out/cros`(`target_os="chromeos"`) `ash_unittests` 증분 13스텝 2분 · `gn check //ash:ash //ash:ash_unittests` ✓ · `validate_format.py` ✓ · `SnoopingProtection*:PowerPrefs*` 수정 전 48/48 → 수정 후 **42/42**(빠진 것은 지표 전용 6개뿐, 이름 대조). 최신 main(ad845e3)과 충돌 없음
- 선점: 디렉터리·파일 열린 CL 0 · 히스토그램 이름 검색 0 · OSSCA 겹침 0
- 리뷰어: ash OWNER blundell@(최근 7일 리뷰 26건; ash/system·power OWNER jiamingc@·amehfooz@는 최근 활동 없음) → +1 뒤 `metadata/chromeos_hps` OWNER jimmyxgong@

**References**

- https://crsrc.org/c/ash/system/human_presence/human_presence_metrics.h
- 지표 추가 CL: https://crrev.com/c/3361618
- https://chromium.googlesource.com/chromium/src/+/main/tools/metrics/histograms/README.md
