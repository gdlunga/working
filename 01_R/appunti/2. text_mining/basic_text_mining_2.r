library(stringr)

if(!require(pdftools)){
  install.packages("pdftools")
  library(pdftools)
} 

# Creazione corpus txt

file_path_orig = 'C:\\Users\\T004314\\Documents\\GitHub\\working\\01_R\\appunti\\2. text_mining\\pdf'
file_path_dest = 'C:\\Users\\T004314\\Documents\\GitHub\\working\\01_R\\appunti\\2. text_mining\\txt'

myfiles = list.files(file_path, pattern = "\\.pdf")


for(thisfile in myfiles){
  # costruzione del nome del file txt in cui sara' salvata l'estrazione
  # da pdf. Nota. Capire bene perché per sottrarre gli ultimi 4 caratteri
  # occorre passare il valore 5!
  txt_file_name = paste(str_sub(thisfile,1,length(thisfile)-5),"txt",sep="")  
  txt_file_name = file.path(file_path_dest, txt_file_name)
  txt <- pdf_text(file.path(file_path_orig,thisfile))  

  fileConn = file(txt_file_name)
  write(txt, fileConn)
  close(fileConn)
}

