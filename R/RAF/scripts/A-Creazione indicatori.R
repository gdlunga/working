# IMPORTARE DATI DA PDL
setwd("/mnt/R/labdata/Audit/RAF/R/src_bin")
library(CogUtils)
Initialize()
credito=paste("Input_IND_CRED.csv",sep="") 
cred=read.csv2(file=paste(g_INPUT_DIR,credito,sep="/"),1)
finanza=paste("Input_IND_FIN.csv",sep="") 
fin=read.csv2(file=paste(g_INPUT_DIR,finanza,sep="/"),1)
operativo=paste("Input_IND_OPERATIVO.csv",sep="") 
oper=read.csv2(file=paste(g_INPUT_DIR,operativo,sep="/"),1)
tasso=paste("Input_IND_TASSO.csv",sep="") 
tas=read.csv2(file=paste(g_INPUT_DIR,tasso,sep="/"),1)


# PREDISPOSIZIONE DATA FRAME
rownames(cred)=cred$Anno
cred=cred[2:37]
rownames(fin)=fin$Anno
fin=fin[2:19]
rownames(oper)=oper$Anno
oper=oper[2:26]
rownames(tas)=tas$Anno
tas=tas[2:32]


# ***********  CALCOLO INDICATORE RISCHIO CREDITO  **************

# il rischio di credito viene calcolato per 4 segmenti: Retail Banking (RB), Corporate Banking (CB),
# Promozione finanziaria e digital banking (PF) e Corporate Center (CC)
# le componenti che calcolano l'indicatore sono: MARGINE DI INTERESSE, RETTIFICHE, 
# ONERI e ESPOSIZIONI

# CALCOLO QUOTA SU MARGINE GESTIONE FINANZIARIA
cred$MGF = abs(cred$MGF_RB)+abs(cred$MGF_CB)+abs(cred$MGF_PF)+abs(cred$MGF_CC)
cred$MGF_RB_q = abs(cred$MGF_RB) / cred$MGF
cred$MGF_CB_q = abs(cred$MGF_CB) / cred$MGF
cred$MGF_PF_q = abs(cred$MGF_PF) / cred$MGF
cred$MGF_CC_q = abs(cred$MGF_CC) / cred$MGF

# CALCOLO QUOTA RETTIFICHE DA IMPUTARE AL CREDITO
cred$X130_TOT = cred$X130a+cred$X130b+cred$X130d
cred$X130_cre = cred$X130a / cred$X130_TOT
cred$X130_fin = (cred$X130b+cred$X130d) / cred$X130_TOT

# CALCOLO QUOTA 4 SEGMENTI SU CAPITALE INTERNO TOTALE  
cred$CI_4segm = (cred$CI_C+cred$CI_M+cred$CI_BB+cred$CI_O)/cred$CI_TOT

# CALCOLO QUOTA CREDITO SU CAPITALE INTERNO DEI 4 SEGMENTI CONSIDERATI
cred$CI_cre = cred$CI_C / (cred$CI_C+cred$CI_M+cred$CI_BB+cred$CI_O)


# CALCOLO DEI 4 INDICATORI RISCHIO CREDITO
# (MI - RC - CO) / ESP
# MI = MARGINE DI INTERESSE * quota segmenti calcolata su Margine Gestione Finanziaria
# RC = RETTIFICHE * quota da imputare al credito (130a/(130a+130b+130d))
# CO = ONERI * quota credito sul Capitale Interno dei 4 segm * quota dei 4 segmenti sul CI TOTALE
# ESP = CREDITI VIVI relativi ai diversi segmenti 

cred$RBC = (cred$MI_30*cred$MGF_RB_q + cred$RN_RB*cred$X130_cre + cred$ON_RB*cred$CI_4segm*cred$CI_cre) / cred$CV_RB
cred$CBC = (cred$MI_30*cred$MGF_CB_q + cred$RN_CB*cred$X130_cre + cred$ON_CB*cred$CI_4segm*cred$CI_cre) / cred$CV_CB
cred$PFC = (cred$MI_30*cred$MGF_PF_q + cred$RN_PF*cred$X130_cre + cred$ON_PF*cred$CI_4segm*cred$CI_cre) / cred$CV_PF
cred$CCC = (cred$MI_30*cred$MGF_CC_q + cred$RN_CC*cred$X130_cre + cred$ON_CC*cred$CI_4segm*cred$CI_cre) / cred$CV_CC

# STIMA DEI DATI MANCANTI DEI PF 
# PFC 2013 + RBC anno 2012-2013 (delta) e così per tutti gli altri dati fino al 2018
cred$PFC[3:7]=0
for (i in 2:6) {
  cred$PFC[i+1] = cred$PFC[i] + cred$RBC[i+1] - cred$RBC[i]
  }

# CREAZIONE DATA SET INDICATORI 
dati = cred[,47:50]


# ********************  CALCOLO INDICATORE RISCHIO MERCATO **********************

