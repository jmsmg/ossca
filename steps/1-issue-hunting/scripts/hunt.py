#!/usr/bin/env python3
"""이슈 후보 수집 + 1차 심사 원커맨드 (track.py의 앞단).

사용법:
  hunt.py todos <디렉토리>...        번호 붙은 TODO(crbug.com/N) 수집 (경로2: 코드 상향)
  hunt.py deprecated <디렉토리>...   "deprecated ... remove" 주석 달린 헤더 수집
  hunt.py expired <디렉토리>...      만료된 NotFatalUntil::M<n> (현재 MAJOR 미만) 수집
  hunt.py tracker <쿼리>             이슈 트래커 검색 추출 시도 — 보통 0건 (결과가 로그인 XHR 렌더링).
                                     실전은: UI에서 번호만 수집 → hunt.py triage 로 일괄 심사
  hunt.py triage <번호>...           후보 일괄 심사: 선점 CL / OSSCA 겹침 / 마지막 활동
  hunt.py spring <라벨> [repo]       Spring 저장소의 열린 이슈를 라벨로 수집 (기본 spring-projects/spring-boot)
                                     미할당·waiting-for-triage 아님 순으로 표시
"""
import os, re, signal, subprocess, sys, urllib.parse
signal.signal(signal.SIGPIPE, signal.SIG_DFL)
# 공용 track.py는 ~/ossca/scripts/ (이 파일 기준 ../../../scripts)
sys.path.insert(0, os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "..", "..", "scripts"))
import track  # http/gerrit 재사용

SRC = "/home/seonggoc/chromium/src"

def git_grep(pattern, dirs, glob=("*.h", "*.cc")):
    specs = [f":(glob){d.rstrip('/')}/**/{g}" for d in dirs for g in glob]
    cmd = ["git", "-C", SRC, "grep", "-n", pattern, "--"] + specs
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.stdout.splitlines()

def cmd_todos(*dirs):
    bugs = {}
    for line in git_grep("TODO(crbug.com/", dirs):
        m = re.search(r"TODO\(crbug\.com/(\d+)\)", line)
        if m:
            bugs.setdefault(m.group(1), []).append(line.split(":", 2))
    print(f"번호 붙은 TODO: 버그 {len(bugs)}개 ({', '.join(dirs)})")
    for n, locs in sorted(bugs.items(), key=lambda x: -len(x[1])):
        first = locs[0]
        print(f"  crbug {n} — {len(locs)}곳 (예: {first[0]}:{first[1]}) {first[2].strip()[:70]}")

def cmd_deprecated(*dirs):
    hits = git_grep("eprecated", dirs, glob=("*.h",))
    seen = set()
    print(f"deprecated 주석 후보 ({', '.join(dirs)}):")
    for l in hits:
        f, ln, txt = l.split(":", 2)
        if "remov" in txt.lower() or "instead" in txt.lower() or "crbug" in txt:
            key = (f, txt.strip()[:40])
            if key in seen: continue
            seen.add(key)
            print(f"  {f}:{ln} {txt.strip()[:85]}")

def cmd_expired(*dirs):
    major = int(re.search(r"MAJOR=(\d+)", open(f"{SRC}/chrome/VERSION").read()).group(1))
    from collections import Counter
    per_file, total = Counter(), 0
    for l in git_grep("NotFatalUntil::M", dirs):
        m = re.search(r"NotFatalUntil::M(\d+)", l)
        if m and int(m.group(1)) < major:
            f = l.split(":", 1)[0]
            per_file[(f, f"M{m.group(1)}")] += 1
            total += 1
    print(f"현재 MAJOR={major} — 그 미만 NotFatalUntil {total}곳 (이미 fatal, 정리 대상). 파일별:")
    for (f, ms), c in per_file.most_common():
        print(f"  {c:4d}  {ms}  {f}")

