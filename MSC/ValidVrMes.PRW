/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VALIDVRMES|Autor | Crislei Toledo							| Data  | 14/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Validacao do valor do mes    informadas pelo usuario						|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function ValidVrMes()

Local lRet := .T.



Return(lRet)



nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZB_DESCRI"})
nPosHora := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == &cHoraFunc})