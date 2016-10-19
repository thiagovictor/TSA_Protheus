#include "Rwmake.ch"
/*
+-----------+-----------+---------------+--------------+------+-------------+
| Programa  | MA120BUT  | Desenvolvedor | Davis        | Data | 30/05/2003  |
+-----------+-----------+---------------+--------------+------+-------------+
| Descricao | Ponto de Entrada para Digitar a Ordem de Compra no Pedido     |
+-----------+---------------------------------------------------------------+
| Uso       | Especifico EPC                                                |
+-----------+---------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                  |
+--------------+-----------+------------------------------------------------+
| Responsavel  | Data      | Motivo                                         |
+--------------+-----------+------------------------------------------------+
+--------------+-----------+------------------------------------------------+
*/

User Function MA120BUT()

Local aBotao:={}

Aadd(aBotao,{"PRODUTO"      ,{|| PEDOC()                            },OemToAnsi("Ordem de Compra")})
aAdd(aBotao,{"Conhecimento" ,{|| fDocum() },OemToAnsi("Conhecimento")})
/*
If !inclui .And. !altera
   Aadd(aBotao,{"BUDGET",   {|| a120Posic("SC7",SC7->(Recno()),2)},OemToAnsi("Consulta Aprovacao"),OemToAnsi("Aprovac.") })
EndIf
*/
Return(aBotao) 


Static Function fDocum()

//027133
Local _n := n
MsDocument("SC7",SC7->(Recno()),2)
n := _n

Return



Static Function PEDOC()
******************************************************************
* Dialog de Ordem de Compra
***


Private aAreaSC7   := SC7->(GetArea())
Private nPosORDC   := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ORDCOM" })
Private oDlgFirst

If n == 1
   cOrdCom:=IIf(INCLUI,Iif( ! Empty(acols[n, nPosORDC]),acols[n, nPosORDC],Space(06)),SC7->C7_ORDCOM)
EndIf

dbSelectArea("SC7")
dbSetOrder(3)
If dbSeek(xFilial("SC7")+CA120FORN+CA120LOJ+CA120NUM)
	cOrdCom := SC7->C7_ORDCOM
EndIf


@ 000,000 To 100,200 Dialog oDlgFirst Title "Ordem de Compra"
@ 005,005 To 030,095 Title "Informe os Dados"
@ 015,010 Say "Nº Ordem Compra: "
@ 015,060 Get cOrdCom Picture "@!" Size 25,35
@ 035,050 BMPBUTTON Type 01 Action FProcOrdc()

Activate Dialog oDlgFirst Center

//Retorna Ambiente

RestArea(aAreaSC7)

Return

Static FuncTion FProcOrdc()
****************************************************************************
* Coloca Nº de Ordem de Compra na Acols
***

//Local nPosORDC      := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ORDCOM" })
Local nPosPROD      := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PRODUTO" })
Local nContAux      := 0


For nContAux = 1 To Len(aCols)
	
	If Empty(aCols[ nContAux,nPosPROD ])
		Exit
	Endif
	If aCols[nContAux ,Len(aHeader)+1] == .F.
		aCols[ nContAux,nPosORDC ] := cOrdCom
	EndIf
	
Next nContAux

Close(oDlgFirst)

RestArea(aAreaSC7)

Return


