# 5단계 — 커밋 및 업로드

| | |
|---|---|
| **입력** | 빌드·테스트 통과한 브랜치 ([4단계](../4-build-and-test/GUIDE.md)) |
| **출력** | Gerrit CL 번호 + PS1, 리뷰어 지정, WIP 해제 |
| **완료 조건** | `track.py verify <CL> <PS>`로 서버 패치셋 = 로컬 HEAD 확인 |
| **다음 단계** | [6단계 — 리뷰 대응](../6-review/GUIDE.md) · [7단계 — 기여 기록](../7-contribution-record/GUIDE.md) (업로드 직후 병행) |
| **현황** | [STATUS.md](STATUS.md) |

> ⚠️ **`git cl upload`는 원격 공개다. 사용자 승인 없이 실행하지 않는다.**

---

## 커밋 메시지 (Gerrit용)

```
[payments] Fix something

본문은 72자에서 줄바꿈. 왜 바꾸는지, 기존 동작이 무엇이었고
무엇이 달라지는지, 시리즈의 일부라면 그 맥락.

Fixed: <crbug번호>
```

- **semantic prefix 금지** (`fix:` `feat:` `chore:` 안 씀). 대신 `모듈명` prefix —
  `[payments] Add ...` / `payments: Add ...` / `[CSS] Fix ...`. `이름:` 형태는 Gerrit에서 태그가 된다
- 제목 다음 **빈 줄 필수** (없으면 `git log --oneline`에서 본문이 다 붙는다)
- 첫 단어는 현재형 동사(Add/Fix/Implement/Move/Migrate), 첫 글자 대문자, 마침표 없이

### `Fixed:` vs `Bug:`

| 트레일러 | 효과 | 쓰는 때 |
|---|---|---|
| `Fixed: <번호>` | 머지 시 crbug **자동 close** | 이 CL로 이슈가 끝날 때 |
| `Bug: <번호>` | 링크만 | 시리즈의 일부, 또는 이슈의 부수 항목만 처리할 때 (40681786) |

### 업로드 전 필수 검사 — AI 흔적

```bash
git log -1 --format=%B | grep -iE 'co-authored|claude|generated'
```

**아무것도 나오지 않아야 한다.** Chromium CL에는 AI 흔적 라인을 넣지 않는다.

## 업로드

```bash
git cl format                          # 변경이 생기면 git commit --amend --no-edit
git cl upload -r <리뷰어> --send-mail  # 리뷰어 지정 + WIP 없이 바로 리뷰 시작
```

- WIP로 올라갔으면 Gerrit UI에서 **Start Review**
- **`git cl upload -f`는 서버의 기존 설명을 재사용한다.** 로컬 커밋 메시지를 고쳤다면 업로드 후:
  ```bash
  git log -1 --format=%B | git cl description -n -
  ```
  이때 메시지 전용 PS가 하나 더 생긴다 (코드 PS + 메시지 PS 쌍)
- 업로드 후 서버=로컬 검증 (해당 브랜치 체크아웃 상태에서):
  ```bash
  python3 ~/ossca/scripts/track.py verify <CL번호> <PS>
  ```

### `track.py` 서브커맨드

| 명령 | 용도 |
|---|---|
| `track.py cl <CL>` | CL 상태 요약 (PS, 리뷰어, 표, attention, 최근 메시지) |
| `track.py bug <crbug>` | 그 버그에 연결된 CL 목록 (선점 확인) |
| `track.py file <경로>` | 그 파일을 건드리는 열린 CL (충돌 예보) |
| `track.py ossca <검색어>` | OSSCA 저장소 이슈/PR 검색 (겹침 확인) |
| `track.py crbug <crbug>` | 이슈 트래커 활동 타임스탬프 (답변 왔는지) |
| `track.py comments <CL> [날짜]` | 그 날짜 이후 달린 코멘트 |
| `track.py verify <CL> <PS>` | 서버 패치셋 = 로컬 HEAD 검증 |

## 리뷰어 선정

기본 공식: 해당 디렉토리 `OWNERS` ∩ 최근 활동자

```bash
git log --format='%an %ae' -10 -- <파일>
```

- **payments는 예외**: 초기 리뷰는 개인이 아니라 **`chrome-payments-reviews@google.com`** 알리아스로 지정
  (darwinyang이 8336867에서 안내, 2026-09-01). OWNERS: smcgruer@, slobodan@, darwinyang@ (chromium.org)
- 멘토(eui-sang.lim@samsung.com): docs 폴더면 리뷰어에, 그 외 폴더면 CC에 추가
- 리뷰어를 정했으면 GitHub 이슈 댓글로 멘토에게 먼저 확인받는 것이 프로그램 절차

## CQ / tryjob

- **CQ Dry Run은 tryjob 권한이 필요하고 컨트리뷰터에겐 없다** → 리뷰어나 멘토에게 댓글로 부탁
- 리뷰는 dry run과 무관하게 **WIP 해제 + 리뷰어 지정 시점부터** 진행된다
- 권한 신청 경로: https://www.chromium.org/getting-involved/become-a-committer/ (CLA + 진행 중 CL 필요)

## 기타

- 첫 기여라면 `src/AUTHORS`에 이름·이메일 추가 (알파벳 순, Gerrit/git 이메일과 동일)
- git 계정: Seonggon Cho <jmsmg1@me.com> — Gerrit 가입 이메일과 동일해야 함
- gitcookies 인증 경고 발생 중 → 언젠가 `git cl creds-check`로 전환 필요
