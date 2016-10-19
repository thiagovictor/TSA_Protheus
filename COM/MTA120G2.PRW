User function MTA120G2()
*********************************************************************************************************************
* Grava na Tabela de Movimento mensal o Numero o Pedido
*
*****

If l120auto // Variável que indica se é rotina automática
	// Esta tabela foi posicionada antes da execução da Rotina
	dbSelectArea("SRC")	
	RecLock("SRC",.F.)
	Replace RC_PEDCOM With SC7->C7_NUM
	MsUnlock()
Endif
Return()
