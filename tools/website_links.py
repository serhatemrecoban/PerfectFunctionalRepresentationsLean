"""Apply PFR's resource-link policy without reserializing its HTML.

Only eligible anchor start tags and one shared accessibility hint are changed.
Local navigation remains in the current tab; content/resource links open a new
tab without an opener. This is presentation policy, not URL safety validation.
"""

from __future__ import annotations

import argparse
from html import escape
from html.parser import HTMLParser
from pathlib import Path
import re
from urllib.parse import urlsplit


SITE_ROOT = Path(__file__).resolve().parents[1] / "site"
HINT_ID = "new-tab-hint"
HINT_TEXT = "Opens in a new tab"
HINT_HTML = f'<span id="{HINT_ID}" class="visually-hidden">{HINT_TEXT}</span>\n'
LOCAL_NAV_CLASSES = frozenset({
    "project-name", "footer-links", "breadcrumb", "contents", "subnav",
    "bp-graph-link", "graph-node", "same-tab",
})
VOID_TAGS = frozenset({
    "area", "base", "br", "col", "embed", "hr", "img", "input", "link",
    "meta", "param", "source", "track", "wbr",
})
# Match complete attributes, including their quoted values, so text inside a
# data/title attribute can never be mistaken for a target/rel attribute.
ATTRIBUTE = re.compile(
    r'''\s+(?P<name>[^\s/>=]+)(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+))?'''
)


def _first_attributes(attrs: list[tuple[str, str | None]]) -> dict[str, str | None]:
    result: dict[str, str | None] = {}
    for name, value in attrs:
        result.setdefault(name, value)
    return result


def _append_tokens(value: str | None, required: tuple[str, ...]) -> str:
    tokens = (value or "").split()
    for token in required:
        if token not in tokens:
            tokens.append(token)
    return " ".join(tokens)


def _anchor_tag(raw: str, attrs: dict[str, str | None]) -> str:
    title = attrs.get("title") or ""
    if HINT_TEXT.casefold() not in title.casefold():
        title = f"{title} — {HINT_TEXT}" if title else HINT_TEXT
    values = {
        "target": "_blank",
        "rel": _append_tokens(attrs.get("rel"), ("noopener", "noreferrer")),
        "title": title,
        "aria-describedby": _append_tokens(attrs.get("aria-describedby"), (HINT_ID,)),
    }
    changes: list[tuple[int, int, str]] = []
    found: set[str] = set()
    for match in ATTRIBUTE.finditer(raw):
        name = match.group("name").lower()
        if name in values:
            found.add(name)
            replacement = f'{name}="{escape(values[name], quote=True)}"'
            changes.append((match.start("name"), match.end(), replacement))
    missing = "".join(
        f' {name}="{escape(value, quote=True)}"'
        for name, value in values.items() if name not in found
    )
    if missing:
        end = len(raw) - (2 if raw.endswith("/>") else 1)
        changes.append((end, end, missing))
    for start, end, replacement in sorted(changes, reverse=True):
        raw = raw[:start] + replacement + raw[end:]
    return raw


class _LinkPolicyParser(HTMLParser):
    def __init__(self, source: str) -> None:
        super().__init__(convert_charrefs=True)
        self.source = source
        self.line_starts = [0] + [m.end() for m in re.finditer("\n", source)]
        self.stack: list[tuple[str, bool]] = []
        self.changes: list[tuple[int, int, str]] = []
        self.resource_count = 0
        self.hint_count = 0
        self.body_end: int | None = None

    def _offset(self) -> int:
        line, column = self.getpos()
        return self.line_starts[line - 1] + column

    def _start(self, tag: str, pairs: list[tuple[str, str | None]], closed: bool) -> None:
        attrs = _first_attributes(pairs)
        classes = set((attrs.get("class") or "").split())
        local_navigation = (
            tag == "nav" or bool(classes & LOCAL_NAV_CLASSES)
            or any(navigation for _, navigation in self.stack)
        )
        if attrs.get("id") == HINT_ID:
            if tag != "span" or "visually-hidden" not in classes:
                raise ValueError(f"Reserved #{HINT_ID} must be a visually-hidden span")
            if any(parent == "template" for parent, _ in self.stack):
                raise ValueError(f"Shared #{HINT_ID} must be outside templates")
            self.hint_count += 1
        if tag == "a" and "download" not in attrs:
            href = (attrs.get("href") or "").strip()
            if href and not href.startswith("#"):
                parsed = urlsplit(href)
                # HTTPS resources remain resources even within navigation. The
                # same applies to HTTP/protocol-relative URLs; the site checker
                # separately enforces its allowed-URL policy.
                external = parsed.scheme.lower() in {"https", "http"} or bool(parsed.netloc)
                local = not parsed.scheme and not parsed.netloc
                if external or (local and not local_navigation):
                    raw = self.get_starttag_text()
                    replacement = _anchor_tag(raw, attrs)
                    self.resource_count += 1
                    if replacement != raw:
                        start = self._offset()
                        self.changes.append((start, start + len(raw), replacement))
        if not closed and tag not in VOID_TAGS:
            self.stack.append((tag, local_navigation))

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        self._start(tag, attrs, False)

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        self._start(tag, attrs, True)

    def handle_endtag(self, tag: str) -> None:
        if tag == "body" and not any(parent == "template" for parent, _ in self.stack):
            self.body_end = self._offset()
        for index in range(len(self.stack) - 1, -1, -1):
            if self.stack[index][0] == tag:
                del self.stack[index:]
                break


def apply_link_policy(html: str) -> str:
    """Return idempotently annotated HTML, preserving all other source text.

    Complete documents receive the shared hint immediately before ``</body>``.
    A fragment receives it at its end. Existing title and description references
    are retained; named local-navigation contexts, hash links, downloads and
    non-web schemes (for example mailto) are left untouched.
    """
    parser = _LinkPolicyParser(html)
    parser.feed(html)
    parser.close()
    if parser.hint_count > 1:
        raise ValueError(f"Expected at most one shared #{HINT_ID}")
    if parser.resource_count and not parser.hint_count:
        position = parser.body_end if parser.body_end is not None else len(html)
        parser.changes.append((position, position, HINT_HTML))
    for start, end, replacement in sorted(parser.changes, reverse=True):
        html = html[:start] + replacement + html[end:]
    return html


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="check all site HTML without writing")
    args = parser.parse_args(argv)
    paths = sorted(SITE_ROOT.rglob("*.html") if args.check else SITE_ROOT.glob("*.html"))
    drift: list[Path] = []
    for path in paths:
        original = path.read_bytes().decode("utf-8")
        try:
            updated = apply_link_policy(original)
        except ValueError as error:
            print(f"{path.relative_to(SITE_ROOT)}: {error}")
            return 1
        if updated != original:
            drift.append(path)
            if not args.check:
                path.write_bytes(updated.encode("utf-8"))
    if args.check and drift:
        print("Link-policy drift: " + ", ".join(str(path.relative_to(SITE_ROOT)) for path in drift))
        return 1
    print(f"Link policy {'checked' if args.check else 'applied'}: {len(paths)} HTML files; {len(drift)} changed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
