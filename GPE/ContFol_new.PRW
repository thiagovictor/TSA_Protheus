#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"  
#include "Ap5mail.ch"  

User Function ContFol()       

	Private nLastKey := 0                                           
	Private cAnoMesFol  := GetMv("MV_FOLMES")
	Private cAnoMesAtu  := ""
	Private cPerg:="GERFIP"
	Private aPerg:={}
	
	AADD(aPerg,{cPerg,"Competencia Ano Mes?"		 		,"C",06,0,"G","!Empty(MV_PAR01)","","","","","",""})
	AADD(aPerg,{cPerg,"Filial de  ?"				 		,"C",02,0,"G","","SM0","","","","",""})
	AADD(aPerg,{cPerg,"Filial At� ?"				 		,"C",02,0,"G","","SM0","","","","",""})
	AADD(aPerg,{cPerg,"C.Custo de ?"						,"C",14,0,"G","","CTT","","","","",""})
	AADD(aPerg,{cPerg,"C.Custo Ate?"				 		,"C",14,0,"G","","CTT","","","","",""})
	AADD(aPerg,{cPerg,"Gerar FIP F�rias?"					,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"Gerar FIP Autom�tica?"	   			,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"Processar Func Sem FIP?"	   			,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"Efetuar Rateio?"			   			,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"Gerar Contabiliza��o?"				,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"Mostra Lan�amentos Cont�beis?" 		,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"Aglutina Lan�amentos Cont�beis?"		,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"e-Mail?"						   		,"C",50,0,"G","","","","","","",""})
	AADD(aPerg,{cPerg,"SubConta F�rias"				 		,"C",5,0,"G","ExistCpo('CTT',MV_PAR14)","CTT","","","","",""})
	AADD(aPerg,{cPerg,"SubConta Afastamentos"				,"C",5,0,"G","ExistCpo('CTT',MV_PAR15)","CTT","","","","",""})
	AADD(aPerg,{cPerg,"Nro Horas p/Dia"			 			,"N",2,0,"G","","","","","","",""})
	AADD(aPerg,{cPerg,"Gera FIP para Func Sem FIP?"			,"N",01,0,"C","","","Sim","N�o","","",""})
	AADD(aPerg,{cPerg,"Gera FIP para Recisao Complementar?"	,"N",01,0,"C","","","Sim","N�o","","",""})
	
	Pergunte(cPerg,.T.)
	cMens:="Este programa tem como Objetivo gerar o rateio e contabiliza��o da Folha de Pgto da Folha de Pgto"
	
	BatchProcess("Contabiliza��o da Folha de Pgto",cMens,cPerg,{|| Processa({||ProcFol()},"Aguarde","Processando...")})

Return()
 


Static Function ProcFol()

	//Criacao de arquivos de trabalho
	Local lOK :=.T.
	Local lGerFIPFerias:=.F.
	Local lGerFIPAuto  :=.F.
	Local lVerSemFip   :=.F.
	Local lGerRat      :=.F.
	Local lGerContab   :=.F.
	Private lMostLanc  :=1 
	Private lAgluLanc  :=1
	Private cmail:=""
	Private _oDlg
	Private oProc1,oProc2,oProc3,oProc4
	Pergunte(cPerg,.F.)
	
	cAnoMes=MV_PAR01
	cFilDe =If(cFilAnt='97','97',MV_PAR02)
	cFilAte=If(cFilAnt='97','97',MV_PAR03)
	cCCDe =MV_PAR04
	cCCAte=MV_PAR05
	lGerFIPFerias:=If(cFilAnt='97',.f.,(MV_PAR06==1))
	lGerFIPAuto  :=(MV_PAR07==1)
	lVerSemFip   :=(MV_PAR08==1)
	lGerRat      :=If(cFilAnt='97',.f.,(MV_PAR09==1))
	lGerContab   :=If(cFilAnt='97',.f.,(MV_PAR10==1))
	Private lMostLanc  :=(MV_PAR11==1) 
	Private lAgluLanc  :=(MV_PAR12==1)
	Private cmail:=MV_PAR13
	Private cContaF:=MV_PAR14
	Private cContaAF:=MV_PAR15
	Private nHoraFip:=MV_PAR16
	Private lForcaFIP:=(MV_PAR17==1)
	Private lRecComplem:=(MV_PAR18==1 .And. cEmpAnt<>'97')
	
	cAnoIni=StrZero(If(Substr(cAnoMes,5,2)='01' , Val(Left(cAnoMes,4))-1, Val(Left(cAnoMes,4))),4)
	cMesIni=StrZero(If(Substr(cAnoMes,5,2)='01' ,12,Val(Substr(cAnoMes,5,2))-1),2)
	cAnoFim=Left(cAnoMes,4)
	cMesFim=Substr(cAnoMes,5,2)
	dDataDe =Stod(cAnoIni+cMesIni+'26')
	dDataAte=Stod(cAnoFim+cMesFim+'25')
	
	If Left(Dtos(dDatabase),6)<>cAnoMes
		Alert("A Data base do sistema deve ser compat�vel com o Ano e Mes Informado no parametro.")
		lOK:=.f.
	Endif
	
	If lGerFIPFerias
		IncProc("Aguarde gerando FIP para Funcion�rios de F�rias e Afastados","Aguarde...")
		lOK:=GerFIPFer()
	Endif
	
	If lGerFIPAuto
		IncProc("Aguarde Gerando lan�amentos de FIP Autom�tica","Aguarde...")
		lOK:=GerFipAuto()
	Endif
	
	If lVerSemFip
		IncProc("Verificando Funcion�rios SEM FIP","Aguarde...")
		lOK:=VerSemFIP()   
	Endif
	
	If lRecComplem
		IncProc("Processando Fun. Recis�o Complementar","Aguarde...")
		lOK:=RecCompl()   
	Endif
	
	If lOK .And. lGerRat
	
		lOK:=ErrosDigit()
		If lOK
			IncProc("Efetuando o Rateio....","Aguarde...")
			lOK:=GerRatFol()
		Endif	
	Endif
	
	If lOK .And. lGerContab
		ApMsgAlert("Iniciando contabiliza��o")
		IncProc("Aguarde Contabilizando....","Aguarde...")
		ProcContab()
	Endif
	
