#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function FATR900()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,LIMITE,CSTRING,TAMANHO")
SetPrvt("TITULO,CABEC1,CABEC2,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("CPERG,APERG,WNREL,DDATAINIC,DDATAFINA,CANALSINT")
SetPrvt("CIMORPRAM,CIMPPA,CIMPPR,CCABECALHO,CMSGREGUA,ATEMPSTRU")
SetPrvt("CARQTRAB1,CARQTRAB2,CARQTRAB3,NBANCOS,NCAIXAS,NSALDOTIT")
SetPrvt("DDATATRAB,CNOME,CCODANT,CANOF,CMESF,CANOI")
SetPrvt("CMESI,DDTREVENC,CCONTRATO,CSUBCONTA,CANO,CMES")
SetPrvt("CREV,CCCUSTO,CDESCRI,M_PAG,NLINHA,CRODATXT")
SetPrvt("NCNTIMPR,DDATAANT,NSALDO,NSALDG,NTOTAREC,NTOTADES")
SetPrvt("NTOTGREC,NTOTGDES,NTOTALDIA,CTIPORD,NRECNOC1,NRECNOC2")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/06/01 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FATR900  ³ Autor ³Ederson Dilney Colen M.³ Data ³17.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Di rio Fluxo de Caixa                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FATR900                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

cDesc1   := "Este relatorio tem como objetivo Listar o Fluxo de Caixa Diario,"
cDesc2   := "a partir dos parametros informados pelo usuario."
cDesc3   := " "
Limite   := 132
cString  := "SE1"
Tamanho  := "M"

Titulo   := "FLUXO DE CAIXA DIARIO"
Cabec1   := ""
Cabec2   := ""

aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Nomeprog := "FATR900"
nLastKey := 0
cPerg    := "FAT900"
aPerg    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³ mv_par01               Do  Periodo                          ³
//³ mv_par02               At‚ Periodo                          ³
//³ mv_par03               Sintetico/Analitico                  ³
//³ mv_par04               Imprime Orcamento/Previsto/Ambos     ³
//³ mv_par05               Imprime PA                           ³
//³ mv_par06               Imprime PR                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aPerg,{cPerg,"Do  Periodo        ?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Ate Periodo        ?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Analitico/Sintetico?","C",01,0,"C","","","Analitico","Sintetico","","",""})
AADD(aPerg,{cPerg,"Imp. Orca/Prev/Amb ?","C",01,0,"C","","","Orcamento","Previsto","Ambos","",""})
AADD(aPerg,{cPerg,"Imp. Pag. Ant.     ?","C",01,0,"C","","","Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Imp. Provisorio    ?","C",01,0,"C","","","Sim","Nao","","",""})

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³ mv_par01               Da Natureza                          ³
//³ mv_par02               At‚ a Natureza                       ³
//³ mv_par03               N£mero de dias                       ³
//³ mv_par04               Moeda                                ³
//³ mv_par05               Cons.Ped.Compra 1=Sim,2=nao FMQ201   ³
//³ mv_par06               Cons.Ped.Vda. 1=Sim,2=Nao   FMQ201   ³
//³ mv_par07               N¡veis de quebra                     ³
//³ mv_par08               Considera Data Base                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := NomeProg            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"","",.F.)

SetDefault(aReturn,cString)

If nLastKey == 27
    Return
Endif

dDataInic := mv_par01
dDataFina := mv_par02
cAnalSint := mv_par03
cImOrPrAm := mv_par04
cImpPA    := mv_par05
cImpPR    := mv_par06

LCRIATRAB()
#IFDEF WINDOWS
   cCabecalho := "Gravacao do Arquivo de Trabalho"
   cMsgRegua  := "Processando "
   Processa( {|| GravTrab()} ,cCabecalho,cMsgRegua )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    Processa( {|| Execute(GravTrab)} ,cCabecalho,cMsgRegua )
   RptStatus({|| Fat900Imp()},titulo)// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    RptStatus({|| Execute(Fat900Imp)},titulo)
#ELSE
   GravTrab()
   FaT900Imp()
#ENDIF

dbSelectArea("TRBF")
dbCloseArea()

dbSelectArea("TRBC")
dbCloseArea()

dbSelectArea("TRBT")
dbCloseArea()

FErase(cArqTrab1 + ".*")
FErase(cArqTrab2 + ".*")
FErase(cArqTrab3 + ".*")

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function LCRIATRAB
Static Function LCRIATRAB()
****************************************************************************
* Cria os arquivos de trabalho
******

aTempStru := {}

Aadd(aTempStru,{"DtTitulo","D",08,0})
Aadd(aTempStru,{"TipoClFo","C",01,0})
Aadd(aTempStru,{"CodiClFo","C",06,0})
Aadd(aTempStru,{"LojaClFo","C",02,0})
Aadd(aTempStru,{"NomeClFo","C",30,0})
Aadd(aTempStru,{"Prefixo" ,"C",03,0})
Aadd(aTempStru,{"NumTitu" ,"C",06,0})
Aadd(aTempStru,{"TipTitu" ,"C",03,0})
Aadd(aTempStru,{"Situacao","C",01,0})
Aadd(aTempStru,{"Contrato","C",06,0})
Aadd(aTempStru,{"SubConta","C",11,0})
Aadd(aTempStru,{"ValrTitu","N",17,2})
Aadd(aTempStru,{"SaldTitu","N",17,2})

cArqTrab1 := CRIATRAB(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab1, "TRBF",.F.,.F.)
IndRegua("TRBF",cArqTrab1,"DtoS(DtTitulo)+TipoClFo+CodiClFo+LojaClFo",,,"Selecionando Registros...")


aTempStru := {}

Aadd(aTempStru,{"DtTitulo","D",08,0})
Aadd(aTempStru,{"TipoClFo","C",01,0})
Aadd(aTempStru,{"CodiClFo","C",06,0})
Aadd(aTempStru,{"LojaClFo","C",02,0})
Aadd(aTempStru,{"Contrato","C",06,0})
Aadd(aTempStru,{"SubConta","C",11,0})
Aadd(aTempStru,{"CodEmpre","C",10,0})

cArqTrab2 := CRIATRAB(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab2, "TRBC",.F.,.F.)
IndRegua("TRBC",cArqTrab2,"DtoS(DtTitulo)+TipoClFo+Contrato+SubConta+CodiClFo+LojaClFo",,,"Selecionando Registros...")


aTempStru := {}

Aadd(aTempStru,{"Contrato","C",06,0})
Aadd(aTempStru,{"SubConta","C",11,0})
Aadd(aTempStru,{"TotlConR","N",17,2})
Aadd(aTempStru,{"TotlConD","N",17,2})
Aadd(aTempStru,{"TotlCoOR","N",17,2})
Aadd(aTempStru,{"TotlCoOD","N",17,2})

cArqTrab3 := CRIATRAB(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab3, "TRBT",.F.,.F.)
IndRegua("TRBT",cArqTrab3,"Contrato+SubConta",,,"Selecionando Registros...")


Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function GravTrab
Static Function GravTrab()
*****************************************************************************
* Grava os dados no arquivo de trabalho
***

nBancos   := 0
nCaixas   := 0
nSaldoTit := 0
dDataTrab := CtoD(Space(08))
cNome     := ""
cCodAnt   := Space(06)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica disponibilidade banc ria                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA6")
dbSeek(xFilial("SA6"))

ProcRegua(RecCount())  // Inicializa regua
cMsgRegua := "Processando disponibilidade Bancaria"

While (! Eof())                          .And. ;
      (SA6->A6_FILIAL == xFilial("SA6"))

   IncProc(cMsgRegua)

   If SA6->A6_FLUXCAI == "N"
      dbSkip()
      Loop
   Endif

   If SubStr(SA6->A6_COD,1,2) == "CX"
      nCaixas := nCaixas + RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
   Else
      nBancos := nBancos + RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
   EndIf

   dbSelectArea("SA6")
   dbSkip()
Enddo

If cImOrPrAm == 2 .Or. cImOrPrAm == 3

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Seleciona o arquivo SE1 - Contas a Receb, selecionando os registros ³
   //³ desejados. Veja a fun‡„o de filtragem.                              ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   dbSelectArea("SE1")
   dbSetOrder(6)
   Set SoftSeek On
   dbSeek(xFilial("SE1")+DtoS(dDataInic))
   Set SoftSeek Off

   ProcRegua(dDataFina - dDataInic)  // Inicializa regua

   While (! Eof())                           .And.;
         (xFilial("SE1")  == SE1->E1_FILIAL) .And.;
         (SE1->E1_EMISSAO <= dDataFina)

      nSaldoTit := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,;
                            SE1->E1_TIPO,SE1->E1_NATUREZA,"R",SE1->E1_CLIENTE,1,,,SE1->E1_LOJA)

      nSaldoTit := nSaldoTit - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1)
       
      IncProc("Processando os Titulos a Receber do Dia " + DtoC(SE1->E1_EMISSAO))

      If cImpPA == 2 .And. SE1->E1_TIPO == "PA"
         dbSkip()
         Loop
      Endif

      If cImpPR == 2 .And. SE1->E1_TIPO == "PR"
         dbSkip()
         Loop
      Endif

      If SE1->E1_EMISSAO > dDataBase .Or. Subs(SE1->E1_TIPO,3,1)  == "-" .OR. SE1->E1_SITUACA $ "27"
         dbSkip()
         Loop
      Endif

      If SE1->E1_FLUXO == "N"
         dbSkip()
         Loop
      EndIf

      If SE1->E1_VENCREA < dDataBase
         dDataTrab := dDataBase - 1
      Else
         dDataTrab := DataValida(SE1->E1_VENCREA,.T.)
      Endif

      If Abs(nSaldoTit) > 0.0001

         If Substr(SE1->E1_TIPO,3,1) == "-" .OR. SE1->E1_TIPO == "RA " .OR. ;
            SE1->E1_TIPO == "NCC"
            nSaldoTit := nSaldoTit - nSaldoTit
         Else
            nSaldoTit := nSaldoTit + nSaldoTit
         Endif

         dbSelectArea("SA1")
         dbSetOrder(1)
         dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

         dbSelectArea("TRBF")
         If ! (dbSeek(DtoS(dDataTrab)+"C"+SE1->E1_CLIENTE+SE1->E1_LOJA))
            RecLock("TRBF",.T.)
            Replace  DtTitulo  With  dDataTrab
            Replace  TipoClFo  With  "C"
            Replace  CodiClFo  With  SE1->E1_CLIENTE
            Replace  LojaClFo  With  SE1->E1_LOJA
            Replace  NomeClFo  With  SA1->A1_NOME
            Replace  Prefixo   With  SE1->E1_PREFIXO
            Replace  NumTitu   With  SE1->E1_NUM
            Replace  TipTitu   With  SE1->E1_TIPO
            Replace  Situacao  With  "P"
            Replace  Contrato  With  SE1->E1_CODCONT
            Replace  SubConta  With  SE1->E1_SUBC
            Replace  ValrTitu  With  SE1->E1_VALOR
            Replace  SaldTitu  With  nSaldoTit
            MsUnlock()
         Else
            RecLock("TRBF",.F.)
            Replace  SaldTitu  With  nSaldoTit
            MsUnlock()
         Endif

      Endif

      nSaldoTit := 0

      dbSelectArea("SE1")
      dbSkip()

   Enddo

   nSaldoTit := 0

   dbSelectArea("SE2")
   dbSetOrder(5)
   Set SoftSeek On
   dbSeek(xFilial("SE2")+DtoS(dDataInic))
   Set SoftSeek Off

   ProcRegua(dDataFina - dDataInic)  // Inicializa regua

   While (! Eof())                           .And.;
         (xFilial("SE2")  == SE2->E2_FILIAL) .And.;
         (SE2->E2_EMISSAO <= dDataFina)

      IncProc("Processando os Titulos a Pagar do Dia "+DtoC(SE2->E2_EMISSAO))

      If SE2->E2_EMISSAO > dDataBase .or. Subs(SE2->E2_TIPO,3,1) == "-"
         dbSkip()
         Loop
      Endif

      nSaldoTit := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
                            SE2->E2_TIPO,SE2->E2_NATUREZA,"P",SE2->E2_FORNECE,1,,,SE2->E2_LOJA)

      nSaldoTit := nSaldoTit - CalcAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,1,"P")

      If cImpPA == 2 .And. SE2->E2_TIPO == "PA"
         dbSkip()
         Loop
      Endif

      If cImpPR == 2 .And. SE2->E2_TIPO == "PR"
         dbSkip()
         Loop
      Endif

      If SE2->E2_VENCREA < dDataBase
         dDataTrab := dDataBase - 1
      Else
         dDataTrab := DataValida(SE2->E2_VENCREA,.T.)
      Endif

      If Abs(nSaldoTit) > 0.0001
         If Substr(SE2->E2_TIPO,3,1) == "-" .OR. SE2->E2_TIPO == "PA " .OR. SE2->E2_TIPO == "NDF"
            nSaldoTit := nSaldoTit - nSaldoTit
         Else
            nSaldoTit := nSaldoTit + nSaldoTit
         Endif

         dbSelectArea("SA2")
         dbSetOrder(1)
         dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE1->E1_LOJA)

         dbSelectArea("SZ2")
         dbSetOrder(3)
         dbSeek(xFilial("SZ2")+SE2->E2_CC)

         dbSelectArea("TRBF")

         If ! (dbSeek(DtoS(dDataTrab)+"C"+SE1->E1_CLIENTE+SE1->E1_LOJA))
            RecLock("TRBF",.T.)
            Replace  DtTitulo  With  dDataTrab
            Replace  TipoClFo  With  "F"
            Replace  CodiClFo  With  SE2->E2_FORNECE
            Replace  LojaClFo  With  SE2->E2_LOJA
            Replace  NomeClFo  With  SA2->A2_NOME
            Replace  Prefixo   With  SE2->E2_PREFIXO
            Replace  NumTitu   With  SE2->E2_NUM
            Replace  TipTitu   With  SE2->E2_TIPO
            Replace  Situacao  With  "P"
            Replace  Contrato  With  SZ2->Z2_COD
            Replace  SubConta  With  SE2->E2_CC
            Replace  ValrTitu  With  SE2->E2_VALOR
            Replace  SaldTitu  With  nSaldoTit
            MsUnlock()
            nSaldoTit := 0
         Else
            RecLock("TRBF",.F.)
            Replace  SaldTitu  With  nSaldoTit
            MsUnlock()
            nSaldoTit := 0
         Endif


      Endif

      dbSelectArea("SE2")
      dbSkip()
   Enddo

