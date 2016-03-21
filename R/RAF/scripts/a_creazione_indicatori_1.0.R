# IMPORTARE DATI DA PDL
setwd("/mnt/R/labdata/Audit/RAF/R/src_bin")
library(CogUtils)
library(xlsx)
Initialize()

#g_INPUT_DIR  = "C:/Lavoro/RAF/R/input"
#g_OUTPUT_DIR = "C:/Lavoro/RAF/R"

version_file = "0"
version_form = "0"
estension    = ".csv"
n_indicatori = 13

credito      =   paste("Input_IND_CRED_",version_file, estension, sep="") 
cred         =   read.csv2(file=paste(g_INPUT_DIR,credito,sep="/"),1)
finanza      =   paste("Input_IND_FIN_",version_file, estension, sep="")
fin          =   read.csv2(file=paste(g_INPUT_DIR,finanza,sep="/"),1)
operativo    =   paste("Input_IND_OPERATIVO_",version_file, estension, sep="") 
oper         =   read.csv2(file=paste(g_INPUT_DIR,operativo,sep="/"),1)
tasso        =   paste("Input_IND_TASSO_", version_file, estension, sep="") 
tas          =   read.csv2(file=paste(g_INPUT_DIR,tasso,sep="/"),1)

# PREDISPOSIZIONE DATA FRAME
rownames(cred) = cred$Anno
cred           = cred[2:ncol(cred)]
rownames(fin)  = fin$Anno
fin            = fin[2:ncol(fin)]
rownames(oper) = oper$Anno
oper           = oper[2:ncol(oper)]
rownames(tas)  = tas$Anno
tas            = tas[2:ncol(tas)]

dati           = data.frame(matrix(ncol=0, nrow=nrow(cred)))
# ***********  CALCOLO INDICATORE RISCHIO CREDITO  **************

# il rischio di credito viene calcolato per 4 segmenti: Retail Banking (RB), Corporate Banking (CB),
# Promozione finanziaria e digital banking (PF) e Corporate Center (CC)
# le componenti che calcolano l'indicatore sono: MARGINE DI INTERESSE, RETTIFICHE, 
# ONERI e ESPOSIZIONI

# CALCOLO QUOTA SU MARGINE GESTIONE FINANZIARIA
if(version_form=="0"){
  # calcolo indicatori nike
  cred$MGF = abs(cred$MGF_RB)+abs(cred$MGF_CB)+abs(cred$MGF_PF)+abs(cred$MGF_CC)
  cred$MGF_RB_q = abs(cred$MGF_RB) / cred$MGF
  cred$MGF_CB_q = abs(cred$MGF_CB) / cred$MGF
  cred$MGF_PF_q = abs(cred$MGF_PF) / cred$MGF
  cred$MGF_CC_q = abs(cred$MGF_CC) / cred$MGF
}else {
  cred$MGF_RB_q = cred$MGF_RB / cred$MGF_TOT
  cred$MGF_CB_q = cred$MGF_CB / cred$MGF_TOT
  cred$MGF_PF_q = cred$MGF_PF / cred$MGF_TOT
  cred$MGF_CC_q = cred$MGF_CC / cred$MGF_TOT
}

# CALCOLO QUOTA RETTIFICHE DA IMPUTARE AL CREDITO
cred$X130_TOT = cred$X130a+cred$X130b+cred$X130d
cred$X130_cre = cred$X130a / cred$X130_TOT
cred$X130_fin = (cred$X130b+cred$X130d) / cred$X130_TOT

# CALCOLO QUOTA 4 SEGMENTI SU CAPITALE INTERNO TOTALE  
cred$CI_4segm = (cred$CI_C+cred$CI_M+cred$CI_BB+cred$CI_O)/cred$CI_TOT

# CALCOLO QUOTA CREDITO SU CAPITALE INTERNO DEI 4 SEGMENTI CONSIDERATI
cred$CI_cre = cred$CI_C / (cred$CI_C+cred$CI_M+cred$CI_BB+cred$CI_O)

