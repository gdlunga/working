import os
import re
import glob
from shutil import copyfile
from os import listdir
from os.path import isfile, join

#_______________________________________________________________________________________________________________________________
#
def copy_file_recursive(src, dst):
    files = glob.glob(src + '/**/*.pdf', recursive=True)
    for f in files:
        copyfile(f, os.path.join(dst,os.path.basename(f)))
        print (f)
#_______________________________________________________________________________________________________________________________
#
if __name__ == "__main__":
    
    src = "Y:/Servizio/04_Documentazione_Comitati/Comitato Gestione Rischi"
    dst = "C:/Users/t004314/Documents/GitHub/working/01_Data_Science/03_Progetti/01_Document_Manager/pdf_2"

    mypath = "C:/Users/t004314/Documents/GitHub/working/01_Data_Science/03_Progetti/01_Document_Manager/txt_2"

    #copy_file_recursive(src, dst)
    
    file_names = [re.sub(r'[0-9]+', '', f)  for f in listdir(mypath) if isfile(join(mypath, f))]
    
    pattern    = r'\[[^()]*\]'
    file_names = [re.sub(pattern, '', f)    for f in file_names]
    
    pattern    = r'\([^()]*\)'
    file_names = [re.sub(pattern, '', f)    for f in file_names]
    
    file_names = [f.replace('-','')         for f in file_names]
    file_names = [f.replace('_','')         for f in file_names]
    file_names = [f.replace('.txt','')      for f in file_names]
    file_names = [f.replace('(F)','')       for f in file_names]
    file_names = [f.replace('update al','') for f in file_names]
    
    pattern    = r' [A-Z]$'
    file_names = [re.sub(pattern, '', f)    for f in file_names]
    
    file_names = [f.strip()                 for f in file_names]
    
    for f in file_names:
        print(f)