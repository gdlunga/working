#____________________________________________________________________________________________________
#
#Modulo         : rename_files
#Descrizione    : Read all file names in a specific folder and 
#                 search for the date info inside the name 
#Autore         : Giovanni Della Lunga
#Versione       : 1.0
#Data           :
#Note           : ref. https://stackoverflow.com/questions/3207219/how-do-i-list-all-files-of-a-directory
#Modifiche      : 
#____________________________________________________________________________________________________
#
# 
import re 
from os import listdir
from os.path import isfile, join
#____________________________________________________________________________________________________
#
def rule_1(w, p):
    file_name = ''
    res = p.search(w)
    if res is not None: 
        data = res.group().split('.')
        #
        dd = data[0]
        mm = data[1]
        yy = data[2]
        data_str  = '-'.join([yy,mm,dd])
        file_name = "comitato-finanza-liquidita-" + data_str
    return file_name    
#____________________________________________________________________________________________________
#
def rule_2(w, p):
    file_name=''
    res = p.search(w)
    if res is not None: 
        data = res.group().split('_')
        #
        yy = data[0]
        mm = data[1]
        dd = data[2]
        #
        data_str  = '-'.join([yy,mm,dd])
        file_name = "comitato-finanza-liquidita-" + data_str
    return file_name    
#____________________________________________________________________________________________________
#
def rule_3(w,p):   
    file_name=''
    res = p.search(w)
    if res is not None: 
        data = res.group()
        #
        dd = str(data[:2])
        mm = str(dict_months[data[2:5]])
        yy = str(data[5:])
        #
        data_str  = '-'.join([yy,mm,dd])
        file_name = "comitato-finanza-liquidita-" + data_str
    return file_name    
#____________________________________________________________________________________________________
#
def rule_4(w,p):
    file_name=''
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
        file_name = "comitato-finanza-liquidita-" + data_str
    return file_name    
#____________________________________________________________________________________________________
#
mypath = "C:/Users/t004314/Documents/GitHub/working/01_Data_Science/03_Progetti/01_Document_Manager/pdf"

onlyfiles = [f.replace(".pdf","") for f in listdir(mypath) if isfile(join(mypath, f))]
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

for w in onlyfiles:
    p           = re.compile('[0-9]{2}\.[0-9]{2}\.[0-9]{4}')    
    file_name   = rule_1(w, p)
    if file_name: dict_file_names[w] = file_name

for w in onlyfiles:
    p           = re.compile('^[0-9]{4}_[0-9]{2}_[0-9]{2}')    
    file_name   = rule_2(w, p)
    if file_name: dict_file_names[w] = file_name

for w in onlyfiles:
    p           = re.compile('[0-9]{2}[a-z]+[0-9]{4}')    
    file_name   = rule_3(w, p)
    if file_name: dict_file_names[w] = file_name

for w in onlyfiles:
    p           = re.compile('[0-9]{2} [a-zA-Z]+ [0-9]{4}')    
    file_name   = rule_4(w, p)
    if file_name: dict_file_names[w] = file_name

    
    
for key,value in dict_file_names.items():
    print(key + " => " + value)   
    