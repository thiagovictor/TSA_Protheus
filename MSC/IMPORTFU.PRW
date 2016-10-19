#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function IMPORTFU()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NNOVOCOD,NFUNOVO,")

Processa( {|| RunProc() },"Importacao do Cad. de Funcionarios","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Importacao do Cad. de Funcionarios","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SA2")  // Fornecedores
dbSetOrder(1)        // Filial + Cod_For
DbGoBottom()         //Ultimo codigo
nNovoCod:=646
nFuNovo:=0
DbUseArea( .T.,, "S:\DADOSADV\FUNC.DBF", "CT", if(.T. .OR. .F., !.F., NIL), .F. )
DbSelectArea("CT")
dbGoTop()
ProcRegua(RecCount())
While ! Eof()
   IncProc("Gravando Registro : "+StrZero(Recno(),6))
   DbSelectArea("SA2")
   dbSetOrder(1)
   If Reclock("SA2",.T.)
      Replace A2_FILIAL  With xFilial("SA2")
      Replace A2_COD     With StrZero(nNovoCod,6)
      Replace A2_LOJA    With "01" 
      Replace A2_TIPO    With "F"
      Replace A2_NOME    With CT->NOMFU
      Replace A2_NREDUZ  With CT->NOMFU
      Replace A2_END     With CT->ENDFU
      Replace A2_MUN     With CT->CIDFU
      Replace A2_EST     With CT->UFEFU
      Replace A2_CEP     With CT->CEPFU
      Replace A2_TEL     With CT->TELFU
      Replace A2_CGC     With CT->CPFFU
      Replace A2_BAIRRO  With CT->BAIFU
      nFUNovo := nFUNovo + 1
      nNovoCod := nNovoCod + 1
      MsUnlock()
   EndIf
   DbSelectArea("CT")
   DbSkip()
EndDo

dbSelectArea("CT")
Use

MSGSTOP(Str(nFuNovo,6) + " Reg. Incluidos Com Exito !" )

Return
