#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function MIGRASET()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CARQUIVO,NLASTKEY,NSTNOVO,LRET,CARQ,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � MIGRASET   � Autor 쿐duardo Carraro      � Data � 29.11.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Migracao de Setores                                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Especifico EPC                                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
cArquivo:=Space(250)

@ 0,0 TO 130,700 DIALOG oDlg1 TITLE "Migracao de Setores"

@ 05,05 TO 40,345 TITLE " Dados "

@ 20,08 Say "Caminho/Arquivo:"
@ 20,60 GET cArquivo Picture "@!S50" VALID FValArq()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 20,60 GET cArquivo Picture "@!S50" VALID Execute(FValArq)

@ 50,280 BMPBUTTON TYPE 01 ACTION Conf1()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,280 BMPBUTTON TYPE 01 ACTION Execute(Conf1)
@ 50,310 BMPBUTTON TYPE 02 ACTION Canc1()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,310 BMPBUTTON TYPE 02 ACTION Execute(Canc1)
ACTIVATE DIALOG oDlg1 CENTER
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  � Conf1    � Autor 쿐duardo Carraro        � Data � 18/11/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o � Tratamento do botao de confirmacao das perguntas           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico para EPC                                        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Conf1
Static Function Conf1()

Close(oDlg1)

ProcMigra()

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  � Canc1    � Autor 쿐duardo Carraro        � Data � 18/11/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o � Tratamento do botao de cancelamento das perguntas          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico para EPC                                        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Canc1
Static Function Canc1()

Close(oDlg1)
nLastkey := 27

Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ProcMigra
Static Function ProcMigra()

Processa( {|| RunProc() },"Migracao do Cad. de Setores","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Migracao do Cad. de Setores","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SZ4")  // Setores
dbSetOrder(1)        // Filial + Codigo
nStNovo:=0
DbUseArea( .T.,, cArq, "ST", if(.T. .OR. .F., !.F., NIL), .F. )
dbSelectArea("ST")
dbGoTop()
ProcRegua(RecCount())
While ! Eof()
   IncProc("Gravando Registro : "+StrZero(Recno(),6))
   DbSelectArea("SZ4")
   dbSetOrder(1)
   IF ! DbSeek(xFilial("SZ4")+ST->CODCS)
      If RecLock("SZ4",.T.)
         Replace Z4_FILIAL   With XFilial("SZ4")
         Replace Z4_SETOR    With ST->CODCS
         Replace Z4_DESC     With ST->NOMCS
         Replace Z4_SIGLA    With ST->SIGCS
         nSTNovo := nSTNovo + 1
         MsUnlock()
      EndIF
   EndIf
   DbSelectArea("ST")
   DbSkip()
EndDo

dbSelectArea("ST")
Use

MSGBOX(Str(nStNovo,6) + " Novos Registros Incluidos Com Exito !","INFO" )

Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FValArq
Static Function FValArq()

lRet:=.T.
cArq:=AllTrim(cArquivo)
If ! File(cArq)
   MSGSTOP("O Arquivo Indicado Nao Existe ou Nao Esta' Acessivel, Verifique o Caminho e/ou o Nome do Arquivo !")
   lRet:=.F.
EndIf

Return(lRet)
