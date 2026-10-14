"""Check the self-contained public site (Python 3.11+, standard library only).

source-links.json has commit (40 hex digits), repository (the public PFR URL),
and entries [{file, line, needle, label}]. Each exact one-based source line must
contain needle at that Git commit, and its blob URL must appear in an HTML href.
This is a structural/publication guard, not a full browser or secret scanner.
"""
from __future__ import annotations

import argparse
from html.parser import HTMLParser
import json
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
from urllib.parse import unquote, urlsplit
import xml.etree.ElementTree as ET

from generate_api import check_api_source_links
from generate_blueprint import check_blueprint_source_links

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = "https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean"
EXTENSIONS = {".html", ".css", ".js", ".svg", ".json", ".txt"}
PRIVATE = {".lake", ".pfr-review", "tmp", "papers", "references", "output",
           ".git", ".env", ".netrc", ".git-credentials", "id_rsa", "id_ed25519"}
LOCAL_PATH = re.compile(r"(?i)\bfile:|\b[a-z]:[\\/]|(?:^|[\s\"'])(?:/Users/|/home/)")
SECRETS = re.compile(
    r"-----BEGIN (?:[A-Z ]+ )?PRIVATE KEY-----|"
    r"\b(?:gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|"
    r"AKIA[0-9A-Z]{16}|sk-(?:proj-)?[A-Za-z0-9_-]{20,})\b|"
    r"(?i:\b(?:password|passwd|api[_-]?key|access[_-]?token|client[_-]?secret)"
    r"\s*[:=]\s*[\"'][^\"'\s]{8,}[\"'])")
CSS_URL = re.compile(r"url\(\s*(['\"]?)(.*?)\1\s*\)", re.I | re.S)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


class Page(HTMLParser):
    def __init__(self, name: str):
        super().__init__(convert_charrefs=True)
        self.name = name
        self.ids: set[str] = set()
        self.id_references: list[tuple[str, str]] = []
        self.references: list[tuple[str, bool]] = []
        self.hrefs: set[str] = set()
        self.counts: dict[str, int] = {}
        self.lang = self.viewport = False
        self.title = ""
        self.current = ""
        self.styles: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = dict(attrs)
        self.counts[tag] = self.counts.get(tag, 0) + 1
        require(len(values) == len(attrs), f"{self.name}: duplicate HTML attribute")
        require(tag not in {"base", "iframe", "object", "embed", "form"},
                f"{self.name}: unsupported embedded content: {tag}")
        require(not any(key.startswith("on") for key in values),
                f"{self.name}: inline event handler")
        if "id" in values:
            identity = values["id"]
            require(bool(identity) and identity not in self.ids,
                    f"{self.name}: empty or duplicate id {identity!r}")
            self.ids.add(identity)
        for attribute in ("aria-labelledby", "aria-describedby", "aria-controls", "data-copy"):
            if attribute in values:
                targets = (values[attribute] or "").split()
                require(bool(targets), f"{self.name}: empty {attribute}")
                self.id_references.extend((attribute, target) for target in targets)
        if tag == "html":
            self.lang = bool((values.get("lang") or "").strip())
        if tag == "meta" and (values.get("name") or "").lower() == "viewport":
            self.viewport = "width=device-width" in (values.get("content") or "").replace(" ", "")
        if tag == "img":
            require("alt" in values and values["alt"] is not None,
                    f"{self.name}: image without alt text")
        if tag in {"script", "title", "style"}:
            self.current = tag
        if tag == "script":
            require(bool(values.get("src")), f"{self.name}: inline script")
        if "style" in values:
            self.styles.append(values["style"] or "")
        for attribute in ("href", "src", "poster", "action"):
            if attribute in values:
                value = values[attribute] or ""
                navigation = tag == "a" and attribute == "href"
                # A canonical URL is metadata, not a downloaded asset.
                navigation |= (tag == "link" and values.get("rel") == "canonical")
                self.references.append((value, navigation))
                if tag == "a" and attribute == "href":
                    self.hrefs.add(value)
        if "srcset" in values:
            for candidate in (values["srcset"] or "").split(","):
                parts = candidate.strip().split()
                require(bool(parts), f"{self.name}: empty srcset entry")
                self.references.append((parts[0], False))

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        self.handle_starttag(tag, attrs)
        self.handle_endtag(tag)

    def handle_endtag(self, tag: str) -> None:
        if self.current == tag:
            self.current = ""

    def handle_data(self, data: str) -> None:
        if self.current == "title":
            self.title += data
        elif self.current == "script":
            require(not data.strip(), f"{self.name}: inline script body")
        elif self.current == "style":
            self.styles.append(data)

    def finish(self) -> None:
        require(self.lang and self.title.strip() and self.viewport,
                f"{self.name}: requires html lang, title and device-width viewport")
        require(self.counts.get("html") == 1 and self.counts.get("main") == 1
                and self.counts.get("h1") == 1,
                f"{self.name}: requires one html, main and h1")
        for attribute, target in self.id_references:
            require(target in self.ids, f"{self.name}: missing {attribute} target: {target}")


