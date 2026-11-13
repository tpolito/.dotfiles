#!/usr/bin/env bash
# Back up ~/.config/quickshell into ./quickshell within this dotfiles repo.
#
# Before copying anything, scans the source config for PII (email
# addresses, private keys, hardcoded secrets/tokens, paths under another
# user's home dir) via lib/pii_scan.sh and aborts if it finds any.
#
# Usage:
#   ./backup-quickshell.sh            # audit, then back up into ./quickshell
#   ./backup-quickshell.sh --dry-run  # audit, then show what would be copied

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="${QUICKSHELL_CONFIG_HOME:-$HOME/.config/quickshell}"
DEST="$ROOT/quickshell"

source "$ROOT/lib/pii_scan.sh"

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

if [[ ! -d "$SRC" ]]; then
  echo "error: quickshell config not found at $SRC" >&2
  exit 1
fi

echo "Auditing $SRC for PII..."
if ! scan_for_pii "$SRC"; then
  echo "error: potential PII found in $SRC — review the matches above and fix before backing up." >&2
  exit 1
fi
echo "Audit clean."

echo "Backing up $SRC -> $DEST"
if [[ $DRY_RUN -eq 1 ]]; then
  echo "(dry run — no files will be written)"
  rsync -a --delete --exclude='node_modules' --dry-run "$SRC/" "$DEST/"
else
  rsync -a --delete --exclude='node_modules' "$SRC/" "$DEST/"
fi

echo "done."