if(version_form=="0"){
  # versione nike. Indicatore calcolato su crediti vivi
  
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
}else{
  # Indicatore calcolato su crediti verso banche + crediti verso clienti riparametrati tramite quota crediti vivi
  # Promozione finanziaria non stimata ma basata su dati puntuali
  # CALCOLO QUOTA SU CREDITI VIVI
  cred$CV = cred$CV_RB + cred$CV_CB + cred$CV_PF + cred$CV_CC
  cred$CV_RB_q = cred$CV_RB / cred$CV
  cred$CV_CB_q = cred$CV_CB / cred$CV
  cred$CV_PF_q = cred$CV_PF / cred$CV
  cred$CV_CC_q = cred$CV_CC / cred$CV
  
  # CALCOLO DEI 4 INDICATORI RISCHIO CREDITO
  # (MI - RC - CO) / ESP
  # MI = MARGINE DI INTERESSE * quota segmenti calcolata su Margine Gestione Finanziaria
  # RC = RETTIFICHE * quota da imputare al credito (130a/(130a+130b+130d))
  # CO = ONERI * quota credito sul Capitale Interno dei 4 segm * quota dei 4 segmenti sul CI TOTALE
  # ESP = (Crediti vs Clienti (70) + Crediti vs Banche (60)) * quota dei segmenti calcolata x credii vivi
  
  cred$RBC = (cred$MI_30*cred$MGF_RB_q + cred$RN_RB*cred$X130_cre + cred$ON_RB*cred$CI_4segm*cred$CI_cre) / ((cred$CRED_BANC_60 + cred$CRED_CLI_70)*cred$CV_RB_q)
  cred$CBC = (cred$MI_30*cred$MGF_CB_q + cred$RN_CB*cred$X130_cre + cred$ON_CB*cred$CI_4segm*cred$CI_cre) / ((cred$CRED_BANC_60 + cred$CRED_CLI_70)*cred$CV_CB_q)
  cred$PFC = (cred$MI_30*cred$MGF_PF_q + cred$RN_PF*cred$X130_cre + cred$ON_PF*cred$CI_4segm*cred$CI_cre) / ((cred$CRED_BANC_60 + cred$CRED_CLI_70)*cred$CV_PF_q)
  cred$CCC = (cred$MI_30*cred$MGF_CC_q + cred$RN_CC*cred$X130_cre + cred$ON_CC*cred$CI_4segm*cred$CI_cre) / ((cred$CRED_BANC_60 + cred$CRED_CLI_70)*cred$CV_CC_q)
}

# CREAZIONE DATA SET INDICATORI 
dati$RBC = cred$RBC
dati$CBC = cred$CBC
dati$PFC = cred$PFC
dati$CCC = cred$CCC

# ********************  CALCOLO INDICATORE RISCHIO MERCATO **********************

# il rischio mercato viene calcolato solo x il segmento Corporate Center (CC)
# Le componenti che calcolano l'indicatore sono: RISULTANTO NETTO ATT. NEG. 80, ONERI 
# e ESPOSIZIONI TRADING (il campo TRADING_q proviene dai dati Nike, foglio Att.finanza)


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
dati$CCM = fin$CCM

# ****************************    CALCOLO INDICATORE TASSO ***************************
# Il rischio tasso viene calcolato per i 4 segmenti: RB, CB, PF e CC
# Le componenti che calcolano l'indicatore sono: MARGINE DI INTERESSE, ONERI e ATT. SENS. TASSO
# (DELTA MI - CO) / Att sens_BB
# DELTA MI = (MARGINE INTERESSE al tempo t - MARGINE INTERESSE al tempo t-1) calcolato per segm
# CO = Oneri * quota tasso su CI dei 4 segm * quota 4 segm su CI TOT) 
# Att sens_BB = (Crediti vs Clienti (70) + Crediti vs Banche (60)) * quota dei segmenti calcolata su Att. sens. tasso


