제목: [<crbug>] <영문 이슈 제목 — crbug 원 제목을 그대로, 길면 요지로 줄임>

> OSSCA `contributions` 저장소 이슈 본문 문안. 이슈 템플릿 "crbug 에서 찾은 이슈 등록"에 맞춘 형식.
> 등록은 본인이 직접 한다 (2단계 GUIDE). 채워진 예시: [`../../../examples/drafts/`](../../../examples/drafts/)
> 이 파일을 `drafts/<crbug>.md`로 복사한 뒤 이 인용 블록은 지운다.

**Bug**

- https://crbug.com/<crbug>

**Documents**

- (배경) 이 코드가 무슨 일을 하는지 한두 줄
- (근거) 스펙 조항 · 헤더 주석 · TODO 원문을 **인용문**으로 — "스펙과 다르다"가 아니라 스펙 문장을 그대로 옮긴다
  > <인용>
- (실체) 현재 구현이 그 근거와 어떻게 어긋나는지 — `파일경로::함수()` 단위로 지목 (리뷰어가 바로 열 수 있게)
- (선행 증거) WPT baseline의 알려진 실패, 자매 이슈, blocking 관계 등

**Description**

- 발굴 경위 — 선점 CL · OSSCA 겹침 없음, 휴면 n일 / 클레임 댓글 여부
- 수정 내용 — 무엇을 어떻게, 범위 밖으로 남긴 것과 이유
- 검증 — TDD면 "수정 전 FAILED → 수정 후 N/N 통과"
- 리뷰어 선정 근거

**References**

- CL: https://crrev.com/c/<CL번호>
- 해당 코드: https://crsrc.org/c/<경로>
- 스펙 / 관련 CL / WPT