# il rischio mercato viene calcolato solo x il segmento Corporate Center (CC)
# Le componenti che calcolano l'indicatore sono: RISULTANTO NETTO ATT. NEG. 80, ONERI 
# e ESPOSIZIONI TRADING


# CALCOLO QUOTA "MERCATO" SU CAPITALE INTERNO 4 SEGMENTI
fin$CI_fin = fin$CI_M / (fin$CI_C+fin$CI_M+fin$CI_BB+fin$CI_O)

# CALCOLO QUOTA 4 SEGMENTI SU CAPITALE INTERNO TOTALE
fin$CI_4segm = (fin$CI_C+fin$CI_M+fin$CI_BB+fin$CI_O)/fin$CI_TOT

# CALCOLO INDICATORE RISCHIO MERCATO - CCM
#(RNN - CO) / ESP_TRAD * TRADING_q
# RNN = Risultato Netto Att.Neg (80)
# CO = Oneri * quota mercato di Capitale Interno Totale * quota mercato CI dei 4 segmenti)
fin$CCM = ((fin$RN_NEG_80 + fin$ON_CC*fin$CI_fin*fin$CI_4segm)/fin$ESP_TRAD)*fin$TRADING_q


# AGGIUNTA DATA SET INDICATORI 
dati$CCM = fin[,21]


# ***********************  CALCOLO INDICATORE RISCHIO OPERATIVO ************************

# Il rischio operativo viene calcolato per i 4 segmenti: Retail Banking (RB), Corporate Banking (CB),
# Promozione finanziaria e digital banking (PF) e Corporate Center (CC)
# Le componenti che calcolano l'indicatore sono: CAPITALE ASSORBITO, ONERI e ESPOSIZIONI

# CALCOLO ONERI TOTALI (somma in val ass) e quota x segmento
oper$ON_TOT = abs(oper$ON_RB) + abs(oper$ON_CB) + abs(oper$ON_PF) + abs(oper$ON_CC) 
oper$ON_RB_q = abs(oper$ON_RB) / oper$ON_TOT
oper$ON_CB_q = abs(oper$ON_CB) / oper$ON_TOT
oper$ON_PF_q = abs(oper$ON_PF) / oper$ON_TOT
oper$ON_CC_q = abs(oper$ON_CC) / oper$ON_TOT

# CALCOLO QUOTA "OPERATIVO" SU CAPITALE INTERNO 4 SEGMENTI
oper$CI_oper = oper$CI_O / (oper$CI_C+oper$CI_M+oper$CI_BB+oper$CI_O)

# CALCOLO QUOTA 4 SEGMENTI SU CAPITALE INTERNO TOTALE
oper$CI_4segm = (oper$CI_C+oper$CI_M+oper$CI_BB+oper$CI_O)/oper$CI_TOT

# CALCOLO QUOTA SU CREDITI VIVI
oper$CV = oper$CV_RB + oper$CV_CB + oper$CV_PF + oper$CV_CC
oper$CV_RB_q = oper$CV_RB / oper$CV
oper$CV_CB_q = oper$CV_CB / oper$CV
oper$CV_PF_q = oper$CV_PF / oper$CV
oper$CV_CC_q = oper$CV_CC / oper$CV

# CALCOLO 4 INDICATORI RISCHIO OPERATIVO 
# (CAPITALE ASSORBITO - CO)/ESP
# CAPITALE ASSORBITO = CAPITALE ASSORBITO RISCHIO OPERATIVO * QUOTA ONERI X SEGMENTO
# CO = ONERI * QUOTA OPERATIVO DI CAPITALE INTERNO TOTALE * QUOTA OPERATIVO CI DEI 4 SEGMENTI
# ESP = (CREDITI VS BANCHE + CREDITI VS CLIENTELA) * QUOTA CREDITI VIVI X SEGMENTO

oper$RBO = ((-oper$CI_O * oper$ON_RB_q) + (oper$ON_RB * oper$CI_oper * oper$CI_4segm)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_RB_q)
oper$CBO = ((-oper$CI_O * oper$ON_CB_q) + (oper$ON_CB * oper$CI_oper * oper$CI_4segm)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_CB_q)
oper$PFO = ((-oper$CI_O * oper$ON_PF_q) + (oper$ON_PF * oper$CI_oper * oper$CI_4segm)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_PF_q)
oper$CCO = ((-oper$CI_O * oper$ON_CC_q) + (oper$ON_CC * oper$CI_oper * oper$CI_4segm)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_CC_q + oper$ESP_TRAD)

# STIMA DEI DATI MANCANTI DEI PF 
# PFO 2013 + RBO anno 2012-2013 (delta) e così per tutti gli altri dati fino al 2018
oper$PFO[3:7]=0
for (i in 2:6) {
  oper$PFO[i+1] = oper$PFO[i] + oper$RBO[i+1] - oper$RBO[i]
}

# CREAZIONE DATA SET INDICATORI
dati$RBO = oper[,38]
dati$CBO = oper[,39]
dati$PFO = oper[,40]
dati$CCO = oper[,41]