EndIf

If cImOrPrAm == 1 .Or. cImOrPrAm == 3

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³Esta montado as Data de Vencimento dos Clientes ³
   // ³             (SZ1 - Contrato)                   ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   cAnoF := SubStr(DtoS(dDataFina),1,4)
   cMesF := SubStr(DtoS(dDataFina),5,2)

   dbSelectArea("SZ1")
   dbSetOrder(1)
   dbGoTop()

   ProcRegua(RecCount())  // Inicializa regua
   cMsgRegua := "Processando os Contratos"

   While ! Eof()

      dbSelectArea("SZ1")
      cAnoI   := SubStr(DtoS(dDataInic),1,4)
      cMesI   := SubStr(DtoS(dDataInic),5,2)
      cCodAnt := SZ1->Z1_COD

      IncProc(cMsgRegua)

      While  ! Eof()                          .And. ;
             SZ1->Z1_Filial == xFilial("SZ1") .And. ;
             SZ1->Z1_COD    == cCodAnt        .And. ;
             (cAnoI+cMesI)  <= (cAnoF+cMesF)

*???      dDtReVenc := (StoD(cAnoI+cMesI+SZ1->Z1_DIAVENC)+Val(SZ1->Z1_DIAFREN))
         dDtReVenc := (StoD(cAnoI+cMesI+SubStr(DtoS(SZ1->Z1_DTVENC),7))+Val(SZ1->Z1_DIAFREN))

         If Empty(dDtReVenc)
            dbSelectArea("SZ1")
            dbSkip()
            Loop
         EndIf

         If dDtReVenc < dDataInic .And. ;
            dDtReVenc > dDataFina
            dbSelectArea("SZ1")
            dbSkip()
            Loop
         EndIf

         dbSelectArea("SZ2")
         dbSetOrder(1)
         dbSeek(xFilial("SZ2")+SZ1->Z1_COD)

         While (! Eof())                           .And.;
               (xFilial("SZ2")  == SZ2->Z2_FILIAL) .And.;
               (SZ2->Z2_COD     == SZ1->Z1_COD)

            cContrato := SZ1->Z1_COD+Space(6-Len(SZ1->Z1_COD))
            cSubConta := SZ2->Z2_SUBC+Space(11-Len(SZ2->Z2_SUBC))

            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"C"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "C"
               Replace  CodiClFo  With  SZ1->Z1_CODCLI
               Replace  LojaClFo  With  SZ1->Z1_LOJA
               Replace  Contrato  With  SZ1->Z1_COD
               Replace  SubConta  With  SZ2->Z2_SUBC
               MsUnlock()
            Endif

            dbSelectArea("SZ2")
            dbSkip()
         EndDo

         cMesI := StrZero((Val(cMesI)+1),2)

         If cMesI > "12"
            cMesI := "01"
            cAnoI := StrZero((Val(cAnoI)+1),4)
         EndIf

      EndDo

      dbSelectArea("SZ1")
      dbSkip()
   EndDo

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³Esta montado as Data de Vencimento dos Fornecedores ³
   // ³          (SZC - Contrato x Fornecedor)             ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   cAnoF := SubStr(DtoS(dDataFina),1,4)
   cMesF := SubStr(DtoS(dDataFina),5,2)

   dbSelectArea("SZC")
   dbSetOrder(1)
   dbGoTop()

   ProcRegua(RecCount())  // Inicializa regua
   cMsgRegua := "Processando os Contratos x Fornecedores"

   While ! Eof()

      dbSelectArea("SZC")
      cAnoI   := SubStr(DtoS(dDataInic),1,4)
      cMesI   := SubStr(DtoS(dDataInic),5,2)
      cCodAnt := SZC->ZC_CONTRAT

      While  ! Eof()                           .And. ;
             SZC->ZC_FILIAL  == xFilial("SZC") .And. ;
             SZC->ZC_CONTRAT == cCodAnt        .And. ;
             (cAnoI+cMesI)   <= (cAnoF+cMesF)

         dDtReVenc := (StoD(cAnoI+cMesI+SZC->ZC_VENCFAT)+Val(SZC->ZC_DIAFREN))

         IncProc(cMsgRegua)

         If Empty(dDtReVenc)
            dbSelectArea("SZC")
            dbSkip()
            Loop
         EndIf

         If dDtReVenc < dDataInic .And. ;
            dDtReVenc > dDataFina
            dbSelectArea("SZC")
            dbSkip()
            Loop
         EndIf

         dbSelectArea("SZ2")
         dbSetOrder(1)
         dbSeek(xFilial("SZ2")+SZC->ZC_CONTRAT)

         While (! Eof())                            .And.;
               (xFilial("SZ2")  == SZ2->Z2_FILIAL)  .And.;
               (SZ2->Z2_COD     == SZC->ZC_CONTRAT)

            cContrato := SZC->ZC_CONTRAT+Space(6-Len(SZC->ZC_CONTRAT))
            cSubConta := SZ2->Z2_SUBC+Space(11-Len(SZ2->Z2_SUBC))
            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"F"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "F"
               Replace  CodiClFo  With  SZC->ZC_FORNECE
               Replace  LojaClFo  With  SZC->ZC_LOJA
               Replace  Contrato  With  SZC->ZC_CONTRAT
               Replace  SubConta  With  SZ2->Z2_SUBC
               MsUnlock()
            Endif

            dbSelectArea("SZ2")
            dbSkip()
         EndDo

         cMesI := StrZero((Val(cMesI)+1),2)

         If cMesI > "12"
            cMesI := "01"
            cAnoI := StrZero((Val(cAnoI)+1),4)
         EndIf

      EndDo

      dbSelectArea("SZC")
      dbSkip()
   EndDo

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³Esta montado as Data de Vencimento dos Diversos e Empregados ³
   // ³                     (SZB - Orcameto)                        ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   cAnoF := SubStr(DtoS(dDataFina),1,4)
   cMesF := SubStr(DtoS(dDataFina),5,2)

   dbSelectArea("SZB")
   dbSetOrder(1)
   dbGoTop()

   ProcRegua(RecCount())  // Inicializa regua
   cMsgRegua := "Processando os Tipos Diversos e Empregados"

   While ! Eof()

      If ! SZB->ZB_TIPO $ "D_E"
         dbSelectArea("SZB")
         dbSkip()
         Loop
      EndIf

      dbSelectArea("SZB")
      cAnoI   := SubStr(DtoS(dDataInic),1,4)
      cMesI   := SubStr(DtoS(dDataInic),5,2)
      cCodAnt := SZB->ZB_CCUSTO

      While  ! Eof()                           .And. ;
             SZB->ZB_FILIAL  == xFilial("SZB") .And. ;
             SZB->ZB_CCUSTO == cCodAnt         .And. ;
             (cAnoI+cMesI)   <= (cAnoF+cMesF)

         IncProc(cMsgRegua)

         If SZB->ZB_TIPO == "D"
            dDtReVenc := (StoD(cAnoI+cMesI+"10"))

            If Empty(dDtReVenc)
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            If dDtReVenc < dDataInic .And. ;
               dDtReVenc > dDataFina
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            dbSelectArea("SZ2")
            dbSetOrder(3)
            dbSeek(xFilial("SZ2")+SZB->ZB_CCUSTO)

            cContrato := SZ2->Z2_COD+Space(6-Len(SZ2->Z2_COD))
            cSubConta := SZB->ZB_CCUSTO+Space(11-Len(SZB->ZB_CCUSTO))

            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"F"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "F"
               Replace  CodiClFo  With  Left(SZB->ZB_DESCRI,6)
               Replace  LojaClFo  With  SubStr(SZB->ZB_DESCRI,7,2)
               Replace  Contrato  With  SZ2->Z2_COD
               Replace  SubConta  With  SZB->ZB_CCUSTO
               MsUnlock()
            Endif
         ElseIf SZB->ZB_TIPO == "E"
            dDtReVenc := (StoD(cAnoI+cMesI+"05"))

            If Empty(dDtReVenc)
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            If dDtReVenc < dDataInic .And. ;
               dDtReVenc > dDataFina
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            dbSelectArea("SZ2")
            dbSetOrder(3)
            dbSeek(xFilial("SZ2")+SZB->ZB_CCUSTO)

            cContrato := SZ2->Z2_COD+Space(6-Len(SZ2->Z2_COD))
            cSubConta := SZB->ZB_CCUSTO+Space(11-Len(SZB->ZB_CCUSTO))

            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"F"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "F"
               Replace  CodiClFo  With  "000907"
               Replace  LojaClFo  With  "01"
               Replace  Contrato  With  SZ2->Z2_COD
               Replace  SubConta  With  SZB->ZB_CCUSTO
               Replace  CodEmpre  With  Iif(SZB->ZB_TIPO == "E",SZB->ZB_DESCRI,"")
               MsUnlock()
            Endif
         EndIf

         cMesI := StrZero((Val(cMesI)+1),2)

         If cMesI > "12"
            cMesI := "01"
            cAnoI := StrZero((Val(cAnoI)+1),4)
         EndIf

      EndDo

      dbSelectArea("SZB")
      dbSkip()
   EndDo

   dbSelectArea("TRBC")
   dbSetOrder(1)
   Set SoftSeek On
   dbSeek(DtoS(dDataInic))
   Set SoftSeek Off

   ProcRegua(RecCount())  // Inicializa regua
   cMsgRegua := "Processando os Orcamentos"

   While ! Eof()                     .And. ;
         TRBC->DtTitulo <= dDataFina

      cAno    := SubStr(DtoS(TRBC->DtTitulo),1,4)
      cMes    := SubStr(DtoS(TRBC->DtTitulo),5,2)
      cRev    := "000"
      cCCusto := (TRBC->SUBCONTA+Space(11-Len(TRBC->SUBCONTA)))

      If TRBC->CODICLFO == "000907" .And. ! Empty(TRBC->CODEMPRE)
         cDescri := (TRBC->CODEMPRE+Space(10-Len(TRBC->CODEMPRE)))
      Else
         cDescri := (TRBC->CODICLFO+TRBC->LOJACLFO+Space(10-Len(TRBC->CODICLFO+TRBC->LOJACLFO)))
      EndIf

      dbSelectArea("SZB")
      dbSetOrder(1)
      dbSeek(xFilial("SZB")+cCCusto+cAno)

      While (! Eof())                                            .And. ;
            (Alltrim(SZB->ZB_CCUSTO) == Alltrim(TRBC->SUBCONTA)) .And. ;
            (SZB->ZB_ANO             == cAno)

        If Val(cRev) < Val(SZB->ZB_Revisao)
           cRev := SZB->ZB_Revisao
        EndIf

        dbSelectArea("SZB")
        dbSkip()

      EndDo

      dbSelectArea("SZB")
      dbSetOrder(2)
      dbSeek(xFilial("SZB")+cCCusto+cAno+cRev+cDescri)

      IncProc(cMsgRegua)

      If ! Eof()

         If TRBC->DtTitulo < dDataBase
            dDataTrab := dDataBase - 1
         Else
            dDataTrab := DataValida(TRBC->DtTitulo,.T.)
         Endif

         dbSelectArea("SZA")
         dbSetOrder(1)
         dbSeek(xFilial("SZA")+SZB->ZB_GRUPGER)

         If ! Eof() .And. SZA->ZA_FLUXO == "S"

            If TRBC->TipoClFo == "C"
               dbSelectArea("SA1")
               dbSetOrder(1)
               dbSeek(xFilial("SA1")+TRBC->CodiClFo+TRBC->LojaClFo)
               cNome := SA1->A1_NOME
            ElseIf TRBC->TipoClFo == "F"
               dbSelectArea("SA2")
               dbSetOrder(1)
               dbSeek(xFilial("SA2")+TRBC->CodiClFo+TRBC->LojaClFo)
               cNome := SA2->A2_NOME
            EndIf

            dbSelectArea("TRBF")
            If ! (dbSeek(DtoS(dDataTrab)+SZB->ZB_TIPO+SZ1->Z1_CODCLI+SZ1->Z1_LOJA))
               RecLock("TRBF",.T.)
               Replace  DtTitulo  With  dDataTrab
               Replace  TipoClFo  With  TRBC->TIPOCLFO
               Replace  CodiClFo  With  TRBC->CODICLFO
               Replace  LojaClFo  With  TRBC->LOJACLFO
               Replace  NomeClFo  With  cNome
               Replace  Prefixo   With  ""
               Replace  NumTitu   With  ""
               Replace  TipTitu   With  ""
               Replace  Situacao  With  "O"
               Replace  Contrato  With  TRBC->Contrato
               Replace  SubConta  With  TRBC->SubConta
               Do Case
                  Case cMes == "01"
                       If SZB->ZB_MES01 < SZB->ZB_SALD01
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES01 - SZB->ZB_SALD01)
                       EndIf
                  Case cMes == "02"
                       If SZB->ZB_MES02 < SZB->ZB_SALD02
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES02 - SZB->ZB_SALD02)
                       EndIf
                  Case cMes == "03"
                       If SZB->ZB_MES03 < SZB->ZB_SALD03
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES03 - SZB->ZB_SALD03)
                       EndIf
                  Case cMes == "04"
                       If SZB->ZB_MES04 < SZB->ZB_SALD04
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES04 - SZB->ZB_SALD04)
                       EndIf
                  Case cMes == "05"
                       If SZB->ZB_MES05 < SZB->ZB_SALD05
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES05 - SZB->ZB_SALD05)
                       EndIf
                  Case cMes == "06"
                       If SZB->ZB_MES06 < SZB->ZB_SALD06
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES06 - SZB->ZB_SALD06)
                       EndIf
                  Case cMes == "07"
                       If SZB->ZB_MES07 < SZB->ZB_SALD07
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES07 - SZB->ZB_SALD07)
                       EndIf
                  Case cMes == "08"
                       If SZB->ZB_MES08 < SZB->ZB_SALD08
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES08 - SZB->ZB_SALD08)
                       EndIf
                  Case cMes == "09"
                       If SZB->ZB_MES09 < SZB->ZB_SALD09
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES09 - SZB->ZB_SALD09)
                       EndIf
                  Case cMes == "10"
                       If SZB->ZB_MES10 < SZB->ZB_SALD10
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES10 - SZB->ZB_SALD10)
                       EndIf
                  Case cMes == "11"
                       If SZB->ZB_MES11 < SZB->ZB_SALD11
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES11 - SZB->ZB_SALD11)
                       EndIf
                  Case cMes == "12"
                       If SZB->ZB_MES12 < SZB->ZB_SALD12
                          Replace ValrTitu With 0
                       Else
                          Replace ValrTitu With (SZB->ZB_MES12 - SZB->ZB_SALD12)
                       EndIf
               EndCase
               Replace  SaldTitu  With  0
               MsUnlock()
            Endif
         Endif
      Endif
      dbSelectArea("TRBC")
      dbSkip()
   EndDo