Return(.T.)



Static Function VerSemFIP()
	
	Local lRet:=.T.
	Local lGerFip:=.F.
	Local cEol:=Chr(13)
	Local cMat:='*'
	Local cCusto:="*"
	Local cAccount  := GetMv("MV_WFACC") 
	Local cCtaPass  := GetMv("MV_WFPASSW")
	Local cCtaSmpt  := GetMv("MV_WFSMTP") 
	Local cSendBy   := cmail
	Local cMens:=""
	Local cConta:=""
	Local lFerias:=.F.
	                              
	//Gera Fip para as pessoas que n�o precisam digitar a FIP
	cQuery:=" SELECT RA_FILIAL,RA_CC,RA_MAT,RA_NOME,RA_FIPAUTO,RA_FIPSUBC,CTT.CTT_DESC01,"
	cQuery+=" Isnull((SELECT MIN(Z2_SUBC) FROM "+RetSqlName("SZ2")+" SZ2 WHERE Z2_SETOR=RA_CC AND LEFT(Z2_SUBC,1)='9' AND Z2_LETRA='A' AND SZ2.D_E_L_E_T_<>'*' AND Z2_SITUAC<>'3'),'') SUBC "
	cQuery+=" FROM "+RetSqlName("SRA")+" SRA"
	cQuery+=" LEFT OUTER JOIN FIPEPC FIP ON (FIPANOMES='"+cAnoMes+"' AND CHAPA=RA_MAT AND "
	cQuery+=" (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F'))) "
	cQuery+=" LEFT OUTER JOIN "+RetSqlName("CTT")+" CTT ON  (CTT.CTT_CUSTO=RA_CC AND CTT.CTT_FILIAL='') "
	cQuery+=" LEFT OUTER JOIN "+RetSqlName("SZ2")+" SZ2 ON  (SZ2.Z2_SUBC=Right(FIP.FIPCUSTO,5) AND SZ2.Z2_COD=LEFT(FIP.FIPCUSTO,5) AND SZ2.Z2_FILIAL='"+Xfilial("SZ2")+"' AND SZ2.D_E_L_E_T_<>'*') "
	cQuery+=" WHERE "
	cQuery+="     RA_CC BETWEEN '"+cCCDe+"' AND '"+cCCAte+"'"
	cQuery+=" AND RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"'"
	cQuery+=" AND RA_ADMISSA <='"+dtos(dDataAte)+"'"
	cQuery+=" AND (RA_DEMISSA='' OR LEFT(RA_DEMISSA,6)>='"+cAnoMes+"') AND FIP.CHAPA IS NULL "
	cQuery+=" AND SRA.D_E_L_E_T_<>'*' "
	cQuery+=" ORDER BY RA_CC,RA_NOME "
	TcQuery cQuery Alias QSFIP New
	 
	cMens:=' <html> '+cEol
	cMens+='	<head>'+cEol
	cMens+='		<TITLE>'+if(cEmpAnt='01','EPC-','TSA')+'-Lista de Funcion�rios Sem FIP </TITLE>'+cEol
	cMens+='	</HEAD>'+cEol
	cMens+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align="Left" colspan=3  bgColor="Silver" >'+cEol
	cMens+='<B> Segue abaixo a lista de Funcion�rios sem FIP.'
	cMens+='� necess�rio que todas as pendencias sejam solucionadas'
	cMens+='para a finaliza��o do processo. </B><br>'+cEol
	cMens+=' Parametros: <br>'
	cMens+=' Ano Mes Refer�ncia:'+cAnoMes+'<br>'
	cMens+=' C.Custo de:'+cCCDe+' Ate '+cCCAte+'<br>'
	cMens+=' Filial de:'+cFilDe+' At� '+cFilAte+'<br>'
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td colspan=3 > </td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align=center colspan=3  bgColor="Silver">'+cEol
	cMens+='				<P>Lista de Funcion�rios sem digita��o de FIP no per�odo'+cEol
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td bgColor="Silver">Centro de Custo </td>'+cEol
	cMens+='			<td bgColor="Silver">Funcion�rio </td>'+cEol
	cMens+='			<td bgColor="Silver">Ocorr�ncia  </td>'+cEol
	cMens+='		</tr>'+cEol
	cCusto=""
	dbSelectArea("QSFIP")
	dbGotop()
	While !Eof()
		
		If cCusto<>QSFIP->RA_CC
			cMens+='		<tr>'+cEol
			cMens+='			<td align=center colspan=3 bgColor="Silver">'+AllTrim(QSFIP->RA_CC)+'-'+QSFIP->CTT_DESC01+'</td>'+cEol
			cMens+='		</tr>'+cEol
			cCusto:=QSFIP->RA_CC
		Endif           
		lGerFip:=.F.
		
		If QSFIP->RA_FILIAL<>'97' .And. lForcaFIP
			//Gera o Lan�amento dos Funcion�rios Sem FIP na Data
			dDiaAtu:=dDiaAtu:=DataValida(dDataDe)
			dDiaFim:=dDataAte
			cMat:=QSFIP->(RA_MAT)
			cConta:="" 	
			//Busca a Conta de Funcion�rios Sem FIP
			//Somente para o contrato E9000
			cQueryK:=" SELECT Z2_COD+'-'+Z2_OS+'-'+Z2_SUBC Z2_SUBC FROM "+RetSqlName("SZ2")
			cQueryK+=" WHERE "
			If cEmpAnt='01'
				cQueryK+=" Z2_COD='E9000' AND "
			Endif
			cQueryK+=" Z2_SETOR='"+QSFIP->RA_CC+"' AND LEFT(Z2_SUBC,1)='9' AND Z2_LETRA='K' AND Z2_SITUAC<>'3' AND D_E_L_E_T_<>'*' "
			TcQuery cQueryK Alias QSF New
			dbSelectArea("QSF")
			dbGoTop()
			If !Eof() 
				cConta:=AllTrim(QSF->Z2_SUBC)
			Else
				cConta:=QSFIP->RA_FIPSUBC+Space(14-Len(QSFIP->RA_FIPSUBC))
			Endif
		
			If !Empty(cConta)	
				nHorasFip:=8.20
				cTipoHr:='N'
				cCodAtiv:='00'
				While (dDiaAtu <= dDiaFim .Or. Empty(dDiaFim))
					cData:=Dtos(dDiaAtu)
					cData:=Left(cData,4)+'-'+SubStr(cData,5,2)+'-'+Right(cData,2)
					If !ExistLan(cMat,cData)
						//Executa a Procedure de Grava��o dos Dados....
						IncProc("Gravando os dados na FIP...") 
						TCSPExec( xProcedures("IMPFIP"),cMat  ,cData          ,nHorasFip      ,cAnoMes   ,cConta  ,cTipoHr    ,cCodAtiv,    0      ,  0    ,cEmpAnt,cFilAnt,'S','S','SEMFIP')
						/*IMPFIP_01 (                   IN_MAT,@IN_DATA       ,@IN_HORAS      ,@IN_COMPET,@IN_SUBC,@IN_HREXTRA,@IN_ATIV,@IN_ITEMCTR,@IN_REV, @IN_EMPR,@OUT_RESULTADO) AS */
						lGerFip:=.T. 
					Endif	
					dDiaAtu:=DataValida(dDiaAtu+1)
				EndDo
			Endif
			
			dbSelectArea("QSF")	
			dbCloseArea()
			
		Endif	
		
		cMens+='		<tr>'+cEol	
		cMens+='			<td>'+AllTrim(QSFIP->RA_CC)+"-"+AllTrim(QSFIP->SUBC)+'</td>'+cEol
		cMens+='			<td>'+QSFIP->(RA_MAT+"-"+RA_NOME)+'</td>'+cEol
		if QSFIP->RA_FILIAL<>'97' .And. lForcaFIP
			if lGerFip
				cMens+='			<td> Fip Gerada Conta:'+cConta+'</td>'+cEol
			Else
				cMens+='			<td> N�o h� conta 9...K no C.Custo ou </br> Funcion�rio sem Subconta padr�o</td>'+cEol
			Endif
		Endif
		cMens+='		</tr>'+cEol   
		if lRet
			lRet:=lGerFip
		Endif
		dbSelectArea("QSFIP")
		dbSkip()
		
	EndDo
	
	dbSelectArea("QSFIP")
	dbCloseArea()
	dbSelectArea("SRA")
	if !lRet
		cMens+='		<tr>'+cEol
		cMens+='			<td align=center colspan=3 bgColor="Red">Existem Funcion�rios que n�o teve as suas FIPs GERADAS por n�o ter uma SubConta Padr�o ou seu centro de custo n�o tem uma SUBCONTA 9...K.N�o � poss�vel efetuar o Rateio</td>'+cEol
		cMens+='		</tr>'+cEol	
	Endif
	cMens+='	</table>'+cEol
	
	cMens+='</html> '+cEol
	
	CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
	
	SEND MAIL FROM  cSendBy TO  cSendBy SUBJECT 'Processo de Rateio da FIP' BODY cMens 
	
	DISCONNECT SMTP SERVER

