#!/usr/bin/python
# -*- coding: utf-8 -*-
from exceptions_pluriel import *
from exceptions_feminin import *
#_______________________________________________________________________________________________________________________________
#
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
def feminin_nom(token):
    
    token = token.encode('latin1')
    # controlliamo se il token appartiene alla lista dei femminili irregolari
    if token in feminin_irreg.keys():
        return feminin_irreg[token] 
    
    # controllo terminazione in -e
    if token[-1] == 'e':
        if token in except_fem_nom_end_e.keys():
            return except_fem_nom_end_e[token]
        return token
    
    # nomi terminanti in -er
    if token[-2:] == 'er':
        return token[:-2] + 'ère'
    
    # nomi terminanti in -an, -en, -on, -el, -et
    if token[-2:] in ['an','en','on','el','et']:
        ultima_consonante = token[-1]
        return token + ultima_consonante + 'e'
    
    # nomi terminanti in -f
    if token[-1]=='f':
        return token[:-1] + 've'
    
    # nomi terminanti in -x
    if token[-1]=='x':
        return token[:-1] + 'se'
    
    # attenzione all'ordine dei prossimi due controlli
    # l'ordine non deve essere invertito
    # nomi terminanti in -teur
    if token[-4:]=='teur':
        if token in except_fem_nom_end_teur.keys():
            return except_fem_nom_end_teur[token]
        return token[:-4] + 'trice'
    
    # nomi terminanti in -eur
    if token[-3:] == 'eur':
        return token[:-3] + 'euse'
    
    return token + 'e'
#_______________________________________________________________________________________________________________________________
#
def feminin_adj(token):
    
    token = token.encode('latin1')
    
    # controllo se irregolare
    if token in except_fem_adj:
        return except_fem_adj[token]
    
    # controllo terminazione in -e
    if token[-1] == 'e':
        return token
    
    # nomi terminanti in -er
    if token[-2:] == 'er':
        return token[:-2] + 'ère'

    # nomi terminanti in -gu
    if token[-2:] == 'gu':
        return token + u'\xeb'   # \xeb = 'e' con dieresi
    
    # nomi terminanti in -en, -on, -el, -et, -eil
    if (token[-2:] in ['en','on','el','et']) or (token[-3:] == 'eil'):
        if token in except_fem_adj_end_et.keys():
            return except_fem_adj_end_et[token]
        else:
            ultima_consonante = token[-1]
            return token + ultima_consonante + 'e'
    
    # nomi terminanti in -f
    if token[-1]=='f':
        return token[:-1] + 've'
    
    # nomi terminanti in -x
    if token[-1]=='x':
        if token in except_fem_adj_end_x.keys():
            return except_fem_adj_end_x[token]
        else:
            return token[:-1] + 'se'
    
    # attenzione all'ordine dei prossimi due controlli
    # l'ordine non deve essere invertito
    # nomi terminanti in -teur
    if token[-4:]=='teur':
        if token in except_fem_adj_end_teur.keys():
            return except_fem_adj_end_teur[token]
        return token[:-4] + 'trice'

    # nomi terminanti in -eur
    if token[-3:] == 'eur':
        if token in except_fem_adj_end_eur.keys():
            return except_fem_adj_end_eur[token]
        return token[:-3] + 'euse'
    
    return token + 'e'


#_______________________________________________________________________________________________________________________________
#


if __name__ == "__main__":
    while 1:
        #token  = raw_input("Inserire il termine al singolare > ")
        token  = raw_input("Inserire il termine al maschile > ")
        if token == '0':
            break
        
        tipo    = token.split()[0]
        token   = token.split()[1]
        
        if tipo == 'a':
            print feminin_adj(token)
        else:    
            print feminin_nom(token)
            
    print 'programma terminato'    
