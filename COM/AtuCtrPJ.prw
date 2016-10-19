	/*
+-----------------------------------------------------------------------+
¦Programa  ¦ AtuCtrPJ  ¦ Autor ¦Crislei Toledo        ¦ Data ¦23.07.2007¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Rotina para atualizar saldo do contrato do PJ, de acordo   ¦
¦          ¦ com a medicao gerada na FAC                                ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 |
+------------+--------+-------------------------------------------------+
*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function AtuCtrPJ(aInfPed)

/*
- Buscar na tabela de Cabecalho da Planilha (CNA) atraves do codigo do fornecedor e da matricula do funcionario
o numero da planilha e o numero do contrato. (Confirmar se so havera uma planilha para cada funcionario (PJ) ou se 
podera acontecer de ter mais de uma planilha para uma mesma matricula. (ok)

- Verificar se ja existe na tabela de Cabecalho da Medicao uma Medicao cadastrada para o fornecedor e mes de
  competencia. (não é necessario uma vez que esta verificação ja e feita antes da inclusao do Pedido de compra) 

*/                      

Local cNumMedi  := GetSx8Num("CND")
Local cMesRef   := Right(aInfPed[05],2) + '/' + Left(aInfPed[05],4)

Local dDtAniv   := CTOD("")
Local cProxItm  := ""
Local cProduto  := ""
Local cDescri   := ""
Local cUM       := ""
Local nQtdePl   := 0
Local nVlUniPl  := 0
Local nVlTotPl  := 0 
Local nTotaPed  := 0
Local nSomaCNB  := 0 

Local cItmMed   := "" //"A00"
Local cCodItMd  := ""
Local cQuery    := ""

Private cNumPed   := aInfPed[01]
Private cMatrFunc := aInfPed[02]
Private cCodForn  := aInfPed[03]
Private cLojaForn := aInfPed[04]
Private cMesRef   := aInfPed[05]
Private cCondPag  := aInfPed[06]
Private cContrato := aInfPed[07]
Private cRevisa   := aInfPed[08]

//Inicializa variaveis de controle do Item da Planilha/Medicao
cItmMed   := FCodItem() 
cCodItMd  := cItmMed


cQuery := " SELECT CNA_CONTRA, CNA_VLTOT, CNA_NUMERO, CNA_REVISA "
cQuery += " FROM " + RetSqlName("CNA") 
cQuery += " WHERE CNA_CONTRA='"+cContrato+"' AND CNA_MAT = '" + cMatrFunc + "' AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY CNA_CONTRA, CNA_REVISA DESC"

TcQuery cQuery Alias "QCNA" New

cQuery := "SELECT SUM(C7_TOTAL) C7_TOTAL " 
cQuery += "FROM " + RetSqlName("SC7")
cQuery += " WHERE C7_NUM = '" + cNumPed + "' AND D_E_L_E_T_ <> '*'"

TcQuery cQuery Alias "QTOTSC7" New

cQuery := "SELECT * FROM " + RetSqlName("SC7") 
cQuery += " WHERE C7_NUM = '" + cNumPed + "' AND D_E_L_E_T_ <> '*'"

TcQuery cQuery Alias "QSC7" New


