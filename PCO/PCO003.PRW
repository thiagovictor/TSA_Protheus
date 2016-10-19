#include "rwmake.ch" 
#Include "TopConn.ch"

/******************************************************************************
 * Descr	Gatilho  para  preenchimento  da  Conta Orçamentária na  inserção
 * 			de um titulo no financeiro E2_XCO. Gatilho no campo E2_ITEMD
 * Data		28/11/2013
 * Autor	Leandro P J Monteiro - CN Tecnologia 	
 *			leandro@cntecnologia.com.br
 *****************************************************************************/
User Function PCO003 (cCC)
	if Empty(cCC) 
		Return
	endif
	               
	//nNaturez 	:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "E2_NATUREZ"	})
	//nItemDeb	:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "E2_ITEMD"		})
	//nXco		:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "E2_XCO"		})
	//
	//IF ALLTRIM(ACOLS[N,nNaturez])<>""		
	//	cNaturez := ACOLS[N,nNaturez ]
	//endif
	cNaturez := M->E2_NATUREZ
	cItemDeb := M->E2_ITEMD
    //
	//IF ALLTRIM(ACOLS[N,nItemDeb])<>""		
	//	cItemDeb := ACOLS[N,nItemDeb ]
	//endif
              
	cXco := ''

	// se a filial é a matriz
	if (SM0->M0_CODFIL == '01')
		cClassi := POSICIONE("CTT", 1, xFilial("CTT")+cItemDeb, "CTT_CLASSI")
				
		DO CASE
			CASE cClassi == 'D'
				cXco := POSICIONE("SED", 1, xFilial("SED")+cNaturez, "ED_CONTA")
			CASE cClassi == 'C'
				cXco := POSICIONE("SED", 1, xFilial("SED")+cNaturez, "ED_CTACUST")
			CASE cClassi == 'I'
				cXco := POSICIONE("SED", 1, xFilial("SED")+cNaturez, "ED_CTACUST")
		ENDCASE       
	else      
		// filial
		cXco := POSICIONE("SED", 1, xFilial("SED")+cNaturez, "ED_CTACEI")
	endif             
	
	M->E2_XCO = cXco          
	//aLERT(CxCO)                
	//ACOLS[N,nXCO] := cXco
return cXco