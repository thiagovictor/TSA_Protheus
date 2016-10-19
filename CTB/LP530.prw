/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP530    ¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦08.06.2007¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ RETORNA INFORMACOES NECESSARIAS PARA CONTABILIZACAO A PAR- ¦
¦          ¦ TIR DO LP 530, DE ACORDO COM O TIPO PASSADO COMO PARAMETRO ¦
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
#INCLUDE "topconn.ch"

User Function LP530(cTipo)

Local xRet    := ""
Local cQuery  := ""
Local cPreFat := SE2->E2_PREFIXO
Local cNumFat := SE2->E2_NUM
Local aArqAnt := {Alias(), IndexOrd(), Recno()}
Local aArqSE2 := {"SE2", SE2->(IndexOrd()), SE2->(Recno())}

Do Case
   Case cTipo $ "PIS"
      cQuery := "SELECT SUM(E2_VRETPIS) AS VLRIMP FROM " + RetSqlName("SE2") 
      cQuery += " WHERE E2_FATURA = '" + cNumFat + "' AND " 
      cQuery += " E2_FATPREF = '" + cPreFat + "' AND D_E_L_E_T_ <> '*'"            
   Case cTipo $ "COF"
      cQuery := "SELECT SUM(E2_VRETCOF) AS VLRIMP FROM " + RetSqlName("SE2") 
      cQuery += " WHERE E2_FATURA = '" + cNumFat + "' AND " 
      cQuery += " E2_FATPREF = '" + cPreFat + "' AND D_E_L_E_T_ <> '*'"      
   Case cTipo $ "CSL"
      cQuery := "SELECT SUM(E2_VRETCSL) AS VLRIMP FROM " + RetSqlName("SE2") 
      cQuery += " WHERE E2_FATURA = '" + cNumFat + "' AND " 
      cQuery += " E2_FATPREF = '" + cPreFat + "' AND D_E_L_E_T_ <> '*'"
EndCase

If cTipo $ "PIS/COF/CSL"
   TCQUERY cQuery ALIAS "QRETIMP" NEW
   
   dbSelectArea("QRETIMP")
   dbGoTop()
   If !Eof()
      xRet := QRETIMP->VLRIMP
   EndIf
   
   dbSelectArea("QRETIMP")
   dbCloseArea()
EndIf

dbSelectArea(aArqSE2[01])
dbSetOrder(aArqSE2[02])
dbGoTo(aArqSE2[03])

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(xRet)