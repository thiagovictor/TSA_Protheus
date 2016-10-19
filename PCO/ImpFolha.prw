#include "rwmake.ch" 
#Include "TopConn.ch"                                         

#define FILIAL 	01
#define	ATIVO	02
#define	REF		03
#define	DATAPG	04
#define XCO		05
#define	CLRVLR	06
#define	VLR		07
#define	HIST	08
#define	XOPER	09
#define	TIPO	10
#define	CC		11
#define	PROCES	12
#define	CHAVE	13
#define	ITEM	14
#define	SEQ		15
#define CUSER	16
#define CODPLA	17

User Function ImpFolha 

	CriaSx1("IMPFOL")
	
	Pergunte("IMPFOL", .T.)           
	
	if Empty(mv_par01)
		MsgStop(OemtoAnsi('O parametro de referencia não pode ser vazio'))
	else
		Processa ( {|| PrcImpF(mv_par01) }, "Aguarde...", "Processando a Importacao",.F.)
	endif
Return

Static Functio PrcImpF(mesRef)
	aArea := GetArea() 
	
	cVebHExt := SuperGetMv ( "CN_VEBHEXT" , .T. , Space(100))       
	cMesR := mesRef                                                                                          
	cMatr := ''          
		
	aLanc := {}                                                           
	
	ProcRegua(0)
	IncProc("Realizando Leitura da SRD")  
	ProcessMessage()
	       	
//	cQry := " select top 100 * from " + RetSqlName("SRD") + " where RD_DATARQ = '" + cMesR + "' and RD_MAT < '999990' ORDER BY RD_MAT " // testes
	cQry := " select * from " + RetSqlName("SRD") + " where RD_DATARQ = '" + cMesR + "' and RD_MAT < '999990' ORDER BY RD_MAT "

	bQuery  := {|| If(Select("QRY2") > 0, QRY2->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"QRY2",.F.,.T.), dbSelectArea("QRY2"), QRY2->(dbGoTop()) }
	Eval(bQuery)                           		
	
	if !QRY2->(Eof())
		LimpaAKD(cMesR)
	endif

	while !QRY2->(Eof())
	
		if cMatr != QRY2->RD_MAT
			cMatr := QRY2->RD_MAT	      
			IncProc("Processando " + cMatr )  
			ProcessMessage()
			
			// Adicionar o total horas FIPEPC para matricula, e por cada centro de custo (SUBCTA) associado
			aCcNormais := HorasFip(cMatr, cMesR, .F.)
			aCcExtras  := HorasFip(cMatr, cMesR, .T.)
			
			nTotNormal := TotalHoras(aCcNormais)
			nTotExtras := TotalHoras(aCcExtras)
			nVal := 0
		endif
	
	    // Testa se o tipo de verba está incluido nos parametros de horas extras
		// Caso esteja Faz rateio pelas horas extras
	 	// Do contrario faz pela horas normais
	    if QRY2->RD_PD $ cVebHExt        
	    	
	    	if Len(aCcExtras) > 0
	    		nVal := QRY2->RD_VALOR
	    		nSld := QRY2->RD_VALOR

	    		for n := 1 to Len(aCcExtras)                                            
	    			If !CriaLanc(aCcExtras[n], nTotExtras, nVal, @nSld, n == Len(aCcExtras), @aLanc)
	    				Return
	    			endif
	    		next                                     
	    	endif
        else                                       
        	if Len(aCcNormais) > 0
	    		nVal := QRY2->RD_VALOR
	    		nSld := QRY2->RD_VALOR

		    	for n := 1 to Len(aCcNormais)            
		    		if !CriaLanc(aCcNormais[n], nTotNormal, nVal, @nSld, n == Len(aCcNormais), @aLanc)
		    			Return    
		    		endif
		    	next        	                           
		    endif
        endif
          
        QRY2->(DbSkip())
	end do             
	
	QRY2->(DbCloseArea())	                     
	                
	ProcRegua(Len(aLanc))
	IncProc("Inserindo informações no PCO ")  
	ProcessMessage()

	cQry := " select (convert(int, isnull(max(AKD_LOTE), 0 )) + 1) NLOTE from " + RetSqlName("AKD") 

	bQuery  := {|| If(Select("QRY") > 0, QRY->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"QRY",.F.,.T.), dbSelectArea("QRY"), QRY->(dbGoTop()) }
	Eval(bQuery)                           		
	
	if !QRY->(Eof())
		nNumLote := QRY->NLOTE
	else 
		nNumLote := 1
	endif
	
	// Lança na AKD diretamente os lançamentos 
	for nAx := 1 to Len(aLanc)
		IncProc("PCO -  " + aLanc[nAx][XCO] + " - " + str(aLanc[nAx][VLR]))  
		ProcessMessage()      
		cId := str(nAx % 100)
		nInc := NoRound(nAx / 100, 0)
	
		RecLock("AKD", .T.) 
			Replace AKD_FILIAL 	with aLanc[nAx][FILIAL]	,;
					AKD_STATUS 	with aLanc[nAx][ATIVO]	,;
					AKD_LOTE 	with strzero(nNumLote + nInc, 10)	,;
					AKD_ID 		with ALLTRIM(cId)		,;
					AKD_DATA 	with aLanc[nAx][DATAPG]	,;
					AKD_CO	 	with aLanc[nAx][XCO]	,;
					AKD_CLASSE 	with aLanc[nAx][CLRVLR]	,;
					AKD_OPER 	with aLanc[nAx][XOPER]	,;
					AKD_TIPO 	with '1'				,; // Credito
					AKD_TPSALD 	with aLanc[nAx][TIPO]	,;
					AKD_HIST 	with aLanc[nAx][HIST]	,;
					AKD_PROCES 	with aLanc[nAx][PROCES]	,;
					AKD_CHAVE 	with aLanc[nAx][CHAVE]	,;
					AKD_ITEM 	with aLanc[nAx][ITEM]	,;
					AKD_SEQ 	with aLanc[nAx][SEQ]	,;
					AKD_USER 	with __CUSERID			,;
					AKD_VALOR1 	with aLanc[nAx][VLR]	,;
					AKD_CODPLA 	with aLanc[nAx][CODPLA]	,;
					AKD_CC 		with aLanc[nAx][CC]		,;
					AKD_FILORI 	with aLanc[nAx][FILIAL]
			
		MsUnlock("SRD")
	Next
	   	
	RestArea(aArea)