# CALCOLO QUOTA SU MARGINE GESTIONE FINANZIARIA
if(version_form=="0"){
  tas$MGF = abs(tas$MGF_RB)+abs(tas$MGF_CB)+abs(tas$MGF_PF)+abs(tas$MGF_CC)
  tas$MGF_RB_q = abs(tas$MGF_RB) / tas$MGF
  tas$MGF_CB_q = abs(tas$MGF_CB) / tas$MGF
  tas$MGF_PF_q = abs(tas$MGF_PF) / tas$MGF
  tas$MGF_CC_q = abs(tas$MGF_CC) / tas$MGF
}else{
  tas$MGF = tas$MGF_RB + tas$MGF_CB + tas$MGF_PF + tas$MGF_CC
  tas$MGF_RB_q = tas$MGF_RB / tas$MGF
  tas$MGF_CB_q = tas$MGF_CB / tas$MGF
  tas$MGF_PF_q = tas$MGF_PF / tas$MGF
  tas$MGF_CC_q = tas$MGF_CC / tas$MGF
}

# CALCOLO MI*quota
tas$MI_RB = tas$MI_30*tas$MGF_RB_q
tas$MI_CB = tas$MI_30*tas$MGF_CB_q
tas$MI_PF = tas$MI_30*tas$MGF_PF_q
tas$MI_CC = tas$MI_30*tas$MGF_CC_q

# CALCOLO DEL MIt-MIt-1 - RB
tas$DELTA_MI_RB=0
for (i in 1:nrow(tas)-1) {
  tas$DELTA_MI_RB[i] = tas$MI_RB[i]-tas$MI_RB[i+1]
}

# CALCOLO DEL MIt-MIt-1 - CB
tas$DELTA_MI_CB=0
for (i in 1:nrow(tas)-1) {
  tas$DELTA_MI_CB[i] = tas$MI_CB[i]-tas$MI_CB[i+1]
}

# CALCOLO DEL MIt-MIt-1 - PF
tas$DELTA_MI_PF=0
for (i in 1:nrow(tas)-1) {
  tas$DELTA_MI_PF[i] = tas$MI_PF[i]-tas$MI_PF[i+1]
}

# CALCOLO DEL MIt-MIt-1 - CC
tas$DELTA_MI_CC=0
for (i in 1:nrow(tas)-1) {
  tas$DELTA_MI_CC[i] = tas$MI_CC[i]-tas$MI_CC[i+1]
}

# si elimina l'anno 2007 che non rientra nel perimetro e che genererebbe errori a causa di campi nulli
tas=tas[1:nrow(tas)-1,1:ncol(tas)]

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
# Nota. DEB_BANC_10 e DEB_CLI_20 nella versione Nike sono valorizzati a zero in quanto non utilizzati nella formula iniziale

if(version_form=="0"){
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
}else{
  tas$RBT= (tas$DELTA_MI_RB + tas$ON_RB*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70-tas$DEB_BANC_10-tas$DEB_CLI_20) * tas$CV_RB_q)  
  tas$CBT= (tas$DELTA_MI_CB + tas$ON_CB*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70-tas$DEB_BANC_10-tas$DEB_CLI_20) * tas$CV_CB_q)  
  tas$PFT= (tas$DELTA_MI_PF + tas$ON_PF*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70-tas$DEB_BANC_10-tas$DEB_CLI_20) * tas$CV_PF_q)  
  tas$CCT= (tas$DELTA_MI_CC + tas$ON_CC*tas$CI_tas*tas$CI_4segm) / ((tas$CRED_BANC_60+tas$CRED_CLI_70-tas$DEB_BANC_10-tas$DEB_CLI_20) * tas$CV_CC_q)  
}

# CREAZIONE DATA SET INDICATORI 
dati$RBT = tas$RBT
dati$CBT = tas$CBT
dati$PFT = tas$PFT
dati$CCT = tas$CCT


# ***********************  CALCOLO INDICATORE RISCHIO OPERATIVO ************************

