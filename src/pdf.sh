#!/usr/bin/env bash


# add pdf.js to github pages


set -ex


PDFJS_VER="4.10.38"
PDFJS_REL_URL="https://github.com/mozilla/pdf.js/releases/download/v$PDFJS_VER/pdfjs-$PDFJS_VER-dist.zip"


# check if unzip is installed
if ! command -v unzip &> /dev/null; then
    echo "unzip is not installed, install now..."
    apt update
    apt install -y unzip
fi

# check if either wget or curl is installed
if command -v wget &> /dev/null; then
    wget $PDFJS_REL_URL -O pdfjs.zip
elif command -v curl &> /dev/null; then
    curl -L $PDFJS_REL_URL -o pdfjs.zip
else
    echo "either wget or curl is required to download pdf.js, install wget now..."
    apt update
    apt install -y wget
    wget $PDFJS_REL_URL -O pdfjs.zip
fi


# unzip to ./res/pdf
mkdir -p res/pdf
unzip pdfjs.zip -d res/pdf

## replace "../build/pdf.mjs" to cdnjs source
## sed -i "s|../build/pdf.mjs|https://cdnjs.cloudflare.com/ajax/libs/pdf.js/$PDFJS_VER/pdf.mjs|g" res/pdf/web/viewer.html
#sed -i "s|../build/pdf.mjs|https://cdnjs.cloudflare.com/ajax/libs/pdf.js/$PDFJS_VER/pdf.min.mjs|g" res/pdf/web/viewer.html
## and "viewer.mjs"
#sed -i "s|viewer.mjs|https://cdnjs.cloudflare.com/ajax/libs/pdf.js/$PDFJS_VER/pdf_viewer.mjs|g" res/pdf/web/viewer.html
## sed -i "s|viewer.mjs|https://cdnjs.cloudflare.com/ajax/libs/pdf.js/$PDFJS_VER/pdf_viewer.min.mjs|g" res/pdf/web/viewer.html
## no such file!
## and "viewer.css"
## sed -i "s|viewer.css|https://cdnjs.cloudflare.com/ajax/libs/pdf.js/$PDFJS_VER/pdf_viewer.css|g" res/pdf/web/viewer.html
#sed -i "s|viewer.css|https://cdnjs.cloudflare.com/ajax/libs/pdf.js/$PDFJS_VER/pdf_viewer.min.css|g" res/pdf/web/viewer.html


# now we can remove the zip file
rm pdfjs.zip
## and the mjs files
#rm -rf res/pdf/web/build
#rm res/pdf/web/viewer.mjs
#rm res/pdf/web/viewer.mjs.map
#rm res/pdf/web/viewer.css

# python3 -m http.server 8080
