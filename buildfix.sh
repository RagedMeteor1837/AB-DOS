#!/usr/bin/env bash
set -e

if [ ! -d "src" ]; then
  echo "ERROR: src directory not found. Run this script from the directory that contains src/"
  exit 1
fi

echo "[*] Fixing invalid characters in specific source files..."

FILES=(
  "src/MAPPER/GETMSG.ASM"
  "src/SELECT/SELECT2.ASM"
  "src/SELECT/USA.INF"
)

for f in "${FILES[@]}"; do
  if [ -f "$f" ]; then
    sed -i -re 's/\xEF\xBF\xBD|\xC4\xBF|\xC4\xB4/#/g' "$f"
    echo "  - Fixed $f"
  else
    echo "  ! Skipped missing file: $f"
  fi
done

echo "Converting line endings to DOS (CRLF)..."

if ! command -v unix2dos >/dev/null 2>&1; then
  echo "ERROR: unix2dos not found"
  exit 1
fi

find src \
  -iname '*.BAT' \
  -o -iname '*.ASM' \
  -o -iname '*.SKL' \
  -o -iname 'ZERO.DAT' \
  -o -iname 'LOCSCR' \
  | xargs unix2dos -f

echo "Source preparation complete"
