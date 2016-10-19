/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |GAMESENTR |Autor | Crislei Toledo							| Data  | 14/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Gatilho para o mes de entrega do produto no Pedido de Compra         |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function GaMesEntr()

Local cMes := ""

nPosMes  := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "C7_MESENTR"})

If Upper(ReadVar()) == "M->C7_PRODUTO"
	nPosData := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "C7_DATPRF"})		
	cMes := StrZero(Month(aCols[n,nPosData]),2)+"/"+StrZero(Year(aCols[n,nPosData]),4)	
	cRet := "M->C7_PRODUTO"
Else
	cMes := StrZero(Month(M->C7_DATPRF),2)+"/"+StrZero(Year(M->C7_DATPRF),4)
	cRet := "M->C7_DATPRF"
EndIf

aCols[n,nPosMes] := cMes


Return(&cRet)