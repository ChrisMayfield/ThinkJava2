# Think Java 2e - Build System
# =============================

# Configuration
PROJECT_NAME = ThinkJava2
BOOK_NAME = thinkjava2
MAIN_FILE = $(BOOK_NAME).tex
BUILD_DIR = build
DIST_DIR = dist

# Tools and commands
PDFLATEX = pdflatex
PYTHON = python3
PYTHON2 = python2
HEVEA = hevea
IMAGEN = imagen
HACHA = hacha
RSYNC = rsync

# Default target
.DEFAULT_GOAL := help

# Help target
.PHONY: help
help: ## Show this help message
	@echo "Think Java 2e - Available build targets:"
	@echo ""
	@echo "📚 Book Generation:"
	@echo "  pdf          - Generate PDF version (default)"
	@echo "  html         - Generate modern HTML with Quarto"
	@echo "  hevea        - Generate legacy HTML with HeVeA"
	@echo "  trinket      - Generate interactive HTML version"
	@echo ""
	@echo "🧹 Maintenance:"
	@echo "  clean        - Remove build artifacts"
	@echo "  distclean    - Remove all generated files"
	@echo ""
	@echo "📦 Distribution (ThinkDSP-style):"
	@echo "  distrib           - Confirm thinkjava2.pdf is ready to commit/push"
	@echo "  publish-gtp-dry   - Dry-run rsync PDF to Green Tea Press"
	@echo "  publish-gtp       - rsync PDF to GTP (stable URLs; needs Host gtp)"
	@echo ""
	@echo "🔧 Development:"
	@echo "  plastex      - Generate DocBook XML"
	@echo "  lint         - Validate generated XML"
	@echo ""
	@echo "🐍 Environment (conda/mamba):"
	@echo "  create_environment  - Create conda env from environment.yml"
	@echo "  update_environment  - Update env (mamba --prune)"
	@echo "  delete_environment  - Remove conda env"
	@echo ""
	@echo "Usage: make [target]"

# =============================================================================
# Conda / mamba environment
# =============================================================================

.PHONY: create_environment
create_environment: ## Create conda environment from environment.yml
	mamba env create -f environment.yml
	@echo ""
	@echo ">>> Environment created successfully!"
	@echo ">>> Activate with: conda activate $(PROJECT_NAME)"
	@echo ">>> Also install Quarto separately: https://quarto.org/docs/get-started/"

.PHONY: update_environment
update_environment: ## Update environment from environment.yml (with --prune)
	mamba env update -f environment.yml --prune
	@echo ">>> Environment updated successfully!"

.PHONY: delete_environment
delete_environment: ## Remove conda environment
	mamba env remove --name $(PROJECT_NAME)
	@echo ">>> Environment $(PROJECT_NAME) removed"

# =============================================================================
# Book Generation Targets
# =============================================================================

.PHONY: pdf
pdf: ## Generate PDF version (requires 3 passes for references)
	@echo "📖 Generating PDF version..."
	-$(PDFLATEX) -interaction=nonstopmode $(MAIN_FILE)
	-$(PDFLATEX) -interaction=nonstopmode $(MAIN_FILE)
	-$(PDFLATEX) -interaction=nonstopmode $(MAIN_FILE)
	@test -f $(BOOK_NAME).pdf
	@echo "✅ PDF generated: $(BOOK_NAME).pdf"

.PHONY: html
html: ## Generate modern HTML with Quarto
	@echo "🌐 Generating modern HTML with Quarto..."
	cd quarto && quarto render
	@echo "✅ HTML generated in quarto/_book/"

