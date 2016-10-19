#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function GERACONT()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,APERG,NOPCA,AROTINA,LCABECALHO")
SetPrvt("NMOSTLANC,NAGLULANC,DDATAINIC,DDATAFINA,CCABECALHO,CMSGREGUA")
SetPrvt("NTOTAL,NHDLPRV,CARQUIVO,CPADRAO,CLOTE,CKEY")
SetPrvt("CINDEX,NINDEX,CCHAVE,")
Private lGerLan:=.f.
// Criar parametro MV_LancPad

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GERACONT  ³ Autor ³ Marcus Augusto        ³ Data ³08.12.99  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao da Contabilidade                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO PARA EPC                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR ³ DATA  ³ MOTIVO DA ALTERACAO                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³       ³                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

lGerLan := .F.       // Verifica se foi gerado contabilizacao
cPerg  := "GERACO"
aPerg  := {}
AADD(aPerg,{cPerg,"Mostra Lancto.   ?","N",01,0,"C","NaoVazio","","Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Aglutina Lancto. ?","N",01,0,"C","NaoVazio","","Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Da Data          ?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Ate a Data       ?","D",08,0,"G","","","","","","",""})

//ExecBlock("TestSX1",.F.,.F.,{cPerg,aPerg})

Pergunte("GERACO",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nOpca := 0

@ 0,0 TO 150,520 DIALOG oDlg TITLE "Contabiliza‡„o Off Line"
@ 01,5 TO 050,255

@ 010,010 Say "  Este programa tem como objetivo gerar Lancamentos Contabeis Off para"
@ 020,010 Say "  Registros existentes nos Sistemas FIP - FOLHA."
@ 060,190 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 060,220 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 060,220 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 060,160 BMPBUTTON TYPE 5 ACTION Pergunte("GERACO",.T.)
ACTIVATE DIALOG oDlg CENTERED

// Chamada a uma funcao para executar em Windows


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function OkProc
Static Function OkProc()
nOpca := 1
Close(oDlg)

// Obs: este array aRotina foi inserido apenas para permitir o
// funcionamento das rotinas internas do advanced.

aRotina:={ { "Localizar"  ,"AxPesqui" , 0 , 1},;
           { "Pagar"      ,"fA100Pag" , 0 , 3},;
           { "Receber"    ,"fA100Rec" , 0 , 3},;
           { "Excluir"    ,"fA100Can" , 0 , 5},;
           { "Transferir" ,"fA100Tran", 0 , 3},;
           { "Classificar","fA100Clas", 0 , 5} }

lCabecalho :=.T.

nMostLanc := Mv_Par01
nAgluLanc := Mv_Par02
dDataInic := Mv_Par03
dDataFina := Mv_Par04

//dDataInic := DToS(Mv_Par07)
//dDataFina := DToS(Mv_Par08)

cCabecalho:="Aguarde"
cMsgRegua :="Gerando Lancamentos Automaticos"

If nOpcA == 1
    Processa({|| ProcCProva() },cCabecalho,cMsgRegua )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>     Processa({|| Execute(ProcCProva) },cCabecalho,cMsgRegua )
EndIf

If !lGerLan
   MsgStop("Nao foram geradas contabilizacoes!")
EndIf

Return()



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ProcCProva
Static Function ProcCProva()
*****************************************************************************
* Funcao para importacao dos Lan‡amentos Cont beis Off-Line
*
****

nTotal     := 0
nHdlPrv    := 0
cArquivo   := ""     // Arquivo CProva
lCabecalho := .F.    // Flag se j  emitiu o cabecaho do CProva
cPadrao    := GetNewPar("MV_LANCPAD","636")
//cPadrao    := "636"

dbSelectArea( "SX5" )
dbSeek( XFILIAL("SX5")+"09FIS" )
If At(UPPER("EXEC"),SX5->X5_DESCRI) > 0  // Se for ExecBlock
   cLote := &(SX5->X5_DESCRI)
Else
   cLote := Substr(SX5->X5_DESCRI,1,4)
Endif

//cKey := "Z7_DtLanc >= dDataInic .And. Z7_DtLanc <= dDataFina .And. Z7_ContaSN=''"
//dbSelectArea("SZ7")
///cIndex:= CriaTrab(NIL,.F.)
//IndRegua("SZ7",cIndex,"Z7_Filial+DToS(Z7_DtLanc)",,cKey,"Selecionando Registros ...")
//nIndex:=RetIndex("SZ7")
///dbSetIndex(cIndex)
///dbSetOrder(nIndex+1)
//cMsgRegua := "Gerando Lancamentos Contabeis ..."
//cChave    := Z7_Filial+DToS(Z7_DtLanc)
dbSelectArea("SZ7")
dbGoTop()

While ! Eof()

   IncProc(cMsgRegua)  //Incrementa a posicao da regua de relatorios

   If !Empty(SZ7->Z7_ContaSN) .Or. (Z7_DtLanc < dDataInic .or. Z7_DtLanc > dDataFina)
      dbSelectArea("SZ7")
      dbSkip()
      Loop
   EndIf

   lGerLan := .T.

   /*If cChave <> SZ7->Z7_Filial+DToS(SZ7->Z7_DtLanc)    // Cada vez que muda a chave, fecha o lote
      RodaProva(nHdlPrv,nTotal)                        // Rodape do arquivo CProva
      cA100Incl(cArquivo,nHdlPrv,3,cLote,nMostLanc==1,nAgluLanc==1)  // Edita Lancamentos
      cChave     := SZ7->Z7_Filial+DToS(SZ7->Z7_DtLanc)
      lCabecalho := .F.
   EndIf*/

   If !lCabecalho
      nHdlPrv := HeadProva(cLote,"MTA901",Substr(cUsuario,7,15),@cArquivo)
//    nHdlPrv := HeadProva(cLote,"GERACONT","Usua",@cArquivo)
      lCabecalho := .T.
   EndIf

// nTotal:=nTotal+DetProva(nHdlPrv,cPadrao,"GERACONT",cLote) // Linha de Detalhe
   nTotal:=nTotal+DetProva(nHdlPrv,cPadrao,"MTA901",cLote) // Linha de Detalhe

   dbSelectArea("SZ7")
   RecLock("SZ7",.F.)
   Replace  Z7_ContaSN With "S"
   MsUnLock() 
   dbSkip()
EndDo

If lCabecalho
   RodaProva(nHdlPrv,nTotal)  // Rodape do arquivo CProva
   cA100Incl(cArquivo,nHdlPrv,3,cLote,nMostLanc==1,nAgluLanc==1,"")  // Edita Lancamentos
EndIf

Return()