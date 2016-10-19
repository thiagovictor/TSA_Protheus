#Include "Rwmake.ch"
/*
+-----------------------------------------------------------------------------+
| Programa  | MTA120G2 | Desenvolvedor | Gilson Lucas Jr  | Data | 16/09/2004 |
|-----------------------------------------------------------------------------|
| Descricao | Ponto de entrada que ira atualizar o dados do SZO quando exister|
|-----------------------------------------------------------------------------|
|um AE para o contrato (para inclusao de AE)
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC Engenharia                                       |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  | 
+--------------+-----------+--------------------------------------------------+
*/

User Function MTA120G2
/******************************************************************************
* PE que faz a atualização dos dados do SZO (na inclusao da AE)
*
**********************************/

Local aAreaOLD  := GetArea()
Local nXi       := 0
Local cnumPesq  := ""
Local cItemPesq := ""

If l120auto .And. SRC->RC_FILIAL=='97'  // Variável que indica se é rotina automática
	// Esta tabela foi posicionada antes da execução da Rotina
	dbSelectArea("SRC")	
	RecLock("SRC",.F.)
	Replace RC_PEDCOM With SC7->C7_NUM
	MsUnlock()
Endif
dbSelectArea("SC7")


If FunName() <> "MATA122"
   Return
EndIf   


For nXi := 1 To Len(aCols)
	If GDDELETED(nXi)
		Loop
	EndIF
    cNumPesq  := GDFieldGet("C7_NUMSC",nXi)         //Chaves para pesquisa
    cItemPesq  := GDFieldGet("C7_ITEMSC",nXi)		//Chaves para pesquisa
	
	SZO->(dbSetOrder(1))
    SZO->(dbSeek(xFilial("SZO")+cnumPesq+cItemPesq+"T"))
    If !SZO->(EOF())
		If RecLock("SZO",.F.)
		    Replace  SZO->ZO_QUJE     With  GDFieldGet("C7_QUANT",nXi)	
		    If ((SZO->ZO_QUANT - SZO->ZO_QUJE ) = 0 )
			    Replace  SZO->ZO_ENCER    With  "E"
			    Replace  SZO->ZO_STATUS   With  "E"  
			Else
			    Replace  SZO->ZO_ENCER    With  "T"
			    Replace  SZO->ZO_STATUS   With  "T"  			    
		    EndIf
		    MsUnLock()       
 	    EndIf    
    EndIf
  
    SZO->(dbSetOrder(1))
    SZO->(dbSeek(xFilial("SZO")+cNumPesq+cItemPesq+"C"))
    If !SZO->(EOF())		
 	    If RecLock("SZO",.F.)
		    Replace  SZO->ZO_QUJE     With  GDFieldGet("C7_QUANT",nXi)	
			If ((SZO->ZO_QUANT - SZO->ZO_QUJE ) = 0 )
		        Replace  SZO->ZO_ENCER    With  "E"
			    Replace  SZO->ZO_STATUS   With  "E"
			Else
				Replace  SZO->ZO_ENCER    With  "T"
  		        Replace  SZO->ZO_STATUS   With  "T"  			    			         
		    EndIf
		    MsUnLock()       
 	    EndIf    				
 	EndIf	
	SZO->(dbSetOrder(1))
    SZO->(dbSeek(xFilial("SZO")+cNumPesq+cItemPesq+"A"))
    If !SZO->(EOF())		
 	    If RecLock("SZO",.F.)
		    Replace  SZO->ZO_QUJE     With  GDFieldGet("C7_QUANT",nXi)	
			If ((SZO->ZO_QUANT - SZO->ZO_QUJE ) = 0 )
		        Replace  SZO->ZO_ENCER    With  "E"
			    Replace  SZO->ZO_STATUS   With  "E"
			Else
				Replace  SZO->ZO_ENCER    With  "A"
  		        Replace  SZO->ZO_STATUS   With  "A"  			    			         
		    EndIf
		    MsUnLock()       
 	    EndIf    				
	EndIf

Next nXi


RestArea(aAreaOLD)
Return 