/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEPCM040   บAutor  ณARNALDO PETRAZZINI  บ Data ณ  17/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ IMPORTACAO DE CONFIRMACOES                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO EPC                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ          ALTERACOES REALIZADAS DESDE A CRIACAO                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      ณ Programador  ช Descricao das Alteracoes                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ24/10/06  ณ Crislei      ช Busca o projeto atraves do codigo do Contra-บฑฑ
ฑฑบ          ณ              ช to do Controle de Documentos para concatenarบฑฑ
ฑฑบ          ณ              ช to do Controle de Documentos para concatenarบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

#INCLUDE "AP5MAIL.CH"
#Include "Protheus.ch"

User Function EPCM040()
	Local cDoc 	   := ""
	Local aSay	   := {}
	Local aButton  := {}
	Local aPerg    := {}
	Local cTitulo  := 'Gera็ใo de Confirma็ใo e Apontamento Fisico'
	Local cDesc1   := 'Esta Rotina busca as informa็๕es do sistema de Controle de Documentos Tecnicos.'
	Local cDesc2   := 'buscando o percentual de realiza็ใo de cada tarefa.'
	Local cPerg	   := 'EPCCON'
	Local cDir	   := GetMv("EX_DIRLOG")	
	Local cDirForm := GetMv("EX_DIRFORM")	
	Local aAreaFF  := AFF->(GetArea())
	Local i
	//Variaveis que recebem os dados dos bdf's
	Local cFormula := ""                                     
	Local dOpera 	:= ""  
	Local nMltA1	:= 0
	Local cContr 	:= SPACE(05)
	Local cNumOs 	:= SPACE(02)
	Local cNumProj  := SPACE(10)
	Local cForm  	:= ""  
	Local nFl   	:= 0
	Local nAVCLI 	:= 0  
	Local cHoraI	:= Time()
	Local cHoraF	:= ""
	Local nSoma		:= 0
	Local nDiv		:= 0
	Local cContrRev  := "" 
	Local cTarefa	:= ""
	Local cTarDOC	:= Space(21)
	//Envio do e-mail
	Local cFile		:= ""
	Local lOk
	Local cErro
	Local cServer	:= GetMv("MV_RELSERV")
	Local cUser		:= GetMv("MV_RELACNT") 
	Local cPasswd	:= GetMv("MV_RELAPSW")
	Local cFrom		:= GetMv("MV_RELFROM")
	Local cTo		:= GetMv("MV_ADMEMAI")
	Local lAuth		:= GetMv("MV_RELAUTH")
	Local cErrF		:= "" // erro no formato
	Local cErrT		:= "" // erro na tarefa
	Local cErrP     := "" // erro no projeto
    Local lCanc		:= .F.
	Local lErroEPC	:= .F.
	
CHKFILE("AFF") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parmetros                        ณ
//ณ mv_par01               Projeto de:                          ณ
//ณ mv_par02               Projeteo Ate:                        ณ
//ณ mv_par03               Tarefa de:                           ณ
//ณ mv_par04               Tarefa Ate:                          ณ
//ณ mv_par05               Recurso de:                          ณ
//ณ mv_par06               Recurso Ate:                         ณ
//ณ mv_par07               Data de:                             ณ
//ณ mv_par08               Data Ate:                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(aPerg,{cPerg,"Contrato de:       ?","C",12,0,"G","","AF8CON","","","","",""})
AADD(aPerg,{cPerg,"Contrato Ate:      ?","C",12,0,"G","","AF8CON","","","","",""})
AADD(aPerg,{cPerg,"Tarefa de:         ?","C",12,0,"G","","AF9EPC","","","","",""})
AADD(aPerg,{cPerg,"Tarefa Ate:        ?","C",12,0,"G","","AF9EPC","","","","",""})
AADD(aPerg,{cPerg,"Recurso de:        ?","C",06,0,"G","","AE8","","","","",""})
AADD(aPerg,{cPerg,"Recurso Ate:       ?","C",06,0,"G","","AE8","","","","",""})
AADD(aPerg,{cPerg,"Data de:           ?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Data Ate:          ?","D",08,0,"G","","","","","","",""})



