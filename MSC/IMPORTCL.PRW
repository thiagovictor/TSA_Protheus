#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function IMPORTCL()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NCLNOVO,NNEWCOD,")

Processa( {|| RunProc() },"Importacao do Cad. de Clientes","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Importacao do Cad. de Clientes","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SA1")  // Clientes
dbSetOrder(1)        // Filial + Cod_Cli
nClNovo:=0
nNewCod:=1
DbUseArea( .T.,, "G:\BD\XEN_FOX\TSA\SICAR01.DBF", "CLIENTE", if(.T. .OR. .F., !.F., NIL), .F. )
dbSelectArea("CLIENTE")
dbGoTop()
ProcRegua(RecCount())
While ! Eof()
   IncProc("Gravando Registro : "+StrZero(Recno(),6))
   DbSelectArea("SA1")
   dbSetOrder(1)
   If Reclock("SA1",.T.)
      Replace A1_FILIAL  With XFilial("SA1")
      Replace A1_ANT     With CLIENTE->COD_CLI
      Replace A1_COD     With StrZero(nNewCod,6)
      Replace A1_LOJA    With "01" 
      Replace A1_NOME    With CLIENTE->NOME_CLI
      Replace A1_NREDUZ  With CLIENTE->SIGLA_CLI
      Replace A1_END     With CLIENTE->END_CLI
//      Replace A1_MUN     With CLIENTE->MUNIC_CLI
      Replace A1_MUNISS  With CLIENTE->MUNIC_CLI
      Replace A1_EST     With CLIENTE->ESTAD_CLI
      Replace A1_CEP     With CLIENTE->CEP_CLI
      Replace A1_TEL     With CLIENTE->TEL_CLI
      Replace A1_FAX     With CLIENTE->FAX_CLI
      Replace A1_CGC     With CLIENTE->CGC_CLI
      Replace A1_INSCR   With CLIENTE->INSCE_CLI
      Replace A1_INSCRM  With CLIENTE->INSCM_CLI
      nClNovo := nClNovo + 1
      nNewCod := nNewCod + 1
      MsUnlock()
   EndIf
   DbSelectArea("CLIENTE")
   DbSkip()
EndDo

dbSelectArea("CLIENTE")
Use

MSGSTOP(Str(nClNovo,6) + " Reg. Incluidos Com Exito !" )

Return
