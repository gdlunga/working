#!/usr/bin/python
# -*- coding: utf-8 -*-

eccezioni = {  'bijou'          :'bijoux'           #gioiello
             , 'caillou'        :'cailloux'         #sasso
             , 'genou'          :'genoux'           #ginocchio
             , 'joujou'         :'joujoux'          #giocattolo
             , 'pou'            :'poux'             #pidocchio
             , 'chou'           :'choux'            #cavolo
             , 'hibou'          :'hiboux'           #gufo
             , 'travail'        :'travaux'          #lavoro
             , 'émail'          :'émaux'            #smalto
             , 'corail'         :'coraux'           #corallo
             , 'vitrail'        :'vitraux'          #vetrata     
             , 'oeil'           :'yeux'             #occhio
             , 'madame'         :'mesdames'         #signora
             , 'monsieur'       :'messieurs'        #signore
             , 'mademoiselle'   :'mesdemoiselles'   #signorina       
             }

eccezioni_1 = {  'bal'          : 'bals'
               , 'fatal'        : 'fatals'
               , 'festival'     : 'festivals'
               , 'naval'        : 'navals'
               }

eccezioni_2 = {  'pneu'         : 'pneus'
               , 'bleu'         : 'bleus'
               }

def plurale(token):
    
    # controllo se token appartiene ad un'eccezione nota
    if token in eccezioni.keys():
        return eccezioni[token]

    # terminazione in -s, -x, -z
    if token[-1] in ['s','x','z']:
        return token
        
    # terminazione in -al
    if token[-2:] == 'al':
        if token in eccezioni_1.keys():
            return eccezioni_1[token]
        else:    
            return token[:len(token)-2] + 'aux'
    
    # terminazione in -au, -eu, -eau
    if token[-2:] in ['au', 'eu'] or token[-3:] == 'eau':
        if token in eccezioni_2.keys():
            return eccezioni_2[token]
        else:
            return token + 'x'
 
    return unicode(token + 's')    
#_______________________________________________________________________________________________________________________________
#
if __name__ == "__main__":
    while 1:
        token  = raw_input("Inserire il termine al singolare > ")
        if token == '0':
            break
        print plurale(unicode(token))
        
    print 'programma terminato'    