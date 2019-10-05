#!/bin/bash
# convert Xfig to PDF version 1.4

if [ -z $1 ]
then
    echo "usage: $0 file.fig"
    exit 1
fi

fig2pdf --nogv $1
PDF=${1%.fig}.pdf

gs -dBATCH -dNOPAUSE -dQUIET -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -sOutputFile=TEMP.pdf $PDF
mv TEMP.pdf $PDF
