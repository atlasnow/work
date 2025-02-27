#!/usr/bin/env bash


# add pdf.js to github pages


set -ex


PDFJS_VER="4.10.38"
PDFJS_REL_URL="https://github.com/mozilla/pdf.js/releases/download/v$PDFJS_VER/pdfjs-$PDFJS_VER-dist.zip"

ARTWOTK_URL="https://github.com/atlasnow/work/releases/download/2502/artwork250227desensitized.pdf"


# check if unzip is installed
if ! command -v unzip &> /dev/null; then
    echo "unzip is not installed, install now..."
    apt update
    apt install -y unzip
fi

# check if either wget or curl is installed
if command -v wget &> /dev/null; then
    wget $PDFJS_REL_URL -O pdfjs.zip
    wget $ARTWOTK_URL -O artwork250227desensitized.pdf
elif command -v curl &> /dev/null; then
    curl -L $PDFJS_REL_URL -o pdfjs.zip
    curl -L $ARTWOTK_URL -o artwork250227desensitized.pdf
else
    echo "either wget or curl is required to download pdf.js, install wget now..."
    apt update
    apt install -y wget
    wget $PDFJS_REL_URL -O pdfjs.zip
    wget $ARTWOTK_URL -O artwork250227desensitized.pdf
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

# allow origin
# sed -i 's|const HOSTED_VIEWER_ORIGINS = \[|const HOSTED_VIEWER_ORIGINS = \["https://github.com", "https://atlasnow.github.io", "https://objects.githubusercontent.com", "https://raw.githubusercontent.com", |g' res/pdf/web/viewer.mjs
# does not work

# sed -i 's|if (fileOrigin !== viewerOrigin) {|{// skip origin check 01|g' res/pdf/web/viewer.mjs
# sed -i 's|throw new Error("file origin|// skip origin check 02|g' res/pdf/web/viewer.mjs
# does not work

# f*ck cross origin
mkdir -p res/doc
mv artwork250227desensitized.pdf res/doc/

# now we can remove the zip file
rm pdfjs.zip
## and the mjs files
#rm -rf res/pdf/web/build
#rm res/pdf/web/viewer.mjs
#rm res/pdf/web/viewer.mjs.map
#rm res/pdf/web/viewer.css

# python3 -m http.server 8080
