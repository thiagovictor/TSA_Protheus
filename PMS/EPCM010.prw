#Define EPCMSGERR "A integração com o Protheus PMS relatou alguns erros de";
+ " inclusão/alteração"
//#DEFINE CRLF CHr(10)+chr(13)
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EPCM010  ºAutor  ³Microsiga           º Data ³  20/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Integra apontamento de mao de obra                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EPCM010()
Local cHoraI := ""
Local cHoraF := ""
Local lValoriza := .F.

Private cPrg   := "EPC010"    	// Grupo de perguntas
Private cMsgEr	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria/Atualiza o grupo de perguntas no SX1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_ECriaSX1()

If (Pergunte(cPrg,.T.))
	cHoraI := Time()
	If mv_par09 == 1
		lValoriza := .T.
	EndIf
	Processa({|| u_E010Recu() },"Atualizando Recursos de Projetos...")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se deve carregar os apontamentos da tabela FIP³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1
		Processa({|| u_E010Apon() },"Atualizando Apontamentos de Recursos...")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄC^¿
	//³Verifica se deve valorizar os apontamentos do PMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄC^Ù
	If lValoriza
		Processa({|| u_E010Val() },"Valorizando os Apontamentos dos Recursos...")
	EndIf
	
	cHoraF := Time()
	Alert("Processo finalizado. Tempo: "+ ElapTime(cHoraI, cHoraF))
	If cMsgEr <> ""
		cMsgCab := "<html><head></head><body>"
		cMsgCab += "<font size=1 face=verdana>"
		cMsgCab := Replicate("*",80) + CRLF
		cMsgCab += "* EPC - ROTINA DE APONTAMENTO/VALORIZACAO DE MAO-DE-OBRA" + CRLF
		cMsgCab	+= "* DATA DE PROCESSAMENTO: " + DtoC(dDataBase) + CRLF
		cMsgCab	+= "* PARAMETROS DEFINIDOS PELO USUARIO" + CRLF
		cMsgCab	+= "* PROJETO DE/ATE: " + mv_par01 + " / " + mv_par02 + CRLF
		cMsgCab	+= "* TAREFA DE/ATE: " + mv_par03 + " / " + mv_par04 + CRLF
		cMsgCab	+= "* RECURSO DE/ATE: " + mv_par05 + " / " + mv_par06 + CRLF
		cMsgCab	+= "* DATA DE/ATE: " + DtoC(mv_par07) + " / " + DtoC(mv_par08) + CRLF
		cMsgCab	+= "* VALORIZA: " + IIF(mv_par09==1,"SIM","NAO") + CRLF
		cMsgCab	+= "* REVISA APONTAMENTOS: " + IIF(mv_par10==1,"SIM","NAO") + CRLF
		cMsgCab	+= "* ADICIONAL DE ENCARGO: " + Alltrim(Str(mv_par11)) + " %" + CRLF
		cMsgCab += Replicate("*",80) + CRLF
		cMsgCab	+= "* INICIO DO PROCESSAMENTO: " + cHoraI + CRLF
		cMsgCab	+= "* FIM DO PROCESSAMENTO: " + cHoraF + CRLF
		cMsgCab	+= "* TEMPO DECORRIDO: " + ElapTime(cHoraI, cHoraF) + CRLF
		cMsgCab += Replicate("*",80) + CRLF
		
		cMsgEr := cMsgCab + cMsgEr + "</body></html>"
		U_Epcmail("Protheus8: Log de Inconsistências da Rotina de Valorização", cMsgEr)
	EndIf
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ E010RECU ºAutor  ³Vanessa Ferraz      º Data ³  20/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Integra a tabela de recursos do Projeto - AE8 - com o     º±±
±±º          ³  sistema legado                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EPC                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function E010Recu()
Local cQuery 	:= ""
Local lInclui 	:= .F.
Local cChapa    := ""
Local aAreaAE8 	:= AE8->( GetArea() )
Local nCount	:= 0
Local cCrono	:= ""
Local nCusto	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL¿
//³Seleciona os recursos que fazem parte dos projetos presentes nos³
//³parametros selecionados.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLÙ
cCrono := u_EPCSRANG()

