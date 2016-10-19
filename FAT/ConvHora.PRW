/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VISUORC   |Autor | Crislei Toledo							| Data  | 06/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Converte as horas feitas pelo funcionario de numerico para form. hora|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function ConvHora()

Local nTot := PARAMIXB[01]
Local cHora := ""
Local cMina := ""
Local cMinum := ""
Local cTot := "000:00"

IF nTot != 0
//	cHora  := Str(Int((nTot/60)*100),7)
	cHora  := Str(Int(nTot*100),7)
	cMina  := Substr(cHORA,6,2)
	cMinum := Substr(Str(Val(cMina)/100*60+100,3),2,2)
	cTot   := Substr(cHora,1,5)+':'+cMinum
EndIf

Return(cTot)