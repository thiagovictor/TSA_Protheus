#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ACERSAL()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ,CCTRINI,CCTRFIM,NLASTKEY,NVALFAT,CINDEX")
SetPrvt("NINDEX,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ACERSAL  ³ Autor ³Eduardo Carraro        ³ Data ³ 31/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina para Acerto do valor Faturado e Saldos dos Contratos³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Processa( {|| Acerta() },"Recalculo dos Valores dos Contratos","Recalculando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(Acerta) },"Recalculo dos Valores dos Contratos","Recalculando Registro ..." )


*****************************************************************************
* Rotina de Recalculo
********************


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Acerta
Static Function Acerta()

aArq    := { Alias(), IndexOrd(), Recno() }
cCtrIni := "E0001"
cCtrFim := "E9999"
nLastKey:= 0
nValFat := 0

Perguntas()

If (nLastKey == 27)
   Return
EndIf

dbSelectArea("SF2")
cIndex:= CriaTrab(NIL,.F.)
IndRegua("SF2",cIndex,"F2_Filial+F2_Contrat+F2_Doc+F2_Serie",,,"Selecionando Registros ...")
//nIndex:=RetIndex("SF2")
//DbSetOrder(nIndex)

DbSelectArea("SZ1") //Contrato
DbSetOrder(1) //Filial+Cod+Cliente
Set SoftSeek On
DbSeek(xFilial("SZ1")+cCtrIni)
Set SoftSeek Off
ProcRegua(LastRec())
While !Eof() .and. Z1_COD <= cCtrFim 
   IncProc("Recalculando Registro")
   DbSelectArea("SF2") //Cabecalhos de Notas
   If DbSeek(xFilial("SF2") + AllTrim(SZ1->Z1_COD))
      While SF2->F2_CONTRAT == AllTrim(SZ1->Z1_COD) .and. ! Eof()
         DbSelectArea("SD2") //Itens Faturados
         DbSetOrder(3) //Filial +  Doc + Serie + Cliente + Loja
         If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
            While SD2->D2_DOC == SF2->F2_DOC .and. ;
                  SD2->D2_SERIE == SF2->F2_SERIE .AND. ;
                  SD2->D2_CLIENTE == SF2->F2_CLIENTE .AND. ;
                  SD2->D2_LOJA == SF2->F2_LOJA .AND. ! Eof()
               //Calcular Valor Jah Faturado
               nValFat := nValFat + D2_TOTAL
               DbSelectArea("SD2")
               DbSkip()
            End
         EndIf
         DbSelectArea("SF2")
         DbSkip()
      Enddo
   EndIf
   DbSelectArea("SZ1")
   If RecLock("SZ1",.f.)
      Do Case
         Case ! Empty(SZ1->Z1_VRADIT3)
              Replace Z1_VRSAL3 With Z1_VRPREV3-nValFat   //Valor do Saldo
         Case ! Empty(SZ1->Z1_VRADIT2)
              Replace Z1_VRSAL2 With Z1_VRPREV2-nValFat   //Valor do Saldo
         Case ! Empty(SZ1->Z1_VRADIT1)
              Replace Z1_VRSAL1 With Z1_VRPREV1-nValFat   //Valor do Saldo
         OtherWise  //Nao houver Aditivos
              Replace Z1_VRSAL With Z1_VRPREV-nValFat   //Valor do Saldo
      EndCase
      Replace Z1_VRSAL With Z1_VRPREV-nValFat   //Valor do Saldo
      Replace Z1_VRFAT With nValFat
      MsUnlock()
   EndIf
   nValFat := 0
   DbSelectArea("SZ1")
   DbSkip()
Enddo

//Restaurando Ambiente
DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])
RetIndex("SF2")
MsgBox("Recalculo Terminado Com Exito!","Termino","INFO")

Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Perguntas
Static Function Perguntas()
*****************************************************************************
* Chama perguntas na tela
*
***

@ 0,0 TO 125,400 DIALOG oDlgX TITLE "Recalculo de Saldos e Valores do Contrato"

@ 04,05 TO 058,195

@ 013,008 SAY "Contrato Inicial :"
@ 013,050 GET cCtrIni PICTURE "!99999"

@ 026,008 Say "Contrato Final: "
@ 026,050 Get cCtrFim Picture "!99999" Valid ! Empty(cCtrFim)

@ 042,015 BMPBUTTON TYPE 01 ACTION FConfirma()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 042,015 BMPBUTTON TYPE 01 ACTION Execute(FConfirma)
@ 042,045 BMPBUTTON TYPE 02 ACTION FCancela()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 042,045 BMPBUTTON TYPE 02 ACTION Execute(FCancela)
ACTIVATE DIALOG oDlgX CENTER

Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FConfirma
Static Function FConfirma()
*****************************************************************************
* Botao de confirmacao
*
***

Close(oDlgX)

RETURN


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FCancela
Static Function FCancela()
*****************************************************************************
* Botao de cancelamento
*
***

Close(oDlgX)

nLastkey := 27

Return

