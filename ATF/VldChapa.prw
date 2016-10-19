#Include "RWMAKE.CH"       
#Include "TopConn.ch"

User function VldChapa(cChapa)
************************************************************************************************************************
*
*
*****
Local aAreaSN1:=GetArea()
Local lRet:=.T.
cQuery:=" SELECT N1_NCHAPA FROM "+RetSqlName("SN1")+" SN1 "
cQuery+=" WHERE N1_NCHAPA='"+cChapa+"' AND N1_FILIAL='"+Xfilial("SN1")+"' AND D_E_L_E_T_<>'*'"

TcQuery cQuery Alias QTMP New
dbSelectArea("QTMP")
dbGotop()
If !Eof()
	MsgBox("Este Numero de Plaqueta Já Existe para o BEM: "+QTMP->N1_NCHAPA)
	lRet:=.F.
Endif
dbcloseArea()

//Restaura o Ambiente anterior
RestArea(aAreaSN1)

Return(lRet)