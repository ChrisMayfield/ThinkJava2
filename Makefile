# ThinkJava2 Makefile
# Build system for the ThinkJava2 textbook project

# =============================================================================
# VARIABLES
# =============================================================================

# Main project filename
F := thinkjava2

# Directories
BUILD_DIR := build
HEVEA_DIR := heveahtml
TRINKET_DIR := trinkethtml
DIST_DIR := dist
DEST_DIR := /home/downey/public_html/greent/thinkjava7

# Tools
PYTHON := python
PYTHON2 := python2
PYTHON3 := python3
LATEX := pdflatex
PLASTEX := plastex
HEVEA := hevea
IMAGEN := imagen
HACHA := hacha
LATEXPAND := latexpand

# =============================================================================
# DEFAULT TARGET
# =============================================================================

.PHONY: all
all: pdf

# Note: 'all' builds only PDF. Use specific targets for other formats:
#   make plastex  - Build XML version
#   make hevea    - Build HTML version  
#   make trinket  - Build Trinket HTML version

# =============================================================================
# PDF BUILD
# =============================================================================

.PHONY: pdf
pdf:
	@echo "Building PDF..."
	$(LATEX) $(F).tex
	$(LATEX) $(F).tex
	$(LATEX) $(F).tex
	@echo "PDF build complete: $(F).pdf"

# =============================================================================
# XML BUILD (PLASTEX)
# =============================================================================

.PHONY: plastex
plastex:
	@echo "Building XML with PlasTeX..."
	@mkdir -p $(BUILD_DIR)
	# Before running plastex, we need the current directory in PYTHONPATH
	# export PYTHONPATH=$PYTHONPATH:.
	$(LATEXPAND) --keep-comments $(F).tex > $(F).expand
	$(PYTHON2) preprocess.py $(F).expand > $(F).plastex
	$(PLASTEX) --renderer=DocBook --theme=book --image-resolution=300 --filename=$(F).xml $(F).plastex
	cd $(BUILD_DIR); $(PYTHON2) ../postprocess.py $(F).xml > temp && mv temp $(F).xml
	cd $(BUILD_DIR); $(PYTHON) ../xmlsplit.py $(F).xml

# =============================================================================
# HTML BUILD (HEVEA)
# =============================================================================
# Note: hevea/ contains source files (htmlonly.tex, templates, scripts)
#       heveahtml/ contains generated HTML output (build artifacts)

