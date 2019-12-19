#____________________________________________________________________________________________________
#
#Funzione       : rename_files
#Descrizione    : Read all file names in a specific folder and 
#                 search for the date info inside the name 
#Autore         : Giovanni Della Lunga
#Versione       : 1.0
#Data           :
#Note           : ref. https://stackoverflow.com/questions/3207219/how-do-i-list-all-files-of-a-directory
#Modifiche      : 
#____________________________________________________________________________________________________
#
# How can I list all files of a directory in Python and add 
# them to a list?
#
# os.listdir() will get you everything that's in a directory - files and directories.
# If you want just files, you could either filter this down using os.path as in the
# following code
# 
import re 
from os import listdir
from os.path import isfile, join

mypath = "C:/Users/t004314/Documents/GitHub/working/01_Data_Science/03_Progetti/01_Document_Manager/pdf"

onlyfiles = [f.replace(".pdf","") for f in listdir(mypath) if isfile(join(mypath, f))]

w1 = [w for w in onlyfiles if re.search('[0-9]{2}\.[0-9]{2}\.[0-9]{4}', w)]
w2 = [w for w in onlyfiles if re.search('^[0-9]{4}', w)]
w3 = [w for w in onlyfiles if re.search('[0-9]{2}[a-z]+[0-9]{4}', w)]
w4 = [w for w in onlyfiles if re.search('[0-9]{2} [a-zA-Z]+ [0-9]{4}', w)]

k = 0
for item in w1:
    k+=1
    print(item) 
print("\n-----> ",k, "items found\n")

k = 0
for item in w2:
    k+=1
    print(item) 
print("\n-----> ",k, "items found\n")
    
k = 0
for item in w3:
    k+=1
    print(item) 
print("\n-----> ",k, "items found\n")
            
k = 0
for item in w4:
    k+=1
    print(item) 
print("\n-----> ",k, "items found\n")
#
# estrazione e conversione della data in un formato standard
#    
p = re.compile('[0-9]{2} [a-zA-Z]+ [0-9]{4}')    
for w in onlyfiles:
    res = p.search(w)
    if res is not None: print(res.span(), res.group())
    
    