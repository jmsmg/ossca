# [자체 발굴] kResetDecoderForNonIDR 킬스위치 제거 — VideoToolboxH264Accelerator (Mac 전용)

**상태: 4단계 검증 완료(09-15, Mac) — `media_unittests` 빌드 19m16s/7,917스텝 ✓, `VideoToolboxH264Accelerator*` 8/8 ✓. 브랜치 `reset-decoder-nonidr-killswitch` 커밋 `643a8a33b8b7e` (+1/−10). **CL 8410466 업로드 완료(09-15).** OSSCA #440 — 진행 코멘트·기록 PR 허가 대기.**

## 링크

- crbug: 없음. 플래그가 보호하던 원 수정의 버그는 https://crbug.com/451536366 → `Bug: 451536366`
- Gerrit: **https://crrev.com/c/8410466** (09-15, PS2 = 로컬 HEAD; PS1은 `-m` 실수로 설명이 커버 문장이 됐던 것을 `git cl description -n +`로 복구, 해시태그 small-cleanup→media, 커버 메시지는 REST로 게시)
- OSSCA 이슈: #440 (2026-09-15)
- 발굴 경로: 코드 상향 — 09-15 «Remove after M<n>» 만료 주석 스윕(97건) 중 Mac 전용 파일 하나에 닫힌 킬스위치

## 무엇을 지우나

`media/gpu/mac/video_toolbox_h264_accelerator.cc`:
- `BASE_FEATURE(kResetDecoderForNonIDR, ENABLED_BY_DEFAULT)` + "Kill-switch: Remove after M145 is stable" 주석 (익명 namespace가 비어 같이 제거)
- 조건 `!pic->idr && first_decode_ && IsEnabled(kResetDecoderForNonIDR)` → `!pic->idr && first_decode_` (첫 샘플이 non-IDR이면 `kCMSampleBufferAttachmentKey_ResetDecoderBeforeDecoding` 부착 — Apple 권고, SEI recovery point 탐색 손상 방지)
- 다른 사용이 없어진 `base/feature_list.h` include

트리 M155, 플래그는 도입 이래 기본 켜짐 → 동작 불변. about_flags·enums·flag-metadata 등록 없음(grep 0). `gn check //media/gpu/mac/*` OK.

## 검증 계획

- `media_unittests --gtest_filter='VideoToolboxH264Accelerator*'` (`video_toolbox_h264_accelerator_unittest.cc`). Mac 전용 코드라 이 Mac에서만 검증 가능
- 러너 `steps/4-build-and-test/scripts/killswitch_test_mac.sh` (사용자 tmux), 마커 `logs/killswitch_done.marker`

## 리뷰어 (2명)

- eugene@chromium.org — media/gpu OWNER, 같은 파일에 열린 CL 8400064(09-15). 그의 CL과 순서를 맞추거나 «같이 넣을까요» 물을 수 있음
- dalecurtis@chromium.org 또는 liberato@chromium.org — media/gpu OWNER

## 진행 체크리스트

- [x] 발굴 + 선점 확인(플래그 이름 든 열린 CL 0) + OSSCA #440
- [x] 브랜치·수정·format·gn check·커밋 (09-15)
- [x] 4단계 — ✅ 09-15 media_unittests 19m16s, VideoToolboxH264Accelerator* 8/8
- [x] 5단계 업로드 — ✅ **CL 8410466** (09-15, 리뷰어 eugene@·dalecurtis@, presubmit 0 경고)
- [ ] 7단계 기록 PR