Return(lRet)



Static Function RecCompl()
	
	Local lRet:=.T.
	Local lGerFip:=.F.
	Local cEol:=Chr(13)
	Local cCusto:="*"
	Local cAccount  := GetMv("MV_WFACC") 
	Local cCtaPass  := GetMv("MV_WFPASSW")
	Local cCtaSmpt  := GetMv("MV_WFSMTP") 
	Local cSendBy   := cmail
	Local cMens:=""
	Local cConta:=""
	Local cTipoHr:='N'
	Local cCodAtiv:='00'
	Local	cData:=dtoS(dDataAte)
	
	cData:=Left(cData,4)+'-'+SubStr(cData,5,2)+'-'+Right(cData,2)
	//Gera Fip para as pessoas Com Recis�o Complementar
	
	cQuery:=" SELECT DISTINCT RA_NOME,RA_CC,CTT_DESC01,RZ_MAT,CASE WHEN Z2_SUBC IS NULL THEN RA_FIPSUBC ELSE Z2_SUBC END SUBCONTA,RA_CC "
	cQuery+=" FROM "+RetSqlName("SRZ")
	cQuery+=" INNER JOIN "+RetSqlName("SRA")+" ON (RA_MAT=RZ_MAT AND RA_FILIAL=RZ_FILIAL AND RA_DEMISSA<'"+Dtos(dDataAte)+"' AND RA_DEMISSA<>'')"
	cQuery+=" LEFT OUTER JOIN "+RetSqlName("SZ2")+" SZ2 ON (Z2_SETOR=RZ_CC AND Z2_LETRA='R' AND SZ2.D_E_L_E_T_<>'*') "
	cQuery+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON  (CTT.CTT_CUSTO=RA_CC AND CTT.CTT_FILIAL='') "
	cQuery+=" LEFT OUTER JOIN FIPEPC ON (CHAPA=RZ_MAT AND FIPANOMES='"+cAnoMes+"' AND (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F'))) "
	cQuery+=" WHERE "
	cQuery+="     RA_CC BETWEEN '"+cCCDe+"' AND '"+cCCAte+"'"
	cQuery+=" AND RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"'"
	cQuery+=" AND RA_ADMISSA <='"+dtos(dDataAte)+"'"
	cQuery+=" AND CHAPA IS NULL "
	cQuery+=" ORDER BY RA_CC,RA_NOME "
	                     
	TcQuery cQuery Alias QREC New
	
	cMens:=' <html> '+cEol
	cMens+='	<head>'+cEol
	cMens+='		<TITLE>'+if(cEmpAnt='01','EPC-','TSA')+'-Lista de Funcion�rios Com Recis�o Complementar </TITLE>'+cEol
	cMens+='	</HEAD>'+cEol
	cMens+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align="Left" colspan=3  bgColor="Silver" >'+cEol
	cMens+='<B> Segue abaixo a lista de Funcion�rios Com Recis�o Complementar.'
	cMens+='� necess�rio que todas as pendencias sejam solucionadas'
	cMens+='para a finaliza��o do processo. </B><br>'+cEol
	cMens+=' Parametros: <br>'
	cMens+=' Ano Mes Refer�ncia:'+cAnoMes+'<br>'
	cMens+=' C.Custo de:'+cCCDe+' Ate '+cCCAte+'<br>'
	cMens+=' Filial de:'+cFilDe+' At� '+cFilAte+'<br>'
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td colspan=3 > </td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align=center colspan=3  bgColor="Silver">'+cEol
	cMens+='				<P>Funcion�rios'+cEol
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td bgColor="Silver">Centro de Custo </td>'+cEol
	cMens+='			<td bgColor="Silver">Funcion�rio </td>'+cEol
	cMens+='			<td bgColor="Silver">Ocorr�ncia  </td>'+cEol
	cMens+='		</tr>'+cEol
	cCusto=""
	dbSelectArea("QREC")
	dbGotop()
	While !Eof()               
	
		If cCusto<>QREC->RA_CC
			cMens+='		<tr>'+cEol
			cMens+='			<td align=center colspan=3 bgColor="Silver">'+AllTrim(QREC->RA_CC)+'-'+QREC->CTT_DESC01+'</td>'+cEol
			cMens+='		</tr>'+cEol
			cCusto:=QREC->RA_CC
		Endif           
		//Gera o Lan�amento da FIP
		if !Empty(QREC->(SUBCONTA))
			TCSPExec(xProcedures("IMPFIP"),QREC->(RZ_MAT),cData ,nHoraFip  ,cAnoMes   , QREC->(SUBCONTA) ,cTipoHr    ,cCodAtiv,    0      ,  0    ,cEmpAnt,cFilAnt,'S','S','RECCOMPL')
			cMens+='			<td>'+AllTrim(QREC->RA_CC)+"-"+AllTrim(QREC->SUBCONTA)+'</td>'+cEol
			cMens+='			<td>'+QREC->(RZ_MAT+"-"+RA_NOME)+'</td>'+cEol   
			cMens+='			<td> Fip Gerada Conta:'+AllTrim(QREC->SUBCONTA)+'</td>'+cEol
		Else       
			cMens+='			<td> N�o h� conta 9...R(Recis�o Complementar) no C.Custo </td>'+cEol
			lGerFip:=.F.
			lRet:=lGerFip
		Endif
		
		cMens+='		</tr>'+cEol   
		
		dbSelectArea("QREC")
		dbSkip()
		
	EndDo
	
	dbSelectArea("QREC")
	dbCloseArea()
	dbSelectArea("SRA")
	if !lRet
		cMens+='		<tr>'+cEol
		cMens+='			<td align=center colspan=3 bgColor="Red">Existem Funcion�rios que n�o teve as suas FIPs GERADAS por n�o ter uma SubConta Padr�o ou seu centro de custo n�o tem uma SUBCONTA 9...K.N�o � poss�vel efetuar o Rateio</td>'+cEol
		cMens+='		</tr>'+cEol	
	Endif
	cMens+='	</table>'+cEol
	
	cMens+='</html> '+cEol
	
	CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
	
	SEND MAIL FROM  cSendBy TO  cSendBy SUBJECT 'Rateio da FIP(Recis�o Complementar)' BODY cMens 
	
	DISCONNECT SMTP SERVER

