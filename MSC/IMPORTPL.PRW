#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function IMPORTPL()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NPLNOVO,")

Processa( {|| RunProc() },"Importacao do Plano de Contas","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Importacao do Plano de Contas","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SI1")  // Plano de Contas
dbSetOrder(1)        // Filial + Codigo
nPLNovo:=0
DbUseArea( .T.,, "\DADOSADV\CONTATSA.DBF", "PLC", if(.T. .OR. .F., !.F., NIL), .F. )
dbSelectArea("PLC")
dbGoTop()
ProcRegua(RecCount())
While ! Eof()
   IncProc("Gravando Registro : "+StrZero(Recno(),6))
   DbSelectArea("SI1")
   dbSetOrder(1)
   If Reclock("SI1",.T.)
      Replace I1_FILIAL  With XFilial("SI1")
      Replace I1_CODIGO  With PLC->I1_CODIGO
      Replace I1_DESC    With PLC->I1_DESC
      Replace I1_CLASSE  With PLC->I1_CLASSE
      Replace I1_NIVEL   With PLC->I1_NIVEL
      Replace I1_NORMAL  With PLC->I1_NORMAL
      Replace I1_CCOBRIG With IIF(SUBSTR(PLC->I1_CODIGO,1,1) $ "3_4", "S", "N")
      nPLNovo := nPLNovo + 1
      MsUnlock()
   EndIf
   DbSelectArea("PLC")
   DbSkip()
EndDo
dbSelectArea("PLC")
Use

MSGSTOP(Str(nPLNovo,6) + " Reg. Incluidos Com Exito !" )

Return