EndIf

dbSelectArea("TRBF")
dbSetOrder(1)
dbGoTop()

While ! Eof()

   dbSelectArea("TRBT")
   If ! (dbSeek(TRBF->Contrato))
      RecLock("TRBT",.T.)
      Replace  Contrato  With  TRBF->Contrato
      Replace  SubConta  With  TRBF->SubConta
      If TRBF->Situacao == "P"
         If TRBF->TIPOCLFO == "F"
            Replace  TotlConD  With  TRBF->ValrTitu
         ElseIf TRBF->TIPOCLFO == "C"
            Replace  TotlConR  With  TRBF->ValrTitu
         EndIF
      ElseIf TRBF->Situacao == "O"
         If TRBF->TIPOCLFO == "F"
            Replace  TotlCoOD  With  TRBF->ValrTitu
         ElseIf TRBF->TIPOCLFO == "C"
            Replace  TotlCoOR  With  TRBF->ValrTitu
         EndIf
      EndIf
      MsUnlock()
   Else
      RecLock("TRBT",.F.)
      If TRBF->Situacao == "P"
         If TRBF->TIPOCLFO == "F"
            Replace  TotlConD  With  TRBT->TotlConD + TRBF->ValrTitu
         ElseIf TRBF->TIPOCLFO == "C"
            Replace  TotlConR  With  TRBT->TotlConR + TRBF->ValrTitu
         EndIF
      ElseIf TRBF->Situacao == "O"
         If TRBF->TIPOCLFO == "F"
            Replace  TotlCoOD  With  TRBT->TotlCoOD + TRBF->ValrTitu
         ElseIf TRBF->TIPOCLFO == "C"
            Replace  TotlCoOR  With  TRBT->TotlCoOR + TRBF->ValrTitu
         EndIf
      EndIf
      MsUnlock()
   Endif
   dbSelectArea("TRBF")
   dbSkip()