Return(lRet)




                     
Static Function ErrosDigit()
	
	Local lRet:=.T.
	Local cEol:=Chr(13)
	Local cMat:='*'
	Local cCusto:="*"
	Local cAccount  := GetMv("MV_WFACC") 
	Local cCtaPass  := GetMv("MV_WFPASSW")
	Local cCtaSmpt  := GetMv("MV_WFSMTP") 
	Local cSendBy   := cmail
	Local cMens:=""
	
	cQuery:=" SELECT RA_CC,RA_MAT,RA_NOME,RA_NOME,CHAPA,CONVERT(CHAR(10),FIPDATA,103) DATAFIP,FIPCUSTO,FIPHORAI,FIPHORAF,CTT.CTT_DESC01 "
	cQuery+=" FROM FIPEPC FIP "
	cQuery+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (RA_MAT=FIP.CHAPA AND SRA.D_E_L_E_T_<>'*') "
	cQuery+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON  (CTT.CTT_CUSTO=RA_CC AND CTT.CTT_FILIAL='"+Xfilial("CTT")+"') "
	cQuery+=" WHERE "
	cQuery+="     FIPANOMES='"+cAnoMes+"'"
	cQuery+=" AND RA_CC BETWEEN '"+cCCDe+"' AND '"+cCCAte+"'"
	cQuery+=" AND RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"'"
	cQuery+=" AND RA_ADMISSA <='"+dtos(dDataAte)+"'"
	cQuery+=" AND (RA_DEMISSA='' OR LEFT(RA_DEMISSA,6)='"+cAnoMes+"')"
	cQuery+=" AND ((FIPHORAI>=FIPHORAF) OR "
	cQuery+=" (RIGHT(CAST(FIPHORAI AS VARCHAR),2)>=60)  OR "
	cQuery+=" (RIGHT(CAST(FIPHORAF AS VARCHAR),2)>=60) OR "
	cQuery+=" (FIPHORAF>23.59) OR    "
	cQuery+=" (FIPHORAI>23.59))      "
	cQuery+=" ORDER BY RA_CC,RA_NOME "
	
	TcQuery cQuery Alias QSFIP New
	 
	cMens:=' <html> '+cEol
	cMens+='	<head>'+cEol
	cMens+='		<TITLE>'+if(cEmpAnt='01','EPC-','TSA')+'-Erros de Digita��o da FIP</TITLE>'+cEol
	cMens+='	</HEAD>'+cEol
	cMens+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align="Left" colspan=5  bgColor="Red" >'+cEol
	cMens+='<B> Segue abaixo a lista de FIPs Digitadas Erradas.</B><br>'+cEol
	cMens+=' Parametros: <br>'
	cMens+=' Ano Mes Refer�ncia:'+cAnoMes+'<br>'
	cMens+=' C.Custo de:'+cCCDe+' Ate '+cCCAte+'<br>'
	cMens+=' Filial de:'+cFilDe+' At� '+cFilAte+'<br>'
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td colspan=5 > </td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align=center colspan=5  bgColor="Red">'+cEol
	cMens+='				<P>Lista de Funcion�rios com digita��o de FIP ERRADA'+cEol
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td bgColor="Silver">Funcion�rio </td>'+cEol
	cMens+='			<td bgColor="Silver">Data</td>'+cEol
	cMens+='			<td bgColor="Silver">Centro de Custo </td>'+cEol
	cMens+='			<td bgColor="Silver">Hora Inicial</td>'+cEol
	cMens+='			<td bgColor="Silver">Hora Final</td>'+cEol
	cMens+='		</tr>'+cEol
	cCusto=""

	dbSelectArea("QSFIP")
	dbGotop()

	While !Eof()
		
		If cCusto<>QSFIP->RA_CC
			cMens+='		<tr>'+cEol
			cMens+='			<td align=center colspan=5 bgColor="Silver">'+AllTrim(QSFIP->RA_CC)+'-'+QSFIP->CTT_DESC01+'</td>'+cEol
			cMens+='		</tr>'+cEol
			cCusto:=QSFIP->RA_CC
		Endif
		cMens+='		<tr>'+cEol	
		cMens+='			<td>'+QSFIP->(RA_MAT+"-"+RA_NOME)+'</td>'+cEol
		cMens+='			<td>'+QSFIP->DATAFIP+'</td>'+cEol
	    cMens+='			<td>'+QSFIP->FIPCUSTO+'</td>'+cEol
		cMens+='			<td>'+StrZero(QSFIP->FIPHORAI,5,2)+'</td>'+cEol
		cMens+='			<td>'+StrZero(QSFIP->FIPHORAF,5,2)+'</td>'+cEol
		cMens+='		</tr>'+cEol   
		lRet:=.t.
		
		dbSelectArea("QSFIP")
		dbSkip()

	EndDo

	dbSelectArea("QSFIP")
	dbCloseArea()
	dbSelectArea("SRA")	
	
	cMens+='	</table>'+cEol
	cMens+='</html> '+cEol
	
	nFile:=Fcreate("c:\SemFIP.html")
	Fwrite(nFile,cMens)
	Fclose(nFile)
	
	CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
	
	SEND MAIL FROM  cSendBy TO  cSendBy SUBJECT 'Processo Valida��o das Digita��es da FIP' BODY cMens 
	
	DISCONNECT SMTP SERVER

