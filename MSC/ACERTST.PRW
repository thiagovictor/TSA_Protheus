#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ACERTST()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NCONT,")

Processa( {|| RunProc() },"Acerto das Situacoes dos Itens do Contrato","Acertando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Acerto das Situacoes dos Itens do Contrato","Acertando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

nCont:=0
DbSelectArea("SZ1")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())
While ! Eof()
  IncProc()
  DbSelectArea("SZ2")
  DbSetOrder(1)
  IF DbSeek(xFilial("SZ2")+SZ1->Z1_COD)
     While ! Eof() .and. xFilial("SZ2") == Z2_FILIAL .and. SZ2->Z2_COD == SZ1->Z1_COD
       If SZ1->Z1_SITUAC <> "0"
          If RecLock("SZ2",.f.)
             Replace Z2_SITUAC With SZ1->Z1_SITUAC
             MsUnlock()
             DbSelectArea("CTT")
             DbSetOrder(1)
             If DbSeek(xFilial("CTT")+SZ2->Z2_SUBC)
                If RecLock("CTT",.F.)
                   Replace CTT_SITUAC With SZ1->Z1_SITUAC
                   MsUnLock()
                EndIf
             EndIf
             DbSelectArea("CTD")
             DbSetOrder(1)
             If DbSeek(xFilial("CTD")+SZ2->Z2_SUBC)
                If RecLock("CTD",.F.)
                   Replace CTD_SITUAC With SZ1->Z1_SITUAC
                   MsUnLock()
                EndIf
             EndIf                          
          EndIf
       EndIf
       DbSelectArea("SZ2")
       DbSkip()
     End
  EndIf
  DbSelectArea("SZ1")
  DbSkip()
End
MsgBox("Termino do Acerto de Itens !","Processo Terminado","INFO")

Return