EndDo

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FaT900Imp
Static Function FaT900Imp()
*****************************************************************************
* Imprime as Informacoes do Arquivo de Trabalho TRBF
***

m_pag	  := 1
nLinha	  := 80
cRodatxt  := ""
nCntImpr  := 0

dDataAnt  := CtoD(Space(08))
nSaldo	  := nBancos
nSaldG	  := 0
nTotaRec  := 0
nTotaDes  := 0
nTotGRec  := 0
nTotGDes  := 0
nTotalDia := 0
cTipoRD   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza e grava titulos a receber dentro dos parametros     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("TRBF")
dbSetorder(1)
dbGoTop()

While ! eof()

   dDataAnt := TRBF->DtTitulo

   While ! Eof()                    .And. ;
	 dDataAnt == TRBF->DtTitulo

      dbSelectArea("TRBF")
      dbSetorder(1)
      nRecnoC1 := Recno()
      dbSeek(DtoS(dDataAnt)+"C")

      If ! Eof()
         cTipoRD   := "C"
         ImprCabe()
         While ! Eof()                    .And. ;
               TRBF->DtTitulo == dDataAnt .And. ;
               TRBF->TipoClFo == "C"

            ImprDeta()

            dbSelectArea("TRBF")
            dbSkip()
         EndDo
         ImpTotRD()
         nRecnoC2 := Recno()
      Else
         DbSelectArea("TRBF")
         DbGoTo(nRecnoC1)
      EndIf

      dbSelectArea("TRBF")
      dbSetorder(1)
      dbGoTo(nRecnoC1)
      dbSeek(DtoS(dDataAnt)+"F")

      If ! Eof()
         cTipoRD   := "F"
         ImprCabe()
         While ! Eof()                    .And. ;
               TRBF->DtTitulo == dDataAnt .And. ;
               TRBF->TipoClFo == "F"

            ImprDeta()

            dbSelectArea("TRBF")
            dbSkip()
         EndDo
         ImpTotRD()
      Else
         dbSelectArea("TRBF")
         dbGoTo(nRecnoC2)
      EndIf
      cTipoRD   := ""
   EndDo

   nTotalDia := ((nTotalDia + nTotaRec) - nTotaDes)
   ImpTotDia()
   nSaldo    := ((nSaldo + nTotaRec) - nTotaDes)
   nTotaRec  := 0
   nTotaDes  := 0
   nTotalDia := 0