cQuery  :=  "SELECT DISTINCT "
cQuery 	+=	"A.ID, A.CHAPA, "
cQuery 	+=	"B.NOME, B.FUNCAO "
cQuery 	+=	"FROM FIPEPC A "
cQuery 	+=	" INNER JOIN PESSOAL B ON "
cQuery 	+=	"A.CHAPA = B.CHAPA "
cQuery	+=	"WHERE "
cQuery	+=	"A.FIPCRONOGRAMA IN (" + cCrono + ") AND "
//	cQuery  +=  "A.ID BETWEEN " + Str(val(mv_par05)) + " AND " + Str(val(mv_par06)) + " AND "
cQuery  +=  "A.CHAPA BETWEEN " + mv_par05 + " AND " + mv_par06 + " AND "
cQuery  +=  "A.FIPDATA BETWEEN '" + dtos(mv_par07) + "' AND '" + dtos(mv_par08) + "' "
cQuery  +=  "A.FIPEMPRESA = '"+SM0->M0_CODIGO+"' AND "
cQuery  +=  "ORDER BY "
cQuery  +=  "A.CHAPA "
cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBEXT", .F., .T.)

TRBEXT->( DbEval( {|| nCount++ } ) ) 	//conta os registros TRBEXT
ProcRegua(nCount)
TRBEXT->( DbGotop () )
AE8-> ( dbSetOrder(1) )				//AE8->AE8_FILIAL + AE8->AE8_RECURS
CursorWait()

If TRBEXT->( Eof() )
	cMsgEr += "* " + Time() + " - NAO FORAM ENCONTRADOS RECURSOS PARA OS PARAMETROS DEFINIDOS " + CRLF
EndIf
While !TRBEXT->( Eof() )
	
	IncProc(TRBEXT->NOME)
	cChapa := Alltrim( TRBEXT->CHAPA )
	
	lInclui := ! ( AE8->( dbSeek(xFilial("AE8") + cChapa ) ) )
	
	RecLock("AE8", lInclui)
	AE8->AE8_FILIAL		:= xFilial("AE8")
	AE8->AE8_RECURS		:= cChapa					//Fipepc->CHAPA
	AE8->AE8_DESCRI 	:= TRBEXT->NOME          	//Pessoal->NOME
	AE8->AE8_TIPO 		:= "2"
	AE8->AE8_ACUMUL 	:= "4"
	AE8->AE8_UMAX 		:= 100.00
	AE8->AE8_SUPALO 	:= "2"
	AE8->AE8_PRODUT 	:= TRBEXT->FUNCAO		  	//Pessoal->FUNCAO
	AE8->AE8_CALEND 	:= "001"
	AE8->AE8_TPREAL 	:= "2"
	AE8->AE8_VALOR 		:= 0.00
	AE8->AE8_CODFUN 	:= cChapa						//Fipepc->CHAPA
	AE8->AE8_ATIVO 		:= "1"
	AE8->( msUnLock() )
	
	TRBEXT->( dbSkip() )
EndDo

TRBEXT->( dbCloseArea() )
dbSelectArea("AE8")
RestArea(aAreaAE8)
CursorArrow()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ E010APON ºAutor  ³Vanessa Ferraz      º Data ³  20/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera/Valoriza o apontamento da mao-de-obra - AFU com base º±±
±±º          ³  nos apontamentos gerados no sistema legado                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EPC                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function E010Apon()
Local cQuery 	:= ""
Local lInclui	:= .F.
Local cChapa 		:= ""
Local aAreaAFU 	:= AFU->( GetArea() )
Local nCount	:= 0
Local cHoraI    := ""
Local cHoraF    := ""
Local cRevisa   := ""
Local cElap     := ""
Local cFil 		:= ""
Local cCtrlV	:= ""
Local cProjet	:= ""
Local cTarefa	:= ""
Local dData     := CtoD(Space(08))
Local cCrono	:= ""
Local cProj		:= ""
Local nCusto	:= 0.00
Local nPercAv   := GetMv("MV_PMSAVFI")

cCrono := u_EPCSRANG()