def cmd_tracker(query):
    url = "https://issues.chromium.org/issues?q=" + urllib.parse.quote(query)
    page = track.http(url, ua=True)
    # 임베드 데이터에서 (이슈번호, 제목) 휴리스틱 추출
    pairs, seen = [], set()
    for m in re.finditer(r'\[(\d{8,9}),.{0,400}?"((?:[^"\\]|\\.){15,140})"', page):
        n, t = m.group(1), m.group(2).encode().decode("unicode_escape", "ignore")
        if n not in seen and not t.startswith(("http", "/")):
            seen.add(n); pairs.append((n, t))
    print(f"트래커 '{query}': 추출 {len(pairs)}건 (휴리스틱 — 0건이면 UI에서 확인)")
    for n, t in pairs[:25]:
        print(f"  {n}  {t[:90]}")

def cmd_triage(*nums):
    print(f"일괄 심사 {len(nums)}건 — [선점CL / OSSCA겹침 / 마지막활동]")
    for n in nums:
        cls = track.gerrit(f"/changes/?q=bug:{n}")
        q = urllib.parse.quote(f"repo:OSSCA-chromium/contributions {n}")
        import json as _j
        gh = _j.loads(track.http(f"https://api.github.com/search/issues?q={q}&per_page=5"))
        overlap = gh.get("total_count", "?")
        try:
            page = track.http(f"https://issues.chromium.org/issues/{n}", ua=True)
            import datetime as _d
            ts = sorted({int(x) for x in re.findall(r"\b(1[4-9]\d{8})\b", page)
                         if 1400000000 < int(x) < _d.datetime.now().timestamp()})
            act = ts[-1] and f"{(_d.datetime.now().timestamp()-ts[-1])/86400:.0f}일 전" if ts else "?"
        except Exception:
            act = "조회실패"
        verdict = "✓ 후보" if not cls and not overlap else "✗ 탈락"
        detail = []
        if cls: detail.append(f"CL {len(cls)}건: " + ",".join(str(c['_number']) for c in cls[:3]))
        if overlap:
            it = gh["items"][0]
            detail.append(f"OSSCA {overlap}건: #{it['number']}({it['user']['login']}) — 본인 것/단순 언급일 수 있으니 확인")
        print(f"  {n}: {verdict}  [CL {len(cls)} / OSSCA {overlap} / 활동 {act}] {' — ' + '; '.join(detail) if detail else ''}")

def cmd_spring(label, repo="spring-projects/spring-boot"):
    import json as _j
    q = urllib.parse.quote(label)
    d = _j.loads(track.http(f"https://api.github.com/repos/{repo}/issues?labels={q}&state=open&per_page=60"))
    rows = []
    for i in d:
        if "pull_request" in i: continue
        labels = [l["name"] for l in i["labels"] if l["name"] != label]
        status = [l for l in labels if l.startswith("status:")]
        rows.append((bool(i.get("assignee")), bool(status), i, labels))
    rows.sort(key=lambda r: (r[0], r[1]))  # 미할당 + status 라벨 없는 것 먼저
    print(f"{repo} [{label}] 열린 이슈 {len(rows)}건 (미할당·상태라벨 없음 우선):")
    for assigned, has_status, i, labels in rows:
        mark = "✓" if not assigned and not has_status else ("담당자" if assigned else "상태")
        extra = ", ".join(l for l in labels if not l.startswith("type:"))[:45]
        print(f"  {mark:3} #{i['number']} {i['title'][:62]} (댓글 {i['comments']}, {i['created_at'][:10]}) {extra}")

CMDS = {"todos": cmd_todos, "spring": cmd_spring, "deprecated": cmd_deprecated, "expired": cmd_expired,
        "tracker": cmd_tracker, "triage": cmd_triage}

if __name__ == "__main__":
    if len(sys.argv) < 3 or sys.argv[1] not in CMDS:
        print(__doc__.strip()); sys.exit(1)
    CMDS[sys.argv[1]](*sys.argv[2:])
