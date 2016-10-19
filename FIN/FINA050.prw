#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function FINA050()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQFI5,CANO,CMES,CREV,CCCUSTO,CDESCRI")
SetPrvt("LTITUOK,NVALRTITU,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FINA050  ³ Autor ³Ederson Dilney Colen M.³ Data ³13/01/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Gravacao do Saldo na inclusao de um titulo no    ³±±
±±³          ³ Contas a Pagar.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±³          ³ Usado sobre o ponto de entrada.                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

If INCLUI

   aArqFI5   := { Alias() , IndexOrd() , Recno() }
   cAno      := SubStr(DtoS(M->E2_DATAREF),1,4)
   cMes      := SubStr(DtoS(M->E2_DATAREF),5,2)
   cRev      := "000"
   cCCusto   := M->E2_CC+Space(11-Len(M->E2_CC))
   cDescri   := M->E2_FORNECE+M->E2_LOJA+Space(10-Len(M->E2_FORNECE+M->E2_LOJA))
   lTituOK   := .T.
   nValrTitu := 0

   If Alltrim(cDescri) == "00090701"

      dbSelectArea("SZB")
      dbSetOrder(3)
      dbSeek(xFilial("SZB")+"E")

      nValrTitu := M->E2_VALOR

      While (!Eof())                            .And. ;
            (SZB->ZB_FILIAL == xFilial("SZB"))  .And. ;
            (SZB->ZB_TIPO   == "E")

         dbSelectArea("SZB")
         RecLoCk("SZB",.F.)
         Do Case
            Case cMes == "01"
                 If ((nValrTitu - SZB->ZB_MES01) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD01 With SZB->ZB_MES01
                 nValrTitu := nValrTitu - SZB->ZB_MES01
            Case cMes == "02"
                 If ((nValrTitu - SZB->ZB_MES02) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD02 With SZB->ZB_MES02
                 nValrTitu := nValrTitu - SZB->ZB_MES02
            Case cMes == "03"
                 If ((nValrTitu - SZB->ZB_MES03) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD03 With SZB->ZB_MES03
                 nValrTitu := nValrTitu - SZB->ZB_MES03
            Case cMes == "04"
                 If ((nValrTitu - SZB->ZB_MES04) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD04 With SZB->ZB_MES04
                 nValrTitu := nValrTitu - SZB->ZB_MES04
            Case cMes == "05"
                 If ((nValrTitu - SZB->ZB_MES05) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD05 With SZB->ZB_MES05
                 nValrTitu := nValrTitu - SZB->ZB_MES05
            Case cMes == "06"
                 If ((nValrTitu - SZB->ZB_MES06) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD06 With SZB->ZB_MES06
                 nValrTitu := nValrTitu - SZB->ZB_MES06
            Case cMes == "07"
                 If ((nValrTitu - SZB->ZB_MES07) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD07 With SZB->ZB_MES07
                 nValrTitu := nValrTitu - SZB->ZB_MES07
            Case cMes == "08"
                 If ((nValrTitu - SZB->ZB_MES08) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD08 With SZB->ZB_MES08
                 nValrTitu := nValrTitu - SZB->ZB_MES08
            Case cMes == "09"
                 If ((nValrTitu - SZB->ZB_MES09) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD09 With SZB->ZB_MES09
                 nValrTitu := nValrTitu - SZB->ZB_MES09
            Case cMes == "10"
                 If ((nValrTitu - SZB->ZB_MES10) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD10 With SZB->ZB_MES10
                 nValrTitu := nValrTitu - SZB->ZB_MES10
            Case cMes == "11"
                 If ((nValrTitu - SZB->ZB_MES11) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD11 With SZB->ZB_MES11
                 nValrTitu := nValrTitu - SZB->ZB_MES11
            Case cMes == "12"
                 If ((nValrTitu - SZB->ZB_MES12) < 0)
                    dbSelectArea("SZB")
                    dbSkip()
                    Loop
                 EndIf
                 Replace ZB_SALD12 With SZB->ZB_MES12
                 nValrTitu := nValrTitu - SZB->ZB_MES12
         EndCase
         MsUnLock()

         dbSelectArea("SZB")
         dbSkip()

      EndDo

      nValrTitu := 0

   Else

      dbSelectArea("SZB")
      dbSetOrder(1)
      dbSeek(xFilial("SZB")+Alltrim(cCCusto)+cAno)

      While (! Eof())                                      .And. ;
            (SZB->ZB_FILIAL          == xFilial("SZB"))    .And. ;
            (Alltrim(SZB->ZB_CCUSTO) == Alltrim(M->E2_CC)) .And. ;
            (SZB->ZB_ANO             == cAno)

        If Val(cRev) < Val(SZB->ZB_Revisao)
           cRev := SZB->ZB_Revisao
        EndIf

        dbSelectArea("SZB")
        dbSkip()
      EndDo

      dbSelectArea("SZB")
      dbSetOrder(2)
      dbSeek(xFilial("SZB")+Alltrim(cCCusto)+cAno+cRev+cDescri)

      While (!Eof())                                              .And. ;
            (SZB->ZB_FILIAL          == xFilial("SZB"))           .And. ;
            (Alltrim(SZB->ZB_CCUSTO) == Alltrim(M->E2_CC))        .And. ;
            (SZB->ZB_Ano             == cAno)                     .And. ;
            (SZB->ZB_Revisao         == cRev)                     .And. ;
            (Alltrim(SZB->ZB_Descri) == M->E2_FORNECE+M->E2_LOJA)

         If SZB->ZB_TIPO <> "D"
            dbSelectArea("SZ2")
            dbSetOrder(3)
            dbSeek(xFilial("SZ2")+Alltrim(cCCusto))
  
            dbSelectArea("SZC")
            dbSetOrder(2)
            dbSeek(xFilial("SZC")+SZ2->Z2_COD+M->E2_FORNECE+M->E2_LOJA)

            If Eof()
               MSGSTOP("Para este titulo nao existe um Contrato x Fornecedor.")
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf
         EndIf

         dbSelectArea("SZB")
         RecLoCk("SZB",.F.)
         Do Case
            Case cMes == "01"
                 If SZB->ZB_MES01 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD01 With SZB->ZB_SALD01 + M->E2_VALOR
            Case cMes == "02"
                 If SZB->ZB_MES02 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD02 With SZB->ZB_SALD02 + M->E2_VALOR
            Case cMes == "03"
                 If SZB->ZB_MES03 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD03 With SZB->ZB_SALD03 + M->E2_VALOR
            Case cMes == "04"
                 If SZB->ZB_MES04 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD04 With SZB->ZB_SALD04 + M->E2_VALOR
            Case cMes == "05"
                 If SZB->ZB_MES05 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD05 With SZB->ZB_SALD05 + M->E2_VALOR
            Case cMes == "06"
                 If SZB->ZB_MES06 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD06 With SZB->ZB_SALD06 + M->E2_VALOR
            Case cMes == "07"
                 If SZB->ZB_MES07 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD07 With SZB->ZB_SALD07 + M->E2_VALOR
            Case cMes == "08"
                 If SZB->ZB_MES08 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD08 With SZB->ZB_SALD08 + M->E2_VALOR
            Case cMes == "09"
                 If SZB->ZB_MES09 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD09 With SZB->ZB_SALD09 + M->E2_VALOR
            Case cMes == "10"
                 If SZB->ZB_MES10 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD10 With SZB->ZB_SALD10 + M->E2_VALOR
            Case cMes == "11"
                 If SZB->ZB_MES11 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD11 With SZB->ZB_SALD11 + M->E2_VALOR
            Case cMes == "12"
                 If SZB->ZB_MES12 < M->E2_VALOR
                    lTituOK := .F.
                 EndIf
                 Replace ZB_SALD12 With SZB->ZB_SALD12 + M->E2_VALOR
         EndCase
         MsUnLock()

         dbSelectArea("SZB")
         dbSkip()

      EndDo

      If !lTituOK
         dbSelectArea("SE2")
         RecLoCk("SE2",.F.)
         Replace E2_TITUOK With "N"
         MsUnLock()
      EndIf

   EndIf

   DbSelectArea(aArqFI5[1])
   DbSetOrder(aArqFI5[2])
   DbGoTo(aArqFI5[3])

EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
