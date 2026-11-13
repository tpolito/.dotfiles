#!/usr/bin/env bash
# Run every backup-*.sh script in this repo (except this one).
#
# Usage:
#   ./backup.sh            # run all backups
#   ./backup.sh --dry-run  # forward --dry-run to every backup script

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SELF="$(basename "$0")"

ARGS=("$@")
FAILED=()

for script in "$ROOT"/backup-*.sh; do
  name="$(basename "$script")"
  [[ "$name" == "$SELF" ]] && continue

  echo "=== $name ==="
  if ! "$script" "${ARGS[@]}"; then
    FAILED+=("$name")
  fi
  echo
done

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo "error: the following backups failed: ${FAILED[*]}" >&2
  exit 1
fi

echo "all backups done."
