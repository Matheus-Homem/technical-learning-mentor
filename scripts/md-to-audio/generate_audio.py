#!/usr/bin/env python3
"""
Step 3 of the .md -> audio pipeline: synthesize narration text with
edge-tts (free Microsoft neural voices, no API key, requires internet).

Usage:
    python tmp/tts/generate_audio.py tmp/audio1.narration.txt tmp/audio1.mp3 \
        [--voice pt-BR-AntonioNeural] [--rate -10%]

List voices: edge-tts --list-voices | grep pt-BR
"""

import argparse
import asyncio
from pathlib import Path

import edge_tts

DEFAULT_VOICE = "pt-BR-AntonioNeural"


async def synthesize(text: str, out_path: Path, voice: str, rate: str) -> None:
    communicate = edge_tts.Communicate(text, voice=voice, rate=rate)
    await communicate.save(str(out_path))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("narration_file", type=Path)
    parser.add_argument("output_file", type=Path)
    parser.add_argument("--voice", default=DEFAULT_VOICE)
    parser.add_argument(
        "--rate", default="-8%", help="speed delta, e.g. -8%% (slower helps clarity)"
    )
    args = parser.parse_args()

    text = args.narration_file.read_text(encoding="utf-8")
    asyncio.run(synthesize(text, args.output_file, args.voice, args.rate))
    print(f"wrote {args.output_file} ({args.output_file.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
