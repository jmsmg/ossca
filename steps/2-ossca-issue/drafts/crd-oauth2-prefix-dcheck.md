제목: [remoting] Remove the leftover oauth2: prefix DCHECK and legacy-token test from RemoteSupportHostAsh (b/309958013, "remove after M122")

템플릿: **직접 찾은 이슈 등록** (공개 crbug 없음, 내부 b/309958013) · 라벨 `2026`, `chromium-issues`, `self-issues` · Status `멘티 작업 진행 중`

**Description**

- 발견 경로: 코드 상향 — 09-23 만료 마일스톤 주석 스윕, 리눅스(ChromeOS) 전용 후보 V
- 배경: CRD(ChromeOS 원격 지원) 액세스 토큰에서 `oauth2:` 접두어를 걷어내는 마이그레이션. joedow@가 2025-02 `b7482bc0cf6ee`(https://crrev.com/c/6227399, «Removing LaCrOS and pre-M124 compat code», Bug 309958013)로 접두어 호환 코드를 지웠지만 두 곳이 남았다
  - `remoting/host/chromeos/remote_support_host_ash.cc:171-174` — «TODO(b/309958013): Remove this DCHECK after M122» + `DCHECK(!access_token.starts_with("oauth2:"))`
  - `remoting/host/chromeos/remote_support_host_ash_unittest.cc:349-357` — «TODO(b/309958013): Remove this test when we remove the oauth prefix logic» + `ValidLegacyAccessTokenFormatSucceeds`
- 트리는 M156. 두 TODO의 조건(M122 경과 · 접두어 로직 삭제)이 모두 충족됐다
- 수정: DCHECK와 주석 4줄, 테스트 10줄 삭제. 동작 불변(DCHECK는 릴리스 빌드에 없음). 약 −14줄, 2파일
- 트레일러: `Bug: b:309958013`
- 검증: ChromeOS 빌드(`target_os="chromeos"`, 리눅스 박스) `remoting_unittests --gtest_filter='*RemoteSupportHostAshTest*'`
- 선점: 파일 열린 CL은 오래 방치된 것뿐 · OSSCA 겹침 0
- 리뷰어: remoting/OWNERS — joedow@(원 CL 작성자) + yuweih@(원 CL 리뷰어)

**References**

- https://crsrc.org/c/remoting/host/chromeos/remote_support_host_ash.cc;l=171
- 앞선 CL: https://crrev.com/c/6227399
