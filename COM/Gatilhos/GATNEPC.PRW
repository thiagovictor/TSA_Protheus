#include "Rwmake.ch"
#include "Colors.ch"

/*
+-----------+-----------+---------------+--------------+------+-------------+
| Programa  | GATNEPC   | Desenvolvedor | Davis        | Data | 30/05/2003  |
+-----------+-----------+---------------+--------------+------+-------------+
| Descricao | Gatilho Para Gerar Nº Interno da EPC na Lista de Materiais    |
+-----------+---------------------------------------------------------------+
| Uso       | Especifico EPC                                                |
+-----------+---------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                  |
+--------------+-----------+------------------------------------------------+
| Responsavel  | Data      | Motivo                                         |
+--------------+-----------+------------------------------------------------+
+--------------+-----------+------------------------------------------------+
*/

User Function GATNEPC()

Private aArea     := GetArea()
Private cCCustLm  := Space(09)
Private cSubDisc  := ""
Private cNumList  := Space(06)
Private nPosSDis  := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_SUBDISC" })
Private nPosNEPC  := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_NEPC" })
Private cDescDis  := Space(50)
Private cDesCCus  := Space(40)
Private cCampLim  := Space(19)
Private oDlgZ

If Empty(M->C7_SUBDISC)
	Return
EndIf

dbSelectArea("SC7")
dbSetOrder(3)
If dbSeek(xFilial("SC7")+CA120FORN+CA120LOJ+CA120NUM)
	ccCCustLm := Substr(SC7->C7_NEPC,6,5)
	cNumList  := Substr(SC7->C7_NEPC,14,6)
	vNumEpc   := SC7->C7_NEPC
	cSubDisc := SC7->C7_SUBDISC
Else
	cSubDisc := M->C7_SUBDISC
EndIf

dbSelectArea("SZM")
dbSetOrder(1)
If dbSeek(xFilial("SZM")+cSubDisc)
	cDescDis := SZM->ZM_Descr
EndIf

@ 0,0 TO 350,450 DIALOG oDlgZ TITLE "Dados Complementares para Geracao Nº Interno EPC"
@ 005,005 TO 137,220 Title "Informe:"
@ 015,008 SAY "Diciplinas da EPC                 "
@ 015,100 Say cSubDisc  Color CLR_HBLUE SIZE 100,15
@ 030,008 SAY cDescDis  COLOR CLR_HRED  SIZE 100,15
@ 045,008 Say "Centro de Custo da Lista          "
@ 045,100 Get cCCustLm Picture "@!" VALID FValCCus() .And. FNumEPC() .And. ! Empty(cCCustLM) F3 "CTT"  // Olhar a Tabela de Centro de Custo
//@ 060,008 Say cDesCCus SIZE 100,15
@ 075,008 Say "Numero da Lista de Materiais      "
@ 075,100 Get cNumList Picture "@!" VALID FNumEPC() .And. ! Empty(cNumList)
@ 090,008 Say "NUMERO DA EPC           "  COLOR CLR_HBLUE SIZE 230,07
//@ 105,008 Say cNumEpc SIZE 100,15

@ 150,110 BMPBUTTON TYPE 01 ACTION FConfirm()
@ 150,150 BMPBUTTON TYPE 02 ACTION FCancela()
ACTIVATE DIALOG oDlgZ CENTER
                              
RestArea(aArea)

Return(cNumEpc)



Static Function FValcCus()
**********************************************************************
* Rotina de Validacao do Cenbtro de Custo da LM
*
***

cDescCus := Space(40)
@ 060,008 Say cDescCus SIZE 100,15
dbSelectArea("CTT")
dbSetOrder(1)
If dbSeek(xFilial("CTT")+cCCustLm)
	cDesCCus := CTT->CTT_DESC01
Else
	MSGBOX("Centro de Custo nao Cadastrado.","..: ATENCAO :..","STOP")
	Return(.F.)
EndIf

@ 060,008 SAY cDescCus   COLOR CLR_HRED SIZE 100,15


Return(.T.)


Static Function FNumEpc()
**********************************************************************
* Rotina de Validacao do Numero da EPC
*
***

cNumEpc := Space(19)

@ 105,008 Say cNumEpc SIZE 300,45

cNumEpc := "E-"+cSubDisc+"-"+Alltrim(cCCustLm)+"-LM"+Alltrim(cNumList)

@ 105,008 SAY cNumEpc  COLOR CLR_HRED SIZE 300,45

Return(.T.)



STATIC Function FConfirm
*****************************************************************************
* Confirmacao dos campos digitados
*
***

aCols[n, nPosNEPC] := cNumEpc

Close(oDlgZ)

Return(.T.)



STATIC Function FCancela
*****************************************************************************
* Cancelamento dos campos digitados
*
***

Close(oDlgZ)

RETURN(.F.)
