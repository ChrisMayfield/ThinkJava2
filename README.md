# ThinkJava2
LaTeX source and code for Think Java, 7th edition. Copyright (C) 2017 Allen Downey and Chris Mayfield. **This new edition is a work in progress and won't be completed until May 2019.**

Permission is granted to copy, distribute, and/or modify this work under the terms of the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License, which is available at https://creativecommons.org/licenses/by-nc-sa/4.0/.

The original form of this book is the LaTeX source code available from http://thinkjava.org and https://github.com/ChrisMayfield/ThinkJava2.

The illustrations were drawn using xfig (http://www.xfig.org/) and dia (https://wiki.gnome.org/Apps/Dia/). These tools are free and open-source.

Compiling the LaTeX source has the effect of generating a device-independent representation of the book, which can be converted to other formats and printed.

To compile the PDF version from source:

    pdflatex thinkjava.tex
    pdflatex thinkjava.tex
    makeindex thinkjava.idx
    pdflatex thinkjava.tex
    pdflatex thinkjava.tex

The source code includes a Makefile that automates this process. On Linux, you will need to install texlive-latex-extra and hevea.
