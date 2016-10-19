#INCLUDE "RWMAKE.CH"
//#include "TbiConn.ch"
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
Local cProtocol :="TCPIP"
Local cCodCal := Space(03)
Local nCon
Local cQuery:=""
Local nFUNovo :=1
Local cDia
Local cNumMes
Local cAno
Local cMes
Local cSdata
cQuery :=" SELECT RA_MAT, RA_CC, RA_DEMISSA, RA_NOME, RA_SALARIO,RA_CATFUNC,RA_HRSMES FROM "+RetSqlName("SRA") + " WHERE D_E_L_E_T_ = '' ORDER BY R_E_C_N_O_"
TCQUERY cQuery ALIAS "DES" NEW

DbSelectArea("DES")
dbGoTop()
ProcRegua(RecCount())
                           
                           
While ! Eof()

  IncProc("Gravando Registro : "+StrZero(Recno(),6))
  If !Empty(DES->RA_DEMISSA)
   cAno:=Left(DES->RA_DEMISSA,4) 
   cDia:=Right(DES->RA_DEMISSA,2)
   cMes:=SubsTr(DES->RA_DEMISSA,5,2)
   If Len(cdia)= 1
      cdia:="0"+cdia
   Endif
    //cSdata:= cDia+"/"+cNumMes+"/"+cAno
    cSdata:= cAno+cMes+cDia
  Endif 
   dbSelectArea("SZJ")
   dbSetOrder(1)
  If  dbSeek(xFilial("SZJ")+DES->RA_CC)
      cCodCal := SZJ->ZJ_CODICAL
  EndIf
   
   dbSelectArea("SZD")
   dbSetOrder(1)
   dbSeek(xFilial("SZD")+DES->RA_MAT)
      
   If Eof()
      Reclock("SZD",.T.)
      Replace ZD_FILIAL   With xFilial("SZD")
      Replace ZD_CODFUNC  With DES->RA_MAT
      Replace ZD_NOMEFUN  With Upper(DES->RA_NOME)
      Replace ZD_SALAFUN  With IF(DES->RA_CATFUNC<>'G',DES->RA_SALARIO,DES->RA_SALARIO*DES->RA_HRSMES)
      Replace ZD_CODCONT  With DES->RA_CC
      Replace ZD_CODICAL  With cCodCal     
      If !empty(DES->RA_DEMISSA) 
        Replace ZD_DATAREC  With Stod(cSdata)   
      Endif
     nFUNovo := nFUNovo + 1
   Else
      Reclock("SZD",.F.)
      Replace ZD_CODCONT  With DES->RA_CC
      Replace ZD_CODICAL  With cCodCal
		Replace ZD_SALAFUN  With IF(DES->RA_CATFUNC<>'G',DES->RA_SALARIO,DES->RA_SALARIO*DES->RA_HRSMES)
     ****If !Empty(DES->RA_DEMISSA) 
        Replace ZD_DATAREC  With stod(DES->RA_DEMISSA)
     *****Endif
      nFUNovo := nFUNovo + 1
   EndIf

   MsUnlock()

   DbSelectArea("DES")
   DbSkip()
EndDo

dbSelectArea("DES")
dbCloseArea()
MSGSTOP(Str(nFuNovo,6) + " Reg. Incluidos Com Exito !" )

Return

