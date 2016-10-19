/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |MOSCOVER  |Autor | Crislei Toledo							| Data  | 08/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Legenda - Aprovacao Orcamento       											|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"  

User Function MosCoVer()

lRet := .F.

Do Case
	Case FunName() == "CADAORC" .OR. ;
		  FunName() == "CADORFUN"
	   If SZB->ZB_APROVA <> "S"
	      lRet := .T.
	   EndIf  
EndCase

Return (lRet)