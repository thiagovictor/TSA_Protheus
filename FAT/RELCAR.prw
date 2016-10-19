#Include "Protheus.ch" 

/*
+-----------+----------+-------------------------------------+----------------+
| Programa  | RELCAR   | Autor | Gilson  Lucas               | Data: 06/08/09 |
+-----------+----------+-------------------------------------+----------------+
| Descricao | Relatorio controle de veiculos                                  |
+-----------+-----------------------------------------------------------------+
| Uso       |  MP10                                                           |
+-----------+-----------------------------------------------------------------+
|           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                  |
+------------+--------+-------------------------------------------------------+
|PROGRAMADOR | DATA   | MOTIVO DA ALTERACAO                                   |
+------------+--------+-------------------------------------------------------+
|            |        |                                                       |
+-----------------------------------------------------------------------------+
*/   
User Function RELCAR()

Local oReport
oReport:= ReportDef()
oReport:PrintDialog()

Return


Static Function ReportDef()
**********************************************************************************
* Definicoes do Relatorio
***

Local aOrdem    := {OemToAnsi("Placa+Data Entrega+Data Devolução")}
Local cAliasTRB := GetNextAlias()
Local aSizeQT	  := {09,2}
Local aSizePR   := {5,2}
Local aSizeVL	  := {09,2}
Local cPictQT   := "@E 999999.99"
Local cPictPR   := "@E 99.99"
Local cPictVL   := "@E 999999.99"
Local oSection

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("RELCAR",OemToAnsi("Controle de veiculos"),"RELCAR", {|oReport| ReportPrint(oReport,aOrdem,cAliasTRB)},OemToAnsi("Controle de entrega/devolução de veiculos"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Acertar Parametros

PutSx1(oReport:uParam,"01",OemToAnsi("Da Placa ?")         ,OemToAnsi("Da Placa ?")          ,OemToAnsi("Da Placa ?")          ,"mv_ch1","C",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{ OemToAnsi("Define placa inical para filtro")}, {}, {} )
PutSx1(oReport:uParam,"02",OemToAnsi("Ate Placa ?")        ,OemToAnsi("Ate Placa ?")         ,OemToAnsi("Ate Placa ?")         ,"mv_ch2","C",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{ OemToAnsi("Define placa final para filtro")}, {}, {} )
PutSx1(oReport:uParam,"03",OemToAnsi("Entrega Inicial ?")  ,OemToAnsi("Entrega Inicial ?")   ,OemToAnsi("Entrega Inicial ?")   ,"mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a data inicial de entrega")}, {}, {} )
PutSx1(oReport:uParam,"04",OemToAnsi("Entrega Final ?")    ,OemToAnsi("Entrega Final ?")     ,OemToAnsi("Entrega Final ?")     ,"mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a data Final de entrega")}, {}, {} )
PutSx1(oReport:uParam,"05",OemToAnsi("Devolução Inicial ?"),OemToAnsi("Devolução Inicial ?") ,OemToAnsi("Entrega Inicial ?")   ,"mv_ch5","D",08,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a data inicial de devolução ")}, {}, {} )
PutSx1(oReport:uParam,"06",OemToAnsi("Devolução Final ?")  ,OemToAnsi("Devolução Final ?")   ,OemToAnsi("Entrega Final ?")     ,"mv_ch6","D",08,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a data Final de devolução ")}, {}, {} )
PutSx1(oReport:uParam,"07",OemToAnsi("Projeto Inicial ?")  ,OemToAnsi("Projeto Inicial ?")   ,OemToAnsi("Projeto Inicial ?")   ,"mv_ch7","C",05,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o projeto inicial para filtro")}, {}, {} )
PutSx1(oReport:uParam,"08",OemToAnsi("Projeto Final ?")    ,OemToAnsi("Projeto Final ?")     ,OemToAnsi("Projeto Final ?")     ,"mv_ch8","C",05,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o projeto final para filtro")}, {}, {} )
PutSx1(oReport:uParam,"09",OemToAnsi("Status ?")           ,OemToAnsi("Status ?")            ,OemToAnsi("Status ?")            ,"mv_ch9","N",01,0,0,"C","","","","","mv_par09","Todos","Todos","Todos","","Alocado","Alocado","Alocado","Entregue","Entregue","Entregue","Faturado","Faturado","Faturado","","","",{ OemToAnsi("Define quais status serão Impressos")}, {}, {} )

Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Sessao 1                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection := TRSection():New(oReport,OemToAnsi("Controle de entrega de veiculos"),{cAliasTRB},aOrdem)
oSection:SetTotalInLine(.F.)


TRCell():New(oSection,'ZZ1_UER'	      ,cAliasTRB,OemToAnsi("Condutor") ,/*Picture*/   ,35,.f.,/*{|| code-block de impressao }*/,,,"LEFT")
TRCell():New(oSection,'ZZ1_PROJET'	  ,cAliasTRB,OemToAnsi("Projeto")  ,/*Picture*/   ,10,.f.,/*{|| code-block de impressao }*/,,,"LEFT")
TRCell():New(oSection,'ZZ1_PLACA'	  ,cAliasTRB,OemToAnsi("Placa")    ,/*Picture*/   ,10,.f.,/*{|| code-block de impressao }*/,,,"LEFT")
TRCell():New(oSection,'ZZ1_DTAINI'	  ,cAliasTRB,OemToAnsi("Entrega")  ,/*Picture*/   ,10,.f.,/*{|| code-block de impressao }*/,,,"LEFT")
TRCell():New(oSection,'ZZ1_DTAFIM'	  ,cAliasTRB,OemToAnsi("Devolução"),/*Picture*/   ,10,.f.,/*{|| code-block de impressao }*/,,,"LEFT")
TRCell():New(oSection,'ZZ1_DIARIA'	  ,cAliasTRB,OemToAnsi("Diarias")  ,"@E 999"      ,05,.f.,/*{|| code-block de impressao }*/,,,"LEFT")
TRCell():New(oSection,'ZZ1_VALOR'	  ,cAliasTRB,OemToAnsi("Valor")    ,"@E 99,999,999.99",12,.f.,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection,'ZZ1_OBS'  	  ,cAliasTRB,OemToAnsi("Obs")      ,/*Picture*/   ,25,.f.,/*{|| code-block de impressao }*/,,,"LEFT")
          

oReport:SetPortrait()
oSection:SetHeaderPage()
oSection:SetNoFilter(cAliasTRB)

Return(oReport)



Static Function ReportPrint(oReport,aOrdem,cAliasTRB)
*******************************************************************************************************************
* Impressao Grafica
***
Local oSection   := oReport:Section(1)
Local nOrdem     := oSection:GetOrder()

oReport:SetTitle(oReport:Title()+" - ("+AllTrim(aOrdem[oSection:GetOrder()])+")")


MontaTrab(oReport,nOrdem,cAliasTRB,oSection)
	
//Processando Impressao
dbSelectArea(cAliasTRB)
dbGoTop()
oReport:SetMeter(LastRec())

oSection:Init()
cGrupoAnt  := ""
While ! oReport:Cancel() .And. !(cAliasTRB)->(Eof())
    oReport:IncMeter()

    oSection:Cell("ZZ1_UER"):SetValue((cAliasTRB)->ZZ1_UER)
    oSection:Cell("ZZ1_PROJET"):SetValue((cAliasTRB)->ZZ1_PROJET)
    oSection:Cell("ZZ1_PLACA"):SetValue((cAliasTRB)->ZZ1_PLACA)
    oSection:Cell("ZZ1_DTAINI"):SetValue((cAliasTRB)->ZZ1_DTAINI)
    oSection:Cell("ZZ1_DTAFIM"):SetValue((cAliasTRB)->ZZ1_DTAFIM)
    oSection:Cell("ZZ1_DIARIA"):SetValue((cAliasTRB)->ZZ1_DIARIA)
    oSection:Cell("ZZ1_VALOR"):SetValue((cAliasTRB)->ZZ1_VALOR)
    oSection:Cell("ZZ1_OBS"):SetValue((cAliasTRB)->ZZ1_OBS)

    oSection:PrintLine() 
    (cAliasTRB)->(dbSkip())
End

oSection:Finish()

//Apagando arquivo de trabalho temporario
dbSelectArea( cAliasTRB )
(cAliasTRB)->(dbCloseArea())

Return


Static Function MontaTrab(oReport,nOrdem,cAliasTRB,oSection)
**********************************************************************************************
* Monta Arquivo de Trabalho
***
Local cWhere	:= ""
Local cFilUser := oSection:GetAdvplExp()


MakeSqlExpr(oReport:uParam)

cWhere := '%'

Do Case
   Case MV_PAR09 == 1
        cWhere += " ZZ1_STATUS IN ('1','2','3') "
   Case MV_PAR09 == 2
        cWhere += " ZZ1_STATUS = '1' "
   Case MV_PAR09 == 3
        cWhere += " ZZ1_STATUS = '2' "
   Case MV_PAR09 == 4                  
        cWhere += " ZZ1_STATUS = '3' "   
EndCase


cWhere += '%'          

BeginSql Alias cAliasTRB
  COLUMN  ZZ1_DTAINI AS DATE
  COLUMN  ZZ1_DTAFIM AS DATE
          SELECT 
          ZZ1_UER,
          ZZ1_PROJET,
          ZZ1_PLACA,
          ZZ1_DTAINI,
          ZZ1_DTAFIM,
          ZZ1_DIARIA,
          ZZ1_VALOR,
          ZZ1_OBS 
          FROM %table:ZZ1% ZZ1
          WHERE ZZ1.%NotDel%
          AND ZZ1_FILIAL = %xFilial:ZZ1%
          AND ZZ1_PLACA  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          AND ZZ1_DTAINI BETWEEN %Exp:DTOS(MV_PAR03)% AND %Exp:DTOS(MV_PAR04)%
          AND ZZ1_DTAFIM BETWEEN %Exp:DTOS(MV_PAR05)% AND %Exp:DTOS(MV_PAR06)%
          AND ZZ1_PROJET BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
          and %Exp:cWhere%
          ORDER BY ZZ1_PLACA,ZZ1_DTAINI,ZZ1_DTAFIM

EndSql

//Abertura do arquivo de trabalho
dbSelectArea( cAliasTRB )
(cAliasTRB)->(dbGoTop())

Return                       