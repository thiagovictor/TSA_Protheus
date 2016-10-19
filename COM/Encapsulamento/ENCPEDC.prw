#Include "Rwmake.ch"
/*
+-----------+------------+----------------+------------------+--------+------------+
| Programa  | ENCPEDC    | Desenvolvedor  | Davis Magalhaes  | Data   | 30/05/2003 |
+-----------+------------+----------------+------------------+--------+------------+
| Descricao | Encapsulamento de Pedido de Compra                                   |
+-----------+----------------------------------------------------------------------+
| Uso       | Especifico EPC/TSA                                                   |
+-----------+----------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                      |
+-------------+---------+----------------------------------------------------------+
| Humano      | Data    | Motivo                                                   |
+-------------+---------+----------------------------------------------------------+
+-------------+---------+----------------------------------------------------------+
*/

User Function ENCPEDC()
Private cOrdCom := Space(06)
Private cNumEpc := Space(19)

MATA121()

Return

User Function MT120FIM()
Local aPar   := Paramixb
Local cQuery := ""
If aPar[1] == 5 .And. aPar[3] == 1
   cQuery := "UPDATE "+RetSqlName("SCR") +" SET D_E_L_E_T_ = '*' "
   cQuery += " WHERE CR_FILIAL = '"+xFilial("SCR")+"'"
   cQuery += " AND CR_NUM = '"+aPar[2]+"'"   
   cQuery += " AND D_E_L_E_T_ = ''"
   TcSqlName(cQuery)
   TcSqlRefresh(RetSqlName("SCR"))
EndIf
Return