#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | FATUASZ3| Claudio Silva            |  Data  | 27/01/2006       |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Rotina para atualizar campos na tabela SZ3                     |
|            | Parametro: cTipo                                               |
|            | I-Se inclusao acumula no evento para cada item                 |
|            | E-Se estorno  lima os dados de faturamento do contrato/evento  |
+------------+----------------------------------------------------------------+
| Uso        | Especifico                                                     |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
|         |             |                                                     |
+---------+-------------+-----------------------------------------------------+
*/

User Function FATUASZ3(cTipo)

Local aAreaOld:= GetArea()
Local cSeek   := ""
Local cPedido := Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_CONTRAT")

DbSelectArea("SZ3")
DbSetOrder(2) //Z3_FILIAL+Z3_COD+Z3_EVENTO
DbSeek(cSeek:= xFilial("SZ3")+cPedido +SD2->D2_EVENTO)
If !Eof() .And. cSeek == Z3_FILIAL+Z3_COD+Z3_EVENTO
	If Reclock("SZ3",.F.)
		Replace 	Z3_DTNF    With Iif(cTipo=="I", SD2->D2_EMISSAO, Ctod(""))     // Daniel Moreira - Alterei Z3_DTNF e Z3_VLNF em 21.02.06
		Replace 	Z3_VLNF    With Iif(cTipo=="I", SZ3->Z3_VLNF+SD2->D2_TOTAL , 0) //                - Inclui  Z3_NOTA E Z3_SERIE
		Replace 	Z3_NOTA    With Iif(cTipo=="I", SD2->D2_DOC  ,"")
		Replace 	Z3_SERIE   With Iif(cTipo=="I", SD2->D2_SERIE,"")
	//				Z3_VLFATUR With Z3_VLFATUR + (Iif(cTipo=="I", 1, -1) * SD2->D2_TOTAL)
	
		MsUnlock()
	EndIf
EndIf

RestArea(aAreaOld)

Return