def css_references(text: str, name: str) -> list[tuple[str, bool]]:
    require(not re.search(r"@import\b", text, re.I), f"{name}: CSS imports are not allowed")
    return [(match.group(2).strip(), False) for match in CSS_URL.finditer(text)]


def check_reference(value: str, navigation: bool, origin: Path, site: Path,
                    identities: dict[Path, set[str]]) -> None:
    require(bool(value) and not LOCAL_PATH.search(value) and "\\" not in value,
            f"{origin.name}: empty or local-filesystem URL")
    parsed = urlsplit(value)
    if parsed.scheme or parsed.netloc:
        require(navigation and parsed.scheme in {"https", "mailto"},
                f"{origin.name}: external asset or unsupported URL: {value}")
        require(not parsed.username and not parsed.password,
                f"{origin.name}: credentials in URL")
        require(bool(parsed.hostname) if parsed.scheme == "https" else bool(parsed.path),
                f"{origin.name}: malformed external URL")
        return
    path = unquote(parsed.path)
    require(not path.startswith("/") and "\\" not in path,
            f"{origin.name}: use site-relative URLs: {value}")
    target = (origin.parent / path).resolve() if path else origin
    if target.is_dir():
        target /= "index.html"
    require(target.is_relative_to(site), f"{origin.name}: URL escapes site: {value}")
    require(target.is_file(), f"{origin.name}: missing linked file: {value}")
    if parsed.fragment:
        require(unquote(parsed.fragment) in identities.get(target, set()),
                f"{origin.name}: missing fragment: {value}")


def git_source(commit: str, file: str, repo_root: Path) -> str:
    result = subprocess.run(["git", "show", f"{commit}:{file}"], cwd=repo_root,
                            capture_output=True, text=True, encoding="utf-8")
    require(result.returncode == 0, f"Source manifest: cannot read {file} at {commit}")
    return result.stdout


def check_source_links(site: Path, hrefs: set[str], repo_root: Path) -> None:
    data = json.loads((site / "source-links.json").read_text(encoding="utf-8"))
    require(isinstance(data, dict), "Source manifest must be an object")
    commit, repository, entries = (data.get(key) for key in ("commit", "repository", "entries"))
    require(isinstance(commit, str) and bool(re.fullmatch(r"[0-9a-f]{40}", commit)),
            "Source manifest requires a full lowercase Git commit")
    require(repository == REPOSITORY, "Source manifest repository changed")
    require(isinstance(entries, list) and bool(entries), "Source manifest has no entries")
    result = subprocess.run(["git", "cat-file", "-e", f"{commit}^{{commit}}"],
                            cwd=repo_root, capture_output=True)
    require(result.returncode == 0, "Source manifest commit is unavailable; fetch full history")
    expected: set[str] = set()
    contents: dict[str, list[str]] = {}
    for entry in entries:
        require(isinstance(entry, dict), "Source manifest entry must be an object")
        file, line, needle, label = (entry.get(key) for key in ("file", "line", "needle", "label"))
        require(isinstance(file, str) and file.startswith("PerfectFunctionalRepresentations/")
                and file.endswith(".lean") and "\\" not in file
                and all(part not in {"", ".", ".."} for part in file.split("/")),
                "Source manifest requires a project Lean source path")
        require(type(line) is int and line > 0 and isinstance(needle, str) and bool(needle.strip())
                and isinstance(label, str) and bool(label.strip()), "Invalid source manifest entry")
        if file not in contents:
            contents[file] = git_source(commit, file, repo_root).splitlines()
        lines = contents[file]
        require(line <= len(lines) and needle in lines[line - 1],
                f"Source link drift: {file}:{line} does not contain {needle!r}")
        url = f"{repository}/blob/{commit}/{file}#L{line}"
        require(url in hrefs, f"Source manifest entry not linked from HTML: {label}")
        require(url not in expected, f"Duplicate source manifest location: {file}:{line}")
        expected.add(url)
    # Compiler-generated API links have a separate exact inventory. Its source,
    # configuration and rendered payload are checked before allowing any URL.
    api_expected = check_api_source_links(site, hrefs, repo_root) if (site / "api").exists() else set()
    blueprint_expected = check_blueprint_source_links(site, hrefs, repo_root) if (site / "blueprint/dep_graph_document.html").exists() else set()
    for href in hrefs:
        if href.startswith(f"{repository}/blob/") and ".lean" in urlsplit(href).path:
            require(href in expected | api_expected | blueprint_expected, f"Unregistered or mutable Lean source link: {href}")


