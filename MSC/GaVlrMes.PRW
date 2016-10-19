/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |GAVLRMES  |Autor | Crislei Toledo				   | Data  | 13/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Gatilho para o campo Valor do mes em questao         					|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function GaVlrMes()

Private cMes      := PARAMIXB[01]
Private cHoraFunc := "M->ZB_HrMes"+cMes
Private cValorMes := "M->ZB_Mes"+cMes
Private nHoraFunc := 0
Private nTotaHora := 0
Private nValorMes := 0

nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZB_DESCRI"})
nPosHora := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == &cHoraFunc})

nHoraFunc := ((Val(SubStr(AllTrim(&cHoraFunc),1,3))*60) + (Val(SubStr(AllTrim(&cHoraFunc),5,2))))/60

If cEmpAnt=='02' .or. cEmpAnt=='03'
	nSalar:=U_CalcRend(GdFieldGet("ZB_GRUPGER"),GdFieldGet("ZB_DESCRI"),GdFieldGet("ZB_VLREVEN"))	
Else
	nSalar:=GdFieldGet("ZB_RENDI")
Endif

If FunName() == "CADAORC"
	nTotaHora := ExecBlock("CalcHora",.F.,.F.,{AllTrim(aCols[n,nPosDesc]),cMes+"/"+M->CANO})
Else
	nTotaHora := ExecBlock("CalcHora",.F.,.F.,{AllTrim(cCodFun),cMes+"/"+M->CANO})
EndIf
//Calcula o Valor baseando no cadastro do Funcionário, pois o Fornecedor é um PJ
If cEmpAnt=='02' .And. nTotaHora==0 .And. GdFieldget("ZB_TIPO")$'F' .And. Posicione("SRA",20,'97'+Alltrim(Left(GdFieldget("ZB_DESCRI"),6)),"RA_FOR")<>''
	cCodFun:=Posicione("SRA",20,'97'+Alltrim(Left(GdFieldget("ZB_DESCRI"),6)),"RA_MAT")
	nTotaHora := ExecBlock("CalcHora",.F.,.F.,{cCodFun,cMes+"/"+M->CANO})	
Endif


nValorMes := (nSalar/nTotaHora)*nHoraFunc

Return(nValorMes)