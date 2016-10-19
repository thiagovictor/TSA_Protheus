#INCLUDE "TOPCONN.CH"
User function CadSZU()
*************************************************************************************************************************
*
*
*******
Local cVldExc := ".T."
Local cVldAlt := ".T."

AxCadastro("SZU","Cadastro de Sub-Disciplinas",cVldAlt,cVldExc)

Return()



User Function VldExc()
**********************************************************************************************************************
*
*
*****
Local lRet:=.T.
Local  cQuery:=""
Local aAreaAnt:=GetArea()
If Exclui
	cQuery:=" SELECT AF9_DISC FROM "+RetSqlName("AF8")
	cQuery+=" WHERE AF9_DISC='"+SZU->ZU_COD+"' AND D_E_L_E_T_<>'*' AND AF9_FILIAL='"+Xfilial("AF9")+"'"
	
	TcQuery cQuery Alias QTMP New
	dbSelectArea("QTMP")
	dbGoTop()
	If !Eof()
		MsgBox("Este código de disciplina é utilizada em outras tabelas !!")
		lRet:=.F.
	Endif
	dbSelectArea("QTMP")
	dbCloseArea()
	RestArea(aAreaAnt)
Endif

Return(lRet)
