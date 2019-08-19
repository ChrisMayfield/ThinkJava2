F=thinkjava2

all:
	pdflatex $(F).tex
	pdflatex $(F).tex
	pdflatex $(F).tex

clean:
	rm -f comment.cut $(F).aux $(F).idx $(F).ilg $(F).ind $(F).log $(F).out $(F).toc

plastex:
	# Before running plastex, we need the current directory in PYTHONPATH
	# export PYTHONPATH=$PYTHONPATH:.
	latexpand --keep-comments $(F).tex > $(F).expand
	python2 preprocess.py $(F).expand > $(F).plastex
	plastex --renderer=DocBook --theme=book --image-resolution=300 --filename=$(F).xml $(F).plastex
	cd $(F); python2 ../postprocess.py $(F).xml > temp; mv temp $(F).xml
	cd $(F); python ../xmlsplit.py $(F).xml

xxe:
	xmlcopyeditor ~/ThinkJava2/$(F)/$(F).xml &

lint:
	xmllint -noout $(F)/$(F).xml

oreilly:
	rsync -a $(F)/ch*.xml atlas/
	rsync -a $(F)/ap*.xml atlas/
	rsync -a figs/*.pdf atlas/figs/
	rsync -a figs/*.png atlas/figs/
	rsync -a figs/*.jpg atlas/figs/
	cd atlas; git add *.xml figs/*
	cd atlas; git commit -m "Automated check in."
	cd atlas; git push

# if a bug (in ocaml?) causes "make hevea" to fail; use "make -i hevea" instead

.PHONY: hevea
hevea:
	cp $(F).tex $(F)_.tex
	rm -rf heveahtml
	mkdir heveahtml
	hevea -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(F)_
	hevea -O -exec xxdate.exe -e latexonly.tex hevea/htmlonly.tex $(F)_
	imagen -png -pdf $(F)_
	imagen -png -pdf $(F)_
	hacha $(F)_.html
	cp hevea/*.png heveahtml
	mv index.html $(F)_.css $(F)_?*.html $(F)_*.png heveahtml
	rm *motif.gif $(F)_.*

.PHONY: trinket
trinket:
	cp $(F).tex $(F)_.tex
	rm -rf trinkethtml
	mkdir trinkethtml
	hevea -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(F)_
	hevea -O -exec xxdate.exe -e latexonly.tex trinket/htmlonly.tex $(F)_
	imagen -png -pdf $(F)_
	imagen -png -pdf $(F)_
	hacha $(F)_.html
	cp trinket/*.css trinket/*.js trinkethtml
	mv index.html $(F)_.css $(F)_?*.html $(F)_*.png trinkethtml
	rm *motif.gif $(F)_.*

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
