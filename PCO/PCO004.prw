#include "rwmake.ch" 
#Include "TopConn.ch"

/******************************************************************************
 * Descr	Gatilho  para  preenchimento  da  Conta Contabil  no  cadastro de 
 * 			produtos  com o valor  do campo  C1_CC eu preencho o campo C1_XCO       
 * Data		12/11/2013
 * Autor	Leandro P J Monteiro - CN Tecnologia 	
 *			leandro@cntecnologia.com.br
 *****************************************************************************/
User Function PCO004 (cCC)
   
	if Empty(cCC) 
		cCC := M->C3_CC
	endif
	               
	nPProduto 	:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C3_PRODUTO"	})
	nPXCO		:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C3_XCO"		})
	
	IF ALLTRIM(ACOLS[N,nPProduto])<>""		
		c1Produto := ACOLS[N,nPProduto ]
	endif

	cXco := ''

	// se a filial é a matriz
//	if (SM0->M0_CODFIL == '01')
	if (SM0->M0_CODFIL >= '01' .and. SM0->M0_CODFIL <= '19')
		cClassi := POSICIONE("CTT", 1, xFilial("CTT")+cCC, "CTT_CLASSI")
				
		DO CASE
			CASE cClassi == 'D'
				cXco := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTADESP")
			CASE cClassi == 'C'
				cXco := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTACONS")
			CASE cClassi == 'I'
				cXco := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTACONS")
		ENDCASE       
	else      
		// filial
		cXco := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTACEI")
	endif             
	                          
	ACOLS[N,nPXCO] := cXco

return cXco