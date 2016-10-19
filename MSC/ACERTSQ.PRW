#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ACERTSQ()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NSEQ,")

Processa( {|| RunProc() },"Acerto Sequencial de Itens","Acertando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Acerto Sequencial de Itens","Acertando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SZ1")  // CONTRATOS
dbSetOrder(1)        // Filial + Codigo
dbGoTop()
ProcRegua(RecCount())

While ! SZ1->(Eof())
   DbSelectArea("SZ2")
   DbSetOrder(2) //FILIAL+CONTRATO+subconta
   If DbSeek(xFilial("SZ2")+SZ1->Z1_COD)
      nSeq:=1
      While ! Eof() .and. SZ2->Z2_COD == SZ1->Z1_COD
            If RecLock("SZ2",.F.)
               Replace Z2_SEQ    With StrZero(nSeq,3)
               MsUnlock()
            EndIf
            nSeq:=nSeq+1
            DbSelectArea("SZ2")
            DbSkip()
      End
   EndIf
   DbSelectArea("SZ1")
   IncProc("Acertanto Registro "+StrZero(Recno(),6))
   DbSkip()
EndDo

MSGSTOP(" Reg. Incluidos Com Exito !" )

Return
