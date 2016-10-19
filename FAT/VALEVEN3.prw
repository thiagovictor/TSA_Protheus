#include "rwmake.ch" 

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  |VALEVEN3   | Autor    | Daniel A. Moreira       |Data  |03.04.2006 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Validacao do campo C5_CONTRAT no Pedido de Venda                  |
+----------+-------------------------------------------------------------------+
| USO      | Especifico TSA                                                    |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+
*/ 

User Function VALEVEN3()

Local aAreaOLD := GetArea()
Local aAreaSZ3 := {}
Local lRet :=.T.

dbSelectArea("SZ3")
aAreaSZ3:=GetArea()

If !Empty(M->C6_EVENTO)
	If !Empty(M->C5_CONTRAT)
		dbSelectArea("SZ3")
		dbSetOrder(1)
		dbSeek(xFilial("SZ3")+M->C5_CONTRAT)
		While !Eof() .AND. SZ3->Z3_COD == M->C5_CONTRAT
			If SZ3->Z3_EVENTO == M->C6_EVENTO .AND. !Empty(SZ3->Z3_DTNF)
			   MsgStop("Evento já faturado !")
			   lRet:=.F.
			   Exit
			EndIf
			dbSelectArea("SZ3")
			dbSkip()
		EndDo
	Else
	   MsgStop("Favor, informar o código do contrato para este evento !")
	   lRet:=.F.
	EndIf
EndIf

RestArea(aAreaSZ3)
RestArea(aAreaOLD)

Return(lRet)