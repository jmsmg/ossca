제목: [media/gpu/mac] Remove the expired kResetDecoderForNonIDR kill switch from VideoToolboxH264Accelerator

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 2026-09-15 ToT에서 «Remove/Delete … after/in M<n>» 형태의 만료 주석 97건을 스윕. 이 항목은 주석이 제거 시점을 명시한 킬스위치 중 **Mac 전용 파일 하나에 닫혀 있는** 것
- `media/gpu/mac/video_toolbox_h264_accelerator.cc:23`의 `BASE_FEATURE(kResetDecoderForNonIDR, ENABLED_BY_DEFAULT)`에 "Kill-switch: Remove after M145 is stable"이 붙어 있다. 트리는 M155라 10개 마일스톤이 지났다
- 유일한 사용처(`:166`)는 «첫 샘플이 non-IDR이면 `kCMSampleBufferAttachmentKey_ResetDecoderBeforeDecoding`을 붙인다»(SEI recovery point 탐색 시 손상 방지, Apple 권고, crbug 451536366)의 조건. 플래그는 기본 켜짐이고 about_flags·enums·flag-metadata 등록 없음 → 조건에서 `FeatureList::IsEnabled` 항을 지우고 `BASE_FEATURE`와 (다른 사용이 없으면) `base/feature_list.h` include를 제거한다. 동작 불변
- 검증: Mac 전용 코드라 이 Mac에서 `media_unittests --gtest_filter='VideoToolboxH264Accelerator*'` 실행(`video_toolbox_h264_accelerator_unittest.cc`)
- 선점: 플래그 이름이 든 열린 CL 0. 같은 파일에 eugene@(media/gpu OWNER)의 열린 CL 8400064(09-15, SPS 변경 처리) → 리뷰어로 eugene@ 지정, 그의 CL과 겹치면 순서를 맞춘다
- 리뷰어(2명): media/gpu OWNERS 중 eugene@ + dalecurtis@ 또는 liberato@

**References**

- https://crsrc.org/c/media/gpu/mac/video_toolbox_h264_accelerator.cc;l=22
- 도입 배경 crbug: https://crbug.com/451536366
- 같은 파일의 열린 CL: https://crrev.com/c/8400064
