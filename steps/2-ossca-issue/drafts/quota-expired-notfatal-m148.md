제목: [storage/browser/quota] Remove expired NotFatalUntil::M148 from 153 quota CHECKs

템플릿: **직접 찾은 이슈 등록** (crbug 없음) · 라벨 `2026`, `self-issues` (템플릿이 자동 부착) · self-assign
Status: **`gerrit 리뷰 중`** (CL 8377550 PS2, evanstade@ `Code-Review +1`, CQ 대기)
`## Issue` 헤딩과 맨 아래 안내문은 지운다.

**Description**

- 발견 경로: 코드 상향 — 만료된 `base::NotFatalUntil` 사용처를 마일스톤 단위로 전 트리에 집계했다. M148은 157곳 중 **153곳이 `//storage/browser/quota` 한 디렉토리**에 몰려 있어 OWNERS 한 그룹으로 끝나는 정리 대상이다. crbug에는 이 정리에 대한 이슈가 없다
- 배경: 2026-02 https://crrev.com/c/7601393 이 `//storage/browser/quota`의 `DCHECK`를 `CHECK(cond, base::NotFatalUntil::M148)`로 바꿨다. M148 전까지 덤프만 남기고 죽지 않게 해서 더 엄격한 검사를 단계적으로 켜는 장치다
- 판정 로직(`base/check.cc`)은 지정 마일스톤이 현재 마일스톤 이하이면 그냥 `LOGGING_FATAL`이다. `chrome/VERSION`의 MAJOR가 155이므로 이 CHECK들은 이미 7개 마일스톤째 fatal이고 인자는 효과 없이 남아 있다. `base/not_fatal_until.h`는 이미 fatal이 된 인자를 CHECK와 목록 양쪽에서 지우라고 명시한다 — 공식 빌드에서 로그 문자열을 버려 CHECK가 더 작아진다
- 수정 내용(CL 1): 10파일의 CHECK 153곳에서 `, base::NotFatalUntil::M148` 인자만 제거(+154/−160). 조건식과 스트림 메시지는 그대로이며 동작 변화 없음(이미 fatal, 앞으로도 fatal)
- 후속(CL 2): 트리에 남은 4곳(`components/signin`, `media/audio/win` 2곳, `services/resource_coordinator`)과 `not_fatal_until.h`의 `M148 = 148,` 삭제. OWNER가 3그룹으로 갈리고 `media/audio/win`은 Linux 빌드 불가라 분리했다. 이 이슈는 CL 2까지 열어 둔다
- 판단 근거: 더 큰 M152(759곳)는 진행 중인 `[dcheck-to-check]` 프로젝트의 일부라 손대지 않았다. M148은 storage 팀의 일회성 롤아웃이고, 이미 머지된 https://crrev.com/c/8282239 가 같은 근거로 `QuotaDatabase` 트랜잭션 CHECK에서 M148을 제거한 선례가 있다. 선점 확인: `message:"NotFatalUntil" status:open` 검색에 M148 정리 CL 없음
- 검증: 동작 불변 정리라 기존 테스트 통과가 검증 — `storage_unittests` quota 필터 313/313. 이 검증 중에 발견한 무관한 순서 의존 크래시는 별도 이슈/CL(https://crrev.com/c/8377022)로 처리했다
- 리뷰: evanstade@가 하루 안에 `+1`과 함께 «커밋 메시지 본문이 불필요하다»는 nit → 본문을 두 문장으로 줄여 PS2

**References**

- Gerrit: https://crrev.com/c/8377550
- 헤더 지시: https://crsrc.org/c/base/not_fatal_until.h;l=14 · 판정: https://crsrc.org/c/base/check.cc;l=69
- 원 롤아웃 CL: https://crrev.com/c/7601393 · 선례: https://crrev.com/c/8282239
- 같은 계열 기여(M143): https://crrev.com/c/8366188
