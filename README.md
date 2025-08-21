# ThinkJava2
LaTeX source for Think Java, 2nd edition. Copyright (c) 2020 Allen B. Downey and Chris Mayfield. This edition was published in December 2019 by [O'Reilly Media](https://www.oreilly.com/library/view/think-java-2nd/9781492072492/) (ISBN 9781492072508).

Permission is granted to copy, distribute, and/or modify this work under the terms of the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License, which is available at https://creativecommons.org/licenses/by-nc-sa/4.0/.

The original form of this book is the LaTeX source code available from http://greenteapress.com/wp/think-java-2e/ and https://github.com/ChrisMayfield/ThinkJava2.

The illustrations were drawn using xfig (http://www.xfig.org/) and dia (https://wiki.gnome.org/Apps/Dia/). These tools are free and open-source.

Compiling the LaTeX source has the effect of generating a device-independent representation of the book, which can be converted to other formats and printed.

## Building the Book

### Prerequisites
On Linux, you may need to install:
- `texlive-latex-extra` and `texlive-fonts-recommended` for PDF generation
- `plastex` for XML generation

#### Installing HeVeA (Required for HTML generation)
HeVeA is available through the OCaml Package Manager (opam):

```bash
# 1. Install opam if you don't have it
# Debian/Ubuntu
sudo apt install opam

# macOS with Homebrew
brew install opam

# 2. Initialize opam
opam init

# 3. Install hevea from opam (latest release from maintainer)
opam install hevea

# 4. Make sure opam's bin directory is in your PATH
eval $(opam env)

#### Troubleshooting: LaTeX Can't Find HeVeA Style File
After installing HeVeA, you may see a warning that `hevea.sty` was installed but LaTeX can't find it. This is because the style file is in opam's directory. Here's how to fix it:

**Solution: Add opam's LaTeX directory to TEXINPUTS**

```bash
# Add this line to your ~/.bashrc or ~/.zshrc
export TEXINPUTS="$HOME/.opam/default/lib/hevea:$TEXINPUTS"

# Then reload your shell configuration
source ~/.bashrc  # or source ~/.zshrc

# Verify the file is now found
kpsewhich hevea.sty
```

This should return the path to `hevea.sty` if the fix worked.



### Build Options

#### PDF Version (Default)
```bash
make pdf    # or just 'make'
```
This runs `pdflatex` three times to resolve cross-references.

#### HTML Versions
```bash
make hevea    # Static HTML version
make trinket  # Interactive HTML version for Trinket platform
```

#### XML Version
```bash
make plastex  # DocBook XML output
```

#### Other Targets
```bash
make clean      # Remove build artifacts
make clean-all  # Remove all generated files including PDF
make lint       # Validate XML output
make distrib    # Create distribution package
```

### Manual PDF Build
If you prefer to build manually:

```bash
pdflatex thinkjava2.tex
pdflatex thinkjava2.tex
pdflatex thinkjava2.tex
```

## Project Structure

- **`*.tex`** - LaTeX source files for each chapter
- **`figs/`** - Source figures (xfig, dia, PNG)
- **`code/`** - Java source code examples
- **`hevea/`** - HTML build configuration and templates
- **`atlas/`** - Publishing workflow files
- **`Makefile`** - Automated build system

## Notes

- The default `make` target builds only PDF for faster development cycles
- Use specific targets for other formats when needed
- Build artifacts are placed in separate directories (e.g., `heveahtml/`, `build/`)
- If HeVeA fails due to OCaml bugs, use `make -i hevea`