cQuery 	:=	"SELECT DISTINCT "
cQuery	+=	"A.ID, "
cQuery	+=	"A.FIPCRONOGRAMA, A.CHAPA, "
cQuery	+=	"Convert(VarChar(30), A.FIPDATA, 103) AS 'FIPDATA', "
cQuery	+=	"A.FIPHORAI, "
cQuery	+=	"A.FIPHORAF "
cQuery	+=	"FROM "
cQuery	+=	"FIPEPC A "
cQuery	+=	"WHERE "
cQuery	+=	"A.FIPCRONOGRAMA IN (" + cCrono + ") AND "
//	cQuery	+=	"A.ID BETWEEN " + Str(Val(mv_par05)) + " AND " + Str(Val(mv_par06)) + " And "
cQuery	+=	"A.CHAPA BETWEEN " + mv_par05 + " AND " + mv_par06 + " And "
cQuery	+=	"A.FIPDATA BETWEEN '" + DtoS( mv_par07 ) +"' AND '" + DtoS( mv_par08 ) + "' "
cQuery	+=	"ORDER BY "
cQuery	+=	"Convert(VarChar(30), A.FIPDATA, 103), "
cQuery	+=	"A.FIPHORAI, "
cQuery	+=	"A.FIPHORAF, "
cQuery	+=	"A.FIPCRONOGRAMA, "
cQuery	+=	"A.CHAPA, "
cQuery	+=	"A.ID "
cQuery  :=  ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBEXT", .F., .T.)

TRBEXT->( DbEval( {|| nCount++ } ) ) 			//conta os registros TRBEXT
ProcRegua(nCount)
TRBEXT->( DbGotop () )

//	AF9-> ( dbSetOrder(6) )
AF9->(dbOrderNickName("EPC001"))	// AF9_FILIAL + AF9_TARCLI

CursorWait()
If TRBEXT->( Eof() )
	cMsgEr += "* " + Time() + " - NAO FORAM ENCONTRADOS APONTAMENTOS PARA OS PARAMETROS DEFINIDOS " + CRLF
