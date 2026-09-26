#!/usr/bin/env bash
# Build the book's outputs from one Markdown source.
#
#   ./build/build.sh                 # the sample chapter, all three outputs
#   SRC=chapters/*.md ./build/build.sh
#
# Outputs land in dist/ : book.html (single self-contained file),
# book.epub (eInk; open it with Calibre or copy it to the device),
# book.pdf (print/desktop, via the self-contained Tectonic LaTeX engine).
#
# Requires: pandoc, tectonic  (both installed in ~/.local/bin by default)
set -euo pipefail

cd "$(dirname "$0")/.."
export PATH="$HOME/.local/bin:$PATH"

PANDOC=${PANDOC:-pandoc}
command -v "$PANDOC" >/dev/null || { echo "pandoc not found in PATH" >&2; exit 1; }

SRC=${SRC:-chapters/10-the-curator.md}
OUT=${OUT:-dist}
META=build/book.yaml
mkdir -p "$OUT"

common=(
  --metadata-file="$META"
  --lua-filter=build/book.lua
  --toc --toc-depth=2
  --standalone
)

echo "== html =="
"$PANDOC" "$SRC" "${common[@]}" \
  --to html5 --css build/theme.css --embed-resources \
  --output "$OUT/book.html"

echo "== epub =="
"$PANDOC" "$SRC" "${common[@]}" \
  --to epub3 --css build/theme.css --epub-title-page=true \
  --output "$OUT/book.epub"

echo "== pdf =="
"$PANDOC" "$SRC" "${common[@]}" \
  --to pdf --pdf-engine=tectonic \
  --include-in-header=build/book-header.tex \
  --include-after-body=build/book-index-page.tex \
  -V documentclass=book -V classoption=oneside \
  -V fontsize=11pt -V linestretch=1.15 \
  -V mainfont="DejaVu Serif" -V sansfont="DejaVu Sans" -V monofont="DejaVu Sans Mono" \
  -V geometry:margin=2.4cm -V colorlinks=true \
  --output "$OUT/book.pdf"

echo
echo "== outputs =="
ls -la "$OUT"
