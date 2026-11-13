#!/usr/bin/env bash
# Back up the user-owned parts of ~/.config/herdr-app into ./herdr-app.
#
# Included:
#   keys.json, settings.json, programs.json   (your keys, preferences, program table)
#   themes/*.json                             (custom themes; shipped ones skipped)
#   layouts/*.json|svg|png                    (only layouts NOT shipped by Herdr)
#   layouts/.state/                           (layout clicks: sizes, hidden, theme picks)
#   mods/<name>/                              (only mods NOT shipped by Herdr)
#
# Excluded (rewritten by Herdr or machine state):
#   shipped layouts/mods (listed in installed.json), AGENTS.md, *.d.ts, frame/,
#   icons/, view.json, shared.json, data/, seen.json, installed.json, window*.json,
#   telemetry/, update-notes*, .backups/, *.error, herdr-app.sock
#
# Usage:
#   ./backup-herdr-app.sh            # back up into ./herdr-app
#   ./backup-herdr-app.sh --dry-run  # show what would be copied

set -euo pipefail

SRC="${HERDR_APP_HOME:-$HOME/.config/herdr-app}"
DEST="$(cd "$(dirname "$0")" && pwd)/herdr-app"
SHIPPED_THEMES=(atom-one-dark win98)

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

if [[ ! -d "$SRC" ]]; then
  echo "error: herdr-app config not found at $SRC" >&2
  exit 1
fi

echo "Backing up $SRC -> $DEST"
if [[ $DRY_RUN -eq 1 ]]; then
  echo "(dry run — no files will be written)"
  run() { echo "  $*"; }
else
  run() { "$@"; }
  rm -rf "$DEST"
fi
run mkdir -p "$DEST"

# Names Herdr ships (mods, and layouts as "layout:<name>").
SHIPPED=""
if [[ -f "$SRC/installed.json" ]]; then
  SHIPPED="$(python3 -c 'import json,sys; print("\n".join(json.load(open(sys.argv[1]))))' "$SRC/installed.json")"
fi
is_shipped() { grep -qxF "$1" <<<"$SHIPPED"; }

# Top-level user files
for f in keys.json settings.json programs.json; do
  [[ -f "$SRC/$f" ]] && run cp "$SRC/$f" "$DEST/$f"
done

shopt -s nullglob

# Themes (skip shipped)
for f in "$SRC"/themes/*.json; do
  name="$(basename "$f" .json)"
  [[ " ${SHIPPED_THEMES[*]} " == *" $name "* ]] && continue
  run mkdir -p "$DEST/themes"
  run cp "$f" "$DEST/themes/"
done

# Layouts: personal ones + layout click state
for f in "$SRC"/layouts/*.json; do
  name="$(basename "$f" .json)"
  is_shipped "layout:$name" && continue
  run mkdir -p "$DEST/layouts"
  run cp "$f" "$DEST/layouts/"
  for p in "$SRC/layouts/$name".{svg,png}; do run cp "$p" "$DEST/layouts/"; done
done
if [[ -d "$SRC/layouts/.state" ]]; then
  run mkdir -p "$DEST/layouts"
  run rsync -a "$SRC/layouts/.state/" "$DEST/layouts/.state/"
fi

# Mods: only personal ones
for d in "$SRC"/mods/*/; do
  name="$(basename "$d")"
  is_shipped "$name" && continue
  run mkdir -p "$DEST/mods"
  run rsync -a --exclude='node_modules' --exclude='*.d.ts' --exclude='jsconfig.json' \
    "$d" "$DEST/mods/$name/"
done

shopt -u nullglob

echo "done."
if [[ $DRY_RUN -eq 0 ]]; then
  echo "Review with: git -C \"$DEST/..\" status herdr-app"
fi
