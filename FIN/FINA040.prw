#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function FINA040()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQFI4,CANO,CMES,CREV,CCCUSTO,CDESCRI")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FINA040  ³ Autor ³Ederson Dilney Colen M.³ Data ³13/01/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Gravacao do Saldo na inclusao de um titulo no    ³±±
±±³          ³ Contas a Receber.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±³          ³ Usado sobre o ponto de entrada.                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

If INCLUI

   aArqFI4 := { Alias() , IndexOrd() , Recno() }
   cAno    := SubStr(DtoS(M->E1_DATAREF),1,4)
   cMes    := SubStr(DtoS(M->E1_DATAREF),5,2)
   cRev    := "000"
   cCCusto := M->E1_SUBC+Space(11-Len(M->E1_SUBC))
   cDescri := M->E1_CLIENTE+M->E1_LOJA+Space(10-Len(M->E1_CLIENTE+M->E1_LOJA))

   dbSelectArea("SZB")
   dbSetOrder(1)
   dbSeek(xFilial("SZB")+cCCusto+cAno)

   While (! Eof())                                        .And. ;
         (Alltrim(SZB->ZB_CCUSTO) == Alltrim(M->E1_SUBC)) .And. ;
         (SZB->ZB_ANO             == cAno)

     If Val(cRev) < Val(SZB->ZB_Revisao)
        cRev := SZB->ZB_Revisao
     EndIf

     dbSelectArea("SZB")
     dbSkip()

   EndDo

   dbSelectArea("SZB")
   dbSetOrder(2)
   dbSeek(xFilial("SZB")+cCCusto+cAno+cRev+cDescri)

   While (!Eof())                                                  .And. ;
         (Alltrim(SZB->ZB_Descri) == M->E1_CLIENTE+M->E1_LOJA) .And. ;
         (Alltrim(SZB->ZB_CCUSTO) == Alltrim(M->E1_SUBC))        .And. ;
         (SZB->ZB_Ano             == cAno)                         .And. ;
         (SZB->ZB_Revisao         == cRev)                     

      dbSelectArea("SZ1")
      dbSetOrder(1)
      dbSeek(xFilial("SZ1")+M->E1_CODCONT+M->E1_CLIENTE+M->E1_LOJA)

      If Eof()
         MSGSTOP("Para este titulo nao existe um Contrato cadastrado.")
         dbSelectArea("SZB")
         dbSkip()
         Loop
      EndIf

      dbSelectArea("SZB")
      RecLoCk("SZB",.F.)
      Do Case
         Case cMes == "01"
              Replace ZB_SALD01 With SZB->ZB_SALD01 + M->E1_VALOR
         Case cMes == "02"
              Replace ZB_SALD02 With SZB->ZB_SALD02 + M->E1_VALOR
         Case cMes == "03"
              Replace ZB_SALD03 With SZB->ZB_SALD03 + M->E1_VALOR
         Case cMes == "04"
              Replace ZB_SALD04 With SZB->ZB_SALD04 + M->E1_VALOR
         Case cMes == "05"
              Replace ZB_SALD05 With SZB->ZB_SALD05 + M->E1_VALOR
         Case cMes == "06"
              Replace ZB_SALD06 With SZB->ZB_SALD06 + M->E1_VALOR
         Case cMes == "07"
              Replace ZB_SALD07 With SZB->ZB_SALD07 + M->E1_VALOR
         Case cMes == "08"
              Replace ZB_SALD08 With SZB->ZB_SALD08 + M->E1_VALOR
         Case cMes == "09"
              Replace ZB_SALD09 With SZB->ZB_SALD09 + M->E1_VALOR
         Case cMes == "10"
              Replace ZB_SALD10 With SZB->ZB_SALD10 + M->E1_VALOR
         Case cMes == "11"
              Replace ZB_SALD11 With SZB->ZB_SALD11 + M->E1_VALOR
         Case cMes == "12"
              Replace ZB_SALD12 With SZB->ZB_SALD12 + M->E1_VALOR
      EndCase

      MsUnLock()

      dbSelectArea("SZB")
      dbSkip()

   EndDo

   DbSelectArea(aArqFI4[1])
   DbSetOrder(aArqFI4[2])
   DbGoTo(aArqFI4[3])

EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
