User function MTA120G2()
*********************************************************************************************************************
* Grava na Tabela de Movimento mensal o Numero o Pedido
*
*****

If l120auto // Vari�vel que indica se � rotina autom�tica
	// Esta tabela foi posicionada antes da execu��o da Rotina
	dbSelectArea("SRC")	
	RecLock("SRC",.F.)
	Replace RC_PEDCOM With SC7->C7_NUM
	MsUnlock()
Endif
Return()
