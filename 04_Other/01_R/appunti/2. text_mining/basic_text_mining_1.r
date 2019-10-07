# Reference : https://www.r-bloggers.com/introducing-pdftools-a-fast-and-portable-pdf-extractor/

if(!require(pdftools)){
  install.packages("pdftools")
  library(pdftools)
} 


file_path = 'https://www.eba.europa.eu/documents/10180/1989045/Final+Guidelines+on+complaint+procedures+under+PSD2+%28EBA-GL-2017-13%29.pdf'

download.file(file_path, 'PSD2', mode='wb')

txt <- pdf_text('PSD2')

# Table of contents
toc <- pdf_toc('PSD2')

# Show as JSON
jsonlite::toJSON(toc, auto_unbox = TRUE, pretty = TRUE)

# Author, version, etc
info <- pdf_info("PSD2")