# Il rischio operativo viene calcolato per i 4 segmenti: Retail Banking (RB), Corporate Banking (CB),
# Promozione finanziaria e digital banking (PF) e Corporate Center (CC)
# Le componenti che calcolano l'indicatore sono: CAPITALE ASSORBITO, ONERI e ESPOSIZIONI

# CALCOLO ONERI TOTALI e quota x segmento
if(version_form=="0"){
  oper$ON_TOT = abs(oper$ON_RB) + abs(oper$ON_CB) + abs(oper$ON_PF) + abs(oper$ON_CC) 
  oper$ON_RB_q = abs(oper$ON_RB) / oper$ON_TOT
  oper$ON_CB_q = abs(oper$ON_CB) / oper$ON_TOT
  oper$ON_PF_q = abs(oper$ON_PF) / oper$ON_TOT
  oper$ON_CC_q = abs(oper$ON_CC) / oper$ON_TOT
}else{
  oper$ON_TOT = oper$ON_RB + oper$ON_CB + oper$ON_PF + oper$ON_CC 
  oper$ON_RB_q = oper$ON_RB / oper$ON_TOT
  oper$ON_CB_q = oper$ON_CB / oper$ON_TOT
  oper$ON_PF_q = oper$ON_PF / oper$ON_TOT
  oper$ON_CC_q = oper$ON_CC / oper$ON_TOT
}

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


# CALCOLO QUOTA SU COMMISSIONI
oper$COM_assTOT = oper$COM_RB + oper$COM_CB + oper$COM_PF + oper$COM_CC
oper$COM_RB_q = oper$COM_RB / oper$COM_assTOT
oper$COM_CB_q = oper$COM_CB / oper$COM_assTOT
oper$COM_PF_q = oper$COM_PF / oper$COM_assTOT
oper$COM_CC_q = oper$COM_CC / oper$COM_assTOT


# CALCOLO 4 INDICATORI RISCHIO OPERATIVO 
# (CAPITALE ASSORBITO - CO)/ESP
# CAPITALE ASSORBITO = CAPITALE ASSORBITO RISCHIO OPERATIVO * QUOTA ONERI X SEGMENTO
# CO = ONERI * QUOTA OPERATIVO DI CAPITALE INTERNO TOTALE * QUOTA OPERATIVO CI DEI 4 SEGMENTI
# ESP = (CREDITI VS BANCHE + CREDITI VS CLIENTELA) * QUOTA CREDITI VIVI X SEGMENTO

if(version_form == "0"){
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
}else{
  oper$RBO = ((-oper$CI_O * oper$ON_RB_q) + (oper$ON_RB * oper$CI_oper * oper$CI_4segm)+ (oper$COM_TOT*oper$CI_oper * oper$CI_4segm*oper$COM_RB_q)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_RB_q)
  oper$CBO = ((-oper$CI_O * oper$ON_CB_q) + (oper$ON_CB * oper$CI_oper * oper$CI_4segm)+ (oper$COM_TOT*oper$CI_oper * oper$CI_4segm*oper$COM_CB_q)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_CB_q)
  oper$PFO = ((-oper$CI_O * oper$ON_PF_q) + (oper$ON_PF * oper$CI_oper * oper$CI_4segm)+ (oper$COM_TOT*oper$CI_oper * oper$CI_4segm*oper$COM_PF_q)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_PF_q)
  oper$CCO = ((-oper$CI_O * oper$ON_CC_q) + (oper$ON_CC * oper$CI_oper * oper$CI_4segm)+ (oper$COM_TOT*oper$CI_oper * oper$CI_4segm*oper$COM_CC_q)) / ((oper$CRED_BANC_60+oper$CRED_CLI_70) * oper$CV_CC_q + oper$ESP_TRAD*oper$TRADING_q)
}

# CREAZIONE DATA SET INDICATORI
dati$RBO = oper$RBO
dati$CBO = oper$CBO
dati$PFO = oper$PFO
dati$CCO = oper$CCO

if(version_form == "0"){
  rownames(dati)=c(2014:2008) #aggiungo colonna anno
}else{
  rownames(dati)=c(2015:2008) #aggiungo colonna anno
}