EndDo

ImprTotP()

nBancos  := 0
nTotGRec := 0
nTotGDes := 0
nSaldG	 := 0

IF nLinha != 80
   Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF

Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImprCabe
Static Function ImprCabe()
*****************************************************************************
* Impressao do Relatorio (Cabecalho)
***


If nLinha >= 57
   If cAnalSint == 1
      cabec1   := "Dia : "+DtoC(dDataAnt)+"                                                                  Saldo Anterior: " + ;
                   Transform(nSaldo,"@E 999,999,999,999,999.99")
      If TRBF->TipoClFo == "C"
         cabec2   := "Cod.Cliente                                 No Tit/Pref  Tipo  Situacao  Contrato  SubCont                       Valor"
      ElseIf TRBF->TipoClFo == "F"
         cabec2   := "Cod.Fornecedor                              No Tit/Pref  Tipo  Situacao  Contrato  SubCont                       Valor"
      EndIf
      nLinha := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho) + 2
   ElseIf cAnalSint == 2
      cabec1   := "Dia : "+DtoC(dDataAnt)
      cabec2   := "                                              Saldo Anterior:" + ;
                   Transform(nSaldo,"@E 999,999,999,999,999.99")
      nLinha := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho) + 2
   EndIf
Else
   If cAnalSint == 1
      @ nLinha,   000 PSAY Replicate("-",118)
      nLinha := nLinha + 1
      @ nLinha,   000 PSAY "Dia : "+DtoC(dDataAnt)+"                                                                  Saldo Anterior: " + ;
                           Transform(nSaldo,"@E 999,999,999,999,999.99")
      nLinha := nLinha + 1
      If TRBF->TipoClFo == "C"
         @ nLinha,   000 PSAY "Cod.Cliente                                 No Tit/Pref  Tipo  Situacao  Contrato  SubCont                       Valor"
      ElseIf TRBF->TipoClFo == "F"
         @ nLinha,   000 PSAY "Cod.Fornecedor                              No Tit/Pref  Tipo  Situacao  Contrato  SubCont                       Valor"
      EndIf
      nLinha := nLinha + 2
   ElseIf cAnalSint == 2
      @ nLinha,   000 PSAY Replicate("-",118)
      nLinha := nLinha + 1
      @ nLinha,   000 PSAY "Dia : "+DtoC(dDataAnt)
      nLinha := nLinha + 1
      @ nLinha,   000 PSAY "                                              Saldo Anterior:" + ;
                           Transform(nSaldo,"@E 999,999,999,999,999.99")
      nLinha := nLinha + 1
   EndIf
