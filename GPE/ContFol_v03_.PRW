#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"  
#include "Ap5mail.ch"  

/*User Function GP090ALT

	Private cTitForm     := "Rateio de Horas" 
	Private oDl002
	Private oDlMont
	Private oFont1       := TFont():New("Arial Black",,024,,.T.,,,,,.F.,.F.)
	
	Private cVebHExt := SuperGetMv ( "CN_VEBHEXT" , .T. , Space(100))
	Private cFolMes  := SuperGetMv ( "MV_FOLMES" , .T. , Space(100))
//	cFolMes := "201208"
	
	Private aVerbas := {}
	Private aItens  := {}
	
	Private aSubHora := {}
	
	Private lLancErro := .F.

	dbSelectArea("SRC") 
	SRC->(dbSetOrder(1))
	SRC->(dbSeek(xFilial("SRC")+SRA->RA_MAT))	
		
	WHILE !(SRC->(EOF())) .AND. SRC->RC_FILIAL == xFilial("SRC") .AND. SRC->RC_MAT == SRA->RA_MAT
	
		if alltrim(SRC->RC_PD) $ alltrim(cVebHExt)
			AADD(aVerbas,{SRC->RC_PD,0,SRC->RC_HORAS})
		endif
		SRC->(dbSkip())
		
	Enddo
	
	if len(aVerbas) == 0
		Return
	endif
	
	if select("Q1") <> 0
		Q1->(dbCloseArea())
	endif 
		
	cQuery := " SELECT FIPCODIGO,FIPCUSTO,FIPEXTRAS,FIPPD, " 
	cQuery += " Convert(VARCHAR(10),FIPDATA,103) AS FIPDATA, "
	cQuery += " replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') AS INICIO, "
	cQuery += " replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') AS FIM, "
	cQuery += " DATEDIFF (hour, "
	cQuery += " Cast(replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime), "
	cQuery += " Cast(replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime)) AS HORAS "
	cQuery += " FROM FIPEPC "
	cQuery += " WHERE FIPANOMES = '"+alltrim(cFolMes)+"' "
	cQuery += "   AND CHAPA     = '"+alltrim(SRA->RA_MAT)+"' "
	cQuery += " ORDER BY 5,6 "
  
  	TCQUERY cQuery NEW ALIAS "Q1"
  	
	aItens := {}
		
	WHILE !(Q1->(EOF()))

		AADD(aItens,{Q1->FIPCUSTO,alltrim(Q1->FIPDATA),alltrim(Q1->INICIO),alltrim(Q1->FIM),Q1->HORAS,Q1->FIPPD,Q1->FIPCODIGO,{}})
		Q1->(dbSkip())
		
	Enddo
	
	if select("Q1") <> 0
		Q1->(dbCloseArea())
	endif 
		
	if len(aItens) == 0
		Aadd(aItens,{"","","","","","","",{}})
	endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Construção da tela -                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
	DEFINE MSDIALOG oDl002 TITLE cTitForm FROM 200,300 TO 700,1200 PIXEL
	
		@ 008,010 Say cTitForm Size 200,020 FONT oFont1 COLOR CLR_BLACK PIXEL OF oDl002
		DEFINE SBUTTON FROM 008,389 TYPE 1 ENABLE OF oDl002 ACTION( Sair(.T.) )
		DEFINE SBUTTON FROM 008,419 TYPE 2 ENABLE OF oDl002 ACTION( Sair(.F.) )
		@ 020, 000 SAY REPLICATE("_",200) SIZE 500, 010 OF oDl002 COLORS CLR_BLACK PIXEL
						
		@ 040,010 ListBox oItens Fields HEADER "FIPCUSTO","FIPDATA","INICIO","FIM","HORAS","Lancamento";
		          Size 280,200 Of oDl002 Pixel On DBLCLICK ( EditaItens() )
			
		@ 040,300 ListBox oVerbas Fields HEADER "Verba","Lancado","Total";
		          Size 140,200 Of oDl002 Pixel //On DBLCLICK ( Edita() )
		          
		oItens:SetArray(aItens)
		oItens:bLine 		:= {|| {;
			aItens[oItens:nAT,01],;
			aItens[oItens:nAT,02],;
			aItens[oItens:nAT,03],;
			aItens[oItens:nAT,04],;
			aItens[oItens:nAT,05],;
			aItens[oItens:nAT,06]}} 
			
		oVerbas:SetArray(aVerbas)
		oVerbas:bLine 		:= {|| {;
			aVerbas[oVerbas:nAT,01],;
			aVerbas[oVerbas:nAT,02],;
			aVerbas[oVerbas:nAT,03]}} 
			
		Valores()
				
	ACTIVATE MSDIALOG oDl002 CENTERED 
	
Return

Static Function EditaItens()

	if !("*" $ aItens[oItens:nAT,06])
		If oItens:ColPos == 6
			lEditCell( aItens, oItens, "@!", oItens:ColPos , "SRV" )
		EndIf
	endif
	
	if "*" $ aItens[oItens:nAT,06]
		fRaHora()
	endif
	
	Valores()
	
Return


Static Function fRaHora()

	Local bOkV := .F.

	aSubHora := {}
	
	for nT := 1 to len(aItens[oItens:nAT][8])
		if !empty(aItens[oItens:nAT][8][nT][1])
			aadd(aSubHora,aItens[oItens:nAT][8][nT])
		endif
	next 
	
	if len(aSubHora) == 0
		Aadd(aSubHora,{Space(5),Space(5),0,Space(3)})
	endif
	
	aItens[oItens:nAT][8] := {}
	aItens[oItens:nAT][6] := Space(3)

	DEFINE MSDIALOG oDlMont TITLE cTitForm FROM 200,300 TO 700,700 PIXEL
	
		@ 008,010 Say "Sub Dividir Hora" Size 200,020 FONT oFont1 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 020,000 Say replicate("_",500) Size 500,008 COLOR CLR_RED PIXEL OF oDlMont
		
		@ 040,010 Say "Projeto" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 040,075 MsGet oMsGet1 Var aItens[oItens:nAT,01] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont

		@ 060,010 Say "Data" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 060,075 MsGet oMsGet2 Var aItens[oItens:nAT,02] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@D 99/99/99" PIXEL OF oDlMont

		@ 080,010 Say "Inicio" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 080,075 MsGet oMsGet3 Var aItens[oItens:nAT,03] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont

		@ 100,010 Say "Fim" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 100,075 MsGet oMsGet4 Var aItens[oItens:nAT,04] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont

		@ 120,010 Say "Horas" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 120,075 MsGet oMsGet5 Var aItens[oItens:nAT,05] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont
		
		@ 140,010 ListBox oSubHora Fields HEADER "Inicio","Fim","Hora","Verba" Size 160,080 Of oDlMont Pixel On DBLCLICK ( fEDSubHoras() )
		
		@ 140, 180 BUTTON oButton1 PROMPT "+"      SIZE 009, 009 OF oDlMont PIXEL ACTION( Eval({|| Aadd(aSubHora,{Space(5),Space(5),0,Space(3)}) , fMontSubHoras() }) )
		@ 160, 180 BUTTON oButton1 PROMPT "-"      SIZE 009, 009 OF oDlMont PIXEL ACTION( Eval({|| aSubHora[oSubHora:nAT,01] := Nil , fMontSubHoras() }) )
			
		@ 220,00 Say replicate("_",500) Size 500,008 COLOR CLR_BLACK PIXEL OF oDlMont		
		DEFINE SBUTTON FROM 233,140 TYPE 1 ENABLE OF oDlMont ACTION( Eval({|| bOkV :=.T. , oDlMont:end() }) )
		DEFINE SBUTTON FROM 233,170 TYPE 2 ENABLE OF oDlMont ACTION( Eval({|| bOkV :=.F. , oDlMont:end() }) )
		
		fMontSubHoras()
			
	ACTIVATE MSDIALOG oDlMont CENTERED 
                     
	if bOkV
		nHot21 := 0

		for nI := 1 to len(aSubHora)
			if val(aSubHora[nI][1]) < val(aItens[oItens:nAT,03])
				MSGSTOP("A horas informadas estão erradas! (001)")
				return
			endif
			if val(aSubHora[nI][1]) > val(aItens[oItens:nAT,04])
				MSGSTOP("A horas informadas estão erradas! (001)")
				return
			endif
			if val(aSubHora[nI][2]) > val(aItens[oItens:nAT,04])
				MSGSTOP("A horas informadas estão erradas! (003)")
				return
			endif
			if val(aSubHora[nI][2]) < val(aItens[oItens:nAT,03])
				MSGSTOP("A horas informadas estão erradas! (004)")
				return
			endif
			if !empty(aSubHora[nI][1]) .and. !empty(aSubHora[nI][2]) .and. !empty(aSubHora[nI][3])
				nHot21 += aSubHora[nI][3]
			endif
		next
		
		IF nHot21 != aItens[oItens:nAT,05]
			MSGSTOP("A horas informadas estão erradas! (005)")
			return
		ENDIF
		aItens[oItens:nAT][8] := {}
		aItens[oItens:nAT][6] := "***"
		
		for nT := 1 to len(aSubHora)
			if !empty(aSubHora[nT][1]) .and. !empty(aSubHora[nT][2]) .and. !empty(aSubHora[nT][3])
				aadd(aItens[oItens:nAT][8],aSubHora[nT])
			endif
		next
	endif
	
Return

Static Function fMontSubHoras()

	aTemp21  := {}
	aTemp21  := aSubHora
	aSubHora := {}
	
	for nI := 1 to len(aTemp21)
		if aTemp21[nI][1] != nil
			aadd(aSubHora,aTemp21[nI])
		endif
	next

	if len(aSubHora) == 0
		Aadd(aSubHora,{Space(5),Space(5),0,Space(3)})
	endif
	
	oSubHora:SetArray(aSubHora)
	oSubHora:bLine 		:= {|| {;
		aSubHora[oSubHora:nAT,01],;
		aSubHora[oSubHora:nAT,02],;
		aSubHora[oSubHora:nAT,03],;
		aSubHora[oSubHora:nAT,04]}} 
		
	oSubHora:Refresh()
	
Return

Static Function fEDSubHoras()

	if  oSubHora:ColPos == 1 .or. oSubHora:ColPos == 2
		lEditCell( aSubHora, oSubHora, "@E 99:99", oSubHora:ColPos )
	endif
	
	if  oSubHora:ColPos == 4
		lEditCell( aSubHora, oSubHora, "@!", oSubHora:ColPos , "SRV" )
	endif
	
	for nI := 1 to len(aSubHora)
		aSubHora[nI,03] := 0
		if !empty(aSubHora[nI,01]) .and. !empty(aSubHora[nI,02])
			aSubHora[nI,03] := val(ELAPTIME(aSubHora[nI,01]+":00",aSubHora[nI,02]+":00"))
		endif
	next

Return


Static Function Valores()

	lLancErro := .F.

	for nI := 1 to len(aVerbas)
		aVerbas[nI,2] := 0
	next

	for nI := 1 to len(aItens)
		if empty(aItens[nI][6])
			Loop
		endif
		
		if "*" $ aItens[nI][6]
			for nT := 1 to len(aItens[nI][8])
				if !empty(aItens[nI][8][nT][4])
					nPos := Ascan(aVerbas,{|aAux| aAux[1] == aItens[nI][8][nT][4] })
					If nPos > 0
						aVerbas[nPos,2] := aVerbas[nPos,2] + aItens[nI][8][nT][3]
					else				
						MSGSTOP("Algum lancamento esta errado, a verba lancada não é de hora extra!")
						lLancErro := .T.
					Endif				
				endif
			next
		else
			nPos := Ascan(aVerbas,{|aAux| aAux[1] == aItens[nI][6] })
			If nPos > 0
				aVerbas[nPos,2] := aVerbas[nPos,2] + aItens[nI][5]
			else				
				MSGSTOP("Algum lancamento esta errado, a verba lancada não é de hora extra!")
				lLancErro := .T.
			Endif		
		endif
	next

	oVerbas:Refresh()	
	
	for nI := 1 to len(aVerbas)
		if aVerbas[nI,2] > aVerbas[nI,3]
			MSGSTOP("O valor vinculado é maior que o valor das horas!")
			lLancErro := .T.
			Return
		Endif
	next	

Return

Static Function Sair(lRet)

	if lRet
		if lLancErro
			MSGSTOP("O valor vinculado é diferente que o valor das horas!")
			Return
		endif
		for nI := 1 to len(aVerbas)
			if aVerbas[nI,2] != aVerbas[nI,3]
				MSGSTOP("O valor vinculado é diferente que o valor das horas!")
				lLancErro := .T.
				Return
			Endif
		next	
		TcSQLExec("UPDATE FIPEPC SET FIPEXTRAS = 'N', FIPPD = '' WHERE FIPANOMES = '"+alltrim(cFolMes)+"' AND CHAPA = '"+alltrim(SRA->RA_MAT)+"';")
		for nI := 1 to len(aItens)
	
			if !empty(aItens[nI][6])
				if empty(aItens[nI][8])
					TcSQLExec("UPDATE FIPEPC SET FIPEXTRAS = 'S', FIPPD = '"+aItens[nI][6]+"' WHERE FIPCODIGO = '"+cvaltochar(aItens[nI][7])+"';")
				else 
					if select("QTEMPFIP") <> 0
						QTEMPFIP->(dbCloseArea())
					endif 
						
					cQuery := " SELECT * ,
					cQuery += " Convert(VARCHAR(10),FIPDATA,112) AS FIPDATA2 FROM FIPEPC "
					cQuery += " WHERE FIPCODIGO = '"+cvaltochar(aItens[nI][7])+"' "
				  
				  	TCQUERY cQuery NEW ALIAS "QTEMPFIP"
				  	
					for ngt := 1 to len(aItens[nI][8])
						cInsert := "INSERT INTO FIPEPC "
						cInsert += "           ([CHAPA]"
						cInsert += "           ,[FIPCUSTO]"
						cInsert += "           ,[FIPDATA]"
						cInsert += "           ,[FIPCRONOGRAMA]"
						cInsert += "           ,[FIPATIVIDADES]"
						cInsert += "           ,[FIPDOCUMENTOS]"
						cInsert += "           ,[FIPHORAI]"
						cInsert += "           ,[FIPHORAF]"
						cInsert += "           ,[FIPHORAS]"
						cInsert += "           ,[FIPHRNORMAL]"
						cInsert += "           ,[FIPMINNORMAL]"
						cInsert += "           ,[FIPHREXTRA]"
						cInsert += "           ,[FIPHRCOMP]"
						cInsert += "           ,[FIPHRBANCO]"
						cInsert += "           ,[FIPANOMES]"
						cInsert += "           ,[FIPESCOPO]"
						cInsert += "           ,[FIPFATURAVEL]"
						cInsert += "           ,[FIPEXTRAS]"
						cInsert += "           ,[FIPSITUACAO]"
						cInsert += "           ,[FIPGERADO]"
						cInsert += "           ,[FIPREVISAO]"
						cInsert += "           ,[FIPANOMESDATA]"
						cInsert += "           ,[SETORFIPIMPORTADAS]"
						cInsert += "           ,[FIPEMPRESA]"
						cInsert += "           ,[FIPFILIAL]"
						cInsert += "           ,[FIPORIGEM]"
						cInsert += "           ,[FIPPD])"
						cInsert += "    VALUES"
						cInsert += "          ('"+QTEMPFIP->CHAPA+"'"//, varchar(6),>"
						cInsert += "           ,'"+QTEMPFIP->FIPCUSTO+"'"//, varchar(14),>"
						cInsert += "           ,'"+QTEMPFIP->FIPDATA2+"'"//, datetime,>     "
						cInsert += "           ,'"+QTEMPFIP->FIPCRONOGRAMA+"'"//, varchar(21),>"
						cInsert += "           ,'"+QTEMPFIP->FIPATIVIDADES+"'"//, varchar(10),>"
						cInsert += "           ,'"+QTEMPFIP->FIPDOCUMENTOS+"'"//, varchar(19),>"
						cInsert += "           ,replace( CAST('"+aItens[nI][8][ngt][1]+"' AS VarChar(5)) ,':','.')"//, numeric(8,2),>"
						cInsert += "           ,replace( CAST('"+aItens[nI][8][ngt][2]+"' AS VarChar(5)) ,':','.')"//, numeric(8,2),>"
						cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHORAS)+""//, numeric(8,2),>"
						cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRNORMAL)+""//, numeric(8,2),>"
						cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPMINNORMAL)+""//, numeric(18,0),>"
						cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHREXTRA)+""//, numeric(8,2),>"
						cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRCOMP)+""//, numeric(8,2),>"
						cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRBANCO)+""//, numeric(8,2),>"
						cInsert += "           ,'"+QTEMPFIP->FIPANOMES+"'"//, varchar(6),>"
						cInsert += "           ,'"+QTEMPFIP->FIPESCOPO+"'"//, varchar(1),>"
						cInsert += "           ,'"+QTEMPFIP->FIPFATURAVEL+"'"//, varchar(1),>"
						cInsert += "           ,'"+QTEMPFIP->FIPEXTRAS+"'"//, varchar(1),>"
					  	cInsert += "           ,'"+QTEMPFIP->FIPSITUACAO+"'"//, varchar(2),>"
						cInsert += "           ,'"+QTEMPFIP->FIPGERADO+"'"//, varchar(1),>"
						cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPREVISAO)+""//, int,>"
						cInsert += "           ,'"+QTEMPFIP->FIPANOMESDATA+"'"//, varchar(6),>"
						cInsert += "           ,'"+QTEMPFIP->SETORFIPIMPORTADAS+"'"//, char(10),>"
						cInsert += "           ,'"+QTEMPFIP->FIPEMPRESA+"'"//, varchar(2),>"
						cInsert += "           ,'"+QTEMPFIP->FIPFILIAL+"'"//, varchar(2),>"
						cInsert += "           ,'"+QTEMPFIP->FIPORIGEM+"'"//, varchar(10),>"
						cInsert += "           ,'"+aItens[nI][8][ngt][4]+"')"//, varchar(3),>)"
						
						TcSQLExec(cInsert)
					next
					
					if select("Q1") <> 0
						Q1->(dbCloseArea())
					endif 
					
					TcSQLExec("DELETE FROM FIPEPC WHERE FIPCODIGO = '"+cvaltochar(aItens[nI][7])+"'")
				endif		
			endif
		
		next
		oDl002:End()
		MSGINFO("Operação concluida.")
	else
		MSGSTOP("Voce cancelou o rateio de horas, as informações não foram gravadas."+chr(13)+chr(10)+"Edite as verbas novamente para refazer o processo!")
		oDl002:End()
	endif

Return




                          */


