write.csv2(dati, paste(g_OUTPUT_DIR, "/output_", version_file, "_",version_form, estension, sep = "")  , row.names=TRUE)
write.csv2(dati, paste(g_INPUT_DIR,  "/output_", version_file, "_",version_form, estension, sep = "")  , row.names=TRUE)

# CALCOLO ESPOSIZIONE ATTUALE - per calcolo pesi "a" file successivi
esp_attuale=c()
if(version_form == "0"){
  esp_attuale[1]  = cred$CV_RB[1]
  esp_attuale[2]  = cred$CV_CB[1]
  esp_attuale[3]  = cred$CV_PF[1]
  esp_attuale[4]  = cred$CV_CC[1]
  esp_attuale[5]  = fin$ESP_TRAD[1]
  esp_attuale[6]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]) * tas$CV_RB_q[1])  
  esp_attuale[7]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]) * tas$CV_CB_q[1])  
  esp_attuale[8]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]) * tas$CV_PF_q[1])  
  esp_attuale[9]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]) * tas$CV_CC_q[1]) 
  esp_attuale[10] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_RB_q[1])
  esp_attuale[11] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_CB_q[1])
  esp_attuale[12] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_PF_q[1])
  esp_attuale[13] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_CC_q[1] +oper$ESP_TRAD[1])
}else{
  esp_attuale[1]  = ((cred$CRED_BANC_60[1]+cred$CRED_CLI_70[1]) * cred$CV_RB_q[1])
  esp_attuale[2]  = ((cred$CRED_BANC_60[1]+cred$CRED_CLI_70[1]) * cred$CV_CB_q[1])  
  esp_attuale[3]  = ((cred$CRED_BANC_60[1]+cred$CRED_CLI_70[1]) * cred$CV_PF_q[1]) 
  esp_attuale[4]  = ((cred$CRED_BANC_60[1]+cred$CRED_CLI_70[1]) * cred$CV_CC_q[1]) 
  esp_attuale[5]  = fin$ESP_TRAD[1]*fin$TRADING_q[1] # correggere?
  esp_attuale[6]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]-tas$DEB_BANC_10[1]-tas$DEB_CLI_20[1]) * tas$CV_RB_q[1])  
  esp_attuale[7]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]-tas$DEB_BANC_10[1]-tas$DEB_CLI_20[1]) * tas$CV_CB_q[1])  
  esp_attuale[8]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]-tas$DEB_BANC_10[1]-tas$DEB_CLI_20[1]) * tas$CV_PF_q[1])  
  esp_attuale[9]  = ((tas$CRED_BANC_60[1]+tas$CRED_CLI_70[1]-tas$DEB_BANC_10[1]-tas$DEB_CLI_20[1]) * tas$CV_CC_q[1]) 
  esp_attuale[10] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_RB_q[1])
  esp_attuale[11] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_CB_q[1])
  esp_attuale[12] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_PF_q[1])
  esp_attuale[13] = ((oper$CRED_BANC_60[1]+oper$CRED_CLI_70[1]) * oper$CV_CC_q[1] +oper$ESP_TRAD[1]*oper$TRADING_q[1])
}

write.csv2(esp_attuale, paste(g_INPUT_DIR, "/esp_attuale_", version_file,"_", version_form, estension, sep=""),row.names=FALSE)

# CALCOLO ESPOSIZIONE - componente al numeratore per calcolo FI
esp_fi=c()
esp_fi=esp_attuale[10:13]

write.csv2(esp_fi, paste(g_INPUT_DIR, "/esp_fi_", version_file, "_", version_form, estension, sep=""),row.names=FALSE)

# CALCOLO CAPITALE INTERNO - componente al denominatore per calcolo FI
CI=c()
CI[1] = cred$CI_C[1]
CI[2] = cred$CI_M[1]
CI[3] = cred$CI_BB[1]
CI[4] = cred$CI_O[1]

write.csv2(CI, paste(g_INPUT_DIR, "/CI_", version_file, "_", version_form, estension, sep=""), row.names=FALSE)

