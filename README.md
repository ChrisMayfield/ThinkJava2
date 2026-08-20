# Think Java

Second Edition

**Think Java** is an introduction to computer science and programming intended for people with little or no experience. The goal is to help students learn to design and implement object-oriented solutions to non-trivial problems.

This book is free to read online and available for purchase in print and electronic formats.

Are you using this book in a class? We'd like to know about it! Please consider filling out [this short survey](http://spreadsheets.google.com/viewform?formkey=dC0tNUZkMjBEdXVoRGljNm9FRmlTMHc6MA).

## Reading the Book

** Free HTML Version**: [Read online at GitHub Pages](https://chrisamayfield.github.io/ThinkJava2/)

** Purchase Options** (affiliate links):
- [Bookshop.org](https://bookshop.org/a/98697/9781492072508) - Support independent bookstores
- [Amazon](https://amzn.to/2BEmdAn) - Kindle and paperback editions


## Building from Source

*Note: Most readers won't need to build from source. The free HTML version is available online.*

### Prerequisites
- [Quarto](https://quarto.org/docs/get-started/) (required for `make html`; install separately, not via conda)
- Python 3.12 for conversion scripts — use the conda env below
- LaTeX distribution (texlive-latex-extra, texlive-fonts-recommended on Linux) for PDF

### Conda environment
```bash
make create_environment   # or: mamba env create -f environment.yml
conda activate ThinkJava2
```

Update later with `make update_environment`. Remove with `make delete_environment`.

No JDK is required for the interactive HTML book: [java-runner](https://github.com/ChrisMayfield/java-runner) runs entirely in the browser.

### Build Commands
```bash
# HTML version (Quarto) — primary interactive book path
make html

# PDF version (LaTeX)
make pdf

# Legacy HTML versions
make hevea    # static HTML
make trinket  # interactive version (Trinket.io; being replaced by java-runner)
```

## Repository Structure

```
ThinkJava2/
├── quarto/              # Quarto book project
│   ├── _quarto.yml      # Book configuration
│   ├── split_book.py    # LaTeX to QMD converter
│   ├── convert.py       # LaTeX command converter
│   └── custom.css       # Custom styling
├── book/                # Generated Quarto output
├── code/                # Example Java programs
├── figs/                # Source figures (xfig, dia)
├── ch*.tex             # Chapter source files
├── app*.tex            # Appendix source files
├── thinkjava2.tex      # Main LaTeX file
└── Makefile            # Build automation
```

## License

Copyright (c) 2020 Allen B. Downey and Chris Mayfield.

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. See [LICENSE](LICENSE) for details.