.PHONY: hevea
hevea: ## Generate legacy HTML with HeVeA
	@echo "🔄 Generating legacy HTML with HeVeA..."
	@mkdir -p heveahtml
	cp $(MAIN_FILE) $(BOOK_NAME)_.tex
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(BOOK_NAME)_
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(BOOK_NAME)_
	$(IMAGEN) -png -pdf $(BOOK_NAME)_
	$(HACHA) $(BOOK_NAME)_.html
	cp hevea/*.png heveahtml/
	cat custom.css >> $(BOOK_NAME)_.css
	mv index.html $(BOOK_NAME)_?*.html $(BOOK_NAME)_*.png $(BOOK_NAME)_.css heveahtml/
	rm -f *motif.gif $(BOOK_NAME)_.*
	@echo "🧹 Cleaning up HTML files..."
	sed -i 's/\\%/%/g' heveahtml/*.html
	sed -i 's/\\{/{/g' heveahtml/*.html
	sed -i 's/\\}/}/g' heveahtml/*.html
	sed -i 's/\\\\n/\\n/g' heveahtml/*.html
	sed -i 's/\\\\t/\\t/g' heveahtml/*.html
	$(PYTHON) hevea/rename.py heveahtml
	@echo "✅ Legacy HTML generated in heveahtml/"

.PHONY: trinket
trinket: ## Generate interactive HTML version
	@echo "🎮 Generating interactive HTML with Trinket..."
	@mkdir -p trinkethtml
	cp $(MAIN_FILE) $(BOOK_NAME)_.tex
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(BOOK_NAME)_
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(BOOK_NAME)_
	$(IMAGEN) -png -pdf $(BOOK_NAME)_
	$(IMAGEN) -png -pdf $(BOOK_NAME)_
	$(HACHA) $(BOOK_NAME)_.html
	cp trinket/*.css trinket/*.js trinkethtml/
	mv index.html $(BOOK_NAME)_.css $(BOOK_NAME)_?*.html $(BOOK_NAME)_*.png trinkethtml/
	rm -f *motif.gif $(BOOK_NAME)_.*
	@echo "🧹 Cleaning up HTML files..."
	sed -i 's/\\%/%/g' trinkethtml/*.html
	sed -i 's/\\{/{/g' trinkethtml/*.html
	sed -i 's/\\}/}/g' trinkethtml/*.html
	sed -i 's/\\\\n/\\n/g' trinkethtml/*.html
	sed -i 's/\\\\t/\\t/g' trinkethtml/*.html
	@echo "🔧 Running post-processing..."
	perl -i -pe 's/\[\[\[\[\s?(\S*?)\s?\]\]\]\]/----{\1}----/g' trinkethtml/*.html
	perl -i -pe 's/\<a .*? ALT\=\"(Previous|Up|Next)\"\>\<\/a\>//g' trinkethtml/*.html
	perl -0777 -i -pe 's/\<hr\>//' trinkethtml/*.html
	@echo "📝 Generating Nunjucks templates..."
	mkdir -p trinkethtml/nunjucks
	$(PYTHON) trinket/maketemplates.py
	@echo "🖼️  Organizing images..."
	mkdir -p trinkethtml/img
	cp trinkethtml/*.png trinkethtml/img/
	@echo "✅ Interactive HTML generated in trinkethtml/"

# =============================================================================
# Development Tools
# =============================================================================

.PHONY: plastex
plastex: ## Generate DocBook XML with plasTeX
	@echo "📄 Generating DocBook XML..."
	latexpand --keep-comments $(MAIN_FILE).tex > $(BOOK_NAME).expand
	$(PYTHON2) preprocess.py $(BOOK_NAME).expand > $(BOOK_NAME).plastex
	plastex --renderer=DocBook --theme=book --image-resolution=300 --filename=$(BOOK_NAME).xml $(BOOK_NAME).plastex
	cd $(BOOK_NAME) && $(PYTHON2) ../postprocess.py $(BOOK_NAME).xml > temp && mv temp $(BOOK_NAME).xml
	cd $(BOOK_NAME) && $(PYTHON) ../xmlsplit.py $(BOOK_NAME).xml
	@echo "✅ DocBook XML generated in $(BOOK_NAME)/"

.PHONY: lint
lint: ## Validate generated XML
	@echo "🔍 Validating XML..."
	xmllint -noout $(BOOK_NAME)/$(BOOK_NAME).xml
	@echo "✅ XML validation passed"

# =============================================================================
# Maintenance Targets
# =============================================================================

.PHONY: clean
clean: ## Remove build artifacts
	@echo "🧹 Cleaning build artifacts..."
	rm -f comment.cut $(BOOK_NAME).aux $(BOOK_NAME).idx $(BOOK_NAME).ilg $(BOOK_NAME).ind
	rm -f $(BOOK_NAME).log $(BOOK_NAME).out $(BOOK_NAME).toc $(BOOK_NAME).dvi
	rm -f $(BOOK_NAME).4ct $(BOOK_NAME).4tc $(BOOK_NAME).idv $(BOOK_NAME).lg
	rm -f $(BOOK_NAME).xref $(BOOK_NAME).tmp $(BOOK_NAME).css $(BOOK_NAME).html
	rm -f $(BOOK_NAME)_*.tex $(BOOK_NAME)_*.html $(BOOK_NAME)_*.css $(BOOK_NAME)_*.png
	@echo "✅ Cleanup complete"

.PHONY: distclean
distclean: clean ## Remove all generated files
	@echo "🧹 Deep cleaning..."
	rm -rf $(BUILD_DIR) $(DIST_DIR) heveahtml trinkethtml
	rm -rf $(BOOK_NAME)/
	rm -f $(BOOK_NAME).pdf $(BOOK_NAME).expand $(BOOK_NAME).plastex
	@echo "✅ Deep cleanup complete"

# =============================================================================
# Distribution (ThinkDSP-style)
# =============================================================================
# GitHub is canonical for the LaTeX PDF: build with `make pdf`, then commit and
# push thinkjava2.pdf (see `make distrib`). Quarto HTML stays on GitHub Pages.
#
# Green Tea Press keeps stable URLs (e.g. greenteapress.com/thinkjava7/).
# Mirror the PDF from any machine with ~/.ssh/config Host gtp:
#   make publish-gtp-dry && make publish-gtp
# Never uses --delete; PDF only (no HeVeA HTML in this ritual).

.PHONY: distrib publish-gtp-dry publish-gtp

distrib: ## Stage LaTeX PDF for GitHub commit (does not upload)
	@test -f $(BOOK_NAME).pdf || (echo ">>> missing $(BOOK_NAME).pdf; run make pdf" && exit 1)
	@echo ">>> Ready for GitHub (git add/commit/push $(BOOK_NAME).pdf):"
	@ls -lh $(BOOK_NAME).pdf
	@echo ">>> Optional GTP mirror: make publish-gtp-dry && make publish-gtp"

# Override if needed: make publish-gtp GTP_HOST=gtp GTP_DIR=greenteapress.com/thinkjava7
GTP_HOST ?= gtp
GTP_DIR  ?= greenteapress.com/thinkjava7
RSYNC_GTP = $(RSYNC) -avz --itemize-changes $(BOOK_NAME).pdf \
	$(GTP_HOST):$(GTP_DIR)/

publish-gtp-dry: ## Dry-run rsync PDF to Green Tea Press
	@test -f $(BOOK_NAME).pdf || (echo ">>> missing $(BOOK_NAME).pdf; run make pdf" && exit 1)
	$(RSYNC_GTP) -n
	@echo ">>> Dry run only. If that looks right: make publish-gtp"

publish-gtp: ## rsync PDF to GTP (never --delete; PDF only)
	@test -f $(BOOK_NAME).pdf || (echo ">>> missing $(BOOK_NAME).pdf; run make pdf" && exit 1)
	$(RSYNC_GTP)
	@echo ">>> Published to $(GTP_HOST):$(GTP_DIR)/"

# =============================================================================
# Legacy targets (kept for compatibility)
# =============================================================================

.PHONY: all
all: pdf ## Alias for pdf target

.PHONY: xxe
xxe: ## Open XML in XML Copy Editor (legacy)
	xmlcopyeditor ~/ThinkJava2/$(BOOK_NAME)/$(BOOK_NAME).xml &

# =============================================================================
# Special notes
# =============================================================================
# Note: If HeVeA fails due to OCaml bugs, use: make -i hevea
# Note: Most users should use 'make html' for the modern Quarto version
