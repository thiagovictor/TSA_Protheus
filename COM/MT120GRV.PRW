/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | WFW120P | Development by Carraro   |  Data  | 08/11/2001       |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Ponto de Entrada Para Gravacao dos Descritivos do Ped. Compra  |
+------------+----------------------------------------------------------------+
| Uso        | Exclusivo EPC                                                  |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
+---------+-------------+-----------------------------------------------------+
|         |             |                                                     |
+---------+-------------+-----------------------------------------------------+
*/ 

#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"

User Function WFW120P(cParFil, cParPed)

Local nGrupo
Local cMensagem
Local aArqAn:={Alias(),IndexOrd(),RecNo()}

Private oDlgFirst
Private lConfirma:=.f.
Private cDetEscop:=IIf(INCLUI,"",SC7->C7_DETES)
Private cDetCondi:=IIf(INCLUI,"",SC7->C7_DETCD)
Private cDetDocto:=IIf(INCLUI,"",SC7->C7_DETDC)
Private cDetPrazo:=IIf(INCLUI,"",SC7->C7_DETPZ)
Private cDetPreco:=IIf(INCLUI,"",SC7->C7_DETPR)
Private cDetLocal:=IIf(INCLUI,"",SC7->C7_DETLC)
Private cDetInpec:=IIf(INCLUI,"",SC7->C7_DETIN)
Private cDetConta:=IIf(INCLUI,"",SC7->C7_DETCT)
Private cDetConfi:=IIf(INCLUI,"",SC7->C7_DETCF)
Private cParFil  := cParFil
Private cParPed  := cParPed

cMensagem := "Atencao, Esta Rotina Tem o Intuito de Informar ao Sistema Os Detalhes "
cMensagem += "Do Pedido de Compras Para Posterior Impressao, Caso Nao Sejam Necessarios "
cMensagem += "Tais Detalhes Apenas Clique no Botão de Cancelamento."

While ! lConfirma
   @ 000,000 To 195,500 DIALOG oDlgFirst Title "Detalhes do Pedido"
   @ 005,005 To 050,245 Title "Atencao"
   @ 012,010 SAY "Esta Rotina Tem o Intuito de Informar ao Sistema Os Detalhes Do Pedido de Compras Para" Color CLR_HBLUE Size 230,07   
   @ 025,010 SAY "Posterior Impressao, Caso Nao Sejam Necessarios Tais Detalhes Apenas Clique no Botao  " Color CLR_HBLUE Size 230,07   
   @ 037,010 SAY "de Cancelamento." Color CLR_HBLUE Size 200,07   

   @ 055,005 To 095,245 
   @ 065,010 BUTTON "_Escopo" 			   	Size 32,12 Action FDialog(1)
   @ 065,045 BUTTON "_Cond. Gerais" 		   Size 45,12 Action FDialog(2)
   @ 065,095 BUTTON "1 _Documentos" 			Size 42,12 Action FDialog(3) 
   @ 065,140 BUTTON "2 _Prazo Entrega" 		Size 47,12 Action FDialog(4) 
   @ 065,190 BUTTON "3 P_reco/Condicao" 		Size 50,12 Action FDialog(5) 
   @ 080,010 BUTTON "4 _Entrega/Embalagem" 	Size 60,12 Action FDialog(6) 
   @ 080,070 BUTTON "5 _Inspecao" 				Size 37,12 Action FDialog(7) 
   @ 080,108 BUTTON "6 Con_tato" 				Size 32,12 Action FDialog(8) 
   @ 080,141 BUTTON "7 Con_firmacao" 			Size 45,12 Action FDialog(9) 
   @ 080,185 BMPBUTTON Type 01 Action FConfGrav()
   @ 080,215 BMPBUTTON Type 02 Action FCancGrav()

   Activate Dialog oDlgFirst Centered

End   

//Restaura Area
DbSelectArea(aArqAn[1])
DbSetOrder(aArqAn[2])
DbGoTo(aArqAn[3])

Return(.t.)


Static Function FConfGrav()
***********************************************************************************
* Confirmacao de Gravacao
***


If MsgBox("Confirma Gravacao dos Detalhes Informados no Pedido?","Atencao","YESNO")
   
   lConfirma := .t.
   Close(oDlgFirst)
   DbSelectArea("SC7")
   DbSetOrder(1)
   DbSeek(cParFil+cParPed)
   While cParFil == C7_FILIAL .and. cParPed == C7_NUM
      If RecLock("SC7",.f.)
         Replace C7_DETES With cDetEscop
         Replace C7_DETDC With cDetDocto
         Replace C7_DETPZ With cDetPrazo
         Replace C7_DETPR With cDetPreco
         Replace C7_DETLC With cDetLocal
         Replace C7_DETIN With cDetInpec
         Replace C7_DETCT With cDetConta
         Replace C7_DETCF With cDetConfi
         Replace C7_DETCD With cDetCondi
         MsUnlock()                                                
      EndIf 
      DbSkip()
   End  
EndIf   

Return


Static Function FCancGrav()
***********************************************************************************
* Cancelamento de Gravacao
***

If MsgBox("Confirma Cancelamento das Informacoes Adicionais ao Pedido?","Atencao","YESNO")
   lConfirma := .t.
   Close(oDlgFirst)
EndIf   

Return


Static Function FDialog(nTipo)
************************************************************************************
* Dialog de Detalhes
***

Local oDlgAux

@ 000,000 To 195,500 DIALOG oDlgAux Title "Dados Adicionais do Pedido"
Do Case
   Case nTipo == 1 //Escopo
        @ 005,005 To 075,245 Title "Descricao do Escopo"        
        @ 010,010 Get cDetEscop Size 230,060 MEMO       
   Case nTipo == 2 //Condicoes Gerais
        @ 005,005 To 075,245 Title "Condicoes Gerais"        
        @ 010,010 Get cDetCondi Size 230,060 MEMO       
   Case nTipo == 3 //Documentos
        @ 005,005 To 075,245 Title "1 Documentos"        
        @ 010,010 Get cDetDocto Size 230,060 MEMO       
   Case nTipo == 4 //Prazo de Entrega
        @ 005,005 To 075,245 Title "2 Prazo de Entrega"        
        @ 010,010 Get cDetPrazo Size 230,060 MEMO       
   Case nTipo == 5 //Precos e Condicoes de Pagamento
        @ 005,005 To 075,245 Title "3 Precos e Condicoes de Pagamento/Faturamento"        
        @ 010,010 Get cDetPreco Size 230,060 MEMO       
   Case nTipo == 6 //Local de Entrega/Embalagem
        @ 005,005 To 075,245 Title "4 Local de Entrega/Embalagem"        
        @ 010,010 Get cDetLocal Size 230,060 MEMO       
   Case nTipo == 7 //Inspecao
        @ 005,005 To 075,245 Title "Inspecao"        
        @ 010,010 Get cDetInpec Size 230,060 MEMO       
   Case nTipo == 8 //Contatos
        @ 005,005 To 075,245 Title "Contatos"        
        @ 010,010 Get cDetConta Size 230,060 MEMO                                                               
   Case nTipo == 9 //Confirmacao do Pedido
        @ 005,005 To 075,245 Title "Confirmacao do Pedido"        
        @ 010,010 Get cDetConfi Size 230,060 MEMO                                                                       
EndCase

@ 080,210 BMPBUTTON Type 01 Action Close(oDlgAux)

Activate Dialog oDlgAux Centered

Return