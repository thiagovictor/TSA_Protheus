/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP510CTA ¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦12.12.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ RETORNA A CONTA CONTABIL DE ACORDO COM AS REGRAS DE CONTABI¦
¦          ¦ LIZACAO                                                    ¦
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

User Function LP510CTA(cTipoOp)

Local aArqAnt := {Alias(), IndexOrd(),Recno()}
Local aArqSE2 := {"SE2", SE2->(IndexOrd()), SE2->(Recno())}
Local aArqSEV := {"SEV", SEV->(IndexOrd()), SEV->(Recno())}
Local aArqSA2 := {"SA2", SA2->(IndexOrd()), SA2->(Recno())}
Local aArqSED := {"SED", SED->(IndexOrd()), SED->(Recno())}

Local cRet    := ""

Do Case
   Case cTipoOp $ "IS"
        cRet := Tabela("Z8",Str(SE2->E2_ALIQISS,1))
   OtherWise 
        cRet := ""
EndCase


dbSelectArea(aArqSED[01])
dbSetOrder(aArqSED[02])
dbGoTo(aArqSED[03])
                         
dbSelectArea(aArqSA2[01])
dbSetOrder(aArqSA2[02])
dbGoTo(aArqSA2[03])
                   
dbSelectArea(aArqSEV[01])
dbSetOrder(aArqSEV[02])
dbGoTo(aArqSEV[03])

dbSelectArea(aArqSE2[01])
dbSetOrder(aArqSE2[02])
dbGoTo(aArqSE2[03])      

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(cRet)