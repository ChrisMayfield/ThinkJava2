#!/bin/bash
# convert EPS to PDF version 1.4

if [ -z $1 ]
then
    echo "usage: $0 file.eps"
    exit 1
fi

epstopdf $1
PDF=${1%.eps}.pdf

gs -dBATCH -dNOPAUSE -dQUIET -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -sOutputFile=TEMP.pdf $PDF
mv TEMP.pdf $PDF
