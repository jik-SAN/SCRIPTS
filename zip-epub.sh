#!/bin/bash
rm -f MynewEbook.epub
zip -X MynewEbook.epub mimetype
zip -rg MynewEbook.epub META-INF -x \*.DS_STORE
zip -rg MynewEbook.epub OEBPS -x \*.DS_STORE
[ -d Fonts ] && zip -rg MynewEbook.epub Fonts -x \*.DS_STORE
