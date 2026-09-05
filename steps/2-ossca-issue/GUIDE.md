# 2단계 — OSSCA GitHub 이슈 등록

| | |
|---|---|
| **입력** | 검증을 통과한 crbug 번호 ([1단계](../1-issue-hunting/GUIDE.md)) |
| **출력** | OSSCA `contributions` 저장소의 이슈 번호 + self-assign |
| **완료 조건** | 이슈 등록 · 라벨 · Assignee 지정 · Status `멘티 작업 진행 중` |
| **산출물 보관** | 이슈 본문 드래프트는 [`drafts/<crbug>.md`](drafts/) |
| **다음 단계** | [3단계 — 브랜치 및 수정](../3-branch-and-fix/GUIDE.md) |
| **현황** | [STATUS.md](STATUS.md) |

> ⚠️ **등록·댓글 게시는 사용자가 직접 한다.** 여기 문서와 `drafts/`는 문안까지만 만든다.

---

## 등록 절차

1. https://github.com/OSSCA-chromium/contributions/issues → **New issue**
2. 템플릿: **"crbug 에서 찾은 이슈 등록"**
3. 제목: `[crbug번호] 이슈 제목` (crbug 원 제목을 그대로 쓰되 길면 요지로 줄임)
4. 라벨: `2026`, `chromium-issues`, 직접 발굴한 이슈면 `self-issues`
5. **Assignees에 본인 self-assign** — 이슈당 1인 선착순. assign 후 작업 시작
6. Status 전이는 진행에 맞춰 직접 갱신:
   `멘티 작업 진행 중` → `멘토 리뷰 중` → `gerrit 리뷰 중` → `반영 완료`

## 이슈 본문 형식 (drafts/ 에 쌓인 실제 형식)

```markdown
제목: [<crbug>] <영문 이슈 제목>

**Bug**

- https://crbug.com/<crbug>

**Documents**

- (배경) 이 코드가 무슨 일을 하는지 한두 줄
- (근거) 스펙 조항·헤더 주석·TODO 원문을 인용문으로 붙임
- (실체) 현재 구현이 그 근거와 어떻게 어긋나는지, 파일:함수 단위로 지목
- (선행 증거) WPT baseline의 알려진 실패, 자매 이슈, blocking 관계 등
```

- 근거는 **인용**으로 넣는다. "스펙과 다르다"가 아니라 스펙 문장을 그대로 옮긴다
  (`545843242.md`가 `If manifest_links's size is not 1, then return failure.`를 인용한 방식).
- 코드 지목은 `파일경로::함수()` 형태로 — 리뷰어가 바로 열 수 있게.

## 클레임 댓글이 필요한 경우 (1단계 판정과 연결)

| 이슈 상태 | 처리 |
|---|---|
| 휴면 (미할당 + 연결 CL 0 + 수개월 무활동) | 클레임 없이 **CL 직행** 가능 |
| 헤더에 "deprecated and will be removed" 등 명시적 정리 지시 | 클레임 불필요 (40831207) |
| 팀이 활발히 보는 이슈 | 먼저 **클레임 댓글**로 작업 의사 표시 (545645933) |
| 방향 자체가 설계 판단인 이슈 (재작성·API 변경) | **의사 타진 댓글** 후 답변 대기, 긍정이면 등록 (41396598) |

## 상위 규칙 (업스트림 CONTRIBUTING)

착수 전 1회성으로 끝내는 것들 — `~/contributions/CONTRIBUTING.md` 원문:

- CLA 동의 (https://cla.developers.google.com/about/google-individual)
- chromium-review 가입, `git config user.name/user.email`을 **Gerrit 가입 이메일과 동일**하게
- 모든 건 실명(영문)으로
- 진행하며 작업 내용을 이슈 댓글로 남기기 (멘토 확인 경로)
- 멘토: 임의상 (eui-sang.lim@samsung.com) — docs 폴더면 리뷰어에, 그 외 폴더면 CC에 추가