Return(lRet)



Static Function GERFIPFER()
	
	Local cConta:=''
	
	cQuery:=" SELECT RA_MAT,RA_NOME, RA_CC, RA_SITFOLH, RA_CC, R8_DATAINI DATAINI, R8_DATAFIM DATAFIM, R8_TIPO "
	cQuery+=" FROM "+RetSqlName("SR8")+" SR8 "
	cQuery+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (RA_MAT=R8_MAT AND SRA.D_E_L_E_T_<>'*') "
	cQuery+=" WHERE "
	cQuery+="         RA_CC BETWEEN '"+cCCDe+"' AND '"+cCCAte+"' AND " 
	cQuery+=" 		   RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"' AND "
	cQuery+="       ((R8_DATAINI BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"') OR " 
	cQuery+="        (R8_DATAFIM BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"') OR "
	cQuery+="        (R8_DATAINI<='"+Dtos(dDataDe)+"' AND R8_DATAFIM ='')             OR "
	cQuery+="        (R8_DATAINI< '"+Dtos(dDataAte) +"' AND R8_DATAFIM >'"+Dtos(dDataAte)+"')) AND "
	cQuery+="         R8_TIPO NOT IN ('2','3','4','H','I','J','K','L','S') AND "
	cQuery+="         SR8.D_E_L_E_T_<>'*' AND SR8.R8_FILIAL<>'97' "
	
	TcQuery cQuery Alias QTMP New
	dbSelectArea("QTMP")
	
	dbGotop()
	While !Eof()                                 
	
		dDiaAtu:=Stod(QTMP->DATAINI)
		dDiaAtu:=If(dDiaAtu < dDataDe,dDataDe , dDiaAtu)
		dDiaFim:=Stod(QTMP->DATAFIM)
		dDiaFim:=If(dDiaFim > dDataAte .Or. Empty(dDiaFim),dDataAte, dDiaFim)
		cMat:=QTMP->RA_MAT
		cTipoHr:='N'                           
		cCodAtiv:='00'				
		If QTMP->R8_TIPO=='F'
			cConta:=cContaF
			cConta:=cConta+Space(14-Len(cConta))
		Else
			cConta:=cContaAF
			cConta:=cConta+Space(14-Len(cConta))
		Endif    
	
		While cConta<>'' .And. (dDiaAtu <= dDiaFim .Or. Empty(dDiaFim))
			cData:=Dtos(dDiaAtu)
			cData:=Left(cData,4)+'-'+SubStr(cData,5,2)+'-'+Right(cData,2)
			If !ExistLan(cMat,cData)
				dbSelectArea("QTMP")
				//Executa a Procedure de Grava��o dos Dados....
				IncProc("Gravando os dados na FIP...") 
				TCSPExec( xProcedures("IMPFIP"),cMat  ,cData          ,nHoraFip       ,cAnoMes   ,cConta  ,cTipoHr    ,cCodAtiv,    0      ,  0    ,cEmpAnt,cFilAnt,'S','S','FIPFERIAS')
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



