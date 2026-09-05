# 7단계 — 기여 기록 (contributions repo)

| | |
|---|---|
| **입력** | 업로드된 CL 번호 ([5단계](../5-commit-and-upload/GUIDE.md)) — **업로드 직후 병행** |
| **출력** | `data/contributions/<CL번호>.md` + PR (`status: in review`) |
| **완료 조건** | CI 통과 + PR 머지 |
| **작업 위치** | `$CONTRIBUTIONS_DIR` (origin: 내 fork `$GITHUB_USER`, upstream: OSSCA-chromium) |
| **다음 단계** | [8단계 — 머지 후 마무리](../8-after-merge/GUIDE.md) |
| **현황** | [STATUS.md](STATUS.md) · 예시 [examples/status/7-contribution-record.md](../../examples/status/7-contribution-record.md) |

> ⚠️ **`git push` / PR 생성은 원격 공개다 — 멘티 본인이 직접 한다.** AI 에이전트는 기록 파일·로컬 커밋까지만, 사용자 승인 없이 push하지 않는다.

---

## 절차

```bash
cd $CONTRIBUTIONS_DIR
git checkout main && git pull
git checkout -b <YYMMDD>-add-<CL번호> upstream/main
cp data/contributions/template.md data/contributions/<CL번호>.md   # 내용 채우기, 템플릿 주석 전부 제거
npm run validate:data && npm run lint:md
git add . && git commit -m "contributions: Add <CL번호>"
git push origin <브랜치>
# PR 생성: https://github.com/OSSCA-chromium/contributions/compare/main...$GITHUB_USER:<브랜치>
```

- 파일명은 **Chromium Review ID** (= CL 번호)
- frontmatter는 `status: in review`로 시작 → 머지되면 8단계에서 `merged`로 갱신
- PR 제목: `contributions: Add <CL번호>`
- PR 본문: `## Summary` + `## 관련 이슈` (OSSCA 이슈 번호 + gerrit 링크)
- **로컬 커밋은 한 줄이면 된다** — upstream 로그의 본문과 `(#PR번호)`는 squash merge가 자동으로 만든다

## 이 저장소의 커밋 메시지 규칙 (Gerrit과 다름!)

여기는 **semantic prefix를 쓴다.** Chromium CL 규칙과 정반대이니 헷갈리지 말 것.

| 변경 대상 | prefix |
|---|---|
| 사이트 코드 (`src/`, `scripts/`, 설정, 테스트) | `feat:` `fix:` `refactor:` `chore:` `test:` |
| 기여 기록 (`data/contributions/**`) | `contributions:` |
| 프로그램 데이터 (그 외 `data/**` — 회의록, 문서 번역) | `data:` |
| 저장소 문서 (README, CONTRIBUTING 등) | `docs:` |

- prefix 뒤 제목은 현재형 동사, 첫 글자 대문자, 마침표 없이, 72자 줄바꿈
- 예: `contributions: Add 6520751`, `data: Add meeting note 2026-07-25`

## CI — 로컬에서 같은 순서로 먼저 돌린다

`.github/workflows/pr-checks.yml`이 PR에서 실행하는 순서:

```
npm ci → npm test → npm run lint → npm run validate:data → npm run lint:md → npm run build
```

## 사이트 구조 메모 (`$CONTRIBUTIONS_DIR/CLAUDE.md` 요약)

- `data/` 아래 마크다운이 **source of truth**. `src/lib/*` 로더가 빌드 타임에 `fs` + `gray-matter`로 읽는다
- 정적 export(GitHub Pages)라 런타임 서버가 없다 → 정렬·필터·검색은 전부 클라이언트 컴포넌트(`'use client'`)
- **basePath 함정**: 모든 라우트가 `/contributions/...` 아래. 개발 서버는
  `http://localhost:3000/contributions/`로 열어야 한다 (`/`는 404)
- 공식 가이드: https://ossca-chromium.github.io/contributions/docs/contribution-record/
