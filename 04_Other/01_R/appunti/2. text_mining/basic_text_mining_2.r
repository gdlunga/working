library(stringr)

if(!require(pdftools)){
  install.packages("pdftools")
  library(pdftools)
} 

# individuazione percorsi file dati
data_path = 'C:\\Users\\T004314\\Documents\\Working\\03_MyTools'
file_path_orig = file.path(data_path, 'pdf')
file_path_dest = file.path(data_path, 'txt')

# la funzione list.files permette di ottenere un vettore di stringhe
# contenente i nomi dei file presenti del percorso passato in input
# alla funzione con un pattern di ricerca definito dall'utente 
# (nel nostro caso pdf)
myfiles = list.files(file_path_orig, pattern = "\\.pdf")
# salvataggio delle stringhe della lista in un file di testo
# utilizzando il medoto lapply
lapply(myfiles, write, file.path(file_path_dest,"(000)_file_names.txt"), append=TRUE, ncolumns=1000)

for(thisfile in myfiles){
  txt <-''  
  # costruzione del nome del file txt in cui sara' salvata l'estrazione
  # da pdf. Nota. Capire bene perché per sottrarre gli ultimi 4 caratteri
  # occorre passare il valore 5!
  txt_file_name = paste(str_sub(thisfile,1,length(thisfile)-5),"txt",sep="")  
  # aggiunta del path di destinazione
  txt_file_name = file.path(file_path_dest, txt_file_name)
  # conversione dei pdf in txt
  try(txt <- pdf_text(file.path(file_path_orig,thisfile)))  
  # apertura file di testo e scrittura del testo estratto dal file pdf
  fileConn = file(txt_file_name)
  write(txt, fileConn)
  close(fileConn)
}

