/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA410   ³ Autor ³Eduardo Carraro        ³ Data ³ 14/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Ponto de entrada para validar o total do pedido com o      ³±±
±±³          ³ contrato.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³          ALTERACOES REALIZADAS DESDE A CRIACAO                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Programador  ³  Data    ³  Descricao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Crislei     ³ 02/05/06 ³  Tratamento para atualizar titulos proviso-  ³±±
±±³             ³          ³  rios no Contas a Receber                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function MTA410()

Local lRet    :=.T. //Variavel de Retorno
Local nSaldo  := 0
Local nxI     := 0 
Local nPos1   := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C6_VALOR"})

Private cContrato := M->C5_CONTRAT
Private cNumPDV   := M->C5_NUM
Private dDataRefe := M->C5_DATAREF
Private nValPed   := 0

If AllTrim(cContrato) == ""
   Return(lRet)
EndIf

//SOMA O VALOR DOS ITENS DO PEDIDO DE VENDA PARA CHEGAR AO VALOR TOTAL DO PEDIDO
For nxI := 1 To Len(aCols)
    If ! aCols[nxI,Len(aHeader)+1] //Nao deletado
       nValPed:=nValPed+aCols[nXi,nPos1]
    EndIf
Next

DbSelectArea("SZ1") //Contratos
DbSetOrder(1)       //Filial+Contrato
If DbSeek(xFilial("SZ1")+cContrato)
   Do Case
      Case ! Empty(Z1_VRADIT3)
           nSaldo := SZ1->Z1_VRSAL3
      Case ! Empty(Z1_VRADIT2)
           nSaldo := SZ1->Z1_VRSAL2
      Case ! Empty(Z1_VRADIT1)
           nSaldo := SZ1->Z1_VRSAL1
      OtherWise   // Nao houver aditivos
           nSaldo := SZ1->Z1_VRSAL
   EndCase
EndIF
If nValPed > nSaldo
   If ! MsgBox("O Valor do Pedido Exedeu o Saldo em Aberto do Contrato!"+Chr(13)+Chr(13)+ ;
          "Valor do Pedido :" + TransForm(nValPed,"@E 999,999,999.99") + Chr(13) + Chr(13)+ ;
          "Saldo do Contrato :" + TransForm(nSaldo,"@E 9,999,999.99"),"ATENCAO","YESNO")
      lRet:=.F.
   EndIf
EndIf

If cFilAnt $ "01" //Executa este tratamento apenas para EPC.
   If INCLUI //Verifica apenas na inclusão do pedido de venda.
      If lRet
         FAtuaProv()
      EndIf
   EndIf
EndIf

Return(lRet)


Static Function FAtuaProv()
**************************************************************************************************************
* Atualiza titulos provisorios referentes a receita de contratos (De acordo com o contrato informado no Pedido)
* 
****
/*
CRIAR INDICE NO SE1 POR CONTRATO + DATA DE REFERENCIA
*/
Local nRespUsu  := 0 
Local aSaveArea := {Alias(), IndexOrd(), Recno()}
Local aSaveSE1  := {"SE1",SE1->(IndexOrd()), SE1->(Recno())}


dbSelectArea("SE1")
dbOrderNickName("USUSE101") //dbSetOrder(19) //Indice a ser criado
dbSeek(xFilial("SE1")+cContrato+DTOS(dDataRefe)+"EST"+cContrato+" PR ")


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se não localizar nenhum titulo com o numero do contrato na data de referencia entende-se como:³
//³"não existe titulo provisorio para este Pedido de Venda"                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
If Eof()
   Return()
EndIf

nRespUsu := Aviso(OemToAnsi("Titulo Provisorio"),"Foi localizado um titulo provisorio no valor de R$ " + Transform(SE1->E1_VALOR,"@E 999,999,999.99") + ;
". O valor do pedido incluido é de R$ " + Transform(nValPed,"@E 999,999,999.99") + ". O que deseja fazer?",{"Excluir PR","Alterar PR","Ignorar"})

Do Case 
   Case nRespUsu == 1
      If RecLock("SE1",.F.)
         dbDelete()
         MsUnlock()
      EndIf
   Case nRespUsu == 2 
      If RecLock("SE1",.F.)
         Replace SE1->E1_VALOR  With SE1->E1_VALOR - nValPed
         Replace SE1->E1_SALDO  With SE1->E1_SALDO - nValPed
         Replace SE1->E1_VLCRUZ With SE1->E1_VLCRUZ - nValPed
         MsUnlock()
      EndIf
EndCase

/*
If nValPed >= SE1->E1_VALOR
   If !MsgBox(OemToAnsi("Existe titulo provisorio (PR) lançado para este contrato. Deseja Excluí-lo?"),"Titulo Provisório","YESNO")
      Return()
   EndIf
   If RecLock("SE1",.F.)
      dbDelete()
      MsUnlock()
   EndIf
//ElseIf nValPed < SE1->E1_VALOR
Else
   If !MsgBox(OemToAnsi("O valor do titulo provisorio (PR) lançado para este contrato é superior a este pedido de venda. Deseja atualizá-lo?"),"Titulo Provisorio","YESNO")
      Return()
   EndIf
   If RecLock("SE1",.F.)
      Replace SE1->E1_VALOR  With SE1->E1_VALOR - nValPed
      Replace SE1->E1_SALDO  With SE1->E1_SALDO - nValPed
      Replace SE1->E1_VLCRUZ With SE1->E1_SALDO - nValPed
      MsUnlock()
   EndIf
EndIf
*/



dbSelectArea(aSaveSE1[01])
dbSetOrder(aSaveSE1[02])
dbGoTo(aSaveSE1[03])

dbSelectArea(aSaveArea[01])
dbSetOrder(aSaveArea[02])
dbGoTo(aSaveArea[03])

Return