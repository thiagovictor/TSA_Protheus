/*
+-------------+---------+-------------+-------------------+-------+----------------------+
| Programa    | IMPSC6  | Programador | Marcus Augusto    | Data  | 23/11/01             |
+-------------+---------+-------------+-------------------+-------+----------------------+
| Descricao   | Importacao da tabela SC6 para a SZ0                                      |
+-------------+--------------------------------------------------------------------------+
| Uso         | Especifico para EPC                                                                                                     |
+-------------+--------------------------------------------------------------------------+
|                          Modificacoes efetuadas no Programa                            |
+---------+-------------+----------------------------------------------------------------+
| Data    | Responsavel | Motivo                                                         |
+---------+-------------+----------------------------------------------------------------+
|01/11/05 |JOAO CARLOS  |Conversao SIGACON p/ SIGACTB                                    |
+---------+-------------+----------------------------------------------------------------+ 
|04/10/07 |CRISLEI      |TRATAMENTO PARA DEMONSTRACAO DOS PEDIDOS DE VENDA SEPARANDO PELO|
|         |             |TIPO DE FATURAMENTO. CADA TIPO DE FATURAMENTO DO PEDIDO DE VENDA|
|         |             |POSSUI UMA CONTA CONTABIL. A RELACAO ENTRE OS DOIS ESTA NA TABE-|
|         |             |LA "ZD" DEFINIDA NO SX5.                                        |
+---------+-------------+----------------------------------------------------------------+
*/

#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ImpSC6()

Processa( {|| ImportSC6() },"Importando Registros da Tabela SC6 para a SZ0","Alterando Registro ..." )

Return NIL



Static Function ImportSC6()
****************************************************************************************
* Rotina para importar dados do arquivo SC6 para ao SZ0
*
****

Private cSeq   := "00"

dbSelectArea("SC6")
/*
cKey := "SC6->C6_QTDEMP <= 0 .And. !Empty(SC6->C6_NOTA)"
cIndex:= CriaTrab(NIL,.F.)
IndRegua("SC6",cIndex,"C6_NUM+C6_ITEM",,cKey,"Selecionando Registros ...")
*/

dbGoTop()
ProcRegua(RecCount())

