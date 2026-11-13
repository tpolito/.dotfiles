#!/usr/bin/env bash
# Shared PII scan used by the backup-*.sh scripts before they copy a config
# directory into this repo. Not meant to be run directly — source it and
# call scan_for_pii().

# scan_for_pii <dir>
# Prints any matches found and returns non-zero if hard-block patterns
# (emails, private keys, hardcoded secrets, non-generic home paths) are
# present anywhere under <dir>. IPv4 addresses are reported as a soft
# warning only, since they show up in legitimate config (e.g. VPN ranges)
# too often to hard-block on.
scan_for_pii() {
  local dir="$1"
  local found=0

  local email_re='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
  local key_re='-----BEGIN (RSA |OPENSSH |EC |DSA |)PRIVATE KEY-----'
  local secret_re='(api[_-]?key|apikey|secret|token|passwd|password)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9]'
  local home_re='/home/[A-Za-z0-9_-]+'
  local ipv4_re='([0-9]{1,3}\.){3}[0-9]{1,3}'

  local matches
  if matches=$(grep -rniE "$email_re" "$dir" 2>/dev/null); then
    echo "-- possible email address(es):"; echo "$matches"; found=1
  fi
  if matches=$(grep -rlE "$key_re" "$dir" 2>/dev/null); then
    echo "-- possible private key file(s):"; echo "$matches"; found=1
  fi
  if matches=$(grep -rniE "$secret_re" "$dir" 2>/dev/null); then
    echo "-- possible hardcoded secret/token/password:"; echo "$matches"; found=1
  fi
  if matches=$(grep -rnE "$home_re" "$dir" 2>/dev/null | grep -vE "/home/$(whoami)([^A-Za-z0-9_-]|$)"); then
    echo "-- hardcoded path under a different user's home dir:"; echo "$matches"; found=1
  fi
  if matches=$(grep -rnE "$ipv4_re" "$dir" 2>/dev/null); then
    echo "-- (warning, not blocking) possible IPv4 address(es), review manually:"; echo "$matches"
  fi

  return $found
}
