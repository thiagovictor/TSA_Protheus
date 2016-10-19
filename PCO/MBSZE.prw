//|=====================================================================|//
//| Desenvolvedor: Clemilson Pena -> chr13.net                          |//
//| Data: 10/2012                                                       |//
//| Descricao: Projeto - Ordem de Serviço Gelth              |//
//|=====================================================================|//

#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH"

User Function MBSZE()                         


	// ----------- Elementos contidos por dimensao ------------    
	// 1. Nome a aparecer no cabecalho                             
	// 2. Nome da Rotina associada                                 
	// 3. Usado pela rotina                                        
	// 4. Tipo de Transacao a ser efetuada                         
	//    1 - Pesquisa e Posiciona em um Banco de Dados            
	//    2 - Simplesmente Mostra os Campos                        
	//    3 - Inclui registros no Bancos de Dados                  
	//    4 - Altera o registro corrente                                                                           															
	//    5 - Remove o registro corrente do Banco de Dados         
	//    6 - Altera determinados campos sem incluir novos Regs    
	
   DBSelectArea("PROFALIAS")
   DbSetOrder(1)

	Private cAlias := "SZE"
	Private cCadastro := POSICIONE("SX2",1,cAlias,"X2_NOME")	      	 
/*	Private aRotina := {{ "Pesquisar" , "PesqBrw" , 0 , 1 },; 
						{ "Visualizar" , "AxVisual" , 0 , 2 },; 
						{ "Incluir" , "AxInclui" , 0 , 3 },; 
						{ "Alterar" , "AxAltera" , 0 , 4 },; 
						{ "Gerar Fluxo" , "U_MBSZEAlt" , 0 , 4 },;
						{ "Excluir" , "AxDeleta" , 0 , 5 }} */
						
	Private aRotina := {{"Pesquisar"	,"PesqBrw",0,1},; 
						{"Visualizar"	,"AxVisual",0,2},; 
						{"Incluir"		,"AxInclui('"+cAlias+"',,3,,,,'U_MBSZEVAL(3)')",0,3},;
						{"Alterar"		,"AxAltera('"+cAlias+"',,4,,,,,'U_MBSZEVAL(4)')",0,4},;
						{"Excluir"		,"AxDeleta",0,5}}
						
	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(1))
	(cAlias)->(DbGoTop())

	mBrowse(6,1,22,75,cAlias,,,,,,)
	
RETURN

User Function MBSZEVAL(nOpcX)

	Local lRet := .T.

	if nOpcX == 3
		dbSelectArea("SZE")
		SZE->(dbSetOrder(1))
		IF SZE->(dbSeek(xFilial("SZE")+M->ZE_REF+M->ZE_CC)) //ZE_FILIAL+ZE_REF+ZE_CC
			ShowHelpDlg("Atenção",{"Ja existe um registro com esse centro de custo e mes de referencia."},1,{"Altere o registro existente."}) 
			lRet := .F.
		ENDIF		
	endif
	
	dbSelectArea("CTT")
	CTT->(dbSetOrder(1))
	IF !(CTT->(dbSeek(xFilial("CTT")+M->ZE_CC))) //CTT_FILIAL+CTT_CUSTO	
		ShowHelpDlg("Atenção",{"Não existe esse centro de custo."},1,{""}) 
		lRet := .F.
	ENDIF	
			
/*	if nOpcX == 4
	endif*/
	