EndIf
While !TRBEXT->( Eof() )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza tab AFU - Apontamentos Recurs ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncProc("Tarefa: " + TRBEXT->FIPCRONOGRAMA + "/Data:"+TRBEXT->FIPDATA )
	If ( AF9->( dbSeek(xFilial("AF9") + TRBEXT->FIPCRONOGRAMA) ) )
		If PmsVldFase("AF8", AF9->AF9_PROJET, "86")
			
			cRevisa  := PmsAF8Ver(AF9->AF9_PROJET)
			
			cChapa 	 := Alltrim( TRBEXT->CHAPA )
			cChapa	 := cChapa + Space(15-Len(cChapa))
			cHoraI	 := u_TstHora( Alltrim( Str(TRBEXT->FIPHORAI) ) )
			cHoraF   := u_TstHora( Alltrim( Str(TRBEXT->FIPHORAF) ) )
			cElap    := Elaptime(cHoraI,cHoraF)   	//FIPHORAF - FIPHORAI
			
			dData	:= DtoS( CtoD( TRBEXT->FIPDATA )  )
			cCtrlV  := "1"
			cProjet := AF9->AF9_PROJET
			cTarefa := AF9->AF9_TAREFA
			
			//AFU->( dbSetOrder(1) )
			AFU->(dbordernickname("AFUHORA"))
			lInclui := !AFU->( dbSeek( xFilial("AFU")+cCtrlV+cProjet+cRevisa+cTarefa+cChapa+dData+Left(cHoraI,5) ))
			
			RecLock("AFU", lInclui)
			AFU->AFU_FILIAL		:= xFilial("AFU")
			AFU->AFU_TARCLI		:= TRBEXT->FIPCRONOGRAMA
			AFU->AFU_PROJET 	:= AF9->AF9_PROJET
			AFU->AFU_REVISA		:= cRevisa
			AFU->AFU_TAREFA 	:= AF9->AF9_TAREFA
			AFU->AFU_RECURS		:= TRBEXT->CHAPA							//TRBEXT->CHAPA
			AFU->AFU_DATA       := CtoD(TRBEXT->FIPDATA)
			AFU->AFU_HORAI  	:= Left(cHoraI,5)
			AFU->AFU_HORAF  	:= Left(cHoraF,5)
			AFU->AFU_HQUANT 	:= Val (SubStr(cElap,1,2)+"."+SubStr(cElap,4,2))	//FIPHORAF - FIPHORAI
			AFU->AFU_FLGFIP		:= "S"                      						//S - Verdadeiro
			AFU->AFU_CTRRVS     := "1"
			AFU->( msUnLock() )
			
			/*BEGINDOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³CRISLEI TOLEDO - 05/05/06                                            ³
			//³VERIFICA SE JÁ EXISTE CONFIRMACAO PARA ESTA TAREFA, SE NÃO,          ³
			//CRIA UMA CONFIRMACAO PARA INDICAR O AVANCO FISICO INICIAL DA TAREFA   ³
			// 	                    *******************                             ³
			//   CRIAR PARAMETRO MV_PMSAVFI - N -                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ENDDOC*/	        
            dbSelectArea("AFF")
			dbSetOrder(1) // AFF_FILIAL+AFF_PROJET+AFF_REVISA+AFF_TAREFA+DTOS(AFF_DATA)
			If !dbSeek(xFilial("AFF") + AF9->AF9_PROJET + cRevisa + AF9->AF9_TAREFA) //SE NAO ENCONTRAR REGISTRO
  			   RecLock("AFF", .T. )// GRAVA 	
			   AFF_FILIAL	:= xFilial("AFF")
			   AFF_PROJET	:= AF9->AF9_PROJET
			   AFF_REVISA	:= cRevisa
			   AFF_DATA	    := CtoD(TRBEXT->FIPDATA)  
			   AFF_HORAI    := Left(cHoraI,5)
			   AFF_HORAF    := Left(cHoraF,5)
			   AFF_TAREFA	:= AF9->AF9_TAREFA
			   AFF_USER	    := "000000"
			   AFF_CONFIRM	:= "2"
			   AFF_PERC	    := 	nPercAv
			   AFF_QUANT    := 	(nPercAv * AF9->AF9_QUANT)/100
			   AFF_FLGDOC	:= .T.
 			   MsUnLock()
 		    EndIf
 		    
 		    //Atualiza data inicio de Realização da tarefa:
 		    If RecLock("AF9",.F.)
 		       Replace AF9_DTATUI With CtoD(TRBEXT->FIPDATA)
 		       MsUnlock()
 		    Endif

		Else
			cMsgEr += "* " + Time() + " - A FASE DO PROJETO NAO PERMITE APONTAMENTOS " + CRLF
		Endif
	Else
		cMsgEr += "* " + Time() + " - NAO FORAM ENCONTRADOS TAREFAS PARA OS PARAMETROS DEFINIDOS " + CRLF
	EndIf
	
	TRBEXT->( dbSkip() )
	
EndDo

TRBEXT->( dbCloseArea() )
dbSelectArea("AFU")
RestArea(aAreaAFU)

if cMsgEr <> ""
	
EndIf
CursorArrow()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³E010VAL   ºAutor  ³Daniel Possebon     º Data ³  11/18/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valoriza os apontamentos do PMS - AFU                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function E010Val()
Local aAreaAFU := AFU->( GetArea() )
Local cQuery := ""
Local nCount := 0
Local nRec	 := 0
Local cRevisao	:= ""
Local nCusto	:= 0.00
Local nQtdHoras	:= 0

cQuery 	:= 	"SELECT "
cQuery	+=	"R_E_C_N_O_ REG, "
cQuery	+= 	"AFU.AFU_RECURS, "
cQuery	+=	"AFU.AFU_DATA "
cQuery	+=	"FROM "
cQuery	+=	RetSQLName("AFU") + " AFU "
cQuery	+=	"WHERE "
cQuery	+=	"AFU_PROJET BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND "
cQuery	+=	"AFU_TAREFA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
cQuery	+=	"AFU_RECURS BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
cQuery	+=	"AFU_DATA BETWEEN '" + DtoS(mv_par07) + "' AND '" + DtoS(mv_par08) + "' AND "
cQuery	+=	"AFU_CTRRVS = '1' AND "
cQuery	+=	"AFU_FILIAL = '" + xFilial("AFU") + "' AND "
cQuery	+=	"AFU.D_E_L_E_T_ <> '*' "
cQuery	+=	"ORDER BY "
cQuery	+=	"R_E_C_N_O_, "
cQuery	+= 	"AFU.AFU_RECURS, "
cQuery	+=	"AFU.AFU_DATA "
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAFU", .F., .T.)

