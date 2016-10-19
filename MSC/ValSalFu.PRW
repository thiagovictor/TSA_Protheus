/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VAlSALFU  |Autor | Crislei de A. Toledo   	         | Data  |10/05/02 |	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Valid para o salario do funcionario                                  |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|             |           |                                                      |
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function ValSalFu()

If FunName() <> "CADORFUN"
   Return(.T.)
EndIf

nPosGrp := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_GRUPGER"})
nPosTip := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_TIPO"})
If cEmpAnt<>'02'
	nPosRend := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_TIPO"})
Endif

dbSelectArea("SZD")
dbSetOrder(1)
dbSeek(xFilial("SZD")+M->cCodFun)
If !Eof()
	aCols[n,nPosGrp] := "000007"
	aCols[n,nPosTip] := "E"
	If cEmpAnt<>'02'
		aCols[n,nPosRend] := SZD->ZD_SALAFUN
	Endif
EndIf

Return(.T.)