User Function ContFol()       

//apmsgalert("teste")

	Private nLastKey := 0                                           
	Private cAnoMesFol  := GetMv("MV_FOLMES")
	Private cAnoMesAtu  := ""
	Private cPerg:="GERFIP"
	Private aPerg:={}
	
	Private cVebHExt := SuperGetMv ( "CN_VEBHEXT" , .T. , Space(100))
	
	if empty(cVebHExt)
		MSGSTOP("O parametro CN_VEBHEXT não esta preenchido!")
		Return(.F.)
	endif
	
	aVerbas  := StrTokArr(cVebHExt,";")
		
	Private cVbasSQL := ""
	for nI := 1 to len(aVerbas)
		if !empty(cVbasSQL)
			cVbasSQL += ","
		endif
		cVbasSQL += "'"+alltrim(aVerbas[nI])+"'"
	next
	cVbasSQL := "("+alltrim(cVbasSQL)+")"

	AADD(aPerg,{cPerg,"Competencia Ano Mes?"		 		,"C",06,0,"G","!Empty(MV_PAR01)","","","","","",""})
	AADD(aPerg,{cPerg,"Filial de  ?"				 		,"C",02,0,"G","","SM0","","","","",""})
	AADD(aPerg,{cPerg,"Filial Até ?"				 		,"C",02,0,"G","","SM0","","","","",""})
	AADD(aPerg,{cPerg,"C.Custo de ?"						,"C",14,0,"G","","CTT","","","","",""})
	AADD(aPerg,{cPerg,"C.Custo Ate?"				 		,"C",14,0,"G","","CTT","","","","",""})
	AADD(aPerg,{cPerg,"Gerar FIP Férias?"					,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"Gerar FIP Automática?"	   			,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"Processar Func Sem FIP?"	   			,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"Efetuar Rateio?"			   			,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"Gerar Contabilização?"				,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"Mostra Lançamentos Contábeis?" 		,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"Aglutina Lançamentos Contábeis?"		,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"e-Mail?"						   		,"C",50,0,"G","","","","","","",""})
	AADD(aPerg,{cPerg,"SubConta Férias"				 		,"C",5,0,"G","ExistCpo('CTT',MV_PAR14)","CTT","","","","",""})
	AADD(aPerg,{cPerg,"SubConta Afastamentos"				,"C",5,0,"G","ExistCpo('CTT',MV_PAR15)","CTT","","","","",""})
	AADD(aPerg,{cPerg,"Nro Horas p/Dia"			 			,"N",2,0,"G","","","","","","",""})
	AADD(aPerg,{cPerg,"Gera FIP para Func Sem FIP?"			,"N",01,0,"C","","","Sim","Não","","",""})
	AADD(aPerg,{cPerg,"Gera FIP para Recisao Complementar?"	,"N",01,0,"C","","","Sim","Não","","",""})
	
	Pergunte(cPerg,.T.)
	
	cMens:="Este programa tem como Objetivo gerar o rateio e contabilização da Folha de Pgto da Folha de Pgto"
	
	BatchProcess("Contabilização da Folha de Pgto",cMens,cPerg,{|| Processa({||ProcFol()},"Aguarde","Processando...")})

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
		Alert("A Data base do sistema deve ser compatível com o Ano e Mes Informado no parametro.")
		lOK:=.f.
	Endif
	
	
	If lGerFIPFerias
		IncProc("Aguarde gerando FIP para Funcionários de Férias e Afastados","Aguarde...")
		lOK:=GerFIPFer()
	Endif
	
	If lGerFIPAuto
		IncProc("Aguarde Gerando lançamentos de FIP Automática","Aguarde...")
		lOK:=GerFipAuto()
	Endif
	
	If lVerSemFip
		IncProc("Verificando Funcionários SEM FIP","Aguarde...")
		lOK:=VerSemFIP()   
	Endif
	
	If lRecComplem
		IncProc("Processando Fun. Recisão Complementar","Aguarde...")
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
		IncProc("Aguarde Contabilizando....","Aguarde...")
		ProcContab()
	endif
	
	if !lOK
		MSGSTOP('Ocorreram erros durante o processo e a contabilização não foi processada, consulte o e-mail enviado para mais detalhes.')
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
	                              
	//Gera Fip para as pessoas que não precisam digitar a FIP
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
	cMens+='		<TITLE>'+if(cEmpAnt='01','EPC-','TSA')+'-Lista de Funcionários Sem FIP </TITLE>'+cEol
	cMens+='	</HEAD>'+cEol
	cMens+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align="Left" colspan=3  bgColor="Silver" >'+cEol
	cMens+='<B> Segue abaixo a lista de Funcionários sem FIP.'
	cMens+='É necessário que todas as pendencias sejam solucionadas'
	cMens+='para a finalização do processo. </B><br>'+cEol
	cMens+=' Parametros: <br>'
	cMens+=' Ano Mes Referência:'+cAnoMes+'<br>'
	cMens+=' C.Custo de:'+cCCDe+' Ate '+cCCAte+'<br>'
	cMens+=' Filial de:'+cFilDe+' Até '+cFilAte+'<br>'
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td colspan=3 > </td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align=center colspan=3  bgColor="Silver">'+cEol
	cMens+='				<P>Lista de Funcionários sem digitação de FIP no período'+cEol
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td bgColor="Silver">Centro de Custo </td>'+cEol
	cMens+='			<td bgColor="Silver">Funcionário </td>'+cEol
	cMens+='			<td bgColor="Silver">Ocorrência  </td>'+cEol
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
			//Gera o Lançamento dos Funcionários Sem FIP na Data
			dDiaAtu:=dDiaAtu:=DataValida(dDataDe)
			dDiaFim:=dDataAte
			cMat:=QSFIP->(RA_MAT)
			cConta:="" 	
			//Busca a Conta de Funcionários Sem FIP
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
						//Executa a Procedure de Gravação dos Dados....
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
				cMens+='			<td> Não há conta 9...K no C.Custo ou </br> Funcionário sem Subconta padrão '+QSFIP->(RA_MAT+"-"+RA_NOME)+'</td>'+cEol
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
		cMens+='			<td align=center colspan=3 bgColor="Red">Existem Funcionários que não teve as suas FIPs GERADAS por não ter uma SubConta Padrão ou seu centro de custo não tem uma SUBCONTA 9...K.Não é possível efetuar o Rateio</td>'+cEol
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
	//Gera Fip para as pessoas Com Recisão Complementar
	
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
	cMens+='		<TITLE>'+if(cEmpAnt='01','EPC-','TSA')+'-Lista de Funcionários Com Recisão Complementar </TITLE>'+cEol
	cMens+='	</HEAD>'+cEol
	cMens+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align="Left" colspan=3  bgColor="Silver" >'+cEol
	cMens+='<B> Segue abaixo a lista de Funcionários Com Recisão Complementar.'
	cMens+='É necessário que todas as pendencias sejam solucionadas'
	cMens+='para a finalização do processo. </B><br>'+cEol
	cMens+=' Parametros: <br>'
	cMens+=' Ano Mes Referência:'+cAnoMes+'<br>'
	cMens+=' C.Custo de:'+cCCDe+' Ate '+cCCAte+'<br>'
	cMens+=' Filial de:'+cFilDe+' Até '+cFilAte+'<br>'
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td colspan=3 > </td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align=center colspan=3  bgColor="Silver">'+cEol
	cMens+='				<P>Funcionários'+cEol
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td bgColor="Silver">Centro de Custo </td>'+cEol
	cMens+='			<td bgColor="Silver">Funcionário </td>'+cEol
	cMens+='			<td bgColor="Silver">Ocorrência  </td>'+cEol
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
		//Gera o Lançamento da FIP
		if !Empty(QREC->(SUBCONTA))
			TCSPExec(xProcedures("IMPFIP"),QREC->(RZ_MAT),cData ,nHoraFip  ,cAnoMes   , QREC->(SUBCONTA) ,cTipoHr    ,cCodAtiv,    0      ,  0    ,cEmpAnt,cFilAnt,'S','S','RECCOMPL')
			cMens+='			<td>'+AllTrim(QREC->RA_CC)+"-"+AllTrim(QREC->SUBCONTA)+'</td>'+cEol
			cMens+='			<td>'+QREC->(RZ_MAT+"-"+RA_NOME)+'</td>'+cEol   
			cMens+='			<td> Fip Gerada Conta:'+AllTrim(QREC->SUBCONTA)+'</td>'+cEol
		Else
			cMens+='			<td> Não há conta 9...R(Recisão Complementar) no C.Custo '+QREC->(RZ_MAT+"-"+RA_NOME)+'</td>'+cEol
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
		cMens+='			<td align=center colspan=3 bgColor="Red">Existem Funcionários que não teve as suas FIPs GERADAS por não ter uma SubConta Padrão ou seu centro de custo não tem uma SUBCONTA 9...K.Não é possível efetuar o Rateio</td>'+cEol
		cMens+='		</tr>'+cEol	
	Endif
	cMens+='	</table>'+cEol
	
	cMens+='</html> '+cEol
	
	CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
	
	SEND MAIL FROM  cSendBy TO  cSendBy SUBJECT 'Rateio da FIP(Recisão Complementar)' BODY cMens 
	
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
	cMens+='		<TITLE>'+if(cEmpAnt='01','EPC-','TSA')+'-Erros de Digitação da FIP</TITLE>'+cEol
	cMens+='	</HEAD>'+cEol
	cMens+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align="Left" colspan=5  bgColor="Red" >'+cEol
	cMens+='<B> Segue abaixo a lista de FIPs Digitadas Erradas.</B><br>'+cEol
	cMens+=' Parametros: <br>'
	cMens+=' Ano Mes Referência:'+cAnoMes+'<br>'
	cMens+=' C.Custo de:'+cCCDe+' Ate '+cCCAte+'<br>'
	cMens+=' Filial de:'+cFilDe+' Até '+cFilAte+'<br>'
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td colspan=5 > </td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align=center colspan=5  bgColor="Red">'+cEol
	cMens+='				<P>Lista de Funcionários com digitação de FIP ERRADA'+cEol
	cMens+='			</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td bgColor="Silver">Funcionário </td>'+cEol
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
		               
	if select("QMAT") <> 0
		QMAT->(dbCloseArea())
	endif 
	
	cQueryMat:=" SELECT DISTINCT RZ_FILIAL,RZ_MAT "
	cQueryMat+=" FROM "+RetSqlName("SRZ")+" SRZ "
	cQueryMat+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON RA_MAT = RZ_MAT AND RA_FILIAL = RZ_FILIAL AND SRA.D_E_L_E_T_<>'*' "
	cQueryMat+=" WHERE RZ_CC     BETWEEN '"+cCCDe+"'  AND '"+cCCAte+"'"
	cQueryMat+="   AND RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"'"
	cQueryMat+="   AND SRZ.D_E_L_E_T_<>'*'"
	
	TCQUERY cQueryMat NEW ALIAS "QMAT"
	
	While !(QMAT->(EOF()))	
	
		for nI := 1 to len(aVerbas)
	
			if select("QHORAS") <> 0
				QHORAS->(dbCloseArea())
			endif 
			
			if select("QVERBA") <> 0
				QVERBA->(dbCloseArea())
			endif 
					
			cQuery := " 	SELECT "
			cQuery += " 	Round(SUM(DATEDIFF (minute, "
			cQuery += " 		Convert( SmallDateTime, replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':'), 108), "
			cQuery += " 		Convert( SmallDateTime, replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':'), 108)) "
			cQuery += "			) / 60.00, 2) "
			cQuery += "			AS FIPTOTAL "
			cQuery += " 	FROM FIPEPC "
			cQuery += " 	WHERE FIPANOMES = '"+cAnoMes+"' "
			cQuery += " 	  AND CHAPA     = '"+QMAT->RZ_MAT+"' "
			cQuery += " 	  AND (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F')) "
			cQuery += "       AND FIPPD = '"+aVerbas[nI]+"'"
			cQuery += " 	  AND FIPHORAI < FIPHORAF "
	
			TCQUERY cQuery NEW ALIAS "QHORAS"
	
			cQuery := " SELECT SUM(RZ_HRS) AS RZ_HRS FROM "+RetSqlName("SRZ")+" "
			cQuery += " INNER JOIN "+RetSqlName("SRV")+" ON RV_FILIAL = '"+xFIlial("SRV")+"' AND RV_COD = RZ_PD AND RV_LPADRAO != '' "
			cQuery += " WHERE RZ_MAT = '"+QMAT->RZ_MAT+"' "
			cQuery += "   AND RZ_PD = '"+aVerbas[nI]+"' "
			cQuery += "   AND "+RetSqlName("SRZ")+".D_E_L_E_T_ = '' "
			cQuery += "   AND "+RetSqlName("SRV")+".D_E_L_E_T_ = '' "
			
			TCQUERY cQuery NEW ALIAS "QVERBA"
			
			IF QHORAS->FIPTOTAL != QVERBA->RZ_HRS		
				cMens+='		<tr>'+cEol	
				cMens+='			<td> A matricula '+QMAT->RZ_MAT+' contém um lancamento de hora extra errado na verba ' + aVerbas[nI] + ' </td>'+cEol
				cMens+='		</tr>'+cEol   
		
				//MSGSTOP("A matricula "+QMAT->RZ_MAT+" contem um lancamento de hora extra errado na verba " + aVerbas[nI] + ".")
