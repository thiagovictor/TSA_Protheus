#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ACERTC()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("M->I1_CODIGO,CDIGITO,CINVERTE,")

Processa( {|| RunProc() },"Acerto do Plano de Contas","Acertando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Acerto do Plano de Contas","Acertando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SI1")  // Plano de Contas
Set Order To
dbGoTop()
ProcRegua(RecCount())
While ! Eof()
   RegToMemory("SI1",.T.)
   M->I1_CODIGO:=I1_CODIGO
   IncProc("Acertando Registro : "+StrZero(Recno(),6))
   If SubStr(I1_CODIGO,1,1) $ "1_2" .AND. I1_CLASSE == "S"
      If Reclock("SI1",.F.)
         Replace I1_CODIGO  With SubStr(I1_CODIGO,1,Val(I1_NIVEL))
         MsUnlock()
      EndIf
   EndIf
   If SubStr(I1_CODIGO,1,1) $ "1_2" .AND. I1_CLASSE == "A"
      If Reclock("SI1",.F.)
         Replace I1_NIVEL  With "5"
         MsUnlock()
      EndIf
   EndIf
   If SubStr(I1_CODIGO,1,1) $ "3_4_5_6_7_8" .AND. I1_CLASSE == "S"
      If Reclock("SI1",.F.)
         Replace I1_CODIGO  With SubStr(I1_CODIGO,1,Val(I1_NIVEL))
         MsUnlock()
      EndIf
   EndIf
//旼컴컴컴컴컴컴컴커
//쿏igito          �
//읕컴컴컴컴컴컴컴켸
   M->I1_CODIGO:=I1_CODIGO
   cDigito:=CA020DIG()
   If RecLock("SI1",.F.)
      Replace I1_DC With cDigito
      MsUnlock()
   EndIF
   cInverte:=InverteSi1(SI1->I1_CODIGO)
   If RecLock("SI1",.F.)
      Replace I1_CODINV With cInverte
      MsUnlock()
   Endif
   DbSkip()
EndDo
DbCommit()
MsgStop("Termino do Acerto de Contas")
RetIndex("SI1")

Return