EndIf

dbSelectArea("TRBF")

Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Imprdeta
Static Function Imprdeta()
*****************************************************************************
*  Imprime as Linhas de Detalhe
***

If (nLinha > 60 )
   nLinha := 80
   ImprCabe()
EndIf

If cAnalSint == 1
   @ nLinha,000 PSAY TRBF->CodiClFo+"-"+TRBF->LojaClFo+" - "+TRBF->NomeClFo
   @ nLinha,044 PSAY TRBF->NumTitu+"/"+TRBF->Prefixo
   @ nLinha,057 PSAY TRBF->TipTitu
   @ nLinha,063 PSAY Iif(TRBF->Situacao == "P","Previsto","Orcado")
   @ nLinha,074 PSAY TRBF->Contrato
   @ nLinha,083 PSAY TRBF->SubConta
   @ nLinha,100 PSAY TRBF->ValrTitu  Picture "@E 999,999,999,999.99"

   nLinha := nLinha + 1

EndIf

If TRBF->TipoClFo == "C"
   nTotaRec := nTotaRec + TRBF->ValrTitu
   nTotGRec := nTotGRec + TRBF->ValrTitu
ElseIf TRBF->TipoClFo == "F"
   nTotaDes := nTotaDes + TRBF->ValrTitu
   nTotGDes := nTotGDes + TRBF->ValrTitu
