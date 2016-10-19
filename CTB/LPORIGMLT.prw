/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LPORIGMLT¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦14.12.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ RETORNA O CONTEUDO DO CAMPO ORIGEM DO LANCAMENTO POSICIONAN¦
¦          ¦ DO O SE2 ATRAVES DO SEV                                    ¦
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

User Function LPORIGMLT()

Local aArqAnt := {Alias(), IndexOrd(),Recno()}
Local aArqSE2 := {"SE2", SE2->(IndexOrd()), SE2->(Recno())}
Local aArqSA2 := {"SA2", SA2->(IndexOrd()), SA2->(Recno())}
Local aArqSEV := {"SEV", SEV->(IndexOrd()), SEV->(Recno())}

Local cRet    := ""

dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2")+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA)

If !Eof()
   cRet := "CX:" + SubStr(DTOC(SE2->E2_VENCREA),1,6) + Right(DTOC(SE2->E2_VENCREA),2) + " RF:" + SubStr(DTOC(SE2->E2_DATAREF),1,6) + Right(DTOC(SE2->E2_DATAREF),2)
EndIf

dbSelectArea(aArqSEV[01])
dbSetOrder(aArqSEV[02])
dbGoTo(aArqSEV[03])
                         
dbSelectArea(aArqSA2[01])
dbSetOrder(aArqSA2[02])
dbGoTo(aArqSA2[03])
                   
dbSelectArea(aArqSE2[01])
dbSetOrder(aArqSE2[02])
dbGoTo(aArqSE2[03])

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(cRet)