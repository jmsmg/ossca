#!/bin/bash
# #441 WebAuthn iCloud Keychain 플래그 제거 검증. 빌드 트리가 M144(8409786) 헤더 상태라 전 트리 재빌드를 피하려고
# 검증 전용 브랜치 verify-441-with-m144(= #441 브랜치 + M144 cherry-pick)에서 unit_tests 증분 빌드 → 테스트.
# 업로드는 깨끗한 webauthn-icloud-keychain-flags 브랜치에서 한다.
unset CLAUDECODE AI_AGENT CLAUDE_CODE_SSE_PORT CLAUDE_CODE_ENTRYPOINT
export PATH="$PATH:$HOME/depot_tools"
L="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)/logs"; mkdir -p "$L"
M="$L/webauthn_done.marker"; rm -f "$M"
cd "$HOME/chromium/src" || exit 1
git checkout -q verify-441-with-m144 || { echo "CHECKOUT_FAILED" >> "$M"; echo END >> "$M"; exit 1; }
autoninja -C out/Default unit_tests > "$L/webauthn_build.log" 2>&1
echo "BUILD=$?" >> "$M"
if grep -q 'Build Succeeded' "$L/webauthn_build.log"; then
  out/Default/unit_tests --gtest_filter='ChromeAuthenticatorRequestDelegate*' > "$L/webauthn_test.log" 2>&1
  echo "TEST=$?" >> "$M"
fi
git checkout -q webauthn-icloud-keychain-flags
echo END >> "$M"
