#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH" 
#include "TOTVS.CH"

#DEFINE CRLF ( chr(13)+chr(10) )

User Function MYPONR100(cAlias,nReg,nOpx)

	cCadastro := "Exportar banco de Horas"

	fParm(.F.)

	lOk := .F.
	aMensagem := {}
	AAdd( aMensagem, "Este programa ira criar um Ms-Excel com base nos parametros preenchidos." )
	AAdd( aMensagem, "- O Ms-Excel precisa estar instalado na maquina cliente." )
	AAdd( aMensagem, "- Este relatorio pode demorar alguns minutos para ser processado." )	
	AAdd( aMensagem, "- O relatorio é gerado em arquivo temporario, salve o arquivo em local apropriado logo" )	
	AAdd( aMensagem, "    apos a exibição dele em tela." )		
	
	aBotoes   := {}	
	AAdd( aBotoes, { 05, .T., { || fParm(.T.) } } )
	AAdd( aBotoes, { 01, .T., { || FechaBatch() , lOk := .T. } } )
	AAdd( aBotoes, { 02, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro , aMensagem, aBotoes )
	
	if lOk
		Processa({|| GerarArq() })
	endif

Return

Static Function fParm(lExibe)

	Local aArea := GetArea()
	
	cPerg := PadR("MYPONR100", Len(SX1->X1_GRUPO))
		
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If !DbSeek(cPerg)
	   //PutSX1( cGrupo, cOrdem, cPergunt      ,cPerSpa, cPerEng, cVar,     cTipo, nTam, nDec, nPresel, cGSC, cValid,cF3, cGrpSxg, cPyme  , cVar01   ,cDef01, cDefSpa1, cDefEng1, cCnt01, cDef02, cDefSpa2, cDefEng2, cDef03,    cDefSpa3, cDefEng3,  cDef04,    cDefSpa4, cDefEng4, cDef05,     cDefSpa5, cDefEng5, aHelpPor,                                     aHelpEng, aHelpSpa, cHelp*/ )
	   //                                                                                                                                                                                                                                                                                                                               1234567890123456789012345678901234567890   1234567890123456789012345678901234567890    1234567890123456789012345678901234567890
	    PutSX1( cPerg,  "01",   "Matricula de" ,  "",      "",      "mv_ch1", "C",   06,   00,   2,       "G",  ""  , "SRA",  "",      "S",   "mv_par01", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" ) 
	    PutSX1( cPerg,  "02",   "Matricula ate",  "",      "",      "mv_ch2", "C",   06,   00,   2,       "G",  ""  , "SRA",  "",      "S",   "mv_par02", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" ) 
	    PutSX1( cPerg,  "03",   "Projeto de"   ,  "",      "",      "mv_ch3", "C",   14,   00,   2,       "G",  ""  , "CTT",  "",      "S",   "mv_par03", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" )
	    PutSX1( cPerg,  "04",   "Projeto ate"  ,  "",      "",      "mv_ch4", "C",   14,   00,   2,       "G",  ""  , "CTT",  "",      "S",   "mv_par04", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" )
	    PutSX1( cPerg,  "05",   "Periodo de"   ,  "",      "",      "mv_ch5", "D",   08,   00,   2,       "G",  ""  , ""   ,  "",      "S",   "mv_par05", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" )
	    PutSX1( cPerg,  "06",   "Periodo Ate"  ,  "",      "",      "mv_ch6", "D",   08,   00,   2,       "G",  ""  , ""   ,  "",      "S",   "mv_par06", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" ) 
	    PutSX1( cPerg,  "07",   "Evento de"    ,  "",      "",      "mv_ch7", "C",   03,   00,   2,       "G",  ""  , "SP9",  "",      "S",   "mv_par07", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" ) 
	    PutSX1( cPerg,  "08",   "Evento ate"   ,  "",      "",      "mv_ch8", "C",   03,   00,   2,       "G",  ""  , "SP9",  "",      "S",   "mv_par08", "", "",       "",       "",     "",  "",       "",       "",        "",       "",        "",        "",       "",       "",         "",       "",       {"", ""}, {""},     {""},     "" )
	EndIf
			
	Pergunte(cPerg,lExibe)
			
Return

Static Function GerarArq()

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet 	:= cCadastro
	Local cTable 		:= cCadastro
	Local cDirTmp 		:= GetTempPath()
	
	Local aCampos       := {}
	Local _cQuery
	Local _cAlias
	Local nCntLin       := 0
	
	U_Pn200CalMp()
	
	ProcRegua(0)
	
	oFwMsEx := FWMsExcel():New()
	
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )	
	  
/*	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SPI"))
	While !SX3->(eof()) .and. SX3->X3_ARQUIVO == "SPI"
		if X3USO(SX3->X3_USADO) .and. SX3->X3_CONTEXT != "V" .and. SX3->X3_TIPO != "M"
			aadd(aCampos,{ Upper( AllTrim( SX3->X3_CAMPO ) ) , SX3->X3_TIPO , SX3->X3_PICTURE })
			//cWorkSheet,cTable,cColumn,,nAlign(1-Left,2-Center,3-Right),nFormat(1-General,2-Number,3-Monetário,4-DateTime),lTotal
			oFwMsEx:AddColumn( cWorkSheet, cTable ,SX3->( AllTrim( X3Titulo() ) ) , 1 , iif(SX3->X3_TIPO$"ND",iif(SX3->X3_TIPO=="N",2,4),1) , .F. )
		endif
		SX3->(dbSkip())
	Enddo  */
	
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Matricula"                ,1,1,.F.)//PI_MAT 
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Nome"                     ,1,1,.F.)//PI_MAT
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Conta"                    ,1,1,.F.)//PI_CONTA
	//oFwMsEx:AddColumn(cWorkSheet,cTable,"Subconta contrato"        ,1,1,.F.)//PI_SUBCONT
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Codigo do Evento"         ,1,1,.F.)//PI_PD
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Descricao do Evento"      ,1,1,.F.)//P9_DESC
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Tipo do Evento "/*+CRLF+"("+PonRetOpcBox(18)+")" */          ,1,1,.F.)//P9_TIPOCOD
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Horas"         ,3,2,.F.)//PI_QUANT	
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Horas Valorizadas"        ,3,2,.F.)//PI_QUANTV	 
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Horas Para calculo"        ,3,2,.T.)//PI_QUANTV	
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Valor das horas"        ,3,2,.T.)//
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Data da Marcacao"         ,2,4,.F.)//PI_DATA
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Centro Custo"             ,1,1,.F.)//PI_CC
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Descricao do Centro Custo",1,1,.F.)//PI_DESCRI 
	oFwMsEx:AddColumn(cWorkSheet,cTable,"Obs"                     ,1,1,.F.)//PI_DESCRI
	
	_cAlias := "TMP_PESQ"
			
	if select(_cAlias) <> 0
		(_cAlias)->(dbCloseArea())
	endif 
	
	_cQuery := " SELECT *,CONVERT( VARCHAR(8000) ,CONVERT( BINARY(8000) , PI_OBS) ) AS OBS FROM "+RetSqlName("SPI") + CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SRA")+" ON RA_FILIAL  = '"+xFilial("SRA")+"' AND PI_MAT = RA_MAT " + CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("CTT")+" ON CTT_FILIAL = '"+xFilial("CTT")+"' AND PI_CC = CTT_CUSTO " + CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SP9")+" ON P9_FILIAL  = '"+xFilial("SP9")+"' AND PI_PD = P9_CODIGO " + CRLF
//	_cQuery += " WHERE PI_FILIAL = '"+xFilial("SPI")+"' " + CRLF
	_cQuery += " WHERE "+RetSqlName("SPI")+".D_E_L_E_T_  = '' " + CRLF
	if !empty(mv_par01)
		_cQuery += " AND PI_MAT >= '"+mv_par01+"' " + CRLF
	endif
	if !empty(mv_par02)
		_cQuery += " AND PI_MAT <= '"+mv_par02+"' " + CRLF
	endif
	
	if !empty(mv_par03)
		_cQuery += " AND PI_CC >= '"+mv_par03+"' " + CRLF
	endif
	if !empty(mv_par04)
		_cQuery += " AND PI_CC <= '"+mv_par04+"' " + CRLF
	endif
	
	if !empty(mv_par05)
		_cQuery += " AND PI_DATA >= '"+dtos(mv_par05)+"' " + CRLF
	endif
	if !empty(mv_par06)
		_cQuery += " AND PI_DATA <= '"+dtos(mv_par06)+"' " + CRLF
	endif
	
	if !empty(mv_par07)
		_cQuery += " AND PI_PD >= '"+mv_par07+"' " + CRLF
	endif
	if !empty(mv_par08)
		_cQuery += " AND PI_PD <= '"+mv_par08+"' " + CRLF
	endif
	
	_cQuery += " AND ISNULL("+RetSqlName("SRA")+".D_E_L_E_T_,'') = '' " + CRLF
	_cQuery += " AND ISNULL("+RetSqlName("CTT")+".D_E_L_E_T_,'') = '' " + CRLF
	_cQuery += " AND ISNULL("+RetSqlName("SP9")+".D_E_L_E_T_,'') = '' " + CRLF
	_cQuery += " ORDER BY " + SqlOrder( SPI->( IndexKey(2) ) ) + CRLF
	
	//u_impt2(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(_cQuery)),_cAlias, .T., .F.)
	
	While !((_cAlias)->(eof()))
		  
		nCntLin += 1
/*		aLinha := {}
		for nY := 1 To Len(aCampos)
			if aCampos[nY][2] == "D"
				xCampo := stod((_cAlias)->&(aCampos[nY][1]))
//			elseif aCampos[nY][2] == "N"
//				xCampo := Transform((_cAlias)->&(aCampos[nY][1]),aCampos[nY][3])
			else
				xCampo := (_cAlias)->&(aCampos[nY][1])
			endif
			aadd(aLinha,xCampo)
		Next
		
		oFwMsEx:AddRow( cWorkSheet , cTable , aLinha ) */
		
		nQut := (_cAlias)->PI_QUANTMP
		
		nVal := nQut*((_cAlias)->RA_SALARIO/(_cAlias)->RA_HRSMES)
		nVal := iif((_cAlias)->P9_TIPOCOD$"13",nVal,nVal*(-1))
		
		aLinha := {}
		aadd(aLinha,(_cAlias)->PI_MAT) 
		aadd(aLinha,(_cAlias)->RA_NOME)
		aadd(aLinha,(_cAlias)->PI_CONTA)
		//aadd(aLinha,(_cAlias)->PI_SUBCONT)
		aadd(aLinha,(_cAlias)->PI_PD)
		aadd(aLinha,(_cAlias)->P9_DESC)
		aadd(aLinha,(_cAlias)->P9_TIPOCOD)
		aadd(aLinha,(_cAlias)->PI_QUANT)
		aadd(aLinha,iif((_cAlias)->P9_TIPOCOD$"13",(_cAlias)->PI_QUANTV,(_cAlias)->PI_QUANTV*(-1)))
		aadd(aLinha,iif((_cAlias)->P9_TIPOCOD$"13",(_cAlias)->PI_QUANTMP,(_cAlias)->PI_QUANTMP*(-1)))		
		aadd(aLinha,nVal)				
		aadd(aLinha,stod((_cAlias)->PI_DATA))
		aadd(aLinha,(_cAlias)->PI_CC)
		aadd(aLinha,(_cAlias)->CTT_DESC01)
		aadd(aLinha,Left(Alltrim((_cAlias)->OBS),200))
		oFwMsEx:AddRow( cWorkSheet , cTable , aLinha )
			
		(_cAlias)->(dbSkip())
	EndDo

	if select(_cAlias) <> 0
		(_cAlias)->(dbCloseArea())
	endif 
		
	if nCntLin == 0
		MsgStop("Nenhum registro encontrado.")
		Return
	endif     
	
	oFwMsEx:Activate()
	
	cArq := CriaTrab( NIL, .F. ) + ".xml"
	LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )
	
	If __CopyFile( cArq, cDirTmp + cArq ) .and. file( cDirTmp + cArq )
		If !ApOleClient( 'MsExcel' )
			MsgAlert("O excel não foi encontrado. Arquivo " + cArq + " gerado em " + cDirTmp + ".", "MsExcel não encontrado" )
		Else
			MsgInfo("Relatorio geredo com sucesso em: "+cDirTmp + cArq )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cArq )
			oExcelApp:SetVisible(.T.)
		EndIf
	Else
		MsgStop( "Arquivo não copiado para temporário do usuário." )
	Endif
	
Return