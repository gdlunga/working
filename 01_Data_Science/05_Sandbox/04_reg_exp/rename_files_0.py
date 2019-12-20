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
    #print(item) 
#print("\nrule 1 -----> ",k, "items found\n")

k = 0
for item in w2:
    k+=1
    #print(item) 
#print("\nrule 2 -----> ",k, "items found\n")
    
k = 0
for item in w3:
    k+=1
    #print(item) 
#print("\nrule 3 -----> ",k, "items found\n")
            
k = 0
for item in w4:
    k+=1
    #print(item) 
#print("\nrule 4 -----> ",k, "items found\n")
#
# estrazione e conversione della data in un formato standard
#   
#
# create dictonary for month names
#
dict_months = {'gen':1, 'feb':2,'mar':3,'apr':4,'mag':5,'giu':6,'lug':7,'ago':8,'set':9,'ott':10,'nov':11,'dic':12}
#
# -----> use rule 1
#
dict_file_names = {} 
p = re.compile('[0-9]{2}\.[0-9]{2}\.[0-9]{4}')    
for w in onlyfiles:
    res = p.search(w)
    if res is not None: 
        data = res.group().split('.')
        #
        dd = data[0]
        mm = data[1]
        yy = data[2]
        #
        data_str  = '-'.join([yy,mm,dd])
        file_name = "comitato-finanza-" + data_str
        dict_file_names[w] = file_name
#
# -----> use rule 2
#
dict_file_names = {} 
p = re.compile('^[0-9]{4}_[0-9]{2}_[0-9]{2}')    
for w in onlyfiles:
    res = p.search(w)
    if res is not None: 
        data = res.group().split('_')
        #
        yy = data[0]
        mm = data[1]
        dd = data[2]
        #
        data_str  = '-'.join([yy,mm,dd])
        file_name = "comitato-finanza-" + data_str
        dict_file_names[w] = file_name
#
# -----> use rule 3
#
dict_file_names = {} 
p = re.compile('[0-9]{2}[a-z]+[0-9]{4}')    
for w in onlyfiles:
    res = p.search(w)
    if res is not None: 
        data = res.group()
        #
        dd = str(data[:2])
        mm = str(dict_months[data[2:5]])
        yy = str(data[5:])
        #
        data_str  = '-'.join([yy,mm,dd])
        file_name = "comitato-finanza-" + data_str
        dict_file_names[w] = file_name
#
# -----> use rule 4
#
dict_file_names = {} 
p = re.compile('[0-9]{2} [a-zA-Z]+ [0-9]{4}')    
for w in onlyfiles:
    res = p.search(w)
    if res is not None: 
        data = res.group().split(' ')
        #
        yy = data[2]
        dd = data[0]
        mm = (data[1][:3]).lower()
        mm = "%02d" % dict_months[mm]
        #
        data_str  = '-'.join([yy,mm,dd])
        file_name = "comitato-finanza-" + data_str
        dict_file_names[w] = file_name
    
    
for key,value in dict_file_names.items():
    print(key + " => " + value)   
    