//				final()
				//Return(.F.)
				lRet := .F.
			ENDIF
			
			if select("QHORAS") <> 0
				QHORAS->(dbCloseArea())
			endif 
			
			if select("QVERBA") <> 0
				QVERBA->(dbCloseArea())
			endif 
	
		next	
	
	
		QMAT->(dbSkip())
		
	EndDo	

	if select("QMAT") <> 0
		QMAT->(dbCloseArea())
	endif 
	
	cMens+='	</table>'+cEol
	cMens+='</html> '+cEol
	
	nFile:=Fcreate("c:\SemFIP.html")
	Fwrite(nFile,cMens)
	Fclose(nFile)
	
	CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
	
	SEND MAIL FROM  cSendBy TO  cSendBy SUBJECT 'Processo Validação das Digitações da FIP' BODY cMens 
	
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
				//Executa a Procedure de Gravação dos Dados....
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
	
	//Gera Fip para as pessoas que não precisam digitar a FIP
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
				//Executa a Procedure de Gravação dos Dados....
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
	ProcRegua(RecCount())      
	
	if select("QMAT") <> 0
		QMAT->(dbCloseArea())
	endif 
	                     	
	cQueryMat:=" SELECT DISTINCT RZ_FILIAL,RZ_MAT "
	cQueryMat+=" FROM "+RetSqlName("SRZ")+" SRZ "
	cQueryMat+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON RA_MAT = RZ_MAT AND RA_FILIAL = RZ_FILIAL AND SRA.D_E_L_E_T_<>'*' "
	cQueryMat+=" WHERE RZ_CC     BETWEEN '"+cCCDe+"'  AND '"+cCCAte+"'"
	cQueryMat+="   AND RA_FILIAL BETWEEN '"+cFilde+"' AND '"+cFilAte+"'"
	cQueryMat+="   AND SRZ.D_E_L_E_T_<>'*'"     
	cQueryMat+=" ORDER BY RZ_FILIAL,RZ_MAT "

	                     
	TCQUERY cQueryMat NEW ALIAS "QMAT"

	While !(QMAT->(EOF()))
	
		IncProc("Efetuando Rateio.... Mat "+QMAT->RZ_MAT ,"Aguarde...")
	
		//Exclui os registros desta matricula para este Mes na tabela de Rateio
		TcSQLExec(" DELETE "+RetSqlName("SZ7")+" WHERE Z7_MAT='"+QMAT->RZ_MAT+"' AND (Z7_DTLANC='' OR Left(Z7_DTLANC,6)='"+cAnoMes+"')")
		
		if select("QHORAS") <> 0
			QHORAS->(dbCloseArea())
		endif 
				
		cQuery := " SELECT FIPCUSTO,FIPEXTRAS,FIPPD, "
		cQuery += " Round(SUM(DATEDIFF (minute, "
		cQuery += " Cast(replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime), "
		cQuery += " Cast(replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime))) / 60.00, 2)  AS FIPHORAS, "		
		cQuery += " ( "
		cQuery += " 	SELECT "
		cQuery += " 	Round(SUM(DATEDIFF (minute, "
		cQuery += " 	Cast(replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime), "
		cQuery += " 	Cast(replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime))) / 60.00, 2) "
		cQuery += " 	FROM FIPEPC "
		cQuery += " 	WHERE FIPANOMES = '"+cAnoMes+"' "
		cQuery += " 	  AND CHAPA     = '"+QMAT->RZ_MAT+"' "
		cQuery += " 	  AND (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F')) "
		cQuery += "       AND (FIPPD NOT IN "+cVbasSQL+" OR FIPPD = '') "
		cQuery += " 	  AND FIPHORAI < FIPHORAF  ) AS FIPTOTAL "
		cQuery += " FROM FIPEPC "
		cQuery += " WHERE CHAPA = '"+QMAT->RZ_MAT+"' "
		cQuery += "   AND FIPANOMES = '"+cAnoMes+"' "
		cQuery += "   AND (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F')) "
		cQuery += "   AND FIPHORAI < FIPHORAF  "
		cQuery += "   AND (FIPPD NOT IN "+cVbasSQL+" OR FIPPD = '' )"
		cQuery += " GROUP BY FIPCUSTO,FIPEXTRAS,FIPPD "

		TCQUERY cQuery NEW ALIAS "QHORAS"
		
		//AVISO("TESTE2",cQuery,{"Ok"},3)		
		//return

		
		if select("QVERBA") <> 0
			QVERBA->(dbCloseArea())
		endif 

		cQuery := " SELECT * FROM "+RetSqlName("SRZ")+" "
		cQuery += " INNER JOIN "+RetSqlName("SRV")+" ON RV_FILIAL = '"+xFIlial("SRV")+"' AND RV_COD = RZ_PD AND RV_LPADRAO != '' "
		cQuery += " WHERE RZ_MAT = '"+QMAT->RZ_MAT+"' "
		cQuery += "   AND RZ_PD NOT IN "+cVbasSQL+" "
		cQuery += "   AND "+RetSqlName("SRZ")+".D_E_L_E_T_ = '' "
		cQuery += "   AND "+RetSqlName("SRV")+".D_E_L_E_T_ = '' "
		
		TCQUERY cQuery NEW ALIAS "QVERBA"
		                           		
		While !(QVERBA->(EOF()))
		
			While !(QHORAS->(EOF()))			
			
				dbSelectArea("SZ7")
				RecLock("SZ7",.T.)
					Replace Z7_MAT     With QVERBA->RZ_MAT
					Replace Z7_FILMAT  With QVERBA->RZ_FILIAL
					Replace Z7_CC      With QVERBA->RZ_CC
					Replace Z7_PD      With QVERBA->RZ_PD
					Replace Z7_VALOR   WITH QVERBA->RZ_VAL
					Replace Z7_VLRAT   WITH (QHORAS->FIPHORAS/QHORAS->FIPTOTAL)*QVERBA->RZ_VAL
					Replace Z7_SUBC    WITH RIGHT(QHORAS->FIPCUSTO,5)
					Replace Z7_LPADRAO WITH QVERBA->RV_LPADRAO
				MsUnlock("SZ7")
		
				QHORAS->(dbSkip())
		
			EndDo					
			QVERBA->(dbSkip())
		
		EndDo			
		  
		/*
		if select("QVERBA") <> 0
			QVERBA->(dbCloseArea())
		endif 
		
		if select("QHORAS") <> 0
			QHORAS->(dbCloseArea())
		endif 
		
		FOR nI := 1 TO LEN(aVerbas)

			if select("QHORAS") <> 0
				QHORAS->(dbCloseArea())
			endif 
					
			cQuery := " SELECT FIPCUSTO,FIPEXTRAS,FIPPD, "
			cQuery += " Round(SUM(DATEDIFF (minute, "
			cQuery += " Cast(replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime), "
			cQuery += " Cast(replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime))) / 60.00, 2)  AS FIPHORAS, "		
			cQuery += " ( "
			cQuery += " 	SELECT "
			cQuery += " 	Round(SUM(DATEDIFF (minute, "
			cQuery += " 	Cast(replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime), "
			cQuery += " 	Cast(replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime))) / 60.00, 2) "
			cQuery += " 	FROM FIPEPC "
			cQuery += " 	WHERE FIPANOMES = '"+cAnoMes+"' "
			cQuery += " 	  AND CHAPA     = '"+QMAT->RZ_MAT+"' "
			cQuery += " 	  AND (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F')) "
			cQuery += "       AND FIPPD = '"+aVerbas[nI]+"'"
			cQuery += " 	  AND FIPHORAI < FIPHORAF  ) AS FIPTOTAL "
			cQuery += " FROM FIPEPC "
			cQuery += " WHERE CHAPA = '"+QMAT->RZ_MAT+"' "
			cQuery += "   AND FIPANOMES = '"+cAnoMes+"' "
			cQuery += "   AND (SUBSTRING(FIPCUSTO,10,1)<>'9' OR RIGHT(FIPCUSTO,1) NOT IN ('F')) "
			cQuery += "   AND FIPHORAI < FIPHORAF  "
			cQuery += "   AND FIPPD = '"+aVerbas[nI]+"' "
			cQuery += " GROUP BY FIPCUSTO,FIPEXTRAS,FIPPD "

			TCQUERY cQuery NEW ALIAS "QHORAS"
			
			
			if select("QVERBA") <> 0
				QVERBA->(dbCloseArea())
			endif 

			cQuery := " SELECT * FROM "+RetSqlName("SRZ")+" "
			cQuery += " INNER JOIN "+RetSqlName("SRV")+" ON RV_FILIAL = '"+xFIlial("SRV")+"' AND RV_COD = RZ_PD AND RV_LPADRAO != '' "
			cQuery += " WHERE RZ_MAT = '"+QMAT->RZ_MAT+"' "
			cQuery += "   AND RZ_PD = '"+aVerbas[nI]+"' "
			cQuery += "   AND "+RetSqlName("SRZ")+".D_E_L_E_T_ = '' "
			cQuery += "   AND "+RetSqlName("SRV")+".D_E_L_E_T_ = '' "
			
			TCQUERY cQuery NEW ALIAS "QVERBA"
			
			
			While !(QVERBA->(EOF()))
			
				While !(QHORAS->(EOF()))			
				
					dbSelectArea("SZ7")
					RecLock("SZ7",.T.)
						Replace Z7_MAT     With QVERBA->RZ_MAT
						Replace Z7_FILMAT  With QVERBA->RZ_FILIAL
						Replace Z7_CC      With QVERBA->RZ_CC
						Replace Z7_PD      With QVERBA->RZ_PD
						Replace Z7_VALOR   WITH QVERBA->RZ_VAL
						Replace Z7_VLRAT   WITH (QHORAS->FIPHORAS/QHORAS->FIPTOTAL)*QVERBA->RZ_VAL
						Replace Z7_SUBC    WITH RIGHT(QHORAS->FIPCUSTO,5)
						Replace Z7_LPADRAO WITH QVERBA->RV_LPADRAO
					MsUnlock("SZ7")
			
					QHORAS->(dbSkip())
			
				EndDo					
				QVERBA->(dbSkip())
			
			EndDo			

			if select("QVERBA") <> 0
				QVERBA->(dbCloseArea())
			endif 
			
			if select("QHORAS") <> 0
				QHORAS->(dbCloseArea())
			endif 
			
		NEXT
		*/
		
		QMAT->(dbSkip())
		
	EndDo	
	
	if select("QMAT") <> 0
		QMAT->(dbCloseArea())
	endif 
	
Return(.T.)


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ProcCProva
Static Function ProcContab()

	nTotal     := 0
	nHdlPrv    := 0
	cArquivo   := ""     // Arquivo CProva
	lCabecalho := .F.    // Flag se ja emitiu o cabecaho do CProva
	cPadrao    := "*"

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
	dbSetOrder(1) //Lançamento Padrão
	dbGotop()
	
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
	
	If lCabecalho
		RodaProva(nHdlPrv,nTotal)  // Rodape do arquivo CProva
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lMostLanc,lAgluLanc,"")  // Edita Lancamentos
	Endif

Return()