Static Function GerFipAuto()
	
	Local lRet:=.T.
	
	//Gera Fip para as pessoas que n�o precisam digitar a FIP
	cQuery:=" SELECT DISTINCT RA_CC,RA_MAT,RA_NOME,RA_FIPAUTO,RA_FIPSUBC "
	cQuery+=" FROM "+RetSqlName("SRA")+" SRA "
	cQuery+=" LEFT OUTER JOIN FIPEPC FIP ON (FIPANOMES='"+cAnoMes+"' AND CHAPA=RA_MAT)"
	cQuery+=" LEFT OUTER JOIN "+RetSqlName("SZ2")+" SZ2 ON  (SZ2.Z2_SUBC=Right(FIP.FIPCUSTO,5) AND SZ2.Z2_COD=LEFT(FIP.FIPCUSTO,5) AND SZ2.Z2_FILIAL='"+Xfilial("SZ2")+"' AND SZ2.D_E_L_E_T_<>'*') "
	cQuery+=" WHERE "
	cQuery+="     RA_CC    BETWEEN '"+cCCDe+"' AND '"+cCCAte+"'"
	cQuery+=" AND RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"'"
	cQuery+=" AND (RA_DEMISSA='' OR LEFT(RA_DEMISSA,6)='"+cAnoMes+"')"
	cQuery+=" AND SRA.RA_FIPAUTO='S' AND RA_FIPSUBC<>'' AND SRA.D_E_L_E_T_<>'*' "
	
	TcQuery cQuery Alias QTMP New
	dbSelectArea("QTMP")
	
	dbGotop()
	While !Eof()                                 
		dDiaAtu:=dDataDe
		dDiaFim:=dDataAte
		cMat:=QTMP->RA_MAT
		While dDiaAtu <= dDiaFim .Or. Empty(dDiaFim)
			cData:=Dtos(dDiaAtu)
			cData:=Left(cData,4)+'-'+SubStr(cData,5,2)+'-'+Right(cData,2)
			If !ExistLan(cMat,cData)
				nHorasFip:=8.20
				cConta:=Alltrim(QTMP->RA_FIPSUBC)
				cConta:=cConta+Space(14-Len(cConta))
				cTipoHr:='N'
				cCodAtiv:='00'
				//Executa a Procedure de Grava��o dos Dados....
				IncProc("Gravando os dados na FIP...") 
				TCSPExec( xProcedures("IMPFIP"),cMat  ,cData          ,nHorasFip      ,cAnoMes   ,cConta  ,cTipoHr    ,cCodAtiv,    0      ,  0    ,cEmpAnt,cFilAnt,'S','S','FIPAUTO')
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
	
Return(lRet)



Static Function ExistLan(cMat,cData)

	Local lRet:=.F.
	Local aAreaAt:=GetArea()
	
	cQuery:=" SELECT CHAPA FROM FIPEPC "
	cQuery+=" INNER JOIN "+RetSqlName("SZ2")+" SZ2 ON  (SZ2.Z2_SUBC=Right(FIPEPC.FIPCUSTO,5) AND SZ2.Z2_COD=LEFT(FIPEPC.FIPCUSTO,5) AND SZ2.Z2_FILIAL='"+Xfilial("SZ2")+"' AND SZ2.D_E_L_E_T_<>'*') "
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

