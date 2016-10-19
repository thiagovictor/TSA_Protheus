#include "rwmake.ch"

/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | M410LIOK| Claudio Silva            |  Data  | 27/01/2006       |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Ponto de Entrada - Validacao da linha do item Pedido de Venda  |
|            | Validacao Amarracao Contrato X Evento                          |
+------------+----------------------------------------------------------------+
| Uso        | Especifico                                                     |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
+---------+-------------+-----------------------------------------------------+
|24/02/06 | Crislei     | Tratamento para retornar verdadeiro se nao tiver    |
|         |             | contrato para o pedido de venda                     |
+---------+-------------+-----------------------------------------------------+
*/

User Function M410LiOk()

Local lRet     := .T.

If SM0->M0_CODIGO == "02" //TSA
	lRet:= fValEvento()
EndIf

Return(lRet)



Static Function fValEvento()
*******************************************************************************
* Valida Contrato X Evento
*
*****
Local lRet     := .T.

//Se for uma NF de remessa nao deve verificar relacao do evento com contrato - Solicitacao do Gleison - TSA
If M->C5_REMESSA $ "S"
   Return(lRet)
EndIf      

//Verifica se o contrato possui evento
DbSelectArea("SZ1")
DbSetOrder(1) //Z1_FILIAL+Z1_COD+Z1_CODCLI
DbSeek(cSeek:= xFilial("SZ1") +M->C5_CONTRAT +M->C5_CLIENTE)

If !Eof() .And. cSeek == Z1_FILIAL+Z1_COD+Z1_CODCLI
//	lRet:= .T.
	lRet:= .F.
   If Z1_EVENTO == "N"
   	lRet:= .T.      
		Return(lRet)
	EndIf

//If lRet
	DbSelectArea("SZ3")
	DbSetOrder(2) //Z3_FILIAL+Z3_COD+Z3_EVENTO
	DbSeek(cSeek:= xFilial("SZ3") +M->C5_CONTRAT +GDFieldGet("C6_EVENTO"))
	If !Eof() .And. cSeek == Z3_FILIAL+Z3_COD+Z3_EVENTO
		lRet:= .T.
	Else
		lRet:= .F.
	   MSGBOX("Não existe relacionamento Contrato X Evento, para o Contrato "+M->C5_CONTRAT+" e Evento " +GDFieldGet("C6_EVENTO")+".","..: ATENCAO :..","STOP")
	EndIf
EndIf

Return(lRet)
