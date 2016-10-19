/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦TSAFAT02  ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 26.10.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Rotina inclusao de titulos provisorios de Receitas                                ¦ 
+----------+-----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                                               ¦
+----------+-----------------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                                   ¦
+------------+--------+------------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                                    ¦
+------------+--------+------------------------------------------------------------------------+
¦            ¦        ¦                                                                        ¦
+------------+--------+------------------------------------------------------------------------+
*/

#include "protheus.ch"
#include "topconn.ch"
#include "colors.ch"
#include "rwmake.ch"

User Function TSAFAT02()
*****************************************************************************************************
* Monta tela solicitando o numero da revisão para inclusao dos titulos provisórios
*
****

Private cRevEst   := Space(03)
Private cContInic := Space(05)
Private cContFina := Space(05)
Private dDataInic := CTOD("")
Private dDataFina := CTOD("")

Define MSDialog oDlgRev Title OemToAnsi("Inclusão Títulos Provisórios") From 005,010 TO 280,255 Of oMainWnd Pixel
oGroupRev := TGroup():New(007,008,070,120,OemToAnsi("Parâmetros:"),,CLR_HBLUE,,.T.)

@ 013,013 SAY oSay1 Var OemToAnsi("Contrato Inicial") Of oDlgRev Pixel 
@ 023,013 GET oContInic Var cContInic Of oDlgRev Pixel 
@ 013,070 SAY oSay2 Var OemToAnsi("Contrato Final") Of oDlgRev Pixel 
@ 023,080 GET oContFina Var cContFina Of oDlgRev Pixel                 

@ 043,013 SAY oSay3 Var OemToAnsi("Data Inicial") Of oDlgRev Pixel 
@ 053,013 GET oDataInic Var dDataInic Of oDlgRev Pixel 
@ 043,070 SAY oSay4 Var OemToAnsi("Data Final") Of oDlgRev Pixel 
@ 053,080 GET oDataFina Var dDataFina Of oDlgRev Pixel 
//@ 043,013 SAY oSay3 Var OemToAnsi("Revisão do Estimado") Of oDlgRev Pixel 
//@ 053,013 GET oRevEst Var cRevEst Of oDlgRev SIZE 020, 07 Pixel 

oContInic:CF3 := "SZ1"
oContInic:CRETF3 := "Z1_COD"
oContFina:CF3 := "SZ1"
oContFina:CRETF3 := "Z1_COD"

Define SButton From 120,030 Type 1 Action (FOk() .And. oDlgRev:End()) Enable Of oDlgRev
Define SButton From 120,070 Type 2 Action (oDlgRev:End()) Enable Of oDlgRev

ACTIVATE MSDIALOG oDlgRev CENTERED

Return


Static Function FOk()
****************************************************************************************************
* Chamada da funcao para inclusao dos titulos provisorios a receber
*
****

cCabecalho := OemToAnsi("Inclusão de títulos provisórios de Receita")
cMsgRegua  := "Processando..."

Processa( {|| FIncTit()} ,cCabecalho,cMsgRegua )

Return(.T.)



Static Function FIncTit()
*****************************************************************************************************
* Inclusao automatica do titulo de provisao de acordo com a revisao do estimado informada pelo usuario 
*
****

Local cQuery  := ""
Local cVencto := ""

cQuery := "SELECT Z1_COD, Z1_CODCLI, Z1_LOJA, Z1_CLIENTE, Z3_EVENTO, Z3_DESCEVE, Z3_SEQ, Z3_VALOR, Z3_DTPREV, Z3_DTRECEB, ZS_NATUREZ "
cQuery += "FROM " + RetSqlName("SZ1") + " SZ1 INNER JOIN " + RetSqlName("SZ3") + " SZ3 ON Z3_COD  = Z1_COD AND "
cQuery += "Z3_NOTA = '' AND " 
cQuery += "Z3_DTRECEB BETWEEN '" + DTOS(dDataInic) + "' AND '" + DTOS(dDataFina) + "' AND "
cQuery += "SZ3.D_E_L_E_T_ <> '*' "
cQuery += "LEFT OUTER JOIN SZS020 SZS ON ZS_COD = Z3_CODALIQ AND "
cQuery += "SZS.D_E_L_E_T_ <> '*' "
cQuery += "WHERE Z1_COD BETWEEN '" + cContInic + "' AND '" + cContFina + "' AND "
cQuery += "SZ1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY Z1_COD, Z1_CODCLI, Z1_LOJA, Z1_CLIENTE, Z3_EVENTO, Z3_DESCEVE, Z3_SEQ, Z3_VALOR, Z3_DTPREV, Z3_DTRECEB, ZS_NATUREZ "

