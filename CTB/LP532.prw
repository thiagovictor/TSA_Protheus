/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP532    ¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦05.06.2007¦
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

User Function LP532(cTipo)

Local cRet := ""

Do Case
   Case cTipo $ "CTA"
       //IIF(SE2->E2_TIPO$"ADI/FER/FOL/RES".OR.(SE2->E2_PROVISA$ "N".AND.SE2->E2_MULTNAT#"1"),FORMULA("566"),IIF(SE2->E2_TIPO$"ACV",SA2->A2_CONTAAD,SA2->A2_CONTA))
         If SE2->E2_TIPO$"ADI/FER/FOL/RES".OR.(SE2->E2_PROVISA$ "N".AND.SE2->E2_MULTNAT#"1")
            cRet := FORMULA("566")
           ElseIf SE2->E2_TIPO $ "ACV"
                  cRet := SA2->A2_CONTAAD
               ElseIf Posicione("SX5",1,xFilial("SX5")+"Z9"+SE2->E2_NATUREZ,"X5_DESCRI") <> ""
                      cRet := SX5->X5_DESCRI
                   Else
                      cRet := SA2->A2_CONTA
        EndIf
EndCase


Return(cRet)