Total:=0
While ! Eof()
	
	IncProc("Importando Produto : "+SC6->C6_Produto)
	If !Empty(SC6->C6_NOTA) 
		If  SC6->C6_QTDEMP <= 0 
			dbSelectArea("SC6")
			dbSkip()
			Loop  
		Endif
	EndIf 
	
	******* Inclui isto para cálculo de residuo	nos pedidos de venda  *******
	If !Empty(SC6->C6_NOTA) .Or. SC6->C6_Local == "03"
	    If  SC6->C6_QTDEMP <= 0  
		    dbSelectArea("SC6")
	    	dbSkip()
	    	Loop                   
		Endif
	EndIf    

	***************************************************************************

	dbSelectArea("SB1")
	
	dbSeek(xFilial("SB1")+SC6->C6_Produto)
	
	dbSelectArea("SC5")
	dbSeek(xFilial("SC5")+SC6->C6_Num)

    //ALTERADO POR CRISLEI 04/10/07 PARA TRATAMENTO DOS PEDIDOS DE VENDA NO RESULTADO GERENCIAL	
    //POSICIONA NA TABELA ZD (SX5) PARA BUSCAR A CONTA CONTABIL DE ACORDO COM O TIPO DE FATURAMENTO DO PEDIDO
	dbSelectArea("SX5")
	dbSeek(xFilial("SX5")+"ZD"+SC5->C5_TIPOFAT)
	

	cSeq   :=  StrZero(Val(cSeq)+1,2)
	cSetor:=Posicione("SZ2",3,Xfilial("cCusto")+Alltrim(SC6->C6_SUBC),"Z2_SETOR")	
	DbSelectArea("SZ0")
	Reclock("SZ0",.T.)
	Replace 	Z0_FILIAL	With xFilial("SZ0") ,;
				Z0_LINHA		With "PV"         ,;
				Z0_HIST		With "PEDIDOS DE VENDA" + "-" + SC6->C6_NUM ,;
				Z0_LOTE		With "9700"             ,;
				Z0_DOC		With "9700"+cSeq               
	        
	//Cálculo de residuo	nos pedidos de venda  *******	        
	If SC6->C6_QTDEMP == 0  
		Replace    Z0_VALOR 	 With Iif(SC5->C5_TIPOFAT $ "5/6",-(SC6->C6_Valor),SC6->C6_Valor) //CRISLEI TOLEDO - 04/10/07
	Else 
		Replace    Z0_VALOR 	 With Iif(SC5->C5_TIPOFAT $ "5/6",-(SC6->C6_QTDEMP*SC6->C6_VALOR),SC6->C6_QTDEMP*SC6->C6_VALOR) //CRISLEI TOLEDO - 04/10/07 
	Endif
	/*Não foi possível incluir a conta cadastrada pelo cadastro de produtos, pois no cadastro existem 3 campo sendo eles
		1 - Estoque
		2-Conta Despesa
		3-Conta Custo
	*/
	Replace 	Z0_CONTA 	With Iif(AllTrim(SX5->X5_DESCRI)<>"",SX5->X5_DESCRI,'6111020001'),; //CRISLEI - 04/10/07
				Z0_CC 		With SC6->C6_SubC ,;
				Z0_DTREF 	With SubStr(DTos(SC5->C5_DataRef),5,2)+"/"+SubStr(DTos(SC5->C5_DataRef),3,2) ,;
				Z0_DATA 	   With "" ,;
				Z0_DTCAIXA 	With "" ,;
				Z0_DTVENC   With "" ,;
				Z0_CUSTO    With 0  ,;
				Z0_RECEITA  With Iif(SC5->C5_TIPOFAT $ "5/6",-(SC6->C6_Valor),SC6->C6_Valor) ,; //CRISLEI TOLEDO - 04/10/07
				Z0_Revisao  With ""            ,;
				Z0_DTLANC  	With dDatabase,;
				Z0_SETORIG    With cSetor
	MsUnlock()	

   //PIS COFINS ISS                                    
	DbSelectArea("SZ0")
	Reclock("SZ0",.T.)
	
	//Se o código é diferente de 521 (Não déve calcular imposto)
	//Modificado por SIMONE e MARCELO
	If !(SC6->C6_TES == "521")
		Replace Z0_FILIAL  With xFilial("SZ0") ,;
		        Z0_LINHA 	 With "PV" ,;
		        Z0_HIST 	 With "PED. VENDA("+SC5->C5_NUM+") PIS COFINS ISS",;
		        Z0_LOTE 	 With "9700"      ,;
		        Z0_DOC 	 With "9700"+cSeq ,;
		        Z0_VALOR 	 With -(SC6->C6_Valor*0.1125),;
		        Z0_CONTA 	 With '3112020003',;
		        Z0_CC 		 With SC6->C6_SUBC      ,;
		        Z0_DTREF 	 With SubStr(DTos(SC5->C5_DataRef),5,2)+"/"+SubStr(DTos(SC5->C5_DataRef),3,2) ,;
		        Z0_DATA 	 With "" ,;
		        Z0_DTCAIXA With ""   ,;
		        Z0_DTVENC  With ""   ,;
		        Z0_CUSTO   With 0    ,;
		        Z0_RECEITA With SC6->C6_Valor ,; 
		        Z0_Revisao With ""            ,;
		        Z0_DTLANC  With dDatabase,;
				Z0_SETORIG    With cSetor
		MsUnlock()	
	Endif	
	dbSelectArea("SC6")
	dbSkip()
	
EndDo

Return
/*	   
	

Static Function FGravaSz0(cMesRefe)
****************************************************************************************
* Gravacao no SZ0
*
****

cSeq   :=  StrZero(Val(cSeq)+1,2)
 
If SubStr(SZB->ZB_GrupGer,3,1) == "1"
	nValor := &("SZB->ZB_Mes"+cMesRefe)
Else
	nValor := (-1)*&("SZB->ZB_Mes"+cMesRefe)
EndIf	

DbSelectArea("SZ0")
Reclock("SZ0",.T.)
Replace Z0_FILIAL  With xFilial("SZ0")
Replace Z0_LINHA 	 With "ZZ" 
Replace Z0_HIST 	 With "ESTIMADO"
Replace Z0_LOTE 	 With "9800" 
Replace Z0_DOC 	 With "9800"+cSeq
Replace Z0_VALOR 	 With nValor
Replace Z0_CONTA 	 With CT1->CT1_CONTA //SI1->I1_Codigo - TBH127 JOAO CARLOS - 01/11/05 - CONVERSAO SIGACON P/ SIGACTB
Replace Z0_CC 		 With SZB->ZB_CCUSTO
Replace Z0_DTREF 	 With cMesRefe+"/"+SubStr(SZB->ZB_Ano,3,2)
Replace Z0_DATA 	 With ""
Replace Z0_DTCAIXA With ""
Replace Z0_DTVENC  With ""
Replace Z0_CUSTO   With Iif(nValor < 0,nValor,0)
Replace Z0_RECEITA With Iif(nValor > 0,nValor,0)
Replace Z0_Revisao With SZB->ZB_Revisao
MsUnlock()

Return
*/