Return                         
                        
// Busca as horas na tabela FIPPC para gerar os rateios
Static Function HorasFip(cMatr, cMesR, lExtras)
    aRateio := {}    
    // Array { CentroCusto, Valor }      
	cQry := " select (Cast((FIPHORAF - FIPHORAI) as int) * 60 + (((FIPHORAF - FIPHORAI) % 1) *100)) / 60 TOTALHORAS, FIPHORAI, FIPHORAF, FIPHORAS, FIPEXTRAS, SUBSTRING(FIPCUSTO, 10, 5) FIPCUSTO "
	cQry += " from FIPEPC where FIPANOMES = '" + cMesR + "' and CHAPA = '" + cMatr + "'  AND FIPEMPRESA = '"+SM0->M0_CODIGO+"'"
	
	if lExtras
		cQry += " and FIPEXTRAS = 'S' "
	else
		cQry += " and FIPEXTRAS <> 'S' "
	endif
	
	bQuery  := {|| If(Select("QRY") > 0, QRY->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"QRY",.F.,.T.), dbSelectArea("QRY"), QRY->(dbGoTop()) }
	Eval(bQuery)
	
	while !QRY->(Eof())
	    n := aScan(aRateio, {|x| AllTrim(x[1]) == Alltrim(QRY->FIPCUSTO) } )

		if n > 0
			aRateio[n][2] += QRY->TOTALHORAS
		else           
			cCc := POSICIONE('SZ2',3,xFilial('SZ2')+QRY->FIPCUSTO, 'Z2_SETOR')
			aAdd( aRateio, { QRY->FIPCUSTO, QRY->TOTALHORAS, cCc})
		endif
          
        QRY->(DbSkip())
	end do             
	
	QRY->(DbCloseArea())
