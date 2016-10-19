/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP597CTA ¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦20.12.2006¦
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

User Function LP597CTA(cEntidade)

Local aArqAnt := {Alias(), IndexOrd(), Recno()}
Local aArqSE5 := {"SE5", SE5->(Indexord()), SE5->(Recno())}
Local aArqSE2 := {"SE2", SE2->(IndexOrd()), SE2->(Recno())}
Local aArqSA2 := {"SA2", SA2->(IndexOrd()), SA2->(Recno())}
Local cRet := ""

dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2")+SubStr(SE5->E5_DOCUMEN,1,18)+SE5->(E5_FORNADT+E5_LOJAADT))

If !Eof()
   Do Case 
      Case cEntidade $ "CTA" //Conta Contabil
           If !(SE2->E2_PROVISA $ "N")
              cRet := RETFIELD("SA2",1,XFILIAL("SA2")+SE5->(E5_FORNADT+E5_LOJAADT),"A2_CONTA")
           Else
              cRet := SE2->E2_CCONTAB
           EndIf
      Case cEntidade $ "CC" //C. Custo
           If !(SE2->E2_PROVISA $ "N")
              cRet := "" 
           Else 
              cRet := SE2->E2_CC
           Endif           
      Case cEntidade $ "ITC" //Item Contabil
           If !(SE2->E2_PROVISA $ "N")
              cRet := SE5->E5_FORNADT+SE5->E5_LOJAADT
           Else 
              cRet := SE2->E2_CC
           EndIf      
      Case cEntidade $ "ORI" //Origem do Lcto.
           If !(SE2->E2_PROVISA $ "N")
              cRet := ""
           Else 
              cRet := U_LPORIGSE2("SE2->E2_VENCREA","SE2->E2_DATAREF")
           EndIf
      EndCase
EndIf

dbSelectArea(aArqSA2[01])
dbSetOrder(aArqSA2[02])
dbGoTo(aArqSA2[03])

dbSelectArea(aArqSE2[01])
dbSetOrder(aArqSE2[02])
dbGoTo(aArqSE2[03])

dbSelectArea(aArqSE5[01])
dbSetOrder(aArqSE5[02])
dbGoTo(aArqSE5[03])

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(cRet)