TRBAFU->( DbEval( {|| nCount++ } ) ) 			//conta os registros TRBEXT
ProcRegua(nCount)
TRBAFU->( DbGotop () )

AFU->( dbSetOrder(1) ) 	//AFU_FILIAL+AFU_CTRRVS+AFU_PROJET+AFU_REVISA+AFU_TAREFA+AFU_RECURS+DTOS(AFU_DATA)
AE8->( dbSetOrder(1) )
CursorWait()
IF TRBAFU->( Eof() )
	cMsgEr += "* " + Time() + " - NAO FORAM ENCONTRADOS APONTAMENTOS P/ VALORIZACAO PARA OS PARAMETROS DEFINIDOS " + CRLF
EndIf
While !TRBAFU->( Eof() )
	nRec++
	IncProc( "Apontamento "+Alltrim(Str(nRec))+" / "+Alltrim(Str(nCount)) )
	
	AFU->( dbGoTo(TRBAFU->REG) )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obter o custo do recurso³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCusto := u_ECalCust( AFU->AFU_RECURS, DtoS(AFU->AFU_DATA) )
	nQtdHoras := u_ESomaHrR( AFU->AFU_RECURS, DtoS(AFU->AFU_DATA) )
	
	Begin Transaction
	RecLock("AFU", .F.)
	AFU->AFU_CUSTO1 := (( nCusto * (mv_par11/100+1) ) / nQtdHoras ) * AFU->AFU_HQUANT
	AFU->( MsUnlock() )
	AE8->( dbSeek( xFilial("AE8")+AFU->AFU_RECURS ) )
	If !AE8->( Eof() )
		RecLock("AE8", .F.)
		AE8->AE8_CUSFIX	:= (( nCusto * (mv_par11/100+1) ) / nQtdHoras )
		AE8->( MsUnlock() )
	EndIf
	End Transaction
	TRBAFU->( dbSkip() )
EndDo

TRBAFU->( dbCloseArea() )
dbSelectArea("AFU")
RestArea(aAreaAFU)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ECRIASX1³ Autor ³  Vanessa Ferraz        ³ Data ³ 20/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as Perguntas na SX1									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ECriaSX1()
Local aAreaSX1 	:= SX1->( GetArea() )
Local aPutSX1 	:= {}
Local nItem		:= 0
Local lInclui	:= .T.
//                                                   4      5    6   7   8          9                           10        11     12     13  14  15  16     17
AADD (aPutSX1, {cPrg, "01", "Projeto de          ?" , "mv_ch1", "C", 10, 0, "G", ""                             , "mv_par01", ""   , ""   , "", "", "", "AF8", "" })
AADD (aPutSX1, {cPrg, "02", "Projeto Até         ?" , "mv_ch2", "C", 10, 0, "G", ""                             , "mv_par02", ""   , ""   , "", "", "", "AF8", "" })
AADD (aPutSX1, {cPrg, "03", "Tarefa de           ?" , "mv_ch3", "C", 12, 0, "G", ""                             , "mv_par03", ""   , ""   , "", "", "", "AF9", "" })
AADD (aPutSX1, {cPrg, "04", "Tarefa Até          ?" , "mv_ch4", "C", 12, 0, "G", ""                             , "mv_par04", ""   , ""   , "", "", "", "AF9", "" })
AADD (aPutSX1, {cPrg, "05", "Recurso de          ?" , "mv_ch5", "C", 15, 0, "G", ""                             , "mv_par05", ""   , ""   , "", "", "", "AE8", "" })
AADD (aPutSX1, {cPrg, "06", "Recurso Até         ?" , "mv_ch6", "C", 15, 0, "G", ""                             , "mv_par06", ""   , ""   , "", "", "", "AE8", "" })
AADD (aPutSX1, {cPrg, "07", "Data de             ?" , "mv_ch7", "D", 07, 0, "G", ""                             , "mv_par07", ""   , ""   , "", "", "", ""   , "" })
AADD (aPutSX1, {cPrg, "08", "Data Até            ?" , "mv_ch8", "D", 07, 0, "G", "U_CompData(mv_par07,mv_par08)", "mv_par08", ""   , ""   , "", "", "", ""   , "" })
AADD (aPutSX1, {cPrg, "09", "Valoriza            ?" , "mv_ch9", "C", 01, 0, "C", ""                             , "mv_par09", "Sim", "Nao", "", "", "", ""   , "" })
AADD (aPutSX1, {cPrg, "10", "Revisa Apontamento  ?" , "mv_chA", "C", 01, 0, "C", ""                             , "mv_par10", "Sim", "Nao", "", "", "", ""   , "" })
AADD (aPutSX1, {cPrg, "11", "Adicional de Encargo?" , "mv_chB", "N", 03, 0, "G", ""                             , "mv_par11", ""   , ""   , "", "", "", ""   , "999" })

