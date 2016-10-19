/*
+-----------------------------------------------------------------------+
¦Programa  ¦ Mt100AGR ¦ Autor ¦ Mário Alex Santos     ¦ Data ¦24.10.2001¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Ponto de Entrada na confirmação da NF de Entrada           ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦  /  /  ¦                                                 ¦
+-----------------------------------------------------------------------+
*/           

#INCLUDE "Rwmake.ch"

User Function Mt100Agr() 

Private aAreaTrb := GetArea()

Private cCodTran := Space(06)
Private cNomTran := Space(40)
Private cPlacVei := Space(07)
Private cUFVei   := Space(02)
Private nPesBrut := 0
Private nPesLiqu := 0
Private cMens1   := Space(03)
Private cMens2   := Space(03)
Private cMenNot1 := Space(70)
Private cMenNot2 := Space(70)

Private lFim     := .T.

While lFim
   FTelaNf()
EndDo   

RestArea(aAreaTrb)

Return



Static Function FTelaNF
*****************************************************************************
* Confirmacao dos campos digitados
*
***

@ 0,0 TO 350,450 DIALOG oDlgZ TITLE "Dados Complementares para Emissao NF Entrada"
@ 005,005 TO 137,220 Title "Informe:"
@ 015,008 SAY "Transportadora                    " 
@ 015,051 GET cCodTran PICTURE "@!"  VALID FValTran() F3 "SA4" 
@ 030,008 SAY cNomTran //PICTURE "@S40" WHEN .F. 
@ 045,008 SAY "Placa Veiculo                     " 
@ 045,051 GET cPlacVei PICTURE "@R XXX 9999"	
@ 045,090 SAY "UF   " 
@ 045,105 GET cUFVei   PICTURE "@!" 
@ 060,008 SAY "Peso Bruto                        " 
@ 060,051 GET nPesBrut PICTURE "@E 99,999.99"
@ 075,008 SAY "Peso Liquido                       " 
@ 075,051 GET nPesLiqu PICTURE "@E 99,999.99" 
@ 090,008 SAY "Mens. Formula                   "
@ 090,051 GET cMens1   PICTURE "@!" VALID FValMen1() F3 "SM4"
@ 090,090 GET cMens2   PICTURE "@!" VALID FValMen2() F3 "SM4"
@ 105,008 SAY "Mensagens NF                      "
@ 105,051 GET cMenNot1 PICTURE "@!"               
@ 120,008 SAY "Continuacao                      "
@ 120,051 GET cMenNot2 PICTURE "@!" 

@ 150,110 BMPBUTTON TYPE 01 ACTION FConfirm()
@ 150,150 BMPBUTTON TYPE 02 ACTION FCancela()
ACTIVATE DIALOG oDlgZ CENTER

Return



Static Function FValTran()
**********************************************************************
* Rotina de Validacao da transportadora
*
***                                    

If ! Empty(cCodTran)  //Este teste pq transportadora pode ser branco
	If ! ExistCpo("SA4",cCodTran)
		Return(.F.)
	EndIf

	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial("SA4")+cCodTran)

	@ 030,008 SAY SA4->A4_Nome  SIZE 100,15
EndIf	
                   
Return(.T.)



Static Function FValMen1()
**********************************************************************
* Rotina de validacao de mensagens por formula
*
***

If ! Empty(cMens1)
	If ! ExistCpo("SM4",cMens1)
		Return(.F.)
	EndIf
EndIf

Return (.T.)



Static Function FValMen2()
**********************************************************************
* Rotina de validacao de mensagens por formula
*
***

If ! Empty(cMens2)
	If ! ExistCpo("SM4",cMens2)
		Return(.F.)
	EndIf
EndIf

Return (.T.)

       

STATIC Function FConfirm
*****************************************************************************
* Confirmacao dos campos digitados
*
***

lFim := .F.
Close(oDlgZ)

RecLock("SF1",.F.)
Replace F1_TRANSP  With cCodTran
Replace F1_PLACVEI With cPlacVei
Replace F1_UFVEI   With cUFVei
Replace F1_PESBRUT With nPesBrut
Replace F1_PESLIQU With nPesLiqu
Replace F1_MENS1   With cMens1
Replace F1_MENS2   With cMens2
Replace F1_MENNOT1 With cMenNot1
Replace F1_MENNOT2 With cMenNot2
MsUnlock()

RETURN



STATIC Function FCancela
*****************************************************************************
* Cancelamento dos campos digitados
*
***

lFim := .F.
Close(oDlgZ)

RETURN      