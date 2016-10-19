/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VALFUNC   |Autor | Crislei Toledo							| Data  | 08/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Validacao do funcionario            											|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/
#include "rwmake.ch"

User Function ValFunc()

SetPrvt("LRET,CALIVAL,CCONTRAT,")

lRet := .T.

If !Empty(cCodFun)
   cAliVal := Alias()
   dbSelectArea("SZD")
   dbSetOrder(1)
   dbSeek(xFilial("SZD")+cCodFun)
   If Eof()
      MsgStop("Funcionario nao esta cadastrado!")
      lRet := .F.
   Else
   	cNomeFun  := SZD->ZD_NOMEFUN
   	nRendFunc := SZD->ZD_SALAFUN
   EndIf

/*
   dbSelectArea("SZ2")
   dbSetOrder(3)
   dbSeek(xFilial("SZ2")+cCCusto)
   cContrat := SZ2->Z2_COD
   dbSelectArea(cAliVal)
*/

Else
   MsgStop("Codigo do Funcionario deve ser informado!")
   lRet := .F.
EndIf

Return(lRet)
