/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦LpOrigSE2 ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 25.05.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Monta o conteudo do campo CT2_ORIGEM (utilizado pelo Lancamento Padrao)           ¦ 
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

User Function LPOrigSE2(cVencRea,cDataRef)

Local cRet := ""

//MONTA O CONTEUDO DO CAMPO ORIGEM PARA SER GRAVADO NO CT2
cRet:= "CX:"+Left(DTOC(&cVencRea),6)+Right(DTOC(&cVencRea),2)+" RF:"+Left(DTOC(&cDataRef),6)+Right(DTOC(&cDataRef),2)

Return(cRet)