EndIf

Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImpTotRD
Static Function ImpTotRD()
*****************************************************************************
* Impressao do Relatorio Total da Receita ou Despesa
*
***

If (nLinha > 57 )
   nLinha := 80
   ImprCabe()
EndIf


If cAnalSint == 1
   If cTipoRD == "C"
      @ nLinha, 096 PSAY Replicate("-",22)
      nLinha := nLinha + 1
      @ nLinha, 081 PSAY "Total Receita:"
      @ nLinha, 100 PSAY nTotaRec                    Picture "@E 999,999,999,999.99"
      nLinha := nLinha + 1
   ElseIf cTipoRD == "F"
      @ nLinha, 096 PSAY Replicate("-",22)
      nLinha := nLinha + 1
      @ nLinha, 081 PSAY "Total Despesa:"
      @ nLinha, 100 PSAY nTotaDes                    Picture "@E 999,999,999,999.99"
     nLinha := nLinha + 1
   EndIf
ElseIf cAnalSint == 2
   If cTipoRD == "C"
      @ nLinha, 062 PSAY Replicate("-",22)
      nLinha := nLinha + 1
      @ nLinha, 047 PSAY "Total Receita:"
      @ nLinha, 066 PSAY nTotaRec                    Picture "@E 999,999,999,999.99"
      nLinha := nLinha + 1
   ElseIf cTipoRD == "F"
      @ nLinha, 062 PSAY Replicate("-",22)
      nLinha := nLinha + 1
      @ nLinha, 047 PSAY "Total Despesa:"
      @ nLinha, 066 PSAY nTotaDes                    Picture "@E 999,999,999,999.99"
     nLinha := nLinha + 1
   EndIf
