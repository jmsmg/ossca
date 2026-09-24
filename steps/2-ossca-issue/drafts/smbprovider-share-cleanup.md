제목: [1258424] Remove the unsupported smbprovider share cleanup from file_system_provider::Service::RestoreFileSystems() ("remove around M108")

템플릿: **crbug 에서 찾은 이슈 등록** · 라벨 `2026`, `chromium-issues` · Status `멘티 작업 진행 중`
⚠️ **등록 전 보류 권장** — 아래 «위험» 참고. OWNER에게 먼저 묻는 편이 낫다. 옛 번호 1258424의 새 ID는 issues.chromium.org에서 확인 후 제목에 반영

**Bug**

- https://crbug.com/1258424

**Documents**

- `chrome/browser/ash/file_system_provider/service.cc:396-408`: «TODO(crbug.com/1258424): Remove this and conditional below around M108» — `@smb` 제공자로 복원되는 파일 시스템을 마운트하지 않고 레지스트리에서 지운다(`ForgetFileSystem`)
- 도입 CL `bd81ca80bec4f`(Josh Simmons, 2021-10): smbprovider 공유 마운트 지원이 없어진 뒤에도 레지스트리에 남은 공유 메타데이터 때문에 **Files 앱이 시작 시 멈춤** → 정리 코드 추가
- 트리는 M156, M108에서 48 마일스톤 경과

**Description**

- 발견 경로: 코드 상향 — 09-23 만료 마일스톤 주석 스윕, 리눅스(ChromeOS) 전용 후보 Y
- 수정: `is_smb_provider` 변수와 조건 블록 삭제. 약 −12줄, 1파일
- **위험(동작 변화)**: `SmbProvider`는 아직 `@smb` ID로 등록된다(`smb_client/smb_service.cc:583`), 즉 이 복원 경로는 지금도 돈다. 블록을 지우면 2021년 이후 한 번도 로그인하지 않은 프로필에 남은 옛 항목이 «삭제» 대신 마운트 경로로 가서, 원 CL이 막았던 Files 앱 멈춤이 다시 날 수 있다. 순수 죽은 코드 삭제가 아니다
- 검증: ChromeOS 빌드 `unit_tests --gtest_filter='FileSystemProviderServiceTest.*'` (smb 경로를 직접 검사하는 테스트는 없음)
- 선점: OSSCA 겹침 0
- 리뷰어: chrome/browser/ash/file_system_provider/OWNERS → ui/file_manager/OWNERS

**References**

- https://crsrc.org/c/chrome/browser/ash/file_system_provider/service.cc;l=396
