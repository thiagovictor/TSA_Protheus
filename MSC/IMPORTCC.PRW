#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function IMPORTCC()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NCCNOVO,")

Processa( {|| RunProc() },"Importacao do Cad. de Centro de Custos","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Importacao do Cad. de Centro de Custos","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()
************************
* Gera dados ....
*****

dbSelectArea("SI3")  // CC
dbSetOrder(1)        // Filial + custo
nCCNovo:=0
DbUseArea( .T.,, "G:\BD\XEN_FOX\TSA\SICAR05.DBF", "CC", if(.T. .OR. .F., !.F., NIL), .F. )
dbSelectArea("CC")
dbGoTop()
ProcRegua(RecCount())
While ! Eof()
   If " " $ COD_CTA
      DbSelectArea("CC")
      DbSkip()
      IncProc("Ignorando Registro : "+StrZero(Recno(),6))
      Loop
   EndIf
   IncProc("Gravando Registro : "+StrZero(Recno(),6))
   DbSelectArea("SI3")
   dbSetOrder(1)
   If Reclock("SI3",.T.)
      Replace I3_FILIAL  With XFilial("SI3")
      Replace I3_CUSTO   With Substr(CC->COD_CTA,1,5)
      Replace I3_MOEDA   With "1" 
      Replace I3_DESC    With CC->DESCR_CTA
      Replace I3_SITUAC  With CC->SITUA_CTA
      nCCNovo := nCCNovo + 1
      MsUnlock()
   EndIf
   DbSelectArea("CC")
   DbSkip()
EndDo
dbSelectArea("CC")
Use

MSGSTOP(Str(nCCNovo,6) + " Reg. Incluidos Com Exito !" )

Return
