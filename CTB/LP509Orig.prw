/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦LP509ORIG ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 23.03.2007¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Monta o conteudo do campo CT2_ORIGEM (utilizado pelo Lancamento Padrao 509)       ¦ 
+----------+-----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                                               ¦
+----------+-----------------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                                   ¦
+------------+--------+------------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                                    ¦
+------------+--------+------------------------------------------------------------------------+
¦            ¦        ¦                                                                        ¦
+------------+--------+------------------------------------------------------------------------+
*/

#include "rwmake.ch"

User Function LP509Orig()

Local aArqAnt := {Alias(), IndexOrd(), Recno()}
Local aArqSEZ := {"SEZ", SEZ->(IndexOrd()), SEZ->(Recno())}
Local aArqSE2 := {"SE2", SE2->(IndexOrd()), SE2->(Recno())}

Local cRet := ""

//Posiciona no SE2 para buscar a data de vencimento real e a data de referencia
dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2")+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA)

If !Eof()
   //MONTA O CONTEUDO DO CAMPO ORIGEM PARA SER GRAVADO NO CT2
   cRet:= "CX:"+Left(DTOC(SE2->E2_VENCREA),6)+Right(DTOC(SE2->E2_VENCREA),2)+" RF:"+Left(DTOC(SE2->E2_DATAREF),6)+Right(DTOC(SE2->E2_DATAREF),2)
EndIf

dbSelectArea(aArqSE2[01])
dbSetOrder(aArqSE2[02])
dbGoTo(aArqSE2[03])

dbSelectArea(aArqSEZ[01])
dbSetOrder(aArqSEZ[02])
dbGoTo(aArqSEZ[03])

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(cRet)             