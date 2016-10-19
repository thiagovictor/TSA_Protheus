#include "rwmake.ch" 
#Include "TopConn.ch"

/******************************************************************************
 * Descr 	Gatilho auxiliar para preenchimento da Conta Contabil no cadastro 
 * 			de produtos. Como existia um gatilho em C1_ITEMCTA que alimentava  
 *			o valor em C1_CC criei este fonte para que executasse os gatilhos 
 *			de C1_CC assim que este fosse alimentado.
 * Data		12/11/13
 * Autor	Leandro P J Monteiro - CN Tecnologia
 *			leandro@cntecnologia.com.br
 *****************************************************************************/
User Function PCO005       
	nPos1 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C3_CC" })
	cItmCta := M->C3_ITEMCTA                                                                                       
	
	// Realiza a atribuição antecipada para que a trigger possa ser executada
	IF ALLTRIM(ACOLS[N,nPos1]) <>""	 
		ACOLS[N,nPos1] := cItmCta
	endif
           
	// Executa o gatilho de C1_CC  
	//If ExistTrigger('C1_CC')        
	//	RunTrigger(3,n,nil,,'C1_CC')
	//endif              
		U_PCO004(cItmCta)
Return cItmCta