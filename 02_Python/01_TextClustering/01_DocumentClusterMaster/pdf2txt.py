#import os

#for file in os.listdir("./pdf"):
#    if file.endswith(".pdf"):
#        print(os.path.join("./pdf", file))
        
        
import PyPDF2

pdf_file = open('./pdf/All_4 Relazione AIRB.pdf', 'rb')
read_pdf = PyPDF2.PdfFileReader(pdf_file)
number_of_pages = read_pdf.getNumPages()
print number_of_pages

for i in range(1, number_of_pages):
    page = read_pdf.getPage(i)
    page_content = page.extractText()
    print page_content.encode('utf-8')        