Return(lRet) /*

User Function MBSZEAlt()

	Processa({|| fGrava() })
	
Return

Static Function fGrava()

	Local cGRUPGER  := Alltrim(GetMV("CN_MBSZEALT"))
	Local lCria		:= .T.
	Local cDoc		:= ""
	Local cHist		:= "PREV RESTITUICAO ICMS/ST"
	Local nTamCPo	:= TamSx3("Z0_DOC")[1]-2
	Local cCount	:= StrZero(1,TamSx3("Z0_DOC")[1]-2)

	dbSelectArea("SZE")
	SZE->(dbSetOrder(1))
	SZE->(dbGoTop())
	                                   
	
	ProcRegua(SZE->(RecCount()))
	
	While !(SZE->(eof()))
	
		IncProc("")
		
		cDoc := "95"+cCount
		cCount := Soma1(cCount)
		cDatRef := SubStr(SZE->ZE_REF,1,2)+"/"+SubStr(SZE->ZE_REF,-2)
			
/*		_cAlias := "TMP_PESQ"
				
		if select(_cAlias) <> 0
			(_cAlias)->(dbCloseArea())
		endif 
		
		_cQuery := " SELECT * FROM "+RetSqlName("SZ0")
		_cQuery += " WHERE Z0_FILIAL = '"+SZE->ZE_FILIAL+"' " 
		_cQuery += " AND Z0_LINHA = 'ZZ' " 
		_cQuery += " AND Z0_CC = '"+SZE->ZE_CC +"' " 
		_cQuery += " AND Z0_DTREF = '"+cDatRef+"' "  
		_cQuery += " AND Z0_HIST = '"+cHist+"' " 
		_cQuery += " AND "+RetSqlName("SZ0")+".D_E_L_E_T_  = '' "
			
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(_cQuery)),_cAlias, .T., .F.)
		
		IF (_cAlias)->(eof())
			lCria := .T.
		ELSE
			lCria := .F.
		ENDIF
		
		if select(_cAlias) <> 0
			(_cAlias)->(dbCloseArea())
		endif * /
	
		RecLock('SZ0',lCria)//FLUXO ECONOMICO               
			Replace Z0_FILIAL  with SZE->ZE_FILIAL // Filial (C,  2,  0)* Campo não usado
			Replace Z0_LINHA   with "ZZ" // Linha Doc. (C,  2,  0)
			Replace Z0_HIST    with cHist // Historico (C, 40,  0)
			//Replace Z0_LOTE    with CAMPO04 // Lote (C,  6,  0)
			Replace Z0_DOC     with cDoc // Documento (C,  9,  0)
			Replace Z0_VALOR   with SZE->ZE_VALOR // Valor (N, 14,  2)
			//Replace Z0_CONTA   with CAMPO07 // Conta (C, 20,  0)
			Replace Z0_CC      with SZE->ZE_CC // Centro Custo (C, 20,  0)
			Replace Z0_DTREF   with cDatRef // Dt. Refer. (C,  5,  0)
			//Replace Z0_DATA    with CAMPO10 // Data (C,  5,  0)
			//Replace Z0_DTCAIXA with CAMPO11 // Dt. Caixa (C,  5,  0)
			//Replace Z0_DTVENC  with CAMPO12 // Vencto (C,  5,  0)
			//Replace Z0_CUSTO   with CAMPO13 // Custo (N, 14,  2)
			//Replace Z0_RECEITA with CAMPO14 // Receita (N, 14,  2)
			//Replace Z0_REVISAO with CAMPO15 // REVISAO (C,  6,  0)
			//Replace Z0_DTRF1   with CAMPO16 // DATA REF (C,  4,  0)
			Replace Z0_SITUACA with "ESTIMADO" // Situacao (C, 45,  0)
			//Replace Z0_CLASSIF with CAMPO18 // CLASSIF (C, 45,  0)
			//Replace Z0_GRUPO   with CAMPO19 // GRUPO_GERAL (C, 45,  0)
			//Replace Z0_DRE     with CAMPO20 // DRE (C, 15,  0)
			Replace Z0_DTLANC  with Date() // Dt Lancament (D,  8,  0)
			Replace Z0_GRUPGER with cGRUPGER // Grupo Gerenc (C,  6,  0)
			Replace Z0_VRPREV  with SZE->ZE_VALOR // Vlr Prev (N, 12,  2)
			Replace Z0_DESC01  with POSICIONE("CTT",1,xFilial("CTT")+SZE->ZE_CC,"CTT_DESC01") // Desc. CCusto (C, 40,  0)
			Replace Z0_FATOR   with POSICIONE("SZA",1,xFilial("SZA")+cGRUPGER,"ZA_FATOR") // Fator (N, 12,  2)
			Replace Z0_DESGER  with POSICIONE("SZA",1,xFilial("SZA")+cGRUPGER,"ZA_DESCRI") // Desc Grupo (C, 40,  0)
			//Replace Z0_FATORE  with CAMPO27 // Fator Receit (N, 12,  2)
			//Replace Z0_CLIENTE with CAMPO28 // Cliente (C, 40,  0)
			//Replace Z0_SITUAC  with CAMPO29 // Sit. Contrat (C,  1,  0)
			//Replace Z0_PROP    with CAMPO30 // Prop (C, 20,  0)
			//Replace Z0_OS      with CAMPO31 // os (C,  2,  0)
			//Replace Z0_SETOR   with CAMPO32 // Setor (C,  5,  0)
			//Replace Z0_DESCSET with CAMPO33 // Setor (C, 40,  0)
			Replace Z0_CODCONT with POSICIONE("CTT",1,xFilial("CTT")+SZE->ZE_CC,"CTT_CODCON") // CodCont (C,  5,  0)
			//Replace Z0_SUBCTA  with CAMPO35 // SubCta (C,  6,  0)
			//Replace Z0_SETORIG with CAMPO36 // Setor Origem (C,  5,  0)
			//Replace Z0_VEICULO with CAMPO37 // Veiculos (C,  1,  0)
			//Replace Z0_USERLGI with CAMPO38 // Log de Inclu (C, 17,  0)* Campo não usado
			//Replace Z0_USERLGA with CAMPO39 // Log de Alter (C, 17,  0)* Campo não usado
			//Replace Z0_DESC2   with CAMPO40 // Desc.Despesa (C, 40,  0)
			//Replace Z0_CODPLA  with CAMPO41 // Planilha (C, 15,  0)
		MsUnLock('SZ0') 
		
		SZE->(dbSkip())
	
	EndDo

Return*/