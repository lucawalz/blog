import os
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TEMPLATE = HERE / "cv.html"
OUTPUT = HERE.parent.parent / "static" / "cv" / "luca-walz-cv.pdf"

os.environ.setdefault("DYLD_FALLBACK_LIBRARY_PATH", "/opt/homebrew/lib")

from weasyprint import HTML


def main():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    HTML(filename=str(TEMPLATE)).write_pdf(str(OUTPUT))
    print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    sys.exit(main())
