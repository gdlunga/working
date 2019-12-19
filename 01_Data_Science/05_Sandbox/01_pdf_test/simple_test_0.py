import PyPDF2

pdf_path = 'C:/Users/T004314/Documents/Working/PDFReader/pdf/'
pdf_name = 'd368.pdf'

print(pdf_path + pdf_name)

pdfFileObj = open(pdf_path + pdf_name,'rb')



pdfReader       = PyPDF2.PdfFileReader(pdfFileObj)

page            = pdfReader.getPage(0)
page_mode       = pdfReader.getPageMode()

page_content    = page.extractText()

print(page_content) 

# closing the pdf file object
pdfFileObj.close()
