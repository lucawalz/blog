"""Render data/cv.yaml + data/projects.yaml into a LaTeX CV and compile it.

Usage:
    uv run --project tools/cv tools/cv/build.py
    uv run --project tools/cv tools/cv/build.py --tex-only
"""

import argparse
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader, StrictUndefined

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
DATA = ROOT / "data"
LATEXMKRC = HERE / "latexmkrc"
DEFAULT_OUTPUT = ROOT / "static" / "cv" / "luca-walz-cv.pdf"

_TEX_REPLACEMENTS = {
    "\\": r"\textbackslash{}",
    "&": r"\&",
    "%": r"\%",
    "$": r"\$",
    "#": r"\#",
    "_": r"\_",
    "{": r"\{",
    "}": r"\}",
    "~": r"\textasciitilde{}",
    "^": r"\textasciicircum{}",
}

_TEX_PATTERN = re.compile("|".join(re.escape(k) for k in _TEX_REPLACEMENTS))


def tex_escape(value):
    """Escape LaTeX specials in display text. URLs must not go through this."""
    return _TEX_PATTERN.sub(lambda m: _TEX_REPLACEMENTS[m.group()], str(value))


def load_yaml(path):
    with path.open(encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def render():
    env = Environment(
        block_start_string=r"\BLOCK{",
        block_end_string="}",
        variable_start_string=r"\VAR{",
        variable_end_string="}",
        comment_start_string=r"\COMMENT{",
        comment_end_string="}",
        line_statement_prefix="%%",
        line_comment_prefix="%#",
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
        autoescape=False,
        undefined=StrictUndefined,
        loader=FileSystemLoader(HERE),
    )
    env.filters["tex"] = tex_escape

    context = dict(load_yaml(DATA / "cv.yaml"))
    context["projects"] = load_yaml(DATA / "projects.yaml")
    return env.get_template("cv.tex.j2").render(**context)


def compile_pdf(tex_source, output, verbose):
    latexmk = shutil.which("latexmk")
    if latexmk is None:
        sys.exit(
            "latexmk not found. Install a TeX distribution, e.g.\n"
            "  brew install --cask mactex-no-gui"
        )

    with tempfile.TemporaryDirectory(prefix="cv-build-") as tmp:
        tmpdir = Path(tmp)
        (tmpdir / "cv.tex").write_text(tex_source, encoding="utf-8")

        cmd = [
            latexmk,
            "-r",
            str(LATEXMKRC),
            f"-outdir={tmpdir}",
            "cv.tex",
        ]
        proc = subprocess.run(
            cmd,
            cwd=tmpdir,
            capture_output=not verbose,
            text=True,
        )

        if proc.returncode != 0:
            log = tmpdir / "cv.log"
            if log.exists():
                tail = log.read_text(encoding="utf-8", errors="replace").splitlines()[-40:]
                print("\n".join(tail), file=sys.stderr)
            elif not verbose:
                print(proc.stdout, file=sys.stderr)
                print(proc.stderr, file=sys.stderr)
            sys.exit(f"latexmk failed with exit code {proc.returncode}")

        output.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(tmpdir / "cv.pdf", output)

    print(f"wrote {output}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT,
        help=f"PDF destination (default: {DEFAULT_OUTPUT})",
    )
    parser.add_argument(
        "--tex-only",
        action="store_true",
        help="print the rendered cv.tex to stdout and exit; no TeX needed",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="stream latexmk output",
    )
    args = parser.parse_args()

    tex_source = render()

    if args.tex_only:
        sys.stdout.write(tex_source)
        return 0

    compile_pdf(tex_source, args.output.resolve(), args.verbose)
    return 0


if __name__ == "__main__":
    sys.exit(main())