# ****************************    CALCOLO INDICATORE TASSO ***************************
# Il rischio tasso viene calcolato per i 4 segmenti: RB, CB, PF e CC
# Le componenti che calcolano l'indicatore sono: MARGINE DI INTERESSE, ONERI e ATT. SENS. TASSO
# (DELTA MI - CO) / Att sens_BB
# DELTA MI = (MARGINE INTERESSE al tempo t - MARGINE INTERESSE al tempo t-1) calcolato per segm
# CO = Oneri * quota tasso su CI dei 4 segm * quota 4 segm su CI TOT) 
# Att sens_BB = (Crediti vs Clienti (70) + Crediti vs Banche (60)) * quota dei segmenti calcolata su Att. sens. tasso


# CALCOLO QUOTA SU MARGINE GESTIONE FINANZIARIA
tas$MGF = abs(tas$MGF_RB)+abs(tas$MGF_CB)+abs(tas$MGF_PF)+abs(tas$MGF_CC)
tas$MGF_RB_q = abs(tas$MGF_RB) / tas$MGF
tas$MGF_CB_q = abs(tas$MGF_CB) / tas$MGF
tas$MGF_PF_q = abs(tas$MGF_PF) / tas$MGF
tas$MGF_CC_q = abs(tas$MGF_CC) / tas$MGF

# CALCOLO MI*quota
tas$MI_RB = tas$MI_30*tas$MGF_RB_q
tas$MI_CB = tas$MI_30*tas$MGF_CB_q
tas$MI_PF = tas$MI_30*tas$MGF_PF_q
tas$MI_CC = tas$MI_30*tas$MGF_CC_q

# CALCOLO DEL MIt-MIt-1 - RB
tas$DELTA_MI_RB=0
for (i in 1:7) {
  tas$DELTA_MI_RB[i] = tas$MI_RB[i]-tas$MI_RB[i+1]
}

# CALCOLO DEL MIt-MIt-1 - CB
tas$DELTA_MI_CB=0
for (i in 1:7) {
  tas$DELTA_MI_CB[i] = tas$MI_CB[i]-tas$MI_CB[i+1]
}

# CALCOLO DEL MIt-MIt-1 - PF
tas$DELTA_MI_PF=0
for (i in 1:7) {
  tas$DELTA_MI_PF[i] = tas$MI_PF[i]-tas$MI_PF[i+1]
}

# CALCOLO DEL MIt-MIt-1 - CC
tas$DELTA_MI_CC=0
for (i in 1:7) {
  tas$DELTA_MI_CC[i] = tas$MI_CC[i]-tas$MI_CC[i+1]
}

# si elimina l'anno 2007 che non rientra nel perimetro e che genererebbe errori a causa di campi nulli
tas=tas[1:7,1:44]

# CALCOLO QUOTA "TASSO" SU CAPITALE INTERNO 4 SEGMENTI 
tas$CI_tas = tas$CI_BB / (tas$CI_C+tas$CI_M+tas$CI_BB+tas$CI_O)

# CALCOLO QUOTA 4 SEGEMNTI SU CAPITALE INTERNO TOTALE
tas$CI_4segm = (tas$CI_C+tas$CI_M+tas$CI_BB+tas$CI_O)/tas$CI_TOT

# CALCOLO QUOTA SU CREDITI VIVI UTILIZZATA PER ALLOCARE LE ATTIVITA' SENSIBILI FRA I 4 SEGMENTI  
tas$CV = tas$CV_RB + tas$CV_CB + tas$CV_PF + tas$CV_CC
tas$CV_RB_q = tas$CV_RB / tas$CV
tas$CV_CB_q = tas$CV_CB / tas$CV
tas$CV_PF_q = tas$CV_PF / tas$CV
tas$CV_CC_q = tas$CV_CC / tas$CV

# CALCOLO DEI 4 INDICATORI DI RISCHIO TASSO
tas$RBT= (tas$DELTA_MI_RB + tas$ON_RB*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70) * tas$CV_RB_q)  
tas$CBT= (tas$DELTA_MI_CB + tas$ON_CB*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70) * tas$CV_CB_q)  
tas$PFT= (tas$DELTA_MI_PF + tas$ON_PF*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70) * tas$CV_PF_q)  
tas$CCT= (tas$DELTA_MI_CC + tas$ON_CC*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70) * tas$CV_CC_q)  

# STIMA DEI DATI MANCANTI DEI PF 
# PFT 2013 + RBT anno 2012-2013 (delta) e così per tutti gli altri dati fino al 2018
tas$PFT[3:7]=0
for (i in 2:6) {
  tas$PFT[i+1] = tas$PFT[i]+ tas$RBT[i+1]-tas$RBT[i]
}

# CREAZIONE DATA SET INDICATORI 
dati$RBT = tas[,52]
dati$CBT = tas[,53]
dati$PFT = tas[,54]
dati$CCT = tas[,55]

write.xlsx(dati, "../output/output.xlsx"  , sheetName="Sheet1")