SX1->( dbSetOrder(1) )
For nItem := 1 To Len(aPutSX1)
	lInclui := !SX1->( dbSeek(aPutSX1[nItem][1]+aPutSX1[nItem][2] ) )
	
	RecLock("SX1", lInclui)
	SX1->X1_GRUPO	:= aPutSX1[nItem][01]
	SX1->X1_ORDEM	:= aPutSX1[nItem][02]
	SX1->X1_PERGUNT	:= aPutSX1[nItem][03]
	SX1->X1_VARIAVL	:= aPutSX1[nItem][04]
	SX1->X1_TIPO	:= aPutSX1[nItem][05]
	SX1->X1_TAMANHO	:= aPutSX1[nItem][06]
	SX1->X1_DECIMAL	:= aPutSX1[nItem][07]
	SX1->X1_PRESEL	:= 1
	SX1->X1_GSC		:= aPutSX1[nItem][08]
	SX1->X1_VALID	:= aPutSX1[nItem][09]
	SX1->X1_VAR01	:= aPutSX1[nItem][10]
	SX1->X1_DEF01	:= aPutSX1[nItem][11]
	SX1->X1_DEF02	:= aPutSX1[nItem][12]
	SX1->X1_DEF03	:= aPutSX1[nItem][13]
	SX1->X1_DEF04	:= aPutSX1[nItem][14]
	SX1->X1_DEF05	:= aPutSX1[nItem][15]
	SX1->X1_F3		:= aPutSX1[nItem][16]
	SX1->X1_PYME	:= "S"
	SX1->X1_PICTURE	:= aPutSX1[nItem][17]
	SX1->( msUnLock() )
	
Next nItem

RestArea(aAreaSX1)

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TstHor	³ Autor ³  Vanessa Ferraz       ³ Data ³ 20/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transforma vvel de formato numérico para caracter          ³±±
±±³            para ser usada na funcao Elaptime que utiliza  (HH:MM:SS)  ³±±
±±³Exemplos:   9 h      10 h     9.1 h    10.3 h    9.55 h    10.45 h     ³±±
±±³            09:00:00 10:00:00 09:10:00 10:30:00  09:55:00  10:45:00    ³±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function TstHora(cHour)
Local cHor := AllTrim(cHour)
Local cAux := 0
Local cTam := 0
Local cPto := "N"
Local cAnt := 0
Local cDep := 0

cTam := Len (cHour)

For cAux := 1 To cTam
	if Substr (cHour, cAux) = "."
		cPto := "S" 							//Se encontrou ponto esta vvel fica "S"
		cHor := strtran(cHor, ".", ":")         //Altera o "." para ":"
	Else
		If cPto = "S"
			cDep := cDep + 1                    //Conta quantos dígitos tem depois do ponto
		Else
			cAnt := cAnt + 1                    //Conta quantos dígitos tem antes do ponto
		EndIf
	EndIf
	
Next cAux

If cAnt = 1
	cHor := "0" + cHor              //Acrescenta dígito zero para hora com 1 caracter
EndIf
If cDep = 0
	cHor := cHor + ":00"            //Acrescenta zeros para  hora cheia
Else
	If cDep = 1
		cHor := cHor + "0"          //Acrescenta dígito zero para minuto com 1 caracter
	EndIf
EndIf

cHor := cHor + ":00"       			//Acrescenta segundos para a Funcao Elaptime

