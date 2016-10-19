#include "rwmake.ch"
#include "topconn.ch"  

User Function FipFerias()
*******************************************************************************************************************
*
*
*
******  

Private cMens:=""
Private cAnoMesAtu  := GetMv("MV_FOLMES")
Private cPerg:="FIPFER"
Private aPerg:={}

AADD(aPerg,{cPerg,"Competencia Ano Mes?","C",06,0,"G","!Empty(MV_PAR01)","","","","","",""})
AADD(aPerg,{cPerg,"Matricula de  ?"         ,"C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Matricula Até ?"         ,"C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Data de     ?"         ,"D",8,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Data Até    ?"         ,"D",8,0,"G","U_ValidPer()","","","","","",""})
AADD(aPerg,{cPerg,"Tipo        ?"         ,"N",1,0,"C","","","Ferias","Afastamentos","","",""})

ExecBlock("TestaSX1",.F.,.F.,{cPerg,aPerg})
Pergunte(cPerg,.T.)
cMens:="  Este programa tem como Objetivo Gerar as marcações de Férias na FIP "
cMens+="  de acordo com o operíodo informado pelo Usuário"

BatchProcess("Gerar marcações de Férias na FIP",cMens,cPerg,{|| Processa({|| GERFIPFER()},"Aguarde","Processando...")})

Return()


Static Function GERFIPFER()
******************************************************************************************************************
*
*
*******
Local cArqsFip:=""
Local aArqFIP:={}
Local cAnoMes:=""
Local cMatDe :=""
Local cMatAte:=""
Local dFerDe :=""
Local dFerAte:=""
Local cConta:='9999F'
Private cCompet:=""

Pergunte("FIPFER",.f.)
cAnoMes:=MV_PAR01
cMatDe :=MV_PAR02
cMatAte:=MV_PAR03
dFerDe :=MV_PAR04
dFerAte :=MV_PAR05
nTipLan :=MV_PAR06

cQuery:=" SELECT RA_MAT,RA_NOME, RA_CC, RA_SITFOLH, RA_CC, R8_DATAINI DATAINI, R8_DATAFIM DATAFIM, R8_TIPO "
cQuery+=" FROM "+RetSqlName("SR8")+" SR8 "
cQuery+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (RA_MAT=R8_MAT AND SRA.D_E_L_E_T_<>'*') "
cQuery+=" WHERE "
cQuery+="        R8_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"' AND " 
cQuery+="       ((R8_DATAINI BETWEEN '"+Dtos(dFerDe)+"' AND '"+Dtos(dFerAte)+"') OR " 
cQuery+="        (R8_DATAFIM BETWEEN '"+Dtos(dFerDe)+"' AND '"+Dtos(dFerAte)+"') OR "
cQuery+="        (R8_DATAINI<='"+Dtos(dFerAte)+"' AND R8_DATAFIM ='')             OR "
cQuery+="        (R8_DATAINI< '"+Dtos(dFerDe) +"' AND R8_DATAFIM >'"+Dtos(dFerAte)+"'))"
cQuery+="        AND R8_TIPO NOT IN ('2','3','4','H','I','J','K','L','S') "

If nTipLan==1 // Ferias
	cQuery+="        AND R8_TIPO ='F'"
Else
	cQuery+="        AND R8_TIPO <>'F'" //Outros afastamentos
Endif

cQuery+="        AND SR8.D_E_L_E_T_<>'*' AND SR8.R8_FILIAL<>'97' "


TcQuery cQuery Alias QTMP New
dbSelectArea("QTMP")


dbGotop()
While !Eof()                                 
	dDiaAtu:=Stod(QTMP->DATAINI)
	dDiaAtu:=If(dDiaAtu < dFerDe,dFerDe , dDiaAtu)
	dDiaFim:=Stod(QTMP->DATAFIM)
	dDiaFim:=If(dDiaFim > dFerAte .Or. Empty(dDiaFim),dFerAte, dDiaFim)
	cMat:=QTMP->RA_MAT
	
	While dDiaAtu <= dDiaFim .Or. Empty(dDiaFim)
		cData:=Dtos(dDiaAtu)
		cData:=Left(cData,4)+'-'+SubStr(cData,5,2)+'-'+Right(cData,2)
		If !ExistLan(cMat,cData)
			
			If QTMP->R8_TIPO=='F'
				nHorasFip:=9
				cConta:='9999F'+Space(4)
				cTipoHr:='N'
				cCodAtiv:='00'
			Else
				
				nHorasFip:=9
				cConta:='9999Y'+Space(4)
				cTipoHr:='N'
				cCodAtiv:='00'			
			Endif
			
			//Executa a Procedure de Gravação dos Dados....
			IncProc("Gravando os dados na FIP...")
			TCSPExec( xProcedures("IMPFIP"),cMat  ,cData          ,nHorasFip      ,cAnoMes   ,cConta  ,cTipoHr    ,cCodAtiv,0,0,SM0->M0_CODFIL)
			/*IMPFIP_01 (                   IN_MAT,@IN_DATA       ,@IN_HORAS      ,@IN_COMPET,@IN_SUBC,@IN_HREXTRA,@IN_ATIV,@IN_ITEMCTR,@IN_REV, @IN_EMPR,@OUT_RESULTADO) AS */
			
		Endif	
		dDiaAtu:=DataValida(dDiaAtu+1)
	EndDo
	dbSelectArea("QTMP")
	dbSkip()
EndDo
dbSelectArea("QTMP")
dbCloseArea()
dbSelectArea("SRA")
Return(.T.)



Static Function ExistLan(cMat,cData)
**************************************************************************************************************
*
*
****** 
Local lRet:=.F.
Local aAreaAt:=GetArea()

cQuery:=" SELECT CHAPA FROM FIPEPC "
cQuery+=" WHERE CHAPA='"+cMat+"' AND FIPDATA='"+cData+"'"
TcQuery cQuery Alias QFIP New

dbSelectArea("QFIP")
dbGotop()
If !Eof()
	lRet:=.T.
Endif
dbSelectArea("QFIP")
dbCloseArea()

RestArea(aAreaAt)
Return(lRet)


User Function ValidPer()
***************************************************************************************************************
*
*
***
Local lRet:=.T.
Local dDataIni:=''
If Right(MV_PAR01,2)=='01'
	dDataIni:=Stod(StrZero(Val(Left(MV_PAR01,4))-1,4)+'1225')
Else 
	dDataIni:=dDataIni:=Stod(Left(MV_PAR01,4)+StrZero(Val(SubStr(MV_PAR01,5,2))-1,2)+'26')
Endif	
dDataFim:=Stod(MV_PAR01+'25')

If MV_PAR04<dDataIni .Or. MV_PAR04>dDataFim .Or. MV_PAR05<dDataIni .Or. MV_PAR05>dDataFim
   MsgBox("Período Fora da Competencia")
   lRet:=.F.
Endif 
Return(lRet)
