#!/usr/bin/env python3
"""이슈/CL 추적 원커맨드 — 토큰 절약용 요약 출력.

사용법:
  track.py cl <CL번호>              Gerrit CL 상태 요약 (PS, 리뷰어, 표, attention, 최근 메시지)
  track.py bug <crbug번호>          해당 버그에 연결된 CL 목록 (선점 확인)
  track.py file <경로>              그 파일을 건드리는 열린 CL (충돌 예보)
  track.py ossca <검색어>           OSSCA contributions 저장소 이슈/PR 검색 (겹침 확인)
  track.py crbug <crbug번호>        이슈 트래커 활동 타임스탬프 (답변 왔는지)
  track.py comments <CL번호> [날짜] 그 날짜(기본 오늘) 이후 달린 코멘트
  track.py verify <CL번호> <PS>     서버 패치셋 = 로컬 HEAD 검증 (~/chromium/src에서)
"""
import json, re, signal, subprocess, sys, urllib.parse, urllib.request
signal.signal(signal.SIGPIPE, signal.SIG_DFL)
from datetime import datetime, timezone

GERRIT = "https://chromium-review.googlesource.com"
SRC = "/home/seonggoc/chromium/src"

def http(url, ua=False):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"} if ua else {})
    return urllib.request.urlopen(req, timeout=30).read().decode("utf-8", "ignore")

def gerrit(path):
    return json.loads(http(GERRIT + path)[5:])  # )]}' 프리픽스 제거

def who(a):  # 계정 → 짧은 표기
    return a.get("email") or a.get("name") or "?"

def cmd_cl(n):
    d = gerrit(f"/changes/{n}?o=CURRENT_REVISION&o=DETAILED_LABELS&o=DETAILED_ACCOUNTS&o=MESSAGES")
    rev = d["revisions"][d["current_revision"]]
    print(f"CL {n} PS{rev['_number']} [{d['status']}{' WIP' if d.get('work_in_progress') else ''}] {d['subject']}")
    print(f"  커밋 {d['current_revision'][:13]} / 갱신 {d['updated'][:16]}")
    cr = d.get("labels", {}).get("Code-Review", {})
    votes = [f"{who(v)}:{v['value']:+d}" for v in cr.get("all", []) if v.get("value")]
    print(f"  CR 표: {', '.join(votes) if votes else '없음'}")
    print(f"  리뷰어: {', '.join(who(a) for a in d.get('reviewers', {}).get('REVIEWER', []))}")
    att = d.get("attention_set") or {}
    print(f"  attention: {', '.join(who(v['account']) for v in att.values()) or '없음'}")
    print(f"  코멘트: 미해결 {d.get('unresolved_comment_count', 0)}/{d.get('total_comment_count', 0)}")
    for m in d.get("messages", [])[-3:]:
        first = m["message"].strip().splitlines()[0][:80] if m["message"].strip() else ""
        print(f"  [{m['date'][:16]}] {who(m['author'])}: {first}")

def cmd_bug(n):
    ds = gerrit(f"/changes/?q=bug:{n}&o=DETAILED_ACCOUNTS")
    print(f"bug:{n} 연결 CL {len(ds)}건" + (" — 선점 없음 ✓" if not ds else ""))
    for c in ds:
        print(f"  {c['_number']} [{c['status']}] {c['subject'][:70]} — {who(c['owner'])} ({c['updated'][:10]})")

def cmd_file(path):
    q = urllib.parse.quote(f"file:{path} status:open", safe=":")
    ds = gerrit(f"/changes/?q={q}&o=DETAILED_ACCOUNTS")
    print(f"{path} 를 건드리는 열린 CL {len(ds)}건")
    for c in ds:
        print(f"  {c['_number']} {c['subject'][:70]} — {who(c['owner'])} ({c['updated'][:10]})")