Pergunte( cPerg, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao janela do Pergunte , FormBatch()ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aSay, cDesc1 ) // Texto explicativo na janela FormBatch.
aAdd( aSay, cDesc2 ) // Texto explicativo na janela FormBatch.
aAdd( aButton, {  5, .T., {|| Pergunte( cPerg, .T.)   }} )// Executa o pergunte
aAdd( aButton, {  1, .T., {|| nOpc := 1, FechaBatch() }} ) // Botao 0k
aAdd( aButton, {  2, .T., {|| FechaBatch(), lCanc := .T. }} )// Botao fecha

FormBatch( cTitulo, aSay, aButton )
// Parametros
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMV_PAR01 = Parametro que define o projeto inicial da selecao ณ
//ณMV_PAR02 = Parametro que define o projeto final da selecao   ณ
//ณMV_PAR03 = Parametro que define a tarefa inicial da selecao  ณ
//ณMV_PAR04 = Parametro que define a tarefa final da selecao    ณ
//ณMV_PAR05 = Parametro que define o recurso inicial da selecao ณ
//ณMV_PAR06 = Parametro que define o recurso final da selecao   ณ
//ณMV_PAR07 = Parametro que define a data inicial da selecao    ณ
//ณMV_PAR08 = Parametro que define a data final da selecao      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
// FORCA A CONVERCAO DE LETRAS MINUSCULAS 
// PARA MAIUSCULAS DOS PARAMETROS.
MV_PAR01 := Upper(MV_PAR01)
MV_PAR02 := Upper(MV_PAR02)
MV_PAR03 := Upper(MV_PAR03)
MV_PAR04 := Upper(MV_PAR04)
MV_PAR05 := Upper(MV_PAR05)
MV_PAR06 := Upper(MV_PAR06)


Do 	Case
	Case Empty(MV_PAR02)  	
		MsgAlert("Parametro : Projeto At้ - Nใo informado!!","ATENวยO")
		Return(.F.)
	Case Empty(MV_PAR04)  	
		MsgAlert("Parametro : Tarefa Final - Nใo informado!!","ATENวยO")
		Return(.F.)
	Case Empty(MV_PAR06)  	
		MsgAlert("Parametro : Recurso Ate - Nใo informado!!","ATENวยO")
		Return(.F.)
	Case Empty(MV_PAR07)  	
		MsgAlert("Parametro : Data De - Nใo informado!!","ATENวยO")
		Return(.F.)
	Case Empty(MV_PAR08)  	
		MsgAlert("Parametro : Data Ate - Nใo informado!!","ATENวยO")
		Return(.F.)
EndCase			

If lCanc
	Return(.F.)
EndIf
	                                                                             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre os arquivos .dbf e cria os indices temporarios.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Abre o arquivo DOC.dbf
dbUseArea(.T.,"DBFCDX" ,cDir+"\doc.dbf","DOC" , .T., .F.)
   	cArquivo := CriaTrab("DOC",.F.)
	IndRegua( "DOC",cArquivo,"D_COD_CTO",,,OemToAnsi("Criando indices..."))   
// Abre o arquivo REV.dbf
dbUseArea(.T.,"DBFCDX" ,cDir+"\rev.dbf","REV" , .T., .F.)     
	cArquivo :=  CriaTrab("REV",.F.)
	IndRegua( "REV",cArquivo,"D_COD_CTO",,,OemToAnsi("Criando indices.."))     
// Abre o arquivo FORMATO.dbf
dbUseArea(.T.,"DBFCDX" ,cDirForm+"\formato.dbf","FORM" , .T., .F.)
 	cArquivo :=  CriaTrab("FORM",.F.)
	IndRegua( "FORM",cArquivo,"T_COD_FORM",,,OemToAnsi("Criando indices.."))   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChama a funcao de Integracao apontamento ณ
//ณde mao de obra                           ณ
//	U_EPCRecu() -- CRISLEI - NAO HA NECESSIDADE DE CONSULTAR A FIP PARA ESTA INTEGRACAO
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		                                   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz a pesquisa com base nos parametros dentro dos .dbfณ
//ณ Busca o projeto dentro do arquivo dbf				  ณ	
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DBSelectArea("DOC")

If Alltrim(mv_par01) == ""
	DOC->( dbGoTop() )
Else
	DOC->( dbSeek(alltrim(MV_PAR01) ) )
EndIf

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona na tabela de PROJETOS atraves do PARAMETRO informado para    ณ
//ณbuscar o codigo do Projeto para localizar a tarefa                     ณ
//ณ CRISLEI - 25/10/06                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/