def check_site(site: Path, repo_root: Path = ROOT) -> tuple[int, int]:
    require(not site.is_symlink(), "Site root must not be a symlink")
    site = site.resolve()
    require(site.is_dir(), "Site directory does not exist")
    pages: dict[Path, Page] = {}
    identities: dict[Path, set[str]] = {}
    references: list[tuple[Path, str, bool]] = []
    for path in sorted(site.rglob("*")):
        name = path.relative_to(site).as_posix()
        require(not path.is_symlink(), f"Symlink in site: {name}")
        require(not any(part.lower() in PRIVATE for part in PurePosixPath(name).parts),
                f"Private path in site: {name}")
        if path.is_dir():
            continue
        require(path.is_file() and (path.suffix.lower() in EXTENSIONS or name == ".nojekyll"),
                f"Unsupported public site file: {name}")
        text = path.read_text(encoding="utf-8")
        require(not LOCAL_PATH.search(text), f"Local filesystem reference in {name}")
        require(not SECRETS.search(text), f"Possible credential in {name}; inspect before publication")
        suffix = path.suffix.lower()
        if suffix == ".html":
            page = Page(name)
            page.feed(text)
            page.close()
            page.finish()
            pages[path] = page
            identities[path] = page.ids
            for style in page.styles:
                page.references.extend(css_references(style, name))
            references.extend((path, value, nav) for value, nav in page.references)
        elif suffix == ".css":
            references.extend((path, value, nav) for value, nav in css_references(text, name))
        elif suffix == ".svg":
            svg = ET.fromstring(text)
            require(svg.tag.rsplit("}", 1)[-1] == "svg", f"{name}: expected SVG root")
            ids: set[str] = set()
            for element in svg.iter():
                tag = element.tag.rsplit("}", 1)[-1]
                require(tag not in {"script", "foreignObject"}, f"{name}: active SVG content")
                for key, value in element.attrib.items():
                    key = key.rsplit("}", 1)[-1]
                    require(not key.lower().startswith("on"), f"{name}: SVG event handler")
                    if key == "id":
                        require(bool(value) and value not in ids, f"{name}: duplicate SVG id")
                        ids.add(value)
                    elif key == "href":
                        references.append((path, value, False))
                    if key == "style" or "url(" in value.lower():
                        references.extend((path, value, nav) for value, nav in css_references(value, name))
                if tag == "style":
                    references.extend((path, value, nav) for value, nav in css_references(element.text or "", name))
            identities[path] = ids
        elif suffix == ".js":
            require(not re.search(r"https?://|\b(?:fetch|XMLHttpRequest|WebSocket|EventSource|importScripts)\s*\(|\bimport\s*(?:\(|['\"])", text),
                    f"{name}: network loading is outside this self-contained site")
    require(site / "index.html" in pages, "Missing site index.html")
    for origin, value, navigation in references:
        check_reference(value, navigation, origin, site, identities)
    check_source_links(site, set().union(*(page.hrefs for page in pages.values())), repo_root)
    return len(pages), len(references)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--site", type=Path, default=ROOT / "site")
    args = parser.parse_args()
    try:
        pages, links = check_site(args.site)
    except (ValueError, OSError, ET.ParseError) as error:
        print(f"Website check failed: {error}", file=sys.stderr)
        raise SystemExit(1) from None
    print(f"Website check passed: {pages} pages, {links} links/assets; pinned source lines verified.")


if __name__ == "__main__":
    main()
