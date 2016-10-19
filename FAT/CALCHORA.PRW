/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |CALCHORA  |Autor | Crislei Toledo							| Data  | 03/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Calcula o total de horas do funcionario                              |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/
#include "rwmake.ch"
  

User Function CALCHORA()

Local aArqSZI := {"SZI", SZI->(IndexOrd()), SZI->(Recno())}

Private cCodiFunc := PARAMIXB[01]
Private cMesRefer := PARAMIXB[02]
Private cCodiCont := ""
Private cCodiCale := ""
Private dDataInic := CTOD("")
Private dDataFina := CTOD("")
Private dDataAuxi := CTOD("")
Private nSomaHora := 0
Private cTotaHora := ""

dDataInic := CTOD("01/"+cMesRefer)
dDataFina := LastDay(dDataInic)
dDataAuxi := dDataInic

//Consulta o numero do contrato e calendario que o funcionario segue.
dbSelectArea("SZD")
dbSetOrder(1)
dbSeek(xFilial("SZD")+cCodiFunc)
If !Eof()
	cCodiCont := SZD->ZD_CODCONT+Space(20-Len(SZD->ZD_CODCONT))
	cCodiCale := SZD->ZD_CODICAL
EndIf

//Loop calcular o total de horas dos dias uteis (SZK)
dbSelectArea("SZK")
dbSetOrder(1)
dbSeek(xFilial("SZK")+cCodiCont+cMesRefer)

While !Eof() 								.And. ;
		cCodiCont == SZK->ZK_CODCONT  .And. ;
		cMesRefer == SZK->ZK_MESANO
					
		dbSelectArea("SZJ")
		dbSetOrder(1)
		dbSeek(xFilial("SZJ")+cCodiCont+cCodiCale)
		
		If !Eof()
		   Do Case
		   	Case	Dow(SZK->ZK_DATA) == 1
		   			nSomaHora += ((Val(SubStr(SZJ->ZJ_HoraDom,1,2))*60) + (Val(SubStr(SZJ->ZJ_HoraDom,4,2))))/60
				Case	Dow(SZK->ZK_DATA) == 2
		   			nSomaHora += ((Val(SubStr(SZJ->ZJ_HoraSeg,1,2))*60) + (Val(SubStr(SZJ->ZJ_HoraSeg,4,2))))/60		   	
		   	Case	Dow(SZK->ZK_DATA) == 3
		   			nSomaHora += ((Val(SubStr(SZJ->ZJ_HoraTer,1,2))*60) + (Val(SubStr(SZJ->ZJ_HoraTer,4,2))))/60
		   	Case	Dow(SZK->ZK_DATA) == 4
		   			nSomaHora += ((Val(SubStr(SZJ->ZJ_HoraQua,1,2))*60) + (Val(SubStr(SZJ->ZJ_HoraQua,4,2))))/60
		   	Case	Dow(SZK->ZK_DATA) == 5
		   			nSomaHora += ((Val(SubStr(SZJ->ZJ_HoraQui,1,2))*60) + (Val(SubStr(SZJ->ZJ_HoraQui,4,2))))/60
		   	Case	Dow(SZK->ZK_DATA) == 6      
		   			nSomaHora += ((Val(SubStr(SZJ->ZJ_HoraSex,1,2))*60) + (Val(SubStr(SZJ->ZJ_HoraSex,4,2))))/60
		   	Case	Dow(SZK->ZK_DATA) == 7
		   			nSomaHora += ((Val(SubStr(SZJ->ZJ_HoraSab,1,2))*60) + (Val(SubStr(SZJ->ZJ_HoraSab,4,2))))/60		  
		   EndCase
		EndIf							
		dbSelectArea("SZK")
		dbSkip()
EndDo

cTotaHora := ExecBlock("ConvHora",.F.,.F.,{nSomaHora})

//GRAVAR ARQUIVO COM O TOTAL DE HORAS DE CADA MES POR SETOR (SZL)
dbSelectArea("SZL")
dbSetOrder(1)
dbSeek(xFilial("SZL")+cCodiCont+cMesRefer)
		
If Reclock("SZL",Eof())
	Replace ZL_CODISET With cCodiCont
	Replace ZL_MESANO  With cMesRefer
	Replace ZL_TOTHORA With AllTrim(cTotaHora)
	MsUnlock()
EndIf

dbSelectArea(aArqSZI[01])
dbSetOrder(aArqSZI[02])
dbGoTo(aArqSZI[03])

Return(nSomaHora)