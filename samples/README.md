# Sample outputs

Generated copies of chapter 10 (`chapters/10-the-curator.md`) in all three
formats, so the look of each output can be judged without building anything.
These are **generated files** — the source of truth is the chapter, and they are
replaced by running the build:

```bash
./build/build.sh        # writes dist/, then copy into samples/ to publish
```

Built 2026-09-26 with `pandoc 3.11` and `tectonic 0.17.0` (LaTeX), from
`build/book.yaml` (title page, contents) and `build/theme.css` (typography,
including the definitive callout).

| File | What to look at |
| :--- | :--- |
| `book.html` | Single self-contained file. Contents box at the top, the **DEFINITIVE** callout, the generated **Key ideas** list and **Index** at the end (index links jump to their section). |
| `book.epub` | The eInk form. Open with Calibre or copy to the device. Reflowable — no page numbers anywhere, so the index links to sections. Title page, contents, chapter, Key ideas, Index. |
| `book.pdf` | 11 pages: title page, contents with page numbers, the chapter with running heads and page numbers, Key ideas, Index. |

## Known gaps in this sample

- **The PDF's index links rather than paginating.** A printed index with page
  numbers needs a `makeindex` pass that the engine did not run; the index that
  ships here is the same generated, link-based one the other formats use.
- **Typeface is DejaVu** (Serif for body, Sans for headings), the best of what
  was already installed. A real pairing is a decision, and the CSS is where it
  changes.
- **No cover image.** EPUB readers show a plain title page instead.
- **No inline figures yet.** Nothing in this chapter needed one.
