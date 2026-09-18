# [자체 발굴] kResetDecoderForNonIDR 킬스위치 제거 — VideoToolboxH264Accelerator (Mac 전용)

**상태: ✅ 완료 — CL 8410466 머지 (2026-09-17 22:54 UTC, PS3, `0a61d4d13c9e4`, eugene@ CQ). 기록 PR #453 머지. 8단계: merged PR(`Closes #440`) 허가 대기 · 보드 Status `반영 완료`(사용자).**

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
- [x] 7단계 기록 PR — ✅ **#453** (09-17, `contributions: Add 8410466`)
- [x] 6단계 — eugene@ +1(09-15) · dalecurtis@ +1(09-16) · 제출 요청 댓글 09-17 06:13 → eugene@ CQ+2 20:26 → 머지 22:54 UTC (`0a61d4d13c9e4`)
- [ ] 8단계 — merged PR(`Closes #440`) 허가 대기 · 보드 Status `반영 완료`(사용자)

## 이 사이클에서 배운 것

- 킬스위치 제거는 «플래그가 항상 켜져 있었는가»와 «about_flags·enums·fieldtrial 등록이 없는가» 두 가지만 확인하면 위험이 없다. 만료 주석 스윕이 이런 XS를 꾸준히 공급한다.
- 플랫폼 전용 코드는 그 플랫폼에서만 검증된다. Mac 전용 후보를 Mac에, 공용 후보를 캐시 있는 쪽에 배정하니 큐가 넓어졌다.
- `git cl upload -m`은 커버 메시지가 아니라 CL 설명을 통째로 대체한다. PS1 제목이 오염돼 `git cl description -n +`로 복구했다. 리뷰어에게 할 말은 업로드 뒤 별도 메시지로.
