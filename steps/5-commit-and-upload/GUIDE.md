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
- **`git cl upload`는 2회차부터 서버의 기존 설명을 재사용한다** (`-f` 없이도. 8351543 PS2에서 실제로 겪음:
  로컬 커밋 메시지에 문단을 추가하고 amend했는데 서버 설명은 그대로였다).
  로컬 커밋 메시지를 고쳤다면 업로드 후 설명을 따로 밀어 넣는다:
  ```bash
  git log -1 --format=%B | git cl description -n -
  ```
  이때 **메시지 전용 PS가 하나 더 생긴다** (코드 PS + 메시지 PS 쌍). 8351543이 PS2=코드, PS3=설명이 된 이유다
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
- **멘토는 CL에 넣지 않는다** (2026-09-08 결정). `~/contributions/CONTRIBUTING.md`에는
  "docs 폴더면 리뷰어에, 그 외 폴더면 CC에 추가"라는 체크리스트가 있지만 **따르지 않는다.**
  최근 CL(8336867·8351543·8349386)도 멘토를 넣지 않았다. 리뷰어 선정도 OWNERS 근거로 직접 정한다

## CQ / tryjob

- **CQ Dry Run은 tryjob 권한이 필요하고 컨트리뷰터에겐 없다** → 리뷰어에게 댓글로 부탁 (트라이잡 권한 신청 진행 중)
- 리뷰는 dry run과 무관하게 **WIP 해제 + 리뷰어 지정 시점부터** 진행된다
- 권한 신청 경로: https://www.chromium.org/getting-involved/become-a-committer/ (CLA + 진행 중 CL 필요)

## 기타

- 첫 기여라면 `src/AUTHORS`에 이름·이메일 추가 (알파벳 순, Gerrit/git 이메일과 동일)
- git 계정: Seonggon Cho <jmsmg1@me.com> — Gerrit 가입 이메일과 동일해야 함
- gitcookies 인증 경고 발생 중 → 언젠가 `git cl creds-check`로 전환 필요

## 트라이잡 권한 요청 (2026-09-07 발송)

CQ dry run을 매 패치셋마다 리뷰어에게 부탁하는 상황을 없애기 위한 절차.
**커미터 신청이 아니다** — 커미터 특권 목록 중 "trigger tryjobs" 한 줄만 미리 받는 별도의 낮은 단계다.

### 절차 (문서 원문 기준)

@chromium.org 주소가 없으면 **본인이 신청할 수 없다.**

> Ask someone you're working with (a frequent reviewer, for example) to send email to
> **accounts@chromium.org** nominating you for try job access. You must provide an email address
> and at least a brief explanation of why you'd like access. It is helpful to provide a name and
> company affiliation (if any) as well. It is **very helpful to have already had some patches
> landed**, but is not absolutely necessary. If **no one objects within two (U.S.) working days**,
> you will be approved.

- 승인은 **이의 제기 방식(lazy consensus)** — 떨어질 위험은 거의 없고, **추천 메일이 안 나가는 것**이 유일한 리스크다.
  그래서 문안의 목표는 "심사에 잘 보이기"가 아니라 **추천인이 5분 안에 복사해 보낼 수 있게 만드는 것**
- `accounts@chromium.org`로 **직접 보내면 안 된다** (추천인이 보내야 함)
- 전달은 **Gerrit 코멘트가 아니라 메일로.** CL에 코멘트를 달면 내용과 무관하게 알림·attention이 갱신돼
  리뷰 재촉과 구분이 안 된다

### 보낸 문안 (2026-09-07, → smcgruer@chromium.org)

```
Subject: Try job access nomination request (Seonggon Cho / jmsmg1@me.com)

Hi Stephen,

Seonggon Cho here — I've been sending CLs to //components/payments; you reviewed 8278112
and landed 8336867, and 8351543 and 8349386 are with you at the moment.

I don't have try-job access, so I've been leaning on reviewers to run CQ dry runs for me.
Would you be willing to nominate me? The instructions just ask for an email to
accounts@chromium.org with an address and a short reason — here's everything you'd need:

  Name:        Seonggon Cho
  Email:       jmsmg1@me.com
  Affiliation: none — individual contributor
  Landed CLs:  8146619, 8264232, 8278112, 8282239, 8336867
  Reason:      Would like to run CQ dry runs without asking a reviewer each time.
               An upcoming CL touches Mac and Windows test files that can't be built
               on Linux, so it would otherwise need a dry run on every patchset.

No rush, and no worries if you'd rather not.

Thanks for the reviews so far,
Seonggon Cho
```

- 보낸 계정은 **`jmsmg1@me.com`** — Gerrit 계정이자 추천 대상 주소라 본문과 일치해야 한다
  (crbug 코멘트가 `조성곤 <jmsmg4@gmail.com>`으로 나갔던 것과 같은 불일치를 피한다)
- 첫 줄 `Seonggon Cho here —` : 상대가 Gerrit에서 나를 알지만 **메일 주소는 낯선** 상황의 관용구.
  `My name is...`는 초면 톤이라 오히려 거리감, `This is...`는 전화 말투
- 영어 메일에서 과한 사과·완곡은 정중함이 아니라 불안정하게 읽힌다. `No rush, and no worries if you'd rather not.` 한 줄이면 충분

### 회신이 없으면

일주일 기준. 백업 추천인은 evanstade@microsoft.com · stevebe@microsoft.com (8282239 리뷰·CQ),
**추천인은 한 명이면 되므로 동시에 여러 명에게 보내지 않는다.**
smcgruer는 월~목 근무(금요일 활동 2%)이므로 회신 지연을 셀 때 `track.py who`로 근무일을 세어본다
(6단계 GUIDE «재촉하기 전에» 절).

### 현황 (2026-09-11 금요일)

- 발송 09-07(월). smcgruer의 근무일로 **월·화·수·목 4일 경과**, 회신 없음
- 그 사람은 계속 일하고 있다 (마지막 활동 **09-10 23:20Z**) → 못 본 게 아니라 우선순위 뒤
- **일주일 기준은 09-14(월)**. 금요일은 그 사람 활동이 2%이므로 오늘 보내면 어차피 월요일에 읽힌다
  → **재촉하지 않고 09-14(월)에 판단한다**

**백업 추천인의 무게가 바뀌었다.** 이 문단을 쓸 때 evanstade@는 «8282239를 리뷰한 사람»일 뿐이었는데,
그 뒤 **8377550에 `CR+1`(09-10)**, **8377022에 실질 리뷰**를 줬고 **하루 안에 응답**했다.
지금은 smcgruer보다 반응이 빠른 리뷰어다.

그리고 8377022의 답글에 «LUCI를 확인 못 했다, try-job 권한이 없어서»라고 **정직하게 쓰게 된다** —
꾸며낸 명분이 아니라 그가 던진 질문에 대한 사실 그대로의 답이다. 그 답을 본 뒤에도 09-14까지 smcgruer의
회신이 없으면, evanstade@에게 보내는 것이 자연스럽다.