dbSelectArea("AF8")
dbSetOrder(8) //FILIAL+COD. CONTRATO+OS  
If dbSeek(xFilial("AF8")+AllTrim(MV_PAR01))
   cNumProj := AF8->AF8_PROJET
//   cTarDoc  := AllTrim(cNumProj) + cTarDoc
EndIf	

If !DOC->( Eof() )	
	DBSelectArea("AF9") 
	AF9->( DBSetOrder(1) ) 
	If  AF9->( dbSeek(xFilial("AF9") + alltrim(cNumProj)))//primeiro registro da filial
			While DOC->( !EOF() )                              .AND. ;
			      Alltrim(DOC->D_COD_CTO) >= Alltrim(MV_PAR01) .AND. ;
                  Alltrim(DOC->D_COD_CTO) <= Alltrim(MV_PAR02) 
		 							                		 							 
				// salva os valores dos campos nas variaveis
				cContr	:= DOC->D_COD_CTO // numero do contrato corrente  --- SO O NUMERO DO CONTRATO D_PROJETO = NUMERO DA OS - D_CON_PRO = CONTRATO+OS
				cNumOs  := DOC->D_PROJETO // Numero da OS (Crislei 24/10/06)
				cTarDOC	:= DOC->D_CR_ITEM // tarefa compativel
				cForm	:= DOC->D_COD_FORM // formato corrente       
				nFl		:= DOC->D_NO_FL 
//				nAVCLI	:= DOC->D_AV_CLI  - ESTE CAMPO ษ DIGITADO PELO USUARIO - NAO CONFIAVEL (CRISLEI)
				nAVCLI	:= DOC->D_AV_EPC 
				
			
				/*BEGINDOC
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPosiciona na tabela de PROJETOS atraves do campo Numero do Contrato    ณ
				//ณe concatena o numero do projeto ao codigo da tarefa, a fim de localizarณ
				//ณa tarefa referente ao Documento atraves do campo AF9_TARCLI            ณ
				//ณ CRISLEI - 24/10/06                                                    ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				ENDDOC*/
			    dbSelectArea("AF8")
 				dbSetOrder(8) //FILIAL+COD. CONTRATO+OS  
				If dbSeek(xFilial("AF8")+cContr+cNumOs)
				   cNumProj := AF8->AF8_PROJET
				   cTarDoc  := AllTrim(cNumProj) + cTarDoc
				EndIf			
				
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAdiciona espaco em branco p/ compatibilizar com o campo DOC->D_COD_CTO ณ
			//ณque possui tamanho de 9 caracteres                                     ณ
			//	cContr 	+= Space(Len(AF9->AF9_PROJET)-Len(DOC->D_COD_CTO))                                                    
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	      			                                            
			
			//	busca a tarefa com base no projeto do arq. dbf				 			 							        
	   			DBSelectArea("AF9")
 				AF9->( DBSetOrder(6) ) //FILIAL+PROJET+TARCLI
				If	AF9->(dbSeek(xFilial("AF9")+ cTarDOC))// tarefa do cliente
			
					While AF9->(!EOF()) .and.	AF9->AF9_TAREFA >= alltrim(MV_PAR03) .AND.;
												AF9->AF9_TAREFA <= alltrim(MV_PAR04)  .AND.;
												AllTrim(AF9->AF9_PROJET) == AllTrim(cNumProj)
