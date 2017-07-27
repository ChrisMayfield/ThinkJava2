F=thinkjava

all:
	pdflatex $(F).tex
	pdflatex $(F).tex
	makeindex $(F).idx        # shouldn't need .idx here, but we do
	pdflatex $(F).tex
	pdflatex $(F).tex

clean:
	rm -f $(F).aux $(F).idx $(F).ilg $(F).ind $(F).log $(F).out $(F).toc

# a bug (in ocaml?) causes "make hevea" to fail; use "make -i hevea" instead
.PHONY: hevea
hevea:
	cp $(F).tex $(F)6.tex
	rm -rf heveahtml
	mkdir heveahtml
	hevea -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(F)6
	hevea -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(F)6
	imagen -png -pdf $(F)6
	imagen -png -pdf $(F)6
	hacha $(F)6.html
	cp hevea/*.png heveahtml
	mv index.html $(F)6.css $(F)6?*.html $(F)6*.png heveahtml
	rm *motif.gif $(F)6.*

# a bug (in ocaml?) causes "make trinket" to fail; use "make -i trinket" instead
.PHONY: trinket
trinket:
	cp $(F).tex $(F)6.tex
	rm -rf trinkethtml
	mkdir trinkethtml
	hevea -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(F)6
	hevea -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(F)6
	imagen -png -pdf $(F)6
	imagen -png -pdf $(F)6
	hacha $(F)6.html
	cp trinket/*.css trinket/*.js trinkethtml
	mv index.html $(F)6.css $(F)6?*.html $(F)6*.png trinkethtml
	rm *motif.gif $(F)6.*

	# perl postprocessing (woot) seems easier than escaping through Latex and Hevea
	perl -i -pe 's/100\\%/100%/g' trinkethtml/*.html
	perl -i -pe 's/\[\[\[\[\s?(\S*?)\s?\]\]\]\]/----{\1}----/g' trinkethtml/*.html
	perl -i -pe 's/\<a .*? ALT\=\"(Previous|Up|Next)\"\>\<\/a\>//g' trinkethtml/*.html
	perl -0777 -i -pe 's/\<hr\>//' trinkethtml/*.html

	# produce nunjucks templates for our app
	mkdir trinkethtml/nunjucks
	python trinket/maketemplates.py

	# gather images for ease of uploading to CDN
	mkdir trinkethtml/img
	cp trinkethtml/*.png trinkethtml/img