return aRateio
                         
Static Function TotalHoras(aCc)                                      
	nTot := 0
	For nAx := 1 to Len (aCc)
		nTot += aCc[nAx][2]
	Next
Return nTot

Static Function LimpaAKD( cMesR )         
	cQry := " Delete from " + RetSqlName("AKD") 
	cQry += " where AKD_PROCES = '000085' and SUBSTRING(AKD_CHAVE, 1, 3) = 'SRD' and SUBSTRING(AKD_CHAVE, 12,6) = '" + cMesR + "'" 
	nRs := TcSqlExec(cQry)
Return
                                                       
// Cria um lançamento espelho a posição atual somente alterando o centro de custo pelo fator                                                                                       
Static Function CriaLanc(aCc, nTotal, nVal, nSld, lUltimo, aLanc)
                                                          
	cSetor := aCc[1]
	nFator := aCc[2] / nTotal
	nValor := nVal * nFator
	// Atualiza o saldo restante
	nSld   -= nValor
	
	cXco  := POSICIONE("SRV",1,XFILIAL("SRV")+QRY2->RD_PD,"RV_XCO")                             
	cHist := "GPE"+ " - "+ QRY2->RD_MAT + " " + POSICIONE("SRV",1,XFILIAL("SRV")+QRY2->RD_PD,"RV_DESC")
    cXOper:= POSICIONE("SRV",1,XFILIAL("SRV")+QRY2->RD_PD,"RV_XOPER")
            
    // para testes
    //	aAdd(aLanc, { QRY2->RD_FILIAL, "1", QRY2->RD_DATARQ, stod(QRY2->RD_DATPGT), cXco, "000001", if(lUltimo, nSld, nValor),;
	//	 cHist, cXOper, "RE", cSetor, "000085", "SRD"+QRY2->RD_FILIAL+QRY2->RD_MAT+QRY2->RD_DATARQ+QRY2->RD_PD+QRY2->RD_SEMANA+QRY2->RD_SEQ+QRY2->RD_CC,;
	//	 "01", "01", __cUserID, "000000000000001";
	//	 })       
	// -----------
    
    if Empty(cXco)
    	MSGSTOP('O valor do campo Conta Orcamentaria para a verba ' + QRY2->RD_PD + ' nao esta cadastrado. Nao e possivel continuar')
    	Return .F.
    	//Return .T. // testes
    endif

    if Empty(cXOper)
    	MSGSTOP('O valor do campo Operacao/Grupo Gerencial para a verba ' + QRY2->RD_PD + ' nao esta cadastrado. Nao e possivel continuar')
    	Return .F.
    	//Return .T.  // testes
    endif
                                                                  
	aAdd(aLanc, { QRY2->RD_FILIAL, "1", QRY2->RD_DATARQ, stod(QRY2->RD_DATPGT), cXco, "000001", if(lUltimo, nSld, nValor),;
		 cHist, cXOper, "RE", cSetor, "000085", "SRD"+QRY2->RD_FILIAL+QRY2->RD_MAT+QRY2->RD_DATARQ+QRY2->RD_PD+QRY2->RD_SEMANA+QRY2->RD_SEQ+cSetor,;
		 "01", "01", __cUserID, "000000000000001";
		 }) 
Return .T.

Static Function CriaSX1(cPerg)
	
	putSx1(cPerg, '01', 'Mes Ref.?'					, '', '', 'mv_ch1', 'C', TAMSX3("RD_DATARQ")[1]	, 0, 0, 'G', '', 	, '', '', 'mv_par01', ,,,,,,,,,,,,,,,,{'Mes de Referencia para Reprocessamento'})
//	putSx1(cPerg, '02', 'Gerente de Negocios Ate?'	, '', '', 'mv_ch2', 'C', TAMSX3("A3_COD")[1]	, 0, 0, 'G', '', 'SA3'	, '', '', 'mv_par02', ,,,,,,,,,,,,,,,,{'GN Final para pesquisa'})

Return
