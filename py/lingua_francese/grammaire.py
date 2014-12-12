from exceptions_pluriel import *
from exceptions_feminin import *

def pluriel(token):
    
    # controllo se token appartiene ad un'eccezione nota
    if token in eccezioni_pl_1.keys():
        return eccezioni_pl_1[token]

    # terminazione in -s, -x, -z
    if token[-1] in ['s','x','z']:
        return token
        
    # terminazione in -al
    if token[-2:] == 'al':
        if token in eccezioni_pl_2.keys():
            return eccezioni_pl_2[token]
        else:    
            return token[:len(token)-2] + 'aux'
    
    # terminazione in -au, -eu, -eau
    if token[-2:] in ['au', 'eu'] or token[-3:] == 'eau':
        if token in eccezioni_pl_3.keys():
            return eccezioni_pl_3[token]
        else:
            return token + 'x'
 
    return unicode(token + 's')    
#_______________________________________________________________________________________________________________________________
#
def feminin(token):
    
    pass
#_______________________________________________________________________________________________________________________________
#
if __name__ == "__main__":
    while 1:
        token  = raw_input("Inserire il termine al singolare > ")
        if token == '0':
            break
        print pluriel(unicode(token))
        
    print 'programma terminato'    