Static Function GerRatFol()

	dbSelectArea("SRA")
	ProcRegua(RecCount()) // Ajusta numero de elementos da regua
	        
	cQuery :=""
	cQuery1:=""
	cQuery2:=""
	cQuery3:=""
	//Complementa a Query de Rateio para que a execu��o seja por matricula
	cQuery :=" SELECT SRZ.RZ_FILIAL,SRZ.RZ_MAT,RA_NOME,RZ_CC,RZ_PD,SRV.RV_LPADRAO,FIP.FIPCUSTO, "
	cQuery +="	SUM( "
	cQuery +="		(CAST(Left(Convert( VARCHAR(5), "
	cQuery +="	 	Cast(replace( CAST(FIP.FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime)"
	cQuery +="		-Cast(replace( CAST(FIP.FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime),108),2) AS NUMERIC)*60)"
	cQuery +="	+"
	cQuery +="		CAST(RIGHT(Convert( VARCHAR(5), "
	cQuery +="	 	 Cast(replace( CAST(FIP.FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime)"
	cQuery +="		-Cast(replace( CAST(FIP.FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime),108),2) AS NUMERIC)"
	cQuery +="	) HORASFIP "
	cQuery +="	,"
	cQuery +="	("
	cQuery +="		SELECT SUM( "
	cQuery +="			(CAST(Left(Convert( VARCHAR(5), "
	cQuery +="	 		Cast(replace( CAST(SUBFIP.FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime)"
	cQuery +="			-Cast(replace( CAST(SUBFIP.FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime),108),2) AS NUMERIC)*60)"
	cQuery +="		+"
	cQuery +="			CAST(RIGHT(Convert( VARCHAR(5), "
	cQuery +="	 	 	Cast(replace( CAST(SUBFIP.FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime)"
	cQuery +="			-Cast(replace( CAST(SUBFIP.FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime),108),2) AS NUMERIC))"
	cQuery +="		FROM FIPEPC SUBFIP"
	cQuery +="     INNER JOIN "+RetSqlName("SZ2")+" SZ2 ON (SUBFIP.FIPCUSTO = Substring(SZ2.Z2_COD,1,5) + '-' + Substring(SZ2.Z2_OS,1,2) + '-' + Substring(SZ2.Z2_SUBC,1,5))"
	
	cQuery2 +=" INNER JOIN "+RetSqlName("SZ2")+" SZ2 ON (FIP.FIPCUSTO = Substring(SZ2.Z2_COD,1,5) + '-' + Substring(SZ2.Z2_OS,1,2) + '-' + Substring(SZ2.Z2_SUBC,1,5))"
	cQuery2 +=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (SRA.RA_MAT=FIP.CHAPA AND SRA.D_E_L_E_T_<>'*')"
	cQuery2 +=" INNER JOIN "+RetSqlName("SRZ")+" SRZ ON (SRZ.RZ_FILIAL=SRA.RA_FILIAL AND SRZ.RZ_MAT=CHAPA AND SRZ.D_E_L_E_T_<>'*')"
	cQuery2 +=" INNER JOIN "+RetSqlName("SRV")+" SRV ON (SRV.RV_FILIAL='"+Xfilial("SRV")+"' AND SRV.RV_COD=SRZ.RZ_PD AND SRV.RV_LPADRAO<>'' AND SRV.D_E_L_E_T_<>'*')"
	cQuery2 +=" WHERE "
	
	cQueryMat:=" SELECT DISTINCT RZ_FILIAL,RZ_MAT "
	cQueryMat+=" FROM "+RetSqlName("SRZ")+" SRZ "
	cQueryMat+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (RA_MAT=RZ_MAT AND RA_FILIAL=RZ_FILIAL AND SRA.D_E_L_E_T_<>'*') "
	cQueryMat+=" WHERE  "
	cQueryMat+="     RZ_CC    BETWEEN '"+cCCDe+"' AND '"+cCCAte+"'"
	cQueryMat+=" AND RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"'"
	cQueryMat+=" AND SRZ.D_E_L_E_T_<>'*'"
	cQueryMat+=" ORDER BY RZ_FILIAL,RZ_MAT "
	
	TcQuery cQueryMat Alias QMAT New
	
	AVISO("TESTE1",cQueryMat,{"Ok"},3)
	
	cMatTemp := ""
	dbSelectArea("QMAT")
	dbGotop()
	While !Eof()
	
		//Exclui os registros desta matricula para este Mes na tabela de Rateio
		cQueryDel:=" DELETE "+RetSqlName("SZ7")+" WHERE Z7_MAT='"+QMAT->RZ_MAT+"' AND (Z7_DTLANC='' OR Left(Z7_DTLANC,6)='"+cAnoMes+"')"
		TcSQLExec(cQueryDel)
		
		IncProc("Efetuando Rateio.... Mat "+QMAT->RZ_MAT ,"Aguarde...")
		cMatTemp += QMAT->RZ_MAT +chr(13)+chr(10)
		
		cQuery1 :="		WHERE SUBFIP.CHAPA='"+QMAT->RZ_MAT+"' AND SUBFIP.FIPANOMES ='"+cAnoMes+"' AND "
		cQuery1 +="	 (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F')) "
		cQuery1 +="		  AND SUBFIP.FIPHORAI<SUBFIP.FIPHORAF"
		cQuery1 +="	) HORASTOT,RZ_VAL "
		cQuery1 +=" FROM FIPEPC AS FIP "	
		
		cQuery3 :=" CHAPA='"+QMAT->RZ_MAT+"' AND "
		cQuery3 +=" RA_FILIAL='"+QMAT->RZ_FILIAL+"' AND "
		cQuery3 +=" FIP.FIPANOMES ='"+cAnoMes+"' AND (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F')) AND FIP.FIPHORAI<FIP.FIPHORAF "
		cQuery3 +=" GROUP BY RZ_FILIAL,RZ_MAT,RA_NOME,RZ_CC,RZ_PD,RV_LPADRAO,FIP.FIPCUSTO,RZ_VAL"
		cQuery3 +=" ORDER BY RZ_FILIAL,RZ_MAT,RA_NOME,RZ_CC,RZ_PD,RV_LPADRAO,FIP.FIPCUSTO,RZ_VAL"
		
		Fwrite(Fcreate('Log_Rateio\Rateio_'+QMAT->RZ_MAT+'.txt'),cQuery+cQuery1+cQuery2+cQuery3)
		//Executa a Query com o Rateio j� realizado
		TCQUERY cQuery+cQuery1+cQuery2+cQuery3 Alias QRATMAT NEW  
		
		//AVISO("TESTE2",cQuery+cQuery1+cQuery2+cQuery3,{"Ok"},3)
		
		
		dbSelectArea("QRATMAT")
		dbGotop()   
		
		While !Eof()
			//Grava os dados na Tabela de Rateio
			dbSelectArea("SZ7")
			RecLock("SZ7",.T.)
				Replace Z7_MAT     With QRATMAT->RZ_MAT
				Replace Z7_FILMAT  With QRATMAT->RZ_FILIAL
				Replace Z7_CC      With QRATMAT->RZ_CC
				Replace Z7_PD      With QRATMAT->RZ_PD
				Replace Z7_VALOR   WITH QRATMAT->RZ_VAL
				Replace Z7_VLRAT   WITH QRATMAT->((HORASFIP/HORASTOT)*RZ_VAL)
				Replace Z7_SUBC    WITH RIGHT(QRATMAT->FIPCUSTO,5)
				Replace Z7_LPADRAO WITH QRATMAT->RV_LPADRAO
			MsUnlock()
			dbSelectArea("QRATMAT")				  
			dbSkip()
		EndDo
		dbSelectArea("QRATMAT")
		dbCloseArea()   
		
		dbSelectArea("QMAT")
		dbSkip()
		
	EndDo	
	
	AVISO("TESTE3",cMatTemp,{"Ok"},3)	
	
	dbSelectArea("QMAT")
	dbCloseArea()
	dbSelectArea("SZ7")
	
