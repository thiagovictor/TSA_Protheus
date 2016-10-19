/*
+-------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦ValInfAl ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 07.03.2006¦
+----------+--------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Tela para usuario informar a aliquota de ISS no Cadastro de NF de Entrada        ¦ 
+----------+----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                                              ¦
+----------+----------------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                                  ¦
+------------+--------+-----------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                                   ¦
+------------+--------+-----------------------------------------------------------------------+
¦            ¦        ¦                                                                       ¦
+------------+--------+-----------------------------------------------------------------------+
*/

#include "rwmake.ch"

User Function ValInfAl()

/*  ************* INSTRUCOES **************
- CRIAR PARAMETROS:
MV_EPCPIS
MV_EPCCOF
MV_EPCCSL
MV_EPCIRF

- ZERAR ALIQUOTAS DE IR NO CADASTRO DE NATUREZAS
- ZERAR ALIQUOTA DOS PARAMETROS:
MV_ALIQISS



*/
                 
Private nAliqISS := 0
Private nAliqIRR := 0
//Private nAliqPIS := GetMv("MV_EPCPIS")   
//Private nAliqCOF := GetMv("MV_EPCCOF")
//Private nAliqCSL := GetMv("MV_EPCCSL")
//Private cEpcIrrf := GetMv("MV_EPCIRF")  //este parametro deve conter as possiveis aliquotas de IRRF



If !(SB1->B1_TIPO $ "SS_SU_GG_F _G ")
	Return(.T.)
EndIf

FTela()

Return(.T.)



Static Function FTela()
*********************************************************************************************************
* Apresenta tela para informar a aliquota de ISS
****

@ 000,000 TO 200,220 DIALOG oDlgX TITLE "Aliquotas do Produto"
@ 005,005 TO 080,110 TITLE "Aliquotas do Produto"
@ 015,020 SAY "Informe aliquota de ISS:"
@ 030,020 GET nAliqISS PICTURE "@E 99.99" SIZE 40,50
//@ 045,020 SAY "Informe aliquota de IR:"
//@ 060,020 GET nAliqIRR PICTURE "@E 99.99" VALID Str(nAliqIRR,3,1) $ cEpcIrrf SIZE 40,50
@ 085,040 BMPBUTTON TYPE 1 ACTION FOk()
@ 085,070 BMPBUTTON TYPE 2 ACTION Close(oDlgX)

ACTIVATE DIALOG oDlgX CENTER

Return


Static Function FOk()
*********************************************************************************************************
* Grava aliquota de ISS no produto
****

//CRIAR PARAMETROS ALIQ PIS, COFINS E CSLL PARA ARMAZENAR ALIQUOTAS E ATUALIZAR CADASTRO DE PRODUTOS COM ESTAS.
If RecLock("SB1",.F.)
	Replace B1_ALIQISS With nAliqISS //,;
//	        B1_PCOFINS With nAliqCOF ,;
//	        B1_PPIS    With nAliqPIS ,;
//	        B1_PCSLL   With nAliqCSL
	MsUnlock()
EndIf

//PutMv("MV_ALIQIRF",Str(nAliqIRR,4,2))

Close(oDlgX)

Return