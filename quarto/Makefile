# Makefile for Think Java Quarto Edition

.PHONY: all html pdf clean preview help

# Default target
all: html

# Build HTML version
html:
	@echo "Building HTML version..."
	quarto render --to html
	@echo "HTML build complete"

publish:
	quarto publish gh-pages --no-render

# Build PDF version
pdf:
	@echo "Building PDF version..."
	quarto render --to pdf --output-dir pdf
	@echo "PDF build complete: pdf/"

# Build both HTML and PDF
both: html pdf

# Preview the book
preview:
	@echo "Starting Quarto preview server..."
	quarto preview

# Copy over the tex files and make conversions
convert:
	python convert.py preface.tex ch01.tex ch02.tex ch03.tex ch04.tex ch05.tex ch06.tex ch07.tex ch08.tex ch09.tex ch10.tex ch11.tex ch12.tex ch13.tex ch14.tex ch15.tex ch16.tex ch17.tex

# Convert LaTeX to Markdown
pandoc:
	pandoc --from latex --to markdown --lua-filter extract-labels.lua thinkjava2.tex -o full_book.md

# Split the Markdown into Quarto chapter files
split:
	python split_book.py

# Complete conversion process: convert LaTeX commands then split book
convert-all: convert pandocsplit

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf _output/
	rm -f *.aux *.log *.out *.idx *.toc *.fdb_latexmk *.fls *.synctex.gz
	@echo "Clean complete"

# Show help
help:
	@echo "Available targets:"
	@echo "  all        - Build HTML (default)"
	@echo "  html       - Build HTML version"
	@echo "  pdf        - Build PDF version"
	@echo "  both       - Build both HTML and PDF"
	@echo "  preview    - Start preview server"
	@echo "  convert    - Convert LaTeX custom commands to listings package"
	@echo "  split      - Split full_book.md into individual chapter files"
	@echo "  convert-all- Run complete conversion process (convert + split)"
	@echo "  clean      - Remove build artifacts"
	@echo "  help       - Show this help message"