//												AllTrim(AF9->AF9_PROJET) == AllTrim(cContr)

						cTarefa := AF9->AF9_TAREFA // recebe tarefa corrente
						
						DBSelectArea("FORM")
						If FORM->(dbSeek(cForm)) // procura o formato da DOC dentro da Formato 
		            		   nMltA1 := FORM->T_MULT_A1 // salva na variavel
						Else
							lErroEpc := .T. // Indica erro ocorrido na importa็ใo
						    U_DbFecha() // SE NAO ENCONTRAR FORMATO RETORNA E FECHA OS ARQUIVOS DBF
					    	cErrF += "O formato "+cForm+" nใo foi encontrado "+ CRLF
						EndIf
						// Monta a formula
						nSoma += ((nFl*nMltA1)*(nAVCLI/100))
						nDiv  +=  nFl
						
		                // Busca a data da ultima revisao para o projeto
						DBSelectArea("REV") 
						If REV->( dbSeek( cContr) )  	   // procura dentro do REV.dbf 
							dOpera := REV->DTOPERAC   	   // pega a primeira data desse projeto
			 			EndIf 
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณEXECUTA A GRAVACAO -> SE DADOS JA EXISTEM NA TABELA -> ATUALIZA            ณ
						//ณ                      SE DADOS NAO EXISTEM -> INCLUI						  ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//						cContrRev:= PmsAF8VER(cContr) // ultima revisao do projeto
						cContrRev:= PmsAF8VER(cNumProj) // ultima revisao do projeto
					
						nFORM	:= (nSoma/nDiv)
						
						/* ::::::::::::::::::::::::::::::::::::::::::
						Codigo original
						DBSelectArea("AFF")
						AFF->( DBSetOrder(1)) // AFF_FILIAL+AFF_PROJET+AFF_REVISA+AFF_TAREFA+DTOS(AFF_DATA)
						dbSeek(xFilial("AFF")+ cContr+ cContrRev + cTarefa) //SE ENCONTRAR REGISTRO
						:::::::::::::::::::::::::::::::*/
												
						DBSelectArea("AFF")
						AFF->( DBSetOrder(1)) // AFF_FILIAL+AFF_PROJET+AFF_REVISA+AFF_TAREFA+DTOS(AFF_DATA)
						dbSeek(xFilial("AFF")+ cNumProj+ cContrRev + cTarefa + dtos(dOpera)) //SE ENCONTRAR REGISTRO

						RecLock("AFF", Eof() )// GRAVA 	
							AFF_FILIAL	:= xFilial("AFF")
							AFF_PROJET	:= cNumProj //cContr
							AFF_REVISA	:= PmsAF8VER(cNumProj) //PmsAF8VER(cContr)
							AFF_DATA	:= dOpera 
							AFF_TAREFA	:= cTarefa
							AFF_USER	:= "000000"
							AFF_CONFIRM	:= "2"
							AFF_PERC	:= 	nFORM
							AFF_QUANT   := 	nFORM/100
							AFF_FLGDOC	:= .T.
						AFF->( msUnLock() )                
						AF9->(DbSkiP())
					EndDo 
				Else
					lErroEpc := .T. // Indica erro ocorrido na importa็ใo
					AF9->( DBSetOrder(5) ) //AF9_FILIAL+AF9_PROJET+AF9_TAREFA
					
					If	AF9->(!dbSeek(xFilial("AF9")+ cNumProj))// tarefa do cliente 												
							
							cErrP += Iif(!Alltrim(cNumProj) $ cErrP,"Projeto <b>"+Alltrim(cNumProj)+"</b> nใo foi encontrado. " + CRLF,"")				   
					
					ElseIf !(Alltrim(cTarefa)+" do projeto <b>"+alltrim(cNumProj) $ cErrT)
							
							cErrT += "Tarefa  "+Alltrim(cTarefa)+"</b> do projeto <b>"+alltrim(cNumProj)+"</b> nใo foi encontrada. " + CRLF						
					EndIf						
				EndIf
		DOC->(DbSkip())
		EndDo
	EndIf // If de AF9
	
Else // if de DOC
	lErroEpc := .T. // Indica erro ocorrido na importa็ใo
	cErrP += "Projeto <b>"+alltrim(cNumProj)+"</b> nใo foi encontrado. " + CRLF		