EndIf

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImpTotDia
Static Function ImpTotDia()
*****************************************************************************
* Impressao do Relatorio Total do Dia
*
***

If (nLinha > 57 )
   nLinha := 80
   ImprCabe()
EndIf

If cAnalSint == 1
   @ nLinha, 096 PSAY Replicate("-",22)
   nLinha := nLinha + 1
   @ nLinha, 073 PSAY "Total do Dia "+DtoC(dDataAnt)+":"
   @ nLinha, 100 PSAY nTotalDia                    Picture "@E 999,999,999,999.99"
   nLinha := nLinha + 2
ElseIf cAnalSint == 2
   @ nLinha, 062 PSAY Replicate("-",22)
   nLinha := nLinha + 1
   @ nLinha, 039 PSAY "Total do Dia "+DtoC(dDataAnt)+":"
   @ nLinha, 066 PSAY nTotalDia                    Picture "@E 999,999,999,999.99"
   nLinha := nLinha + 2
EndIf

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImprTotP
Static Function ImprTotP()
*****************************************************************************
* Impressao do Relatorio Total do Periodo do Departamento
*
***

If (nLinha > 57 )
   nLinha := 80
   ImprCabe()
EndIf

nSaldG := ((nBancos + nTotGRec) - nTotGDes)

If cAnalSint == 1
   nLinha := nLinha + 1
   @ nLinha, 000 PSAY Replicate("-",118)
   nLinha := nLinha + 1
   @ nLinha, 069 PSAY "Total Receita Periodo:"
   @ nLinha, 100 PSAY nTotGRec                    Picture "@E 999,999,999,999.99"
   nLinha := nLinha + 1
   @ nLinha, 069 PSAY "Total Despesa Periodo:"
   @ nLinha, 100 PSAY nTotGDes                    Picture "@E 999,999,999,999.99"
   nLinha := nLinha + 1
   @ nLinha, 085 PSAY "Saldo:"
   @ nLinha, 100 PSAY nSaldG                      Picture "@E 999,999,999,999.99"
   nLinha := nLinha + 1
ElseIf cAnalSint == 2
   nLinha := nLinha + 1
   @ nLinha, 000 PSAY Replicate("-",118)
   nLinha := nLinha + 1
   @ nLinha, 039 PSAY "Total Receita Periodo:"
   @ nLinha, 062 PSAY nTotGRec                    Picture "@E 999,999,999,999,999.99"
   nLinha := nLinha + 1
   @ nLinha, 039 PSAY "Total Despesa Periodo:"
   @ nLinha, 062 PSAY nTotGDes                    Picture "@E 999,999,999,999,999.99"
   nLinha := nLinha + 1
   @ nLinha, 055 PSAY "Saldo:"
   @ nLinha, 062 PSAY nSaldG                      Picture "@E 999,999,999,999,999.99"
   nLinha := nLinha + 1
EndIf

ImprToCon()

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImprToCon
Static Function ImprToCon()
*****************************************************************************
* Impressao do Relatorio Total do Periodo do Departamento
*
***

If (nLinha > 55 )
   nLinha := 80
   ImprCabe()
EndIf

dbSelectArea("TRBT")
dbSetorder(1)
dbGoTop()

If ! Eof()

   nLinha := nLinha + 1
   @ nLinha, 000 PSAY Replicate("-",130)
   nLinha := nLinha + 1
   @ nLinha, 000 PSAY "Contrato    Total Previsto Receita  Total Previsto Despesa    Total Orcado Receita    Total Orcado Despesa   Total (PR+OR)-(PD+OD)"
   nLinha := nLinha + 2

   dbSelectArea("TRBT")
   While ! eof()

      If nLinha > 60
         nLinha := 80
         ImprCabe()
         @ nLinha, 000 PSAY "Contrato    Total Previsto Receita  Total Previsto Despesa    Total Orcado Receita    Total Orcado Despesa   Total (PR+OR)-(PD+OD)"
      EndIf

      @ nLinha, 000 PSAY TRBT->Contrato
      @ nLinha, 012 PSAY TRBT->TotlConR                      Picture "@E 999,999,999,999.99"
      @ nLinha, 036 PSAY TRBT->TotlConD                      Picture "@E 999,999,999,999.99"
      @ nLinha, 060 PSAY TRBT->TotlCoOR                      Picture "@E 999,999,999,999.99"
      @ nLinha, 084 PSAY TRBT->TotlCoOD                      Picture "@E 999,999,999,999.99"
      @ nLinha, 108 PSAY (TRBT->TotlConR+TRBT->TotlCoOR) - ;
                         (TRBT->TotlConD+TRBT->TotlCoOD)     Picture "@E 999,999,999,999.99"

     nLinha := nLinha + 1
     dbSelectArea("TRBT")
     dbSkip()
   EndDo

EndIf

Return

