/*
+-----------------------------------------------------------------------+
¦Programa  ¦  ¦ Autor ¦      ¦ Data ¦24.10.2001¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Ponto de Entrada na confirmação da ampliação               ¦
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

User Function AF150AMP() 

Private aAreaTrb := GetArea()

Private cNumNFE  := Space(06)
Private cSerNFE  := Space(03)
Private cNumDoc  := Space(06)
Private cForNFE  := Space(06)
Private cLjNFE   := Space(02)
Private cItemNFE := Space(TamSx3("D1_ITEM")[1])
Private cDescr   :=Space(40)
Private cNumMov  :=Space(6)
Private cProdMov :=Space(15)
Private cSeqMov  :=Space(6)


@ 000,000 TO 250,350 DIALOG oDlgZ TITLE "Dados Complementares da transferencia"
@ 005,005 TO 054,145 Title "Informe dados da Nota Fiscal"
@ 015,008 SAY "Nota Fiscal:" 
@ 015,040 GET cNumNFE  PICTURE "@ 999999"  Valid Vazio() .Or. VldNFE() F3 "ZD1" 
@ 015,075 SAY "Serie:" 
@ 015,095 GET cSerNFE  When .F.  PICTURE "@!"  
@ 027,008 SAY "Fornecedor:" 
@ 027,040 GET cForNFE  When .F.  PICTURE "@ 999999" 
@ 027,075 SAY "Loja:" 
@ 027,095 GET cLjNFE  When .F. PICTURE "@!"  
@ 038,008 SAY "Item:" 
@ 038,040 GET cItemNFE  When .F. PICTURE "@ 999" 
@ 038,075 SAY "Produto:" 
@ 038,095 GET cProdMov  When .F. PICTURE "@ 999"

@ 055,005 TO 089,145 Title "Informe dados da Movimentação de Estoque:"
@ 065,008 SAY "Nro Doc:" 
@ 065,040 GET cNumMov  PICTURE "@ 999999" F3 "ZD3"
@ 065,075 SAY "Produto:" 
@ 065,095 GET cProdMov  When .F.
@ 077,008 SAY "Num.Seq:" 
@ 077,040 GET cSeqMov  When .F. PICTURE "@ 999999"  
@ 093,008 SAY "Descrição:"
@ 093,051 GET cDescr PICTURE "@!"               
@ 010,150 BMPBUTTON TYPE 01 ACTION (If(VldNFE(),FConfirm(),.T.)) Object oObtConf
@ 027,150 BMPBUTTON TYPE 02 ACTION Close(oDlgZ) 

ACTIVATE DIALOG oDlgZ CENTER

Return(0)



Static Function VldNFE()
**********************************************************************
* Rotina de Validacao da transportadora
*
***          
Local lRet:=.t.

If !Empty(cNumNFE)
	dbSelectArea("SD1")
	dbSetOrder(1)
	If !SD1->(dbSeek(Xfilial("SD1")+cNumNFE+cSerNFE+cForNFE+cLjNFE+cProdMov+cItemNFE))
		MsgBox("Nota Fiscal não Encontrada, Favor selecionar o Item através da Consulta VIA F3")
		lRet:=.f.
	Endif
Endif

If !Empty(cNumMov)
	dbSelectArea("SD3")
	dbSetOrder(8)
	If !SD3->(dbSeek(Xfilial("SD3")+cNumMov+cSeqMov))
		MsgBox("Movimentação não Encontrada, Favor selecionar o Item através da Consulta VIA F3")
		lRet:=.f.
	Endif
Endif

If Empty(cNumMov) .And. Empty(cNumNFE)
	MsgBox("Favor Informar o Numero da NOTA FISCAL ou a MOVIMENTAÇÃO DE ESTOQUE desta Ampliação")
	lRet:=.f.
Endif
                   
Return(lRet)


STATIC Function FConfirm
*****************************************************************************
* Confirmacao dos campos digitados
*
***

Close(oDlgZ)

RecLock("SN4",.F.)
Replace N4_NUMNF  With cNumNFE
Replace N4_SERNF  With cSerNFE
Replace N4_ITEMNF With cItemNFE
Replace N4_FORNF  With cForNFE
Replace N4_LOJANF With cLjNFE
Replace N4_DESCR  With cDescr
Replace N4_CODNF  With cProdMov
Replace N4_DOCMOV With cNumMov
Replace N4_SEQMOV With cSeqMov
MsUnlock()

RETURN
