#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ACERTAF()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Processa( {|| RunProc() },"Acerto do Cadastro de Fornecedores","Acertando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Acerto do Cadastro de Fornecedores","Acertando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

DbUseArea( .T.,, "S:\DADOSADV\FUNC.DBF", "FUN", if(.T. .OR. .F., !.F., NIL), .F. )
DbSelectArea("FUN")

IndRegua("FUN","FUNCIND","NOMFU",,,"Selecionando Registros...")

DbSelectArea("FUN") //Funcionarios
DbSetOrder(1)  //Nome
DbGoTop()
While ! Eof()
   DbSelectArea("SA2") //Fornecedores
   DbSetOrder(2) //Descricao+Loja
   If DbSeek(xFilial("SA2")+FUN->NOMFU+"01")
      IF RecLock("SA2",.f.)
         DbDelete()
         MsUnlock()
      EndIf
   EndIF
   DbSelectArea("FUN")
   DbSkip()
End
DbCommit()
DbSelectArea("SA2")
DbSetOrder(1)
DbGoTop()
While ! EOF()
   If Empty(A2_NOME)
      If RecLock("SA2",.f.)
         DbDelete()
         MsUnlock()
      EndIF
   EndIf
   DbSkip()
End
DbCommit()
MsgStop("Termino do Acerto de Fornecedores")

Return
