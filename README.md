# ThinkJava2
LaTeX source for Think Java, 2nd edition. Copyright (c) 2019 Allen Downey and Chris Mayfield. **This new edition is a work in progress and won't be completed until Fall 2019.**

Permission is granted to copy, distribute, and/or modify this work under the terms of the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License, which is available at https://creativecommons.org/licenses/by-nc-sa/4.0/.

The original form of this book is the LaTeX source code available from http://greenteapress.com/wp/think-java-2e/ and https://github.com/ChrisMayfield/ThinkJava2.

The illustrations were drawn using xfig (http://www.xfig.org/) and dia (https://wiki.gnome.org/Apps/Dia/). These tools are free and open-source.

Compiling the LaTeX source has the effect of generating a device-independent representation of the book, which can be converted to other formats and printed.

To compile the PDF version from source:

    pdflatex thinkjava2.tex
    pdflatex thinkjava2.tex
    pdflatex thinkjava2.tex

The source code includes a Makefile that automates this process. On Linux, you may need to install texlive-latex-extra and texlive-fonts-recommended.

To build the HTML versions, the hevea package is required. Use the Makefile as follows:

    make hevea    # static html
    make trinket  # interactive