Return cHor


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ECALCUST ³ Autor ³  Vanessa Ferraz       ³ Data ³ 28/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula o custo do Recurso        						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function ECalCust(cChapa, cData)
Local cSel   := ""
Local nCusto := 0.0
Local cAno	:= SubStr(cData,1,4)
Local cMes	:= SubStr(cData,5,2)

cSel := "SELECT "
cSel += "SRV.RV_TIPOCOD, "
cSel += "FICH.VALOR "
cSel += "FROM "
cSel += "FUNCAO FUN, "
cSel += "PESSOAL PES, "
cSel += "FICHA FICH, "
cSeL += RetSQLName("SRV") + " SRV "
cSel += "WHERE "
cSel += "FICH.CHAPA = '" + cChapa + "' AND "
cSel += "FUN.CODIGO = PES.FUNCAO AND "
cSel += "FICH.CHAPA = PES.CHAPA AND "
cSel += "FICH.COD_VERBA = SRV.RV_COD AND "
cSel += "Month(FICH.COMPETENCIA) = " + cMes + " AND "
cSel += "Year(FICH.COMPETENCIA) = " + cAno + " AND "
cSel += "SRV.RV_CUSTEMP = '1' AND "
cSel += "SRV.RV_FILIAL = '" + xFilial("SRV") + "' AND "
cSel += "SRV.D_E_L_E_T_ <> '*' "
cSel := ChangeQuery(cSel)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cSel),"TRBVAL", .F., .T.)

If TRBVAL->( Eof() )
	cMsgEr += "* " + Time() + " - NAO FOI POSSIVEL REALIZAR O CALCULO DE CUSTO PARA O RECURSO " + cChapa + " NO MES/ANO " + cMes + "/" + cANO +". VERIFIQUE AS TABELAS DE VERBAS (SRV/FICHA)" + CRLF
EndIf
While !TRBVAL->( Eof() )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³RV_TIPOCOD:              ³
	//³    1 = somar ao custo   ³
	//³    2 = subtrair do custo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If TRBVAL->RV_TIPOCOD == '1'
		nCusto += TRBVAL->VALOR
	ElseIf TRBVAL->RV_TIPOCOD == '2'
		nCusto -= TRBVAL->VALOR
	EndIf
	
	TRBVAL->( dbSkip() )
EndDo

TRBVAL->( dbCloseArea() )
dbSelectArea("AFU")

