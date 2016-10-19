/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |GAVLRMES  |Autor | Crislei Toledo							| Data  | 14/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Gatilho para o campo Hora do mes em questao            					|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function GaHrMes()

Private cMes      := PARAMIXB[01]
Private cHoraFunc := "ZB_HRMES"+cMes
Private cValorMes := "M->ZB_Mes"+cMes
Private nHoraFunc := 0
Private nTotaHora := 0
Private nHoraMes  := 0
Private cHoraMes  := ""

nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZB_DESCRI"})
If cEmpAnt=='02' .or. cEmpAnt=='03'
	nSalar:=U_CalcRend(GdFieldGet("ZB_GRUPGER"),GdFieldGet("ZB_DESCRI"),GdFieldGet("ZB_VLREVEN"))	
Else
	nSalar:=GdFieldGet("ZB_RENDI")
Endif

nPosHora := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == cHoraFunc})

If FunName() == "CADAORC"
	nTotaHora := ExecBlock("CalcHora",.F.,.F.,{AllTrim(aCols[n,nPosDesc]),cMes+"/"+M->CANO})
Else
	nTotaHora := ExecBlock("CalcHora",.F.,.F.,{AllTrim(cCodFun),cMes+"/"+M->CANO})
EndIf

nHoraMes := (nTotaHora*&cValorMes)/nSalar

cHoraMes := ExecBlock("ConvHora",.F.,.F.,{nHoraMes})

aCols[n,nPosHora] := AllTrim(cHoraMes)
 
Return(&cValorMes)