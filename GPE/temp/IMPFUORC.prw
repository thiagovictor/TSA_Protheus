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
cQuery :="SELECT ID,CHAPA,CCUSTO,DATAS,NOME,SALARIO FROM IMP_ZD_VW " // VIEW VINCULADA AO BANCO PERSONNE
TCQUERY cQuery ALIAS "DES" NEW

DbSelectArea("DES")
dbGoTop()
ProcRegua(RecCount())

While ! Eof()

   IncProc("Gravando Registro : "+StrZero(Recno(),6))
  /* 
   If !empty(DATAS)
      DbSelectArea("DES")
      DbSkip()
      Loop
   EndIf
   */
  If !empty(DATAS)
   cAno:=ALLTRIM(right(DATAS,3)) 
   cDia:=ALLTRIM(SUBSTR(DATAS,5,2))
   cMes:=Left(DATAS,3)
   If Len(cdia)= 1
      cdia:="0"+cdia
   Endif
   Do Case
   Case cMes == "jan" 
        cNumMes:="01"      
   Case cMes == "Feb" 
        cNummes:="02"       
   Case cMes == "Mar" 
        cNummes:="03"       
   Case cMes == "Apr"
        cNummes:="04"       
   Case cMes == "May" 
        cNummes:="05"       
   Case cMes == "Jun"
        cNummes:="06"       
   Case cMes == "Jul"
		cNummes:="07" 
   Case cMes == "Aug"
		cNummes:="08"
   Case cMes == "Sep"
        cNummes:="09"
   Case cMes == "Oct"
        cNummes:="10"
   Case cMes == "Nov"
        cNummes:="11"
   Case cMes == "Dec"
        cNummes:="12"
   EndCase
    //cSdata:= cDia+"/"+cNumMes+"/"+cAno
    cSdata:= "20"+cAno+cNumMes+cDia
  Endif 
   dbSelectArea("SZJ")
   dbSetOrder(1)
  If  dbSeek(xFilial("SZJ")+DES->CCUSTO)
      cCodCal := SZJ->ZJ_CODICAL
  EndIf
   
   dbSelectArea("SZD")
   dbSetOrder(1)
   dbSeek(xFilial("SZD")+DES->CHAPA)
      
   If Eof()
      Reclock("SZD",.T.)
      Replace ZD_FILIAL   With xFilial("SZD")
      Replace ZD_CODFUNC  With DES->CHAPA
      Replace ZD_NOMEFUN  With Upper(DES->NOME)
      Replace ZD_SALAFUN  With DES->SALARIO
      Replace ZD_CODCONT  With DES->CCUSTO
      Replace ZD_CODICAL  With cCodCal     
      If !empty(DES->DATAS) 
        Replace ZD_DATAREC  With stod(cSdata)   
      Endif
     nFUNovo := nFUNovo + 1
   Else
      Reclock("SZD",.F.)
      Replace ZD_CODCONT  With DES->CCUSTO
      Replace ZD_CODICAL  With cCodCal
     If !empty(DES->DATAS) 
        Replace ZD_DATAREC  With stod(cSdata)   
     Endif
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

