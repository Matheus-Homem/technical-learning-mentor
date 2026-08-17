#!/usr/bin/env python3
"""
Step 1+2 of the .md -> audio pipeline: strip markdown syntax and adapt the
text for narration (TTS reads punctuation/structure literally, so raw
markdown/prose that's fine to *read* often sounds broken out loud).

Usage:
    python3 prepare_narration.py <source.md> > <narration.txt>
    python3 prepare_narration.py <source.md> --glossary <path.json> > <narration.txt>

Then review/edit the .narration.txt by hand before generating audio -
this step is a heuristic first pass, not a guarantee.

Glossary resolution (in order):
1. --glossary <path>, if given.
2. .mentor/narration_glossary.json under the current working directory, if it
   exists — this is the per-project glossary and where new terms should be
   added. It is NOT part of this skill's repo: it lives in the project being
   mentored and grows with that project's own vocabulary (topic names, field
   names, tool invocations). See references/audio.md.
3. narration_glossary.json next to this script — ships empty. Do not add
   project-specific terms here; that would leak one project's vocabulary
   into every other project that installs this skill.
"""

import argparse
import json
import re
import sys
from pathlib import Path

DEFAULT_GLOSSARY_PATH = Path(__file__).parent / "narration_glossary.json"
PROJECT_GLOSSARY_PATH = Path.cwd() / ".mentor" / "narration_glossary.json"


def strip_markdown(text: str) -> str:
    text = re.sub(r"^#+\s*", "", text, flags=re.MULTILINE)  # headers
    text = re.sub(r"\*\*(.*?)\*\*", r"\1", text)  # bold
    text = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"\1", text)  # italic
    text = re.sub(r"`([^`]+)`", r"\1", text)  # inline code
    text = re.sub(r"^```.*?^```", "", text, flags=re.MULTILINE | re.DOTALL)  # code blocks
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)  # links -> link text
    text = re.sub(r"^---+$", "", text, flags=re.MULTILINE)  # hr
    text = re.sub(r"\n{3,}", "\n\n", text).strip()
    return text


ABBREVIATIONS = {
    r"\bex\.?:": "por exemplo,",
    r"\bp\.\s*ex\.": "por exemplo",
    r"\betc\.": "etcétera",
    r"\bi\.e\.": "isto é,",
    r"\be\.g\.": "por exemplo,",
    r"\bvs\.": "versus",
    r"\bobs\.:": "observação:",
}


def expand_abbreviations(text: str) -> str:
    """TTS reads abbreviations literally letter-by-letter or spells them out
    wrong (e.g. 'ex:' read as the letters 'e x' instead of 'exemplo'). Expand
    the common ones before synthesis. Extend ABBREVIATIONS as new ones show
    up - this runs before the glossary so file-specific terms still win."""
    for pattern, replacement in ABBREVIATIONS.items():
        text = re.sub(pattern, replacement, text, flags=re.IGNORECASE)
    return text


def resolve_glossary_path(explicit: Path | None) -> Path:
    """Explicit --glossary wins, then the per-project glossary, then this
    script's own."""
    if explicit is not None:
        return explicit
    if PROJECT_GLOSSARY_PATH.exists():
        return PROJECT_GLOSSARY_PATH
    return DEFAULT_GLOSSARY_PATH


def apply_glossary(text: str, glossary_path: Path) -> str:
    """Swap technical tokens for how they should be pronounced."""
    if not glossary_path.exists():
        return text
    glossary = json.loads(glossary_path.read_text(encoding="utf-8"))
    # longest keys first so substrings don't shadow more specific matches
    for term in sorted(glossary, key=len, reverse=True):
        text = re.sub(re.escape(term), glossary[term], text)
    return text


def split_em_dash_clauses(text: str) -> str:
    """Em-dash-heavy sentences (common in written PT-BR tech prose) tend to
    come out as run-on, oddly-paced audio. Turn ' — X — ' asides and trailing
    ' — X' clauses into their own sentences so the TTS engine puts a real
    pause there instead of a comma-length blip."""
    text = re.sub(r"\s+—\s+", ". ", text)
    text = re.sub(r"\.\.", ".", text)
    return text


def prepare(text: str, glossary_path: Path) -> str:
    text = strip_markdown(text)
    text = expand_abbreviations(text)
    text = apply_glossary(text, glossary_path)
    text = split_em_dash_clauses(text)
    return text


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("source", type=Path, help="source .md file")
    parser.add_argument(
        "--glossary",
        type=Path,
        default=None,
        help="override the glossary path (default: .mentor/narration_glossary.json if present, else this script's own empty one)",
    )
    args = parser.parse_args()

    glossary_path = resolve_glossary_path(args.glossary)
    print(prepare(args.source.read_text(encoding="utf-8"), glossary_path))
