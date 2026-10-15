"""Typeset the authored Lemma 4 proof as static, self-contained SVG pages.

Build: python -B tools/build_lemma4_proof.py (pdflatex and pdftocairo on PATH).
Check: python -B tools/build_lemma4_proof.py --check (standard library only).
The PDF and TeX logs are private intermediates; only vector pages, a source
copy and content fingerprints enter the website. CI checks the reviewed asset
fingerprints, not cross-platform byte-identical TeX rendering.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "tools/proofs/lemma-4.tex"
ASSETS = ROOT / "site/assets/proofs"
MANIFEST = ASSETS / "lemma-4.json"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_text():
    # Git may check out CRLF; published TeX is canonical UTF-8/LF.
    return SOURCE.read_text(encoding="utf-8").replace("\r\n", "\n")


def check():
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    source = source_text().encode("utf-8")
    if manifest["source_sha256"] != hashlib.sha256(source).hexdigest():
        raise ValueError("LaTeX source changed; rebuild and visually review its pages")
    files = manifest["files"]
    pages = manifest["page_count"]
    expected = {"lemma-4.tex.txt", *(f"lemma-4-{i}.svg" for i in range(1, pages + 1))}
    if pages < 1 or set(files) != expected:
        raise ValueError("Unexpected proof asset inventory")
    actual = {p.name for p in ASSETS.glob("lemma-4*") if p != MANIFEST}
    if actual != expected:
        raise ValueError("Missing or stale proof assets")
    for name, fingerprint in files.items():
        if digest(ASSETS / name) != fingerprint:
            raise ValueError(f"Changed proof asset: {name}")
    if (ASSETS / "lemma-4.tex.txt").read_bytes() != source:
        raise ValueError("Published LaTeX source differs from authored source")
    html = (ROOT / "site/discussion.html").read_text(encoding="utf-8")
    for i in range(1, pages + 1):
        if f'src="assets/proofs/lemma-4-{i}.svg"' not in html:
            raise ValueError(f"Discussion page does not display proof page {i}")
    print(f"Proof freshness PASS: LaTeX source and {pages} reviewed vector pages")


def build():
    work = ROOT / "tmp/pdfs/lemma-4"
    work.mkdir(parents=True, exist_ok=True)
    ASSETS.mkdir(parents=True, exist_ok=True)
    for _ in range(2):
        subprocess.run([
            "pdflatex", "-no-shell-escape", "-interaction=nonstopmode",
            "-halt-on-error", f"-output-directory={work}", str(SOURCE),
        ], check=True, cwd=ROOT, timeout=60, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    log = (work / "lemma-4.log").read_text(encoding="utf-8", errors="replace")
    if re.search(r"Overfull \\[hv]box|LaTeX Warning:.*undefined", log):
        raise ValueError("Resolve the layout/reference warnings in tmp/pdfs/lemma-4/lemma-4.log")
    pdf = work / "lemma-4.pdf"
    info = subprocess.run(["pdfinfo", str(pdf)], check=True, capture_output=True,
                          text=True, timeout=30).stdout
    pages = int(re.search(r"^Pages:\s+(\d+)", info, re.M).group(1))
    files = {}
    for i in range(1, pages + 1):
        page = ASSETS / f"lemma-4-{i}.svg"
        subprocess.run(["pdftocairo", "-svg", "-f", str(i), "-l", str(i),
                        str(pdf), str(page)], check=True, timeout=30)
        files[page.name] = digest(page)
    source = source_text().encode("utf-8")
    copy = ASSETS / "lemma-4.tex.txt"
    copy.write_bytes(source)
    files[copy.name] = digest(copy)
    manifest = {"source": "tools/proofs/lemma-4.tex",
                "source_sha256": hashlib.sha256(source).hexdigest(),
                "page_count": pages, "files": files}
    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"Rendered {pages} vector pages; visually review {pdf} before delivery")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    check() if args.check else build()
