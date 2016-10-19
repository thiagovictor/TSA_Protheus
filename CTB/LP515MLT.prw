/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP515MLT ¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦14.03.2007¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ RETORNA A CONTA CONTABIL QUANDO POSSUI MULTINATUREZA NO    ¦
¦          ¦ MOMENTO DA EXCLUSAO DO TITULO                              ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO                                                 ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
+-----------------------------------------------------------------------+
*/

#INCLUDE "rwmake.ch"

User Function LP515MLT()

Local aArqAnt  := {Alias(), IndexOrd(),Recno()}
Local aArqSEV  := {"SEV", SEV->(IndexOrd()), SEV->(Recno())}
Local aArqCTD  := {"CTD", CTD->(IndexOrd()), CTD->(Recno())}
Local cRet     := ""
Local cClasfIt := Space(01)


dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2")+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA)

If !Eof()
   cClasfIt := POSICIONE("CTD",1,xFilial("CTD")+SE2->E2_CC,"CTD_CLASSI")  
   cRet := POSICIONE("SED",1,XFILIAL("SED")+SEV->EV_NATUREZ,IIF(cClasfIt$"D","ED_CONTA","ED_CTACUST"))
EndIf

dbSelectArea(aArqCTD[01])
dbSetOrder(aArqCTD[02])
dbGoTo(aArqCTD[03])

dbSelectArea(aArqSEV[01])
dbSetOrder(aArqSEV[02])
dbGoTo(aArqSEV[03])
                      
dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(cRet)