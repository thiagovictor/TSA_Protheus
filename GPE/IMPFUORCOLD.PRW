#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#INCLUDE "Topconn.ch"


User Function IMPFUORC()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CLOCDBF,NFUNOVO,")

Processa( {|| ImporFun() },"Importacao do Cad. de Funcionarios para o Orcamento","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(ImporFun) },"Importacao do Cad. de Funcionarios para o Orcamento","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImporFun
Static Function ImporFun()


































Local cCodCal := Space(03)

dbSelectArea("SZD")  // Funcionarios
dbSetOrder(1)        // Filial + Cod_Func

cLocDBF := ""
cLocDBF := GetMv("MV_LOCARQF")

//Inserido por Carlito 05/09/02
If !File(cLocDBF)
   Msgbox("Arquivo "+cLocDBF+" nao encontrado. ")
   Return 
EndIf

nFuNovo:=0
DbUseArea( .T.,, cLocDbf, "FU", if(.T. .OR. .F., !.F., NIL), .F. )

DbSelectArea("FU")
dbGoTop()
ProcRegua(RecCount())

While ! Eof()

   IncProc("Gravando Registro : "+StrZero(Recno(),6))

   If FU->DREFU <> "  /  /    " .and. !Empty(FU->DREFU)
      DbSelectArea("FU")
      DbSkip()
      Loop
   EndIf

   dbSelectArea("SZJ")
   dbSetOrder(1)
   dbSeek(xFilial("SZJ")+FU->CCSFU)
   
   If !Eof()
   	cCodCal := SZJ->ZJ_CODICAL
   EndIf
   
   dbSelectArea("SZD")
   dbSetOrder(1)
   dbSeek(xFilial("SZD")+FU->NumFu)
      
   If Eof()
      Reclock("SZD",.T.)
      Replace ZD_FILIAL   With xFilial("SZD")
      Replace ZD_CODFUNC  With FU->NUMFU
      Replace ZD_NOMEFUN  With Upper(FU->NOMFU)
      Replace ZD_SALAFUN  With (FU->SATFU+(((FU->AANFU+;
                                             FU->APEFU+;
                                             FU->ATRFU+;
                                             FU->AINFU+;
                                             FU->APRFU+;     
                                             FU->AIBFU )/100)*FU->SATFU))
     Replace ZD_CODCONT  With FU->CCSFU
     Replace ZD_CODICAL  With cCodCal     
     Replace ZD_DATAREC  With CTOD(FU->DREFU)   
     nFUNovo := nFUNovo + 1
   Else
      Reclock("SZD",.F.)
      Replace ZD_SALAFUN  With (FU->SATFU+(((FU->AANFU+;
                                             FU->APEFU+;
                                             FU->ATRFU+;
                                             FU->AINFU+;
                                             FU->APRFU+;
                                             FU->AIBFU )/100)*FU->SATFU))
      Replace ZD_CODCONT  With FU->CCSFU
      Replace ZD_CODICAL  With cCodCal
      Replace ZD_DATAREC  With CTOD(FU->DREFU)   
      nFUNovo := nFUNovo + 1
   EndIf

   MsUnlock()

   DbSelectArea("FU")
   DbSkip()
EndDo

dbSelectArea("FU")
Use

MSGSTOP(Str(nFuNovo,6) + " Reg. Incluidos Com Exito !" )

Return