EndIf// if de DOC 
U_DbFecha() // Fecha os dbf's
RestArea(aAreaFF) 

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do E-mail para o Administrador. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cHoraF := Time()  
		cFile  := "Log de Importa็ใo de Confirma็๕es / Apontamento" + CRLF + CRLF
  		cFile  += "<html><head></head><body>"
		cFile  += "<font size=1 face=verdana>" 
		cFile  += Replicate("*",55) + CRLF
	   	cFile  += "* EPC - ROTINA DE IMPORTAวรO DE CONFIRMAวีES/APONTAMENTO" + CRLF
		cFile  += "* DATA DE PROCESSAMENTO: " + DtoC(dDataBase) + CRLF
		cFile  += "* PARAMETROS DEFINIDOS PELO USUARIO" + CRLF
		cFile  += Replicate("*",55) + CRLF
		cFile  += "* PROJETO DE/ATE: "+" " +alltrim(mv_par01)+ " / " +alltrim(mv_par02) +CRLF
		cFile  += "* TAREFA DE/ATE:	"+" " +alltrim(mv_par03)+ " / " +alltrim(mv_par04) +CRLF
		cFile  += "* RECURSO DE/ATE: "+" " +alltrim(mv_par05)+ " / " +alltrim(mv_par06) +CRLF
		cFile  += "* DATA DE/ATE: "+ DtoC(mv_par07) + " / " +DtoC(mv_par08) +CRLF
		cFile  += Replicate("*",55) + CRLF
		cFile  += "* INICIO DO PROCESSAMENTO: " + cHoraI + CRLF
		cFile  += "* FIM DO PROCESSAMENTO: " + cHoraF + CRLF
		cFile  += "* TEMPO DECORRIDO: " + ElapTime(cHoraI, cHoraF) + CRLF
		cFile  += Replicate("*",55) + CRLF
        If lErroEPC
			cFile  += "<b> ERROS OCORRIDOS NO PROCESSAMENTO: </b>" + CRLF
		Else 
			cFile  += "<b> PROCESSAMENTO FINALIZADO </b> "+ CRLF 
		EndIf	

		If Len(cErrP) > 0
			cFile  += Replicate("-",77) + CRLF
			cFile  += cErrP + CRLF
		EndIf
		
		If Len(cErrT) > 0         
			cFile  += Replicate("-",77) + CRLF
			cFile  += cErrT + CRLF
		EndIf
			
		If Len(cErrF) > 0                        
			cFile  += Replicate("-",77) + CRLF
			cFile  += cErrF + CRLF
		EndIf
		cFile  += Replicate("*",55) + CRLF 
		cFile  += "</body></html>"
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEfetua a conexao ao servidor de envio de e-mail (SMTP) ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//Verifica se existe necessidade de autentica็ใo
		If lAuth
			CONNECT SMTP SERVER cServer ACCOUNT cUser PASSWORD cPasswd RESULT lOK
		Else
			CONNECT SMTP SERVER cServer ACCOUNT '' PASSWORD '' RESULT lOK
		EndIf
	
		//Se conexao estabelecida com o servidor
		If lOk	
			cBody := cFile // corpo do email
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณEnvia mensagemณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
			cSbjct := "LOG DE IMPORTAวรO DE CONFIRMAวีES"
		
			SEND MAIL FROM cFrom TO cTo SUBJECT cSbjct BODY cBody ATTACHMENT cFile

			If !lOk
				GET MAIL ERROR cErro
				MsgAlert("Ocorreu o seguinte erro ao tentar enviar um e-mail ao Adminstrador:"+ CRLF + cErro)
			EndIf
			DISCONNECT SMTP SERVER RESULT lOK
			If !lOk
				GET MAIL ERROR cErro
				MsgAlert("Ocorreu o seguinte erro ao tentar desconectar o Servidor de  e-mails:"+ CRLF + cErro)
			EndIf		
		Else
			//Se nใo foi possํvel conectar-se ao servidor, obtem o tipo do erro 
			//e mostra uma mensagem de alerta.	 
			GET MAIL ERROR cErro
			MsgAlert("Ocorreu o seguinte erro ao tentar conectar  o  Servidor  de  e-mails:"+ CRLF + cErro)
		EndIf

Return ()	   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDbFecha   บAutor  ณARNALDO PETRAZZINI  บ Data ณ  22/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFecha as areas dos dbfs                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function DbFecha()
	DOC->(DbCloseArea())
	REV->(DbCloseArea())
	FORM->(DbCloseArea()) 
Return()    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ E010RECU บAutor  ณVanessa Ferraz      บ Data ณ  20/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Integra a tabela de recursos do Projeto - AE8 - com o     บฑฑ
ฑฑบ          ณ  sistema legado                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EPC                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/    
User Function EPCRecu()
    Local cQuery 	:= ""
    Local lInclui 	:= .F.
    Local cChapa    := ""
    Local aAreaAE8 	:= AE8->( GetArea() )
  	Local nCount	:= 0
	Local cCrono	:= ""
	Local nCusto	:= 0
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSeleciona os recursos que fazem parte dos projetos presentes nosณ
	//ณparametros selecionados.                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCrono := u_EPCrono()