.PHONY: hevea
hevea:
	@echo "Building HTML with HeVeA..."
	@rm -rf $(HEVEA_DIR)
	@mkdir -p $(HEVEA_DIR)
	cp $(F).tex $(F)_.tex
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(F)_
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(F)_
	$(IMAGEN) -png -pdf $(F)_
	# $(IMAGEN) -png -pdf $(F)_
	$(HACHA) $(F)_.html
	cp hevea/*.png $(HEVEA_DIR)
	cat custom.css >> $(F)_.css
	mv index.html $(F)_?*.html $(F)_*.png $(F)_.css $(HEVEA_DIR)
	rm -f *motif.gif $(F)_.*
	sed -i 's/\\%/%/g' $(HEVEA_DIR)/*.html
	sed -i 's/\\{/{/g' $(HEVEA_DIR)/*.html
	sed -i 's/\\}/}/g' $(HEVEA_DIR)/*.html
	sed -i 's/\\\\n/\\n/g' $(HEVEA_DIR)/*.html
	sed -i 's/\\\\t/\\t/g' $(HEVEA_DIR)/*.html
	$(PYTHON3) hevea/rename.py $(HEVEA_DIR)

# =============================================================================
# TRINKET BUILD
# =============================================================================

.PHONY: trinket
trinket:
	@echo "Building Trinket HTML..."
	@rm -rf $(TRINKET_DIR)
	@mkdir -p $(TRINKET_DIR)
	cp $(F).tex $(F)_.tex
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(F)_
	$(HEVEA) -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(F)_
	$(IMAGEN) -png -pdf $(F)_
	$(IMAGEN) -png -pdf $(F)_
	$(HACHA) $(F)_.html
	cp trinket/*.css trinket/*.js $(TRINKET_DIR)
	mv index.html $(F)_.css $(F)_?*.html $(F)_*.png $(TRINKET_DIR)
	rm -f *motif.gif $(F)_.*
	sed -i 's/\\%/%/g' $(TRINKET_DIR)/*.html
	sed -i 's/\\{/{/g' $(TRINKET_DIR)/*.html
	sed -i 's/\\}/}/g' $(TRINKET_DIR)/*.html
	sed -i 's/\\\\n/\\n/g' $(TRINKET_DIR)/*.html
	sed -i 's/\\\\t/\\t/g' $(TRINKET_DIR)/*.html

	# Perl postprocessing for Trinket-specific formatting
	perl -i -pe 's/\[\[\[\[\s?(\S*?)\s?\]\]\]\]/----{\1}----/g' $(TRINKET_DIR)/*.html
	perl -i -pe 's/\<a .*? ALT\=\"(Previous|Up|Next)\"\>\<\/a\>//g' $(TRINKET_DIR)/*.html
	perl -0777 -i -pe 's/\<hr\>//' $(TRINKET_DIR)/*.html

	# Produce Nunjucks templates for our app
	@mkdir -p $(TRINKET_DIR)/nunjucks
	$(PYTHON) trinket/maketemplates.py

	# Gather images for ease of uploading to CDN
	@mkdir -p $(TRINKET_DIR)/img
	cp $(TRINKET_DIR)/*.png $(TRINKET_DIR)/img

# =============================================================================
# UTILITY TARGETS
# =============================================================================

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -f comment.cut $(F).aux $(F).idx $(F).ilg $(F).ind $(F).log $(F).out $(F).toc
	rm -f $(F).expand $(F).plastex
	rm -rf $(BUILD_DIR) $(HEVEA_DIR) $(TRINKET_DIR) $(DIST_DIR)

.PHONY: clean-all
clean-all: clean
	@echo "Cleaning all generated files..."
	rm -f $(F).pdf

.PHONY: xxe
xxe:
	@echo "Opening XML in XML Copy Editor..."
	xmlcopyeditor ~/ThinkJava2/$(BUILD_DIR)/$(F).xml &

.PHONY: lint
lint: $(BUILD_DIR)/$(F).xml
	@echo "Validating XML..."
	xmllint -noout $(BUILD_DIR)/$(F).xml

# =============================================================================
# DISTRIBUTION
# =============================================================================

.PHONY: distrib
distrib:
	@echo "Creating distribution package..."
	rsync -a $(F).pdf $(DIST_DIR)
	rsync -a $(HEVEA_DIR)/ $(DIST_DIR)/html/
	rsync -a $(DIST_DIR)/* $(DEST_DIR)
	chmod -R o+r $(DEST_DIR)/*
	cd $(DEST_DIR)/..; sh back
	@echo "Distribution complete: $(DEST_DIR)"

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

# =============================================================================
# HELP
# =============================================================================

.PHONY: help
help:
	@echo "ThinkJava2 Makefile - Available targets:"
	@echo ""
	@echo "  all/pdf     - Build PDF version (default)"
	@echo "  plastex     - Build XML version using PlasTeX"
	@echo "  hevea       - Build HTML version using HeVeA"
	@echo "  trinket     - Build Trinket HTML version"
	@echo "  distrib     - Create distribution package"
	@echo ""
	@echo "  clean       - Remove build artifacts"
	@echo "  clean-all   - Remove all generated files"
	@echo "  lint        - Validate XML output"
	@echo "  xxe         - Open XML in XML Copy Editor"
	@echo "  help        - Show this help message"
	@echo ""
	@echo "Note: If HeVeA fails due to OCaml bugs, use 'make -i hevea'"
