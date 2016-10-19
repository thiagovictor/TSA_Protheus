#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF  

User Function CONR120B()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,WNREL,CSTRING")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,CABEC1")
SetPrvt("CABEC2,CCANCEL,TAMANHO,LI,M_PAG,CLOTEINI")
SetPrvt("CLOTEFIM,DDATADE,DDATAATE,CCODICONT,CMOED,CTIPORELA")
SetPrvt("LSALTPAGI,CTIPOIMPR,LDESMEMBRA,LIMITE,NTOTDEB,NTOTCRD")
SetPrvt("NTOTDIG,DDATAINI,CDOCANT,NTOTTINF,NTOTTDEB,NTOTTCRED")
SetPrvt("NTOTTDIG,NTOTTDIF,NVALLANC,NDIFDBCR,DDATAATU,CPER")
SetPrvt("CPERIODOI2,CPERIODO,CBTXT,CBCONT,NTOTRDDEB,NTOTRDCRD")
SetPrvt("NTOTDIAS,NTOTHIST,CRESDEB,CRESCRD,LCUSTO,CDIGVER")
SetPrvt("DDATA,CDEBITO,CCREDITO,CFILTRO,CFILTERUSER,LARQTMP")
SetPrvt("CMESATU17,CTOTINFO,CTOTDEBIT,CTOTDIGI,CTOTCREDI,CDIFER")
SetPrvt("CDIF,CTOTGER,CANALITICO,LEND,CLOTE,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/06/01 ==> 	#DEFINE PSAY SAY
#ENDIF  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Conr120B ³ Autor ³ Alcides R. de Andrade ³ Data ³ 25.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o de Lancamentos por Lote para EPC - Voucher         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Conr120B                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Foi alterado o programa original CONR120, para se adaptar  ³±±
±±³ Uso      ³ ao lay-out do relatorio emitido pelo cliente, facilitando  ³±±
±±³          ³ desta forma sua analise e conferencia.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo   := "Relacao de Lotes"
cDesc1   := "Este programa tem o objetivo de emitir a  rela‡„o  de  lotes"
cDesc2   := "digitados. Poder  ser emitido de forma Anal¡tica (todos lan-"
cDesc3   := "‡amentos) ou Sint‚tica (Apenas os totais do lote)."
wnrel    := "CONR120B"            //Nome Default do relatorio em Disco
cString  := "SI2"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog :="CONR120B"
aLinha   := { }
nLastKey := 0
cPerg    :="COR120"
cabec1   := " " 
cabec2   := " "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
tamanho  := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li     := 80
m_pag  := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("COR120",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01      // do lote                                     ³
//³ mv_par02      // at‚ o lote                                  ³
//³ mv_par03      // da data                                     ³
//³ mv_par04      // ate a data                                  ³
//³ mv_par05      // Cod Conta ou Reduzido                       ³
//³ mv_par06      // Moeda                                       ³
//³ mv_par07      // Tipo do Relatorio (Analitico ou Sintetico)  ³
//³ mv_par08      // Salta pagina por lote                       ³
//³ mv_par09      // Imprime? Lancamento / Pre-Lancamento        ³
//³ mv_par10      // Desmembra ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel :="CONR120B"            //Nome Default do relatorio em Disco
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

cLoteIni   := mv_par01
cLoteFim   := mv_par02
dDataDe    := mv_par03
dDataAte   := mv_par04
cCodiCont  := mv_par05
cMoed      := mv_par06
cTipoRela  := mv_par07
lSaltPagi  := mv_par08
cTipoImpr  := mv_par09
lDesmembra := mv_par10

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif


#IFDEF WINDOWS
       RptStatus({|| Cr120Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>        RptStatus({|| Execute(Cr120Imp)})
#ELSE
       Cr120Imp()
#ENDIF
   

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ Cr120Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Relacao de Lotes                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ Cr120Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACON                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes ³ Alterador por Alcides R. de Andrade em 25.11.99            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Cr120Imp
Static Function Cr120Imp()

limite      := 132
nTotDeb     := 0
nTotCrd     := 0
nTotDig     := 0
dDataIni    := Periodo(dDataDe,cMoed)
cDocAnt     := " "
nTotTInf    := 0
nTotTDeb    := 0
nTotTCred   := 0
nTotTDig    := 0
nTotTDif    := 0
nValLanc    := 0
nDifDbCr    := 0
dDataAtu    := dDataDe
cPer        := " "
//cPeriodoI2  := " "
cPeriodo    := " "
cbtxt       := SPACE(10)
cbcont      := 0
nTotRdDeb   := 0
nTotRdCrd   := 0
nTotDias    := 0
nTotHist    := 0
cResDeb     := " "
cResCrd     := " "
lCusto      := .F.
cDigVer     := GetMv("MV_DIGVER")
dData       := ctod ("  /  /  ")
cDebito     := " "
cCredito    := " "
cFiltro     := " "
cFilterUser := " " 
lArqTmp     := .F.
cMesAtu17   := " " 
cTotInfo    := "Total Informado : "
cTotDebit   := "Total Debito :"
cTotDigi    := "Total Digitado  :"
cTotCredi   := "Total Credito:"
cDifer      := "Diferenca Total:"
cDif        := "Dif Debito/Credito:"
cTotGer     := "TOTAL GERAL ----->"
cAnalitico  := " - Analitico"

cabec1 :="Conta     Nome Conta                 Lancto. Historico                                        Debito        Credito   C.Custo "
cabec2 := " " 

dDataAtu := dDataAte

// Se a moeda escolhida, nao esta em uso -> sai do programa.
If Empty(GetMv("MV_MOEDA"+Str(cMoed,1)))
	Set Filter To
	Return
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o Periodo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataIni:=Periodo(dDataDe,cMoed)

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("I2_CCD")
If X3Uso(X3_USADO)
	 lCusto := .T.
End
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza Lancamento inicial                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SI2")
Set Softseek On
dbSetOrder(1)
dbSeek(xFilial("SI2")+cloteini,.T.)

SetRegua(RecCount())

While  !Eof()                        .and.; 
       I2_FILIAL  == xFilial("SI2")  .and.;
       I2_LOTE    >= cLoteIni        .and.;
       I2_LOTE    <= cLoteFim        .and.;
       I2_DATA    >= dDataDe         .and.;
       I2_DATA    <= dDataAte        .and.;
       IncRegua()

	#IFNDEF WINDOWS
		Inkey()
		If Lastkey() == K_ALT_A
			lEnd := .T.
		EndIf
	#ENDIF

	IF lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	cLote := I2_LOTE
	cPer  := I2_PERIODO

	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		li := li - 1
	ElseIf lSaltPagi == 1                                                            // quebra por lote
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		li := li - 1 
	EndIF

	dbSelectArea("SI1")
	dbSetOrder(1)
	If SI2->I2_DC == "D" 
	   dbSeek(xFilial("SI1")+SI2->I2_DEBITO)
	   @li, 00 PSAY Substr(SI2->I2_DEBITO,1,8)
	   @li, 10 PSAY SI1->I1_DESC
	   @li, 38 PSAY SI2->I2_LINHA
	   @li, 45 PSAY SI2->I2_HIST
	   @li, 86 PSAY SI2->I2_VALOR Picture tm ( SI2->I2_VALOR, 14 )
	   @li,118 PSAY SI2->I2_CCD
	   nTotTDeb := nTotTDeb + SI2->I2_VALOR
	ElseIf SI2->I2_DC == "C" 
	   dbSeek(xFilial("SI1")+SI2->I2_CREDITO)
	   @li, 00 PSAY Substr(SI2->I2_CREDITO,1,8)
	   @li, 10 PSAY SI1->I1_DESC
	   @li, 38 PSAY SI2->I2_LINHA
	   @li, 45 PSAY SI2->I2_HIST
	   @li,102 PSAY SI2->I2_VALOR Picture tm ( SI2->I2_VALOR, 14 )
	   @li,118 PSAY SI2->I2_CCD
	   nTotTCred := nTotTCred + SI2->I2_VALOR
	EndIf
	If SI2->I2_DC == "X"
	   dbSeek(xFilial("SI1")+SI2->I2_DEBITO)
	   @li, 00 PSAY Substr(SI2->I2_DEBITO,1,8)
	   @li, 10 PSAY SI1->I1_DESC
	   @li, 38 PSAY SI2->I2_LINHA
	   @li, 45 PSAY SI2->I2_HIST
	   @li, 86 PSAY SI2->I2_VALOR Picture tm ( SI2->I2_VALOR, 14 )
	   @li,118 PSAY SI2->I2_CCD
	   li := li + 1
	   dbSeek(xFilial("SI1")+SI2->I2_CREDITO)
	   @li, 00 PSAY Substr(SI2->I2_CREDITO,1,8)
	   @li, 10 PSAY SI1->I1_DESC
	   @li, 38 PSAY SI2->I2_LINHA
	   @li, 45 PSAY SI2->I2_HIST
	   @li,102 PSAY SI2->I2_VALOR Picture tm ( SI2->I2_VALOR, 14 )
	   @li,118 PSAY SI2->I2_CCD
	   nTotTDeb := nTotTDeb + SI2->I2_VALOR
	   nTotTCred:= nTotTCred+ SI2->I2_VALOR
	EndIf
	If SI2->I2_DC == "-"
	   @li, 45 PSAY SI2->I2_HIST
	EndIf
       li := li + 1
       dbSelectArea("SI2")
       dbSkip()

End
ImpTot120()
roda(cbcont,cbtxt,Tamanho)

#IFNDEF WINDOWS
	Set Device To Screen
#ENDIF
dbSetOrder(1)
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpTot120 ³ Autor ³ Erick Nori Barbosa    ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRIMIR TOTAL DO RELATORIO                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTot120()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Conr120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImpTot120
Static Function ImpTot120()

li := li + 2

If ( li > 55 )
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
End

@li,060 PSAY "TOTAIS ->"
@li,086 PSAY nTotTDeb               Picture TM(nTotTDeb,14)
@li,102 PSAY nTotTCred              Picture TM(nTotTCred,14)
Return(.T.)