def cmd_ossca(term):
    q = urllib.parse.quote(f"repo:OSSCA-chromium/contributions {term}")
    d = json.loads(http(f"https://api.github.com/search/issues?q={q}&per_page=20"))
    if "items" not in d:
        print("API 오류:", str(d)[:200]); return
    print(f"OSSCA '{term}' 검색: {d['total_count']}건" + (" — 겹침 없음 ✓" if not d["total_count"] else ""))
    for i in d["items"]:
        print(f"  #{i['number']} [{i['state']}] {i['title'][:72]} — {i['user']['login']} ({i['created_at'][:10]})")

def cmd_crbug(n):
    page = http(f"https://issues.chromium.org/issues/{n}", ua=True)
    title = re.search(r"<title>(.*?)</title>", page, re.S)
    if title:
        print(re.sub(r"\s+", " ", title.group(1)).strip()[:100])
    ts = sorted({int(x) for x in re.findall(r"\b(1[4-9]\d{8})\b", page)
                 if 1400000000 < int(x) < datetime.now(timezone.utc).timestamp()})
    if not ts:
        print("타임스탬프 추출 실패 — 페이지를 직접 확인할 것"); return
    fmt = lambda t: datetime.fromtimestamp(t, timezone.utc).strftime("%Y-%m-%d %H:%M")
    print(f"이벤트 타임스탬프 {len(ts)}개 (UTC, 추정): 최초 {fmt(ts[0])} / 마지막 활동 {fmt(ts[-1])}")
    days = (datetime.now(timezone.utc).timestamp() - ts[-1]) / 86400
    print(f"마지막 활동 이후 {days:.0f}일 경과")

def cmd_comments(n, since=None):
    since = since or datetime.now(timezone.utc).strftime("%Y-%m-%d")
    d = gerrit(f"/changes/{n}/comments")
    rows = [(f, c) for f, cs in d.items() for c in cs if c["updated"][:10] >= since]
    print(f"CL {n} — {since} 이후 코멘트 {len(rows)}건")
    for f, c in sorted(rows, key=lambda x: x[1]["updated"]):
        loc = f"{f}:{c['line']}" if c.get("line") else f
        u = "미해결!" if c.get("unresolved") else "resolved"
        print(f"  [{c['updated'][:16]}] {who(c.get('author', {}))} ({loc}, {u})")
        print(f"    {c.get('message', '')[:250]}")

def cmd_verify(n, ps):
    ref = f"refs/changes/{str(n)[-2:]}/{n}/{ps}"
    def git(*a):
        return subprocess.run(["git", "-C", SRC] + list(a), capture_output=True, text=True)
    r = git("fetch", "https://chromium.googlesource.com/chromium/src", ref)
    if r.returncode:
        print("fetch 실패:", r.stderr.strip()[-200:]); return
    stat = git("diff", "--stat", "FETCH_HEAD", "HEAD").stdout.strip()
    print(f"PS{ps} vs 로컬 HEAD 파일 diff: {'없음 — 동일 ✓' if not stat else chr(10) + stat}")
    a = git("log", "-1", "--format=%B", "FETCH_HEAD").stdout.splitlines()
    b = git("log", "-1", "--format=%B", "HEAD").stdout.splitlines()
    extra = [l for l in set(a) ^ set(b) if l.strip()]
    ok = all(l.startswith(("R=", "Change-Id:")) for l in extra)
    print("메시지 diff: " + ("자동 라인(R=/Change-Id)만 — 정상 ✓" if ok and extra else
                             "완전 동일 ✓" if not extra else "차이 있음! → " + " | ".join(extra[:5])))

CMDS = {"cl": cmd_cl, "bug": cmd_bug, "file": cmd_file, "ossca": cmd_ossca,
        "crbug": cmd_crbug, "comments": cmd_comments, "verify": cmd_verify}

if __name__ == "__main__":
    if len(sys.argv) < 3 or sys.argv[1] not in CMDS:
        print(__doc__.strip()); sys.exit(1)
    CMDS[sys.argv[1]](*sys.argv[2:])