Return(.T.)



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ProcCProva
Static Function ProcContab()

	nTotal     := 0
	nHdlPrv    := 0
	cArquivo   := ""     // Arquivo CProva
	lCabecalho := .F.    // Flag se ja emitiu o cabecaho do CProva
	cPadrao    := "*"

	ApMsgAlert("Dentro de ProcContab")
	
	dbSelectArea( "SX5" )
	dbSeek( XFILIAL("SX5")+"09FIS" )
	If At(UPPER("EXEC"),SX5->X5_DESCRI) > 0  // Se for ExecBlock
		cLote := &(SX5->X5_DESCRI)
	Else
		cLote := Substr(SX5->X5_DESCRI,1,4)
	Endif

	cMsgRegua := "Gerando Lancamentos Contabeis ..."
	dbSelectArea("SZ7")          
	
	cKey := "Z7_CC >= '"+cCCDe+"' .And. Z7_CC <= '"+cCCAte+"'"
	cIndex:= CriaTrab(NIL,.F.)
	IndRegua("SZ7",cIndex,"Z7_MAT",,cKey,"Selecionando Registros ...")
	
	ProcRegua(RecCount()) // Ajusta numero de elementos da regua
	dbSetOrder(1) //Lan�amento Padr�o
	dbGotop()
	
	ApMsgAlert("Fazendo a contabiliza��o")
	While !Eof() 
	
		IncProc(cMsgRegua)  //Incrementa a posicao da regua de relatorios
		
		If (!Empty(Z7_CONTASN)) .or. (SZ7->Z7_CC< cCCDe .or. SZ7->Z7_CC > cCCAte) .or. (SZ7->Z7_FILMAT< cFilDe .or. SZ7->Z7_FILMAT > cFilAte)
			dbSelectArea("SZ7")
			dbSkip()
			Loop
		EndIf
		   
		//Posiciona as Tabelas envolvidas
		SRA->(dbSeek(Xfilial("SRA")+SZ7->Z7_MAT))
		CTT->(dbSeek(Xfilial("CTT")+SZ7->Z7_CC))
		CTD->(dbSeek(Xfilial("CTD")+SZ7->Z7_SUBC))
		   
		If cPadrao <> SZ7->Z7_LPADRAO // Cada vez que muda a chave, fecha o lote   	
			If cPadrao<>"*" .and. nTotal>0
				//RodaProva(nHdlPrv,nTotal)                        // Rodape do arquivo CProva
				//cA100Incl(cArquivo,nHdlPrv,3,cLote,lMostLanc==1,lAgluLanc==1)  // Edita Lancamentos
			Endif     
			if cPadrao=='*'
				nHdlPrv:= HeadProva(cLote,"MTA901",Substr(cUsuario,7,15),@cArquivo)
			Endif
			cPadrao:= SZ7->Z7_LPADRAO
			lCabecalho:=.T.
		EndIf
	
		dbSelectArea("SZ7")
		nTotal:=nTotal+DetProva(nHdlPrv,cPadrao,"MTA901",cLote) // Linha de Detalhe
		
		dbSelectArea("SZ7")
		RecLock("SZ7",.F.)
			Replace Z7_DTLANC  With dDatabase
			Replace Z7_CONTASN With 'S'
		MsUnLock("SZ7") 
		dbSkip()
		
	EndDo
	
	ApMsgAlert("Preparando a prova")
	
	If lCabecalho
		ApMsgAlert("Rodando a prova")
		RodaProva(nHdlPrv,nTotal)  // Rodape do arquivo CProva
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lMostLanc,lAgluLanc,"")  // Edita Lancamentos
	Endif

Return()