dbSelectArea("QCNA")
dbGoTop()           
If !Eof()
	
	dbSelectArea("QTOTSC7")
	dbGoTop()	
	
	Begin Transaction 
	   //CRIA MEDICAO (CND/CNE) PARA O PEDIDO DE COMPRAS GERADO
	   RecLock("CND",.T.)
	   Replace CND_FILIAL With xFilial("CND"), ;
	           CND_NUMMED With cNumMedi , ;
	           CND_DTINIC With dDataBase, ;
	           CND_DTVENC With dDataBase, ;
	           CND_DTFIM  With dDataBase, ;
	           CND_VLTOT  With QTOTSC7->C7_TOTAL, ;
	           CND_ZERO   With "2", ;
	           CND_FORNEC With cCodForn, ; 
	           CND_LJFORN With cLojaForn, ;
	           CND_CONTRA With QCNA->CNA_CONTRA, ;
	           CND_REVISA With QCNA->CNA_REVISA, ;
	           CND_COMPET With Right(cMesRef,2)+"/"+Left(cMesRef,4), ;
	           CND_CONDPG With cCondPag, ;
	           CND_VLCONT With QCNA->CNA_VLTOT, ;
	           CND_NUMERO With QCNA->CNA_NUMERO, ;
	           CND_MAT    With cMatrFunc
	   MsUnlock()
	   ConfirmSX8()
	
	
	   dbSelectArea("QSC7")
	   dbGoTop()
	
	   //GRAVA ITENS DA MEDICAO
	   While !Eof()
	      cCodItMd := Soma1(cCodItMd)
	      
	      RecLock("CNE",.T.)
	      Replace CNE_FILIAL With xFilial("CNE"), ;
	              CNE_ITEM   With cCodItMd, ;
	              CNE_PRODUT With QSC7->C7_PRODUTO, ;
	              CNE_QTDSOL With QSC7->C7_QUANT, ;
	              CNE_QTAMED With QSC7->C7_QUANT, ;   
	              CNE_QUANT  With QSC7->C7_QUANT, ;
	              CNE_PERC   With 100.00, ;
	              CNE_VLUNIT With QSC7->C7_PRECO, ;
	              CNE_VLTOT  With QSC7->C7_TOTAL, ; 
	              CNE_DTENT  With dDataBase, ;
	              CNE_CONTRA With QCNA->CNA_CONTRA, ;
	              CNE_REVISA With QCNA->CNA_REVISA, ;
	              CNE_NUMERO With QCNA->CNA_NUMERO, ;
	              CNE_NUMMED With cNumMedi, ;
	              CNE_PEDIDO With cNumPed
	      MsUnlock()   

	      nTotaPed += QSC7->C7_TOTAL

	      dbSelectArea("SC7")
	      dbSetOrder(1)
	      dbSeek(xFilial("SC7")+QSC7->C7_NUM+QSC7->C7_ITEM)
	      
	      If !Eof()
	         If RecLock("SC7",.F.)
	            Replace C7_CONTRA  With QCNA->CNA_CONTRA, ;
	                    C7_CONTREV With QCNA->CNA_REVISA, ;
	                    C7_PLANILH With QCNA->CNA_NUMERO, ;
	                    C7_MEDICAO With cNumMedi, ;
	                    C7_ITEMED  With cCodItMd
	            MsUnlock()
	         EndIf
	      EndIf
	   
	      dbSelectArea("QSC7")
	      dbSkip()
	   End
	   /*
	   cQuery := "SELECT MAX(CNB_ITEM) AS CNB_ITEM FROM " 
	   cQuery += RetSqlName("CNB") 
	   cQuery += " WHERE CNB_CONTRA = '" + QCNA->CNA_CONTRA + "' AND "
	   cQuery += " CNB_REVISA = '" + QCNA->CNA_REVISA + "' AND CNB_QTDMED=0 AND "
	   cQuery += " CNB_NUMERO = '" + QCNA->CNA_NUMERO + "' AND D_E_L_E_T_ <> '*' "
	   
	   TcQuery cQuery Alias "QITCNB" New
	   
	   dbSelectArea("QITCNB")
	   dbGoTop()
	   
	   cCodItMd := Soma1(QITCNB->CNB_ITEM) //Reinicializa o contador de item de medicao para utiliza-lo na gravacao de Itens da Planilha
	   */
	   
	   //Apaga o primeiro item da planilha pois refere-se a proxima medicao.
	   dbSelectArea("CNB")
	   dbSetOrder(1)
	   dbSeek(xFilial("CNB")+QCNA->CNA_CONTRA+QCNA->CNA_REVISA+QCNA->CNA_NUMERO)
	   
	   While !Eof() .And. ;
	         QCNA->(xFilial("CNB")+CNA_CONTRA+CNA_REVISA+CNA_NUMERO)=CNB->(CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO)
      	            	             
			If CNB->CNB_QTDMED == 0 
 			   cProxItm  := CNB->CNB_ITEM
			   cProduto  := CNB->CNB_PRODUT
			   cDescri   := CNB->CNB_DESCRI
 			   cUM       := CNB->CNB_UM
 	 		   dDtAniv   := CNB->CNB_DTANIV
			   nQtdePl   := CNB->CNB_QUANT
			   nVlUniPl  := CNB->CNB_VLUNIT
			   nVlTotPl  := CNB->CNB_VLTOT
				  
               If CNB->CNB_VLTOT  >= nTotaPed  .And. ;
                  nSomaCNB == 0				  
				  If RecLock("CNB",.F.)
				   	 dbDelete()
					 MsUnlock()
				  EndIf
				  Exit
		   	   Else
		   	      //soma os itens que serao apagados para atender o valor do pedido.
		   	      nSomaCNB += CNB->CNB_VLTOT 
		   	   	  If RecLock("CNB",.F.)
				   	 dbDelete()
					 MsUnlock()
				  EndIf
				  
				  //Se a soma dos itens for maior ou igual ao valor do pedido, sai do Loop, pois não é mais 
				  //necessario pegar valor de novos itens 
				  If nSomaCNB >= nTotaPed
				     Exit
				  EndIf
				  
		   	   EndIf
		   	Endif
		   	
		   	dbSelectArea("CNB")
		   	dbSkip()
	   EndDo
	   
	   //Insere em CNB (Itens da Planilha) os itens gerados pela medicao
	   cCodItMd := cItmMed
   
	   dbSelectArea("QSC7")
	   dbGoTop()
	   
	   While !Eof()      
	      cCodItMd := Soma1(cCodItMd)
	      
	      RecLock("CNB",.T.)
	      Replace CNB_FILIAL With xFilial("CNB"), ;
	              CNB_NUMERO With QCNA->CNA_NUMERO, ;
	              CNB_REVISA With QCNA->CNA_REVISA, ; 
	              CNB_ITEM   With cCodItMd, ;
	              CNB_PRODUT With QSC7->C7_PRODUTO, ;
	              CNB_DESCRI With QSC7->C7_DESCRI, ;
	              CNB_UM     With QSC7->C7_UM, ;
	              CNB_QUANT  With QSC7->C7_QUANT, ;
	              CNB_VLUNIT With QSC7->C7_PRECO, ;
	              CNB_VLTOT  With QSC7->C7_TOTAL, ;
	              CNB_QTDMED With QSC7->C7_QUANT, ;
	              CNB_SLDREC With QSC7->C7_QUANT, ;
	              CNB_DTANIV With dDtAniv, ;
	              CNB_CONTRA With QCNA->CNA_CONTRA, ;
	              CNB_DTCAD  With dDtAniv
	      MsUnlock()
	      
	      dbSelectArea("QSC7")
	      dbSkip()           
	   End
	   
	   //VERIFICA SE O TOTAL DO PEDIDO E INFERIOR AO VALOR DA PLANILHA (SALARIO) SE FOR, CRIA UM NOVO REGISTRO COM 
	   //O VALOR DA DIFERENCA
	   If QTOTSC7->C7_TOTAL < nVlTotPl .And. ;
	      nSomaCNB == 0	      
	      cCodItMd := Soma1(cCodItMd)
	      
	      RecLock("CNB",.T.)
	      Replace CNB_FILIAL With xFilial("CNB"), ;
	              CNB_NUMERO With QCNA->CNA_NUMERO, ;
	              CNB_REVISA With QCNA->CNA_REVISA, ; 
	              CNB_ITEM   With cCodItMd, ;
	              CNB_PRODUT With cProduto, ;    
	              CNB_DESCRI With cDescri, ;
	              CNB_UM     With cUM, ;              
	              CNB_QUANT  With nQtdePl, ;
	              CNB_VLUNIT With (nVlTotPl - QTOTSC7->C7_TOTAL), ;
	              CNB_VLTOT  With (nQtdePl * (nVlTotPl - QTOTSC7->C7_TOTAL)), ;
	              CNB_QTDMED With 0, ;
	              CNB_SLDMED With nQtdePl, ;
	              CNB_SLDREC With nQtdePl, ;
	              CNB_DTANIV With dDtAniv, ;
	              CNB_CONTRA With QCNA->CNA_CONTRA, ;
	              CNB_DTCAD  With dDtAniv
	      MsUnlock()
	   /*   
	      dbSelectArea("CNE")
		  RecLock("CNE",.T.)
		  Replace CNE_FILIAL With xFilial("CNE"), ;
		   		  CNE_ITEM   With cCodItMd, ;
				  CNE_PRODUT With cProduto,;
				  CNE_QTDSOL With nQtdePl,;
				  CNE_QTAMED With 0,;
				  CNE_QUANT  With 0,;   
				  CNE_VLUNIT With (nVlTotPl - QTOTSC7->C7_TOTAL),;
				  CNE_VLTOT  With 0,; 
				  CNE_CONTRA With QCNA->CNA_CONTRA,;
				  CNE_REVISA With QCNA->CNA_REVISA,;
				  CNE_NUMERO With QCNA->CNA_NUMERO,;
				  CNE_PEDIDO With cNumPed,;
				  CNE_DTENT  With dDataBase,;
				  CNE_NUMMED With cNumMedi
			MsUnlock()
        */
	   EndIf
	   	   
	   //VERIFICA O TOTAL DO PEDIDO E MAIOR QUE O VALOR DA PLANILHA (SALARIO) SE FOR, CRIA UM NOVO REGISTRO COM 
	   //O VALOR DA DIFERENCA, POIS FORAM UTILIZADOS PELO MENOS DOIS ITENS DA PLANILHA PARA ATENDER O VALOR DO PEDIDO
	   If nSomaCNB > 0
	      cCodItMd := Soma1(cCodItMd)
	      
	      RecLock("CNB",.T.)
	      Replace CNB_FILIAL With xFilial("CNB"), ;
	              CNB_NUMERO With QCNA->CNA_NUMERO, ;
	              CNB_REVISA With QCNA->CNA_REVISA, ; 
	              CNB_ITEM   With cCodItMd, ;
	              CNB_PRODUT With cProduto, ;    
	              CNB_DESCRI With cDescri, ;
	              CNB_UM     With cUM, ;              
	              CNB_QUANT  With 1 ,; //nQtdePl, ;
	              CNB_VLUNIT With Iif(nSomaCNB > nTotaPed, nSomaCNB - nTotaPed, nTotaPed), ;
	              CNB_VLTOT  With Iif(nSomaCNB > nTotaPed, nSomaCNB - nTotaPed, nTotaPed), ; //(nQtdePl * (Iif(nSomaCNB > nTotaPed, nSomaCNB - nTotaPed, nTotaPed))), ;
	              CNB_QTDMED With 0, ;
	              CNB_SLDMED With 1, ;
	              CNB_SLDREC With 1, ;
	              CNB_DTANIV With dDtAniv, ;
	              CNB_CONTRA With QCNA->CNA_CONTRA, ;
	              CNB_DTCAD  With dDtAniv
	      MsUnlock()
	      /*
   	      dbSelectArea("CNE")
		  RecLock("CNE",.T.)
		  Replace CNE_FILIAL With xFilial("CNE"), ;
		   		  CNE_ITEM   With cCodItMd, ;
				  CNE_PRODUT With cProduto,;
				  CNE_QTDSOL With nQtdePl,;
				  CNE_QTAMED With 0,;
				  CNE_QUANT  With 0,;   
				  CNE_VLUNIT With Iif(nSomaCNB > nTotaPed, nSomaCNB - nTotaPed, nTotaPed),;
				  CNE_VLTOT  With 0,; 
				  CNE_CONTRA With QCNA->CNA_CONTRA,;
				  CNE_REVISA With QCNA->CNA_REVISA,;
				  CNE_NUMERO With QCNA->CNA_NUMERO,;
				  CNE_PEDIDO With cNumPed,;
				  CNE_DTENT  With dDataBase,;
				  CNE_NUMMED With cNumMedi
			MsUnlock()	      
           */
	   EndIf
	   
	   
	                   
	   //ATUALIZA O SALDO DO CONTRATO NAS TABELAS DE CONTRATO (CN9) E PLANILHA (CNA)   
	   dbSelectArea("CN9")
	   dbSetOrder(1)
	   dbSeek(xFilial("CN9")+QCNA->CNA_CONTRA+QCNA->CNA_REVISA)
	   
	   If !Eof()
	      If RecLock("CN9",.F.)
	         Replace CN9_SALDO With (CN9->CN9_SALDO - QTOTSC7->C7_TOTAL)
	         MsUnlock()
	      EndIf
	      
	      dbSelectArea("CNA")
	      dbSetOrder(1)
	      dbSeek(xFilial("CNA")+QCNA->CNA_CONTRA+QCNA->CNA_REVISA+QCNA->CNA_NUMERO)
	      
	      If !Eof()
	         If RecLock("CNA",.F.)
	            Replace CNA_SALDO With (CNA->CNA_SALDO - QTOTSC7->C7_TOTAL)
	            MsUnlock()
	         EndIf
	      EndIf
	   EndIf
		
		//Neste ponto deve ser O ACERTO NA TABELA CNE
		cQuery:=" SELECT CNB_QTDMED,* FROM " + RetSqlName("CNB")
		cQuery+=" WHERE CNB_CONTRA = '" + QCNA->CNA_CONTRA + "' AND CNB_REVISA='" + QCNA->CNA_REVISA + "'"
		cQuery+=" AND CNB_QTDMED = 0 AND CNB_NUMERO = '" + QCNA->CNA_NUMERO + "' AND "
		cQuery+=" CNB_FILIAL = '" + xFilial("CNB")+"' AND D_E_L_E_T_<>'*' "
		TcQuery cQuery Alias QCNB New
		dbSelectArea("QCNB")
		dbGotop()
		While !Eof()
			dbSelectArea("CNE")
			RecLock("CNE",.T.)
			Replace CNE_FILIAL With xFilial("CNE"), ;
					CNE_ITEM   With QCNB->CNB_ITEM, ;
					CNE_PRODUT With QCNB->CNB_PRODUT,;
					CNE_QTDSOL With QCNB->CNB_QUANT,;
					CNE_QTAMED With 0,;
					CNE_QUANT  With 0,;   
					CNE_VLUNIT With QCNB->CNB_VLUNIT,;
					CNE_VLTOT  With 0,; 
					CNE_CONTRA With QCNB->CNB_CONTRA,;
					CNE_REVISA With QCNB->CNB_REVISA,;
					CNE_NUMERO With QCNB->CNB_NUMERO,;
					CNE_PEDIDO With cNumPed,;
					CNE_DTENT  With dDataBase,;
					CNE_NUMMED With cNumMedi
			MsUnlock()
			dbSelectArea("QCNB")
			dbSkip()
		EndDo
		dbSelectArea("QCNB")
		dbCloseArea()
		
		/*
		//Acerto da Tabela CNE dos Itens que já foram Exluidos
		cQuery:=" UPDATE "+RetSqlName("CNE")+" SET D_E_L_E_T_='*', R_E_C_D_E_L_= CNE.R_E_C_N_O_ "
		cQuery+=" FROM "+RetSqlName("CNE")+" CNE "
		cQuery+=" LEFT OUTER JOIN "+RetSqlName("CNB")+" CNB ON (CNE_CONTRA=CNB_CONTRA AND CNE_REVISA=CNB_REVISA AND "
		cQuery+=" CNE_ITEM=CNB_ITEM AND CNB.D_E_L_E_T_<>'*' ) "
		cQuery+=" INNER JOIN "+RetSqlName("SC7")+" SC7 ON ( C7_NUM='"+cNumPed+"' AND C7_CONTRA='"+QCNA->CNA_CONTRA+"' AND " //C7_CONTREV='"+QCNA->CNA_REVISA+"' AND "
		cQuery+="		AND C7_MEDICAO='"+cNumMedi+"' AND C7_ITEMED=CNE_ITEM ) "
		cQuery+=" WHERE CNE.CNE_CONTRA = '"+QCNA->CNA_CONTRA+"' AND CNE.CNE_REVISA='"+QCNA->CNA_REVISA+"' AND CNE.D_E_L_E_T_<>'*' "
		cQuery+=" AND CNE_NUMMED<>'"+cNumMedi+"' AND CNB_ITEM IS NULL "
		TcSqlExec(cQuery)
		
		cQuery:=" SELECT DISTINCT CNE_NUMMED,CNE_PEDIDO,CNE_DTENT FROM "+RetSqlName("CNE")+" CNE WHERE CNE_CONTRA='"+QCNA->CNA_CONTRA+"'
		cQuery+=" AND CNE.CNE_REVISA='"+QCNA->CNA_REVISA+"' AND CNE_FILIAL='"+Xfilial("CNE")+"'"
		cQuery+=" AND D_E_L_E_T_<>'*' "
		TcQuery cQuery Alias MEDTMP New
		
		//Varre a Medição atual e cria os novos registros nas Revisões anteriores
		dbSelectArea("CNE")		
		dbSeek(Xfilial("CNE")+QCNA->CNA_CONTRA+QCNA->CNA_REVISA+QCNA->CNA_NUMERO+cNumMedi)
		While !Eof() .And. Xfilial("CNE")+QCNA->CNA_CONTRA+QCNA->CNA_REVISA+QCNA->CNA_NUMERO+cNumMedi=CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED
			nPosCNE=Recno()
			// Verifica se Existe Este Item nas Medições anteriores
			dbSelectArea("MEDTMP")
			dbGoTop()
			While !Eof()
				dbSelectArea("CNE")
				cQuery:=" SELECT CNE_ITEM FROM "+RetSqlName("CNE")+" CNE "
				cQuery+=" WHERE "
				// cQuery+=" CNE.CNE_CONTRA = '"+QCNA->CNA_CONTRA+"' AND CNE.CNE_REVISA='"+QCNA->CNA_REVISA+"'"
				// cQuery+=" AND CNE_NUMERO='"+QCNA->CNA_NUMERO+"' AND "
				cQuery+=" CNE_NUMMED='"+MEDTMP->CNE_NUMMED+"' AND CNE_ITEM='"+CNE->CNE_ITEM+"' AND CNE.D_E_L_E_T_<>'*' "
				TcQuery cQuery Alias QCNETMP New
				dbSelectArea("QCNETMP")
				dbGotop()
				If Eof()
					//salva os Itens para a Gravação
					cItemMed  :=CNE->CNE_ITEM
					cProdMed  :=CNE->CNE_PRODUT
					nQuantMed :=CNE->CNE_QUANT
					nQtaMed   :=CNE->CNE_QTAMED
					nVlrUnitMed :=CNE->CNE_VLUNIT
					cContraMed:=CNE->CNE_CONTRA
					cRevisaMed:=CNE->CNE_REVISA
					cNroMEd   :=CNE->CNE_NUMERO
					//Grava o novo Item
					dbSelectArea("CNE")
					Reclock("CNE",.T.)
					Replace CNE_FILIAL With xFilial("CNE"), ;
							CNE_ITEM   With cItemMed, ;
							CNE_PRODUT With cProdMed,;
							CNE_QTDSOL With nQuantMed,;
							CNE_QTAMED With nQtaMed,;
							CNE_QUANT  With 0,;   
							CNE_VLUNIT With nVlrUnitMed,;
							CNE_VLTOT  With 0,; 
							CNE_CONTRA With cContraMed,;
							CNE_REVISA With cRevisaMed,;
							CNE_NUMERO With cNroMEd,;
							CNE_PEDIDO With MEDTMP->CNE_PEDIDO,;
							CNE_DTENT  With Stod(MEDTMP->CNE_DTENT),;
							CNE_NUMMED With MEDTMP->CNE_NUMMED
					MsUnlock()
				Endif       
				dbSelectArea("CNE")		
				dbGoto(nPosCNE)
				
				dbSelectArea("QCNETMP")
				dbCloseArea()
				
				dbSelectArea("MEDTMP")
				dbSkip()
			EndDo
						
			//Reposiciona na Tabela CNE
			dbSelectArea("CNE")		
			dbGoto(nPosCNE)
			dbSkip()
		EndDo
		
		dbSelectArea("MEDTMP")
		dbCloseArea()
		*/
		//
		
	End Transaction 
End If
dbSelectArea("QCNA")
dbCloseArea()

dbSelectArea("QTOTSC7")
dbCloseArea()

dbSelectArea("QSC7")
dbCloseArea()

Return


Static Function FCodItem()
************************************************************************************************
* Calcula o novo código do item da Planilha/Medição
*
****

Local cRet := ""
Local cQuery := ""

cQuery := "SELECT MAX(CNB_ITEM) CODITM "
cQuery += "FROM " + RetSqlName("CNB") 
cQuery += " WHERE CNB_CONTRA = '" + cContrato + "' AND "
cQuery += " LEFT(CNB_ITEM,1) IN('A') AND "
cQuery += " D_E_L_E_T_ <> '*' "

TcQuery cQuery Alias "QITM" New

dbSelectArea("QITM")
dbGoTop()

If !Eof()   .And. ; 
   AllTrim(QITM->CODITM) <> ""   
   cRet := QITM->CODITM
Else
   cRet := "A00"
EndIf

dbSelectArea("QITM")
dbCloseArea()


Return(cRet)