TcQuery cQuery ALIAS "EVENTO" NEW

dbSelectArea("EVENTO")
dbGoTop()

While !Eof()
   dbSelectArea("SE1")
   dbSetOrder(1)
   dbSeek(xFilial("SE1")+"EST"+EVENTO->Z1_COD+EVENTO->Z3_SEQ+"PR ")
                          
   If RecLock("SE1",Eof())
      Replace E1_FILIAL  With xFilial("SE1")
      Replace E1_PREFIXO With "EST"
      Replace E1_NUM     With EVENTO->Z1_COD
      Replace E1_CODCONT With EVENTO->Z1_COD
      Replace E1_TIPO    With "PR"
      Replace E1_PARCELA With EVENTO->Z3_SEQ
      Replace E1_NATUREZ With IIf(AllTrim(EVENTO->ZS_NATUREZ)<>"",EVENTO->ZS_NATUREZ,"20001")
      Replace E1_DATAREF With CTOD(SubStr(EVENTO->Z3_DTPREV,7,2)+"/"+SubStr(EVENTO->Z3_DTPREV,5,2)+"/"+SubStr(EVENTO->Z3_DTPREV,1,4))
      Replace E1_CLIENTE With EVENTO->Z1_CODCLI
      Replace E1_LOJA    With EVENTO->Z1_LOJA
      Replace E1_NOMCLI  With EVENTO->Z1_CLIENTE
      Replace E1_EMISSAO With CTOD(SubStr(EVENTO->Z3_DTPREV,7,2)+"/"+SubStr(EVENTO->Z3_DTPREV,5,2)+"/"+SubStr(EVENTO->Z3_DTPREV,1,4))
      Replace E1_EMIS1   With CTOD(SubStr(EVENTO->Z3_DTPREV,7,2)+"/"+SubStr(EVENTO->Z3_DTPREV,5,2)+"/"+SubStr(EVENTO->Z3_DTPREV,1,4))
      Replace E1_VENCTO  With CTOD(SubStr(EVENTO->Z3_DTRECEB,7,2)+"/"+SubStr(EVENTO->Z3_DTRECEB,5,2)+"/"+SubStr(EVENTO->Z3_DTRECEB,1,4))
      Replace E1_VENCORI With CTOD(SubStr(EVENTO->Z3_DTRECEB,7,2)+"/"+SubStr(EVENTO->Z3_DTRECEB,5,2)+"/"+SubStr(EVENTO->Z3_DTRECEB,1,4))
      Replace E1_VENCREA With DataValida(CTOD(SubStr(EVENTO->Z3_DTRECEB,7,2)+"/"+SubStr(EVENTO->Z3_DTRECEB,5,2)+"/"+SubStr(EVENTO->Z3_DTRECEB,1,4)))
      Replace E1_VALOR   With EVENTO->Z3_VALOR
      Replace E1_VLCRUZ  With EVENTO->Z3_VALOR
      Replace E1_SALDO   With EVENTO->Z3_VALOR
      Replace E1_HIST    With " Evento: " + EVENTO->Z3_EVENTO + " - " + EVENTO->Z3_DESCEVE
      Replace E1_MOEDA   With 1
      Replace E1_STATUS  With "A"
      Replace E1_ORIGEM  With "FINA040"
      Replace E1_SITUACA With "0"
      Replace E1_FILORIG With xFilial("SE1")
      MsUnlock()
   EndIf
   dbSelectArea("EVENTO")
   dbSkip()
End

dbSelectArea("EVENTO")
dbCloseArea()

Return