Return(nCusto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ THorRec	³ Autor ³  Vanessa Ferraz       ³ Data ³ 28/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totaliza a quantidade de horas do recurso				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function ESomaHrR( cRecurso, cData )

Local aAreaAFU 	:= AFU->( GetArea() )
Local cAnoMes	:= SubStr(cData,1,4)+ SubStr(cData,5,2)
Local nQtdHoras	:= 0

AFU->( dbSetOrder(3) )	//AFU_FILIAL+AFU_CTRRVS+AFU_RECURS+DTOS(AFU_DATA)
AFU->( dbSeek( xFilial("AFU")+"1"+cRecurso+cData ) )
While !AFU->( Eof() ) .And. AFU->( AFU_FILIAL+AFU_CTRRVS+AFU_RECURS+SubStr(DtoS(AFU_DATA),1,6) ) == (xFilial("AFU")+"1"+cRecurso+cAnoMes)
	nQtdHoras := SomaHoras(nQtdHoras, ElapTime(AFU->AFU_HORAI+":00", AFU->AFU_HORAF+":00") )
	AFU->( dbSkip() )
EndDo

RestArea(aAreaAFU)

Return(nQtdHoras)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ EpcMail  ³ Autor ³ Cristian M. Pinheiro  ³ Data ³21/10/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Envia um e-mail                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ u_EpcMail                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTo   : Destinatário da mensagem                           ³±±
±±³          ³ cSbjct: Assunto da mensagem                                ³±±
±±³          ³ cBody : Corpo da mensagem                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Epcmail(cSbjct, cBody)
Local lOk
Local cErro
Local cServer	:= GetMv("MV_RELSERV")
Local cUser		:= GetMv("MV_RELACNT")
Local cPasswd	:= GetMv("MV_RELAPSW")
Local cFrom		:= GetMv("MV_RELFROM")
Local cTo		:= GetMv("MV_ADMEMAI")
Local lAuth		:= GetMv("MV_RELAUTH")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÑ„ÑÈÑ¿
//³Efetua a conexao ao servidor de envio de e-mail (SMTP)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÑÀÑÀÑÙ
//Verifica se existe necessidade de autenticação
If lAuth
	CONNECT SMTP SERVER cServer ACCOUNT cUser PASSWORD cPasswd RESULT lOK
Else
	CONNECT SMTP SERVER cServer ACCOUNT '' PASSWORD '' RESULT lOK
EndIf
//CONNECT SMTP SERVER '10.10.20.206' ACCOUNT 'teste' PASSWORD 'teste' RESULT lOK

//Se conexao estabelecida com o servidor
If lOk
	//Complementa corpo do e-mail.
	cBody := EPCMSGERR + ":" + CRLF + CRLF + cBody
	
	//Envia mensagem
	SEND MAIL FROM cFrom TO cTo SUBJECT cSbJct BODY cBody RESULT lOk
	If !lOk
		GET MAIL ERROR cErro
		MsgAlert(EPCMSGERR + ", porém ocorreu o seguinte erro ao tentar enviar";
		+ " um e-mail ao Adminstrador:"+ CRLF + cErro)
	EndIf
	DISCONNECT SMTP SERVER RESULT lOK
	If !lOk
		GET MAIL ERROR cErro
		MsgAlert(EPCMSGERR + ", porém ocorreu o seguinte erro ao tentar";
		+ " desconectar o Servidor de  e-mails:"+ CRLF + cErro)
	EndIf
Else
	//Se não foi possível conectar-se ao servidor, obtem o tipo do erro
	//e mostra uma mensagem de alerta.
	GET MAIL ERROR cErro
	MsgAlert(EPCMSGERR + ", porém ocorreu o seguinte erro ao tentar";
	+ " conectar o Servidor de  e-mails:"+ CRLF + cErro)
EndIf
Return lOk

User Function CompData(dDataIni, dDataFin)
Local lRet
lRet = dDataFin >= dDataIni
if !lRet
	MsgAlert("A data final deve ser maior ou igual a data inicial.")
Endif
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EPCSRANG  ºAutor  ³ Vanessa Iatski     º Data ³  17/11/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona o Range de Cronogramas que farao parte do IN     º±±
±±º          ³ nos select da tabela FIPEPC                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Precisa ter carregado o PERGUNTE antes                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EPCSRANG()
Local cQuery := ""
Local cCrono := ""
Local cProj	 := ""

//Selecionar os projetos que farao parte do select
cQuery	:= 	"Select distinct "
cQuery 	+=	"AF9.AF9_TARCLI, "
cQuery 	+=	"AF9.AF9_PROJET, "
cQuery 	+=	"AF9.AF9_REVISA, "
cQuery 	+=	"AF9.AF9_TAREFA "
cQuery 	+=	"FROM "
cQuery 	+=	RetSQLName("AF9") + " AF9 "
cQuery 	+=	"Where "
cQuery 	+=	"AF9.AF9_FILIAL = '" + xFilial("AF9") + "' AND "
cQuery 	+=	"AF9.AF9_PROJET BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND "
cQuery 	+=	"AF9.AF9_TAREFA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
cQuery 	+=	"AF9.D_E_L_E_T_ <> '*' "
cQuery 	+=	"ORDER BY "
cQuery 	+=	"AF9.AF9_PROJET, "
cQuery 	+=	"AF9.AF9_REVISA DESC, "
cQuery 	+=	"AF9.AF9_TAREFA "
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"CRONO", .F., .T.)

cCrono := ""
If !CRONO->( Eof() )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o parametro com os projetos que serao pesquisados em FIPEPC³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cProj  := ""
	While !CRONO->( Eof() )
		If cProj != CRONO->AF9_PROJET
			cCrono += "'" + Alltrim( CRONO->AF9_TARCLI ) + "',"
			cProj := CRONO->AF9_PROJET
		EndIf
		CRONO->( dbSkip() )
	EndDo
	cCrono := SubStr(cCrono, 1, Len(cCrono)-1 )
EndIf
CRONO->( dbCloseArea() )
dbSelectArea("AF9")
Return(cCrono)