/*	
	cQuery  :=  "SELECT DISTINCT "
	cQuery 	+=	"A.CHAPA, "
	cQuery 	+=	"B.NOME, B.FUNCAO "
	cQuery 	+=	"FROM FIPEPC A "
	cQuery 	+=	" INNER JOIN PESSOAL B ON "
	cQuery 	+=	"A.CHAPA = B.CHAPA "
	cQuery	+=	"WHERE "
	cQuery	+=	"A.FIPCRONOGRAMA IN (" + cCrono + ") AND "	
	cQuery  +=  "A.CHAPA BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
	cQuery  +=  "A.FIPDATA BETWEEN '" + dtos(mv_par07) + "' AND '" + dtos(mv_par08) + "' "
	cQuery  +=  "ORDER BY "  
	cQuery  +=  "A.CHAPA "
*/

	cQuery  :=  "SELECT DISTINCT "
	cQuery 	+=	"A.CHAPA, "
	cQuery 	+=	"B.RA_NOME, B.RA_CODFUNC "
	cQuery 	+=	"FROM FIPEPC A "
	cQuery 	+=	" INNER JOIN " + RetSqlName("SRA") + " B ON "
	cQuery 	+=	"A.CHAPA = B.RA_MAT "
	cQuery	+=	"WHERE "
	cQuery	+=	"A.FIPCRONOGRAMA IN (" + cCrono + ") AND "	
	cQuery  +=  "A.CHAPA BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
	cQuery  +=  "A.FIPDATA BETWEEN '" + dtos(mv_par07) + "' AND '" + dtos(mv_par08) + "' "
	cQuery  +=  "ORDER BY "  
	cQuery  +=  "A.CHAPA "
	cQuery  +=  "A.FIPEMPRESA = '"+SM0->M0_CODIGO+"' AND "
   	cQuery  := ChangeQuery(cQuery)
   	
    dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBEXT", .F., .T.)  
 
	TRBEXT->( DbEval( {|| nCount++ } ) ) 	//conta os registros TRBEXT
	ProcRegua(nCount)
    TRBEXT->( DbGotop () )
	AE8-> ( dbSetOrder(1) )				//AE8->AE8_FILIAL + AE8->AE8_RECURS 
	CursorWait()
	
/*	If TRBEXT->( Eof() )
		cMsgEr := "* " + Time() + " - NAO FORAM ENCONTRADOS RECURSOS PARA OS PARAMETROS DEFINIDOS " + CRLF
	EndIf*/
	While !TRBEXT->( Eof() )  

		IncProc(TRBEXT->NOME)
		cChapa := Alltrim(TRBEXT->CHAPA)
			   
		lInclui := ! ( AE8->( dbSeek(xFilial("AE8") + cChapa ) ) )
		
		RecLock("AE8", lInclui)                                     	
		AE8->AE8_FILIAL		:= xFilial("AE8")
		AE8->AE8_RECURS		:= cChapa 						//Fipepc->ID
		AE8->AE8_DESCRI 	:= TRBEXT->RA_NOME          	//Pessoal->NOME
		AE8->AE8_TIPO 		:= "2" 
		AE8->AE8_ACUMUL 	:= "4" 
		AE8->AE8_UMAX 		:= 100.00
		AE8->AE8_SUPALO 	:= "2"
		AE8->AE8_PRODUT 	:= TRBEXT->RA_CODFUNC		  	//Pessoal->FUNCAO
		AE8->AE8_CALEND 	:= "001"		
		AE8->AE8_TPREAL 	:= "2"
		AE8->AE8_VALOR 		:= 0.00			
		AE8->AE8_CODFUN 	:= cChapa 						//Fipepc->ID
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEPCSRANG  บAutor  ณ Vanessa Iatski     บ Data ณ  17/11/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona o Range de Cronogramas que farao parte do IN     บฑฑ
ฑฑบ          ณ nos select da tabela FIPEPC                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Precisa ter carregado o PERGUNTE antes                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function EPCrono()
	Local cQuery := ""
	Local cCrono := ""
	Local cContr	 := ""
   
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
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta o parametro com os projetos que serao pesquisados em FIPEPCณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	 	cContr  := ""
	 	While !CRONO->( Eof() )
	 		If cContr != CRONO->AF9_PROJET .And. Alltrim(CRONO->AF9_TARCLI) != ""
	 			cCrono += "'" + Alltrim( CRONO->AF9_TARCLI ) + "',"
	 			cContr := CRONO->AF9_PROJET
	 		EndIf
	 		CRONO->( dbSkip() )
	 	EndDo
		cCrono := SubStr(cCrono, 1, Len(cCrono)-1 )
	EndIf
	CRONO->( dbCloseArea() )
	dbSelectArea("AF9")
Return(cCrono)                    