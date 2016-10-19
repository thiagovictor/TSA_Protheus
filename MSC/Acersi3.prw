#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function Acersi3()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NCONT,")

Processa( {|| RunProc() },"Acerto das Sub-Contas no SI3","Acertando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Acerto das Sub-Contas no SI3","Acertando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

nCont:=0
DbSelectArea("SZ2")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())
While ! Eof()
  IncProc()
  DbSelectArea("SI3") // Centro de Custos
  DbSetOrder(1)
  If ! DbSeek(xFilial("SI3")+SZ2->Z2_SUBC) //Nao Encontrou e Deve Criar
     If RecLock("SI3",.T.)
        Replace I3_FILIAL With xFilial("SI3")
        Replace I3_CUSTO   With SZ2->Z2_SUBC
        Replace I3_MOEDA   With "1"
        Replace I3_DESC    With SZ2->Z2_DESC
        Replace I3_SITUAC  With SZ2->Z2_SITUAC
        MsUnlock()
     EndIf
  EndIf
  DbSelectArea("SZ2")
  DbSkip()
End

MsgBox("Termino de Acerto de Sub-Contas !","Processo Terminado","INFO")

Return
