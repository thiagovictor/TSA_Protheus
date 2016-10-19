#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function IMPORTFO()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NFONOVO,NNEWCOD,")

Processa( {|| RunProc() },"Importacao do Cad. de Fornecedores","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Importacao do Cad. de Fornecedores","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SA2")  // Fornecedores
dbSetOrder(1)        // Filial + Cod_For
nFoNovo:=0
nNewCod:=1
DbUseArea( .T.,, "T:\SIGAADV\FUNC.DBF", "FORNECEDOR", if(.T. .OR. .F., !.F., NIL), .F. )
dbSelectArea("FORNECEDOR")
dbGoTop()
ProcRegua(RecCount())
While ! Eof()
   IncProc("Gravando Registro : "+StrZero(Recno(),6))
   DbSelectArea("SA2")
   dbSetOrder(1)
   If Reclock("SA2",.T.)
      Replace A2_FILIAL  With XFilial("SA2")
      Replace A2_COD     With StrZero(nNewCod,6)
      Replace A2_LOJA    With "01" 
      Replace A2_TIPO    With "FISICA"
      Replace A2_NOME    With FORNECEDOR->NOMFU
      Replace A2_END     With FORNECEDOR->ENDFU
      Replace A2_MUN     With FORNECEDOR->CIDFU
      Replace A2_EST     With FORNECEDOR->UFEFU
      Replace A2_CEP     With FORNECEDOR->CEPFU
      Replace A2_TEL     With FORNECEDOR->TELFU
      Replace A2_CGC     With FORNECEDOR->CPFFU
      Replace A2_BAIRRO  With FORNECEDOR->BAIFU
      nFoNovo := nFoNovo + 1
      nNewCod := nNewCod + 1
      MsUnlock()
   EndIf
   DbSelectArea("FORNECEDOR")
   DbSkip()
EndDo

dbSelectArea("FORNECEDOR")
Use

MSGSTOP(Str(nFoNovo,6) + " Reg. Incluidos Com Exito !" )

Return
