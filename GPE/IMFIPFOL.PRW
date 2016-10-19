#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function IMFIPFOL()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LTESTPATH,NLASTKEY,CMESBASE,CDIREARQU,CARQ1,CARQ2")
SetPrvt("CCABECALHO,CMSGREGUA,CPATHARQU,CARQUFIP,CARQUFOL,CARQUPAM")
SetPrvt("CARQ3,ASTRU,CARQ4,CARQ5,NTOTASALA,DDTBASE")
SetPrvt("CFUNCANTE,")

/*

CRIAR ARQUIVO SZ6

Z6_Filial
Z6_CodVerb
Z6_ContDeb
Z6_ContCrR
Z6_ContCrN
Z6_Sinal

CRIAR CAMPO NO ARQUIVO SZ7

Z7_ContCtb

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IMFIPFOL  ³ Autor ³ Marcus Augusto        ³ Data ³08.12.99  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de dados dos sistema FIP e FOLHA METACON        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO PARA EPC                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR ³ DATA  ³ MOTIVO DA ALTERACAO                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³       ³                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

lTestPath  := .F.
nLastKey   := 0

Private cMesBase  := "012000"
Private cDireArqu := "\\Epcs02_11_9733\D\ap6\ap_data\download" + Space(15)
//cDireArqu := space(50)
Private cArq1     := ""
Private cInd1     := ""
Private cArq2     := ""
Private cInd2     := ""
Private cArq3     := ""
Private cInd3     := ""

set century on

Perguntas()
If ! TestPath()
   Return
EndIf

If (nLastKey == 27) .or. (! lTestPath)
   Return
EndIf

FCriaArq()

cCabecalho := "Importacao de Arquivos dos Sistemas de FIP e FOLHA METACON"
cMsgRegua  := "Processando "

Processa( {|| FGravArq()} ,cCabecalho,cMsgRegua )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(FGravArq)} ,cCabecalho,cMsgRegua )

set century off

Return

RETURN



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Perguntas
Static Function Perguntas()
*****************************************************************************
* Chama perguntas na tela
*
***

@ 0,0 TO 125,400 DIALOG oDlgX TITLE "Importacao de Dados dos Sistema FIP e FOLHA METACON"

@ 04,05 TO 058,195

@ 013,008 SAY "Mes Base :"
@ 013,045 GET cMesBase PICTURE "@R 99/9999" valid FValMes() size 30,07 // Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 013,045 GET cMesBase PICTURE "@R 99/9999" valid Execute(FValMes)

@ 026,008 Say "Caminho : "
@ 026,045 Get cDireArqu   Picture "@!S26" VALID TestPath() size 100,07 // Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 026,045 Get cDireArqu   Picture "@!S26" VALID Execute(TestPath)

@ 042,015 BMPBUTTON TYPE 01 ACTION FConfirma()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 042,015 BMPBUTTON TYPE 01 ACTION Execute(FConfirma)
@ 042,045 BMPBUTTON TYPE 02 ACTION FCancela()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 042,045 BMPBUTTON TYPE 02 ACTION Execute(FCancela)
ACTIVATE DIALOG oDlgX CENTER

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FValMes
Static Function FValMes()
*****************************************************************************
* Validacao do Mes base
*
***

If (SubStr(cMesBase,1,2) >= "01" .and. SubStr(cMesBase,1,2) <= "12" .and. SubStr(cMesBase,3,4) >= "1980" .and. SubStr(cMesBase,3,4) <= "2099")
   dbSelectArea("SZ7")
   dbSetOrder(2)
   DbSeek(xFilial("SZ7")+DToS(CToD("01/"+SubStr(cMesBase,1,2)+"/"+SubStr(cMesBase,5,4))))

   If ! Eof()
      If MsgYesNo("Esse mes ja foi importado. Deseja sobrepor ?")
         Return(.T.)
      Else
         Return(.F.)
      EndIf
   EndIf

   RETURN(.T.)
Else
   MsgStop("Data Invalida!")
   RETURN(.F.)
EndIf



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FConfirma
Static Function FConfirma()
*****************************************************************************
* Botao de confirmacao
*
***

Close(oDlgX)
lTestPath := .T.

RETURN



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FCancela
Static Function FCancela()
*****************************************************************************
* Botao de cancelamento
*
***

Close(oDlgX)

nLastkey := 27

RETURN




// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function TestPath
Static Function TestPath()
*****************************************************************************
* Testa se a path e correta
*
***

cPathArqu := Upper(IIf(Right(AllTrim(cDireArqu),1)=="\",AllTrim(cDireArqu),AllTrim(cDireArqu)+"\"))
cArquFIP  := "FIP.DBF"
cArquFOL  := "ADP03B.DBF"
cArquPAM  := "ADPAM"+SubStr(cMesBase,5,2)+".DBF"
cArq1     := cPathArqu + cArquFIP
cInd1     := cPathArqu + "FIP"
cArq2     := cPathArqu + cArquFOL
cInd2     := cPathArqu + "ADP03B"
cArq3     := cPathArqu + cArquPAM
cInd3     := cPathArqu + "ADPAM"+SubStr(cMesBase,5,2)

If !file(cArq1) .Or. ;
   !file(cArq2) .Or. ;
   !file(cArq3)

   MsgStop( " Arquivo "+cArquFOL+" ou "+cArquFIP+" ou "+cArquPAM+" nao se encontram no "+Chr(13)+Chr(10)+;
            " diretorio "+cPathArqu)
   Return(.F.)
EndIf

lTestPath := .T.

Return(.T.)



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FCriaArq
Static Function FCriaArq()
******************************************************************************
* Criacao de arquivos de trabalho
*
***

// Arquivo da FIP
dbUseArea( .T.,,cArq1,"FIP",.F.,.F.)
IndRegua("FIP",cInd1,"Matr_Fi",,,"Selecionando Registros...")

// Arquivo da Folha Metacon
dbUseArea( .T.,,cArq2,"FOLHA",.F.,.F.)
IndRegua("FOLHA",cInd2,"NumFu+DigFu",,,"Selecionando Registros...")

// Arquivo da Folha Metacon (ADPAM99)
dbUseArea( .T.,,cArq3,"PAM",.F.,.F.)
IndRegua("PAM",cInd3,"PerPg+NumFu",,,"Selecionando Registros...")

// Arquivo da Folha Metacon (VERBA)
//dbUseArea( .T.,,"C:\temp\VERBA1.DBF","VERBA",.F.,.F.)

aStru := {}
AADD(aStru, {"NumFunc","C", 05, 0 })
AADD(aStru, {"TotApro","N", 16, 2 })
AADD(aStru, {"HorParc","N", 06, 2 })
AADD(aStru, {"ContCre","C", 20, 0 })
AADD(aStru, {"ContDeb","C", 20, 0 })

cArq4 := CriaTrab(aStru, .T.)
dbUseArea(.T.,, cArq4, "TRABALHO",.F.)

dbSelectArea("TRABALHO")
IndRegua("TRABALHO",cArq4,"NumFunc+ContDeb",,,"Criando Arquivo Trabalho ...")

aStru := {}
AADD(aStru, {"NumFunc","C", 05, 0 })
AADD(aStru, {"CentCus","C", 09, 0 })
AADD(aStru, {"HorCCus","N", 06, 2 })

cArq5 := CriaTrab(aStru, .T.)
dbUseArea(.T.,, cArq5, "TRCENCUS",.F.)

dbSelectArea("TRCENCUS")
IndRegua("TRCENCUS",cArq5,"NumFunc+CentCus",,,"Criando Arquivo Trabalho ...")

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FGravArq
Static Function FGravArq()
*****************************************************************************
* Gravacao de Arquivo para Exportacao
*
***

DbSelectArea("PAM")
DbSeek(Substr(cMesBase,1,2))

ProcRegua(lastrec())

While (! Eof()) .And. (Substr(cMesBase,1,2) == PAM->PerPg)

  IncProc()

  DbSelectArea("FOLHA")
  DbSeek(PAM->NumFu)

  If Eof()
     MsgStop("O funcionario de matricula : "+PAM->NumFu+" nao se encontra no arquivo da Folha !")
     DbSelectArea("PAM")
     DBSkip()
     loop
  EndIf

  dbSelectArea("SZ6")
  dbSeek(xFilial("SZ6")+PAM->Verba)

  If Eof()
     dbSelectArea("PAM")
     DbSkip()
     LOOP
  EndIf

   If SubStr(FOLHA->DReFu,1,2) == "  " 
   //If Empty(FOLHA->DReFu)

     DbSelectArea("TRABALHO")
     DbSeek(PAM->NumFu+SZ6->Z6_ContDeb)

     If Eof()
        RecLock("TRABALHO",.T.)
        Replace NumFunc With PAM->NumFu
        Replace ContCre With SZ6->Z6_ContCrN
        Replace ContDeb With SZ6->Z6_ContDeb
      Else
        RecLock("TRABALHO",.F.)
      EndIf
   Else
      DbSelectArea("TRABALHO")
      DbSeek(PAM->NumFu+SZ6->Z6_ContDeb)

      If Eof()
         RecLock("TRABALHO",.T.)
         Replace NumFunc With PAM->NumFu
         Replace ContCre With SZ6->Z6_ContCrR
         Replace ContDeb With SZ6->Z6_ContDeb
      Else
         RecLock("TRABALHO",.F.)
      EndIf
   EndIf

   If SZ6->Z6_Sinal == "-"
      Replace TotApro With TotApro - PAM->ValAp  // Total da apropriacao da
                                                 // verba negativa
   Else
      Replace TotApro With TotApro + PAM->ValAp  // Total da apropriacao da
                                                  // verba positiva
   EndIf

   MsUnLock()

   If ! Empty(TRABALHO->HorParc)
      dbSelectArea("PAM")
      DbSkip()
      loop
   EndIf

   DbSelectArea("FIP")
   dbSeek(PAM->NumFu)

   While (! Eof()) .And. SubStr(FIP->Matr_Fi,1,5) == PAM->NumFu

      If Empty(FIP->Cod_STA) .Or. SubStr(FIP->Cod_STA,1,4) == "9999"
         DbSelectArea("FIP")
         DBSkip()
         loop
      EndIf

      If FIP->Seq_FI == 998 .Or. FIP->Seq_FI == 999
         DbSelectArea("FIP")
         DBSkip()
         loop
      EndIf

      DbSelectArea("TRABALHO")
//      DbSeek(SubStr(FIP->Matr_Fi,1,5))

      RecLock("TRABALHO",.F.)
      Replace HorParc With TRABALHO->HorParc + FIP->THonor_FI  // Total de Horas por func.
      MsUnLock()

      dbSelectArea("FIP")
      DbSkip()
   EndDo

   dbSelectArea("PAM")
   DbSkip()
EndDo

DbSelectArea("FIP")
dbGoTop()

While (! Eof())

   If Empty(FIP->Cod_STA) .Or. SubStr(FIP->Cod_STA,1,4) == "9999"
      DbSelectArea("FIP")
      DBSkip()
      loop
   EndIf

   If FIP->Seq_FI == 998 .Or. FIP->Seq_FI == 999
      DbSelectArea("FIP")
      DBSkip()
      loop
   EndIf

   DbSelectArea("TRCENCUS")
   DbSeek(SubStr(FIP->Matr_Fi,1,5)+FIP->Cod_STA)

   If Eof()
      RecLock("TRCENCUS",.T.)
      Replace NumFunc With SubStr(FIP->Matr_Fi,1,5)  // Codigo do funcionario
      Replace CentCus With FIP->Cod_STA              // Centro de Custo
   Else
      RecLock("TRCENCUS",.F.)
   EndIf

   Replace HorCCus With HorCCus + FIP->THonor_FI  // Total de horas por func.
   MsUnLock()                                  // e centro de custo

   dbSelectArea("FIP")
   DbSkip()
EndDo

DbSelectArea("TRCENCUS")
DbGoTop()

ProcRegua(lastrec())

While (! Eof())

   IncProc()

   dbSelectArea("TRABALHO")
   DbSeek(TRCENCUS->NumFunc)

   While ! Eof() .And. (TRABALHO->NumFunc == TRCENCUS->NumFunc)

      nTotaSala := (TRABALHO->TotApro*TRCENCUS->HorCCus)/TRABALHO->HorParc

      dbSelectArea("SZ7")
      dbSetOrder(1)
      DbSeek(xFilial("SZ7")+TRCENCUS->NumFunc+" "+SubStr(TRCENCUS->CentCus,1,5)+"    "+TRABALHO->ContDeb)

      If Eof()
         RecLock("SZ7",.T.)
         replace Z7_Filial  With xFilial("SZ7")
         replace Z7_CCusto  With SubStr(TRCENCUS->CentCus,1,5)     // Centro de Custo
         replace Z7_NumFu   With TRCENCUS->NumFunc     // Codigo do Funcionario
         replace Z7_ContCre With TRABALHO->ContCre     // Conta contabil credito
         replace Z7_ContDeb With TRABALHO->ContDeb     // Conta contabil debito

         dDtBase := CToD("01/"+SubStr(cMesBase,1,2)+"/"+SubStr(cMesBase,3,4))

         replace Z7_DtLanc With dDtBase              // DataBase
      Else
         RecLock("SZ7",.F.)
      EndIf

      replace Z7_VlHoPer With Z7_VlHoPer + nTotaSala   // Total de horas no periodo

      MsUnLock()

      DbSelectArea("TRABALHO")
      DbSkip()
   EndDo
   DbSelectArea("TRCENCUS")
   DbSkip()
EndDo

RETURN


/*
DbSelectArea("FIP")
DbSeek(Substr(cMesBase,1,2)+Substr(cMesBase,5,2))

ProcRegua(lastrec())

While (! Eof()) .And. FIP->Mes_Ano_Fi == (Substr(cMesBase,1,2)+Substr(cMesBase,5,2))

   IncProc()

   If Empty(FIP->Cod_STA) .Or. SubStr(FIP->Cod_STA,1,4) == "9999"
      DbSelectArea("FIP")
      DBSkip()
      loop
   EndIf

   If FIP->Seq_FI == 998 .Or. FIP->Seq_FI == 999
      DbSelectArea("FIP")
      DBSkip()
      loop
   EndIf

   DbSelectArea("FOLHA")
   DbSeek(FIP->Matr_Fi)

   If Eof()
      MsgStop("O funcionario de matricula : "+FOLHA->Matr_Fi+" nao se encontra no arquivo da Folha !")
      DbSelectArea("FIP")
      DBSkip()
      loop
   EndIf

   //---------------- Gravacao dos salarios somando as verbas --------------//

   If cFuncAnte <> SubStr(FIP->Matr_Fi,1,5)
      DbSelectArea("PAM")
      DbSeek(SubStr(FIP->Matr_Fi,1,5)+SubStr(FIP->Mes_Ano_Fi,1,2))

      While (! Eof())                                   .And. ;
            (SubStr(FIP->Matr_Fi,1,5)    == PAM->NumFu) .And. ;
            (SubStr(FIP->Mes_Ano_Fi,1,2) == PAM->PerPg)

         cFuncAnte := SubStr(FIP->Matr_Fi,1,5)

         dbSelectArea("SZ6")
         dbSeek(xFilial("SZ6")+PAM->Verba)

         If Eof()
            dbSelectArea("PAM")
            DbSkip("PAM")
            LOOP
         EndIf
         
         If SubStr(FOLHA->DReFu,1,2) == "  " 
         //If Empty(FOLHA->DReFu)
            DbSelectArea("TRABALHO")
            DbSeek(SubStr(FIP->Matr_Fi,1,5)+SZ6->Z6_ContDeb) // Conta credito normal, ou seja sem recisao
            If Eof()
               RecLock("TRABALHO",.T.)
               Replace NumFunc With SubStr(FIP->Matr_Fi,1,5)  // Codigo do funcionario
               Replace ContCre With SZ6->Z6_ContCrN
               Replace ContDeb With SZ6->Z6_ContDeb
            Else
               RecLock("TRABALHO",.F.)
            EndIf

         Else
            DbSelectArea("TRABALHO")
            DbSeek(SubStr(FIP->Matr_Fi,1,5)+SZ6->Z6_ContDeb)     // Conta credito com recisao

            If Eof()
               RecLock("TRABALHO",.T.)
               Replace NumFunc With SubStr(FIP->Matr_Fi,1,5)  // Codigo do funcionario
               Replace ContCre With SZ6->Z6_ContCrR
               Replace ContDeb With SZ6->Z6_ContDeb
            Else
               RecLock("TRABALHO",.F.)
            EndIf
         EndIf

//         If SubStr(AllTrim(SX5->X5_Chave),1,1) == "-"

         If SZ6->Z6_Sinal == "-"
            Replace TotApro With TotApro - PAM->ValAp  // Total da apropriacao da
                                                       // verba negativa
         Else
            Replace TotApro With TotApro + PAM->ValAp  // Total da apropriacao da
                                                       // verba positiva
         EndIf

         MsUnLock()

         dbSelectArea("PAM")
         DbSkip("PAM")
      EndDo
   EndIf

   //---------- Gravacao das horas independente do centro de custo ---------//

   DbSelectArea("TRABALHO")
   DbSeek(SubStr(FIP->Matr_Fi,1,5))

   RecLock("TRABALHO",.F.)
   Replace HorParc With HorParc + FIP->THonor_FI  // Total de Horas por func.
   MsUnLock()

   //--------- Gravacao das horas de acordo com o centro de custo ----------//

   DbSelectArea("TRCENCUS")
   DbSeek(SubStr(FIP->Matr_Fi,1,5)+FIP->Cod_STA)

   If Eof()
      RecLock("TRCENCUS",.T.)
      Replace NumFunc With SubStr(FIP->Matr_Fi,1,5)  // Codigo do funcionario
      Replace CentCus With FIP->Cod_STA  // Centro de Custo
   Else
      RecLock("TRCENCUS",.F.)
   EndIf

   Replace HorCCus With HorCCus + FIP->THonor_FI  // Total de horas por func.
   MsUnLock()                                  // e centro de custo

   DbSelectArea("FIP")
   DbSkip("FIP")
EndDo

*/
