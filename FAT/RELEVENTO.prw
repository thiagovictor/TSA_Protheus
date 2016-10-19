#include "protheus.CH"

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  |RELEVENTO  | Autor    | Daniel A. Moreira       |Data  |20.02.2006 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Relatório/listagem de eventos                                     |
+----------+-------------------------------------------------------------------+
| USO      | Especifico TSA                                                    |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+
*/  
                                                         
User Function RELEVENTO 

//-----------------------------------------------------------------------
// Declaracao de Variaveis                                             
//-----------------------------------------------------------------------

Local cDesc1 		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2      := "de acordo com os parametros informados pelo usuario."
Local cDesc3      := "Contrato x Evento x Faturamento"
Local cPict       := ""
Local titulo      := "RELATORIO DE EVENTOS"
Local nLin        := 80

//Local Cabec1     	:=	"Nota  Ser  Contrato                                       Event Seq Descrição                                              Dt. Prev. Vl. Previsão  Dt. Fatu. Vl. Fatura.  Dt. Recebi. Vl. Recebi.  Prev.Receb  Vl. Diferença"
//                                10        20        30        40        50        60        70        80       100       110       120       130       140       150       160       170       180       190       200       210       220       230
//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1      :=	"Nota     Ser  Contrato                               Event      Seq Descrição                                            Dt. Prev.  Vl. Previsão  Dt. Fatu. Vl. Fatura.   Dt. Receb. Vl. Recebi.   Prev.Receb  Vl. Diferença"
Local Cabec2      := 	""

Local imprime      	 := .T.
Local lOk            := .T.                                     
Local aOrd           := {}
Local aCabec         := {}
Local aDados         := {}
Private aPerg        := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.                                   
Private CbTxt        := ""                                   
Private limite    	:= 132
Private tamanho    	:= "G"
Private nomeprog  	:= "RELEVENTO" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo     	:= 18
Private aReturn   	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey  	:= 0
Private cPerg        := "RELEVE"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00                      
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELEVE" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ3"

//Processa({|| ProcTeste() },"Aguarde Validando o Arquivo",'Aguarde......')


dbSelectArea("SZ3")
dbSetOrder(1)

aAdd(aPerg,{cPerg,"Contrato De ?       " ,"C",06,00,"G","","SZ1","","","","","",""})
aAdd(aPerg,{cPerg,"Contrato Ate ?      " ,"C",06,00,"G","NAOVAZIO().AND.MV_PAR02>=MV_PAR01","SZ1","","","","","",""})
aAdd(aPerg,{cPerg,"Dt.Prev. De Faturamento?  " ,"D",08,00,"G","NAOVAZIO()","","","","","","",""})
aAdd(aPerg,{cPerg,"Dt.Prev. Ate Faturamento? " ,"D",08,00,"G","NAOVAZIO().AND.MV_PAR04>=MV_PAR03","","","","","","",""})
aAdd(aPerg,{cPerg,"Considera Dt.Receb ?" ,"N",01,00,"C","","","Sim","Nao","","","",""})
aAdd(aPerg,{cPerg,"Dt.Recebimento De ?" ,"D",08,00,"G","NAOVAZIO()","","","","","","",""})
aAdd(aPerg,{cPerg,"Dt.Recebimento Ate ?" ,"D",08,00,"G","NAOVAZIO().AND.MV_PAR07>=MV_PAR06","","","","","","",""})
aAdd(aPerg,{cPerg,"Considera Dt. Fatu ?" ,"N",01,00,"C","","","Sim","Nao","","","",""})
aAdd(aPerg,{cPerg,"Dt.Fatu. De ?       " ,"D",08,00,"G","NAOVAZIO()","","","","","","",""})
aAdd(aPerg,{cPerg,"Dt.Fatu. Ate ?      " ,"D",08,00,"G","NAOVAZIO().AND.MV_PAR10>=MV_PAR09","","","","","","",""})
aAdd(aPerg,{cPerg,"Status ?            " ,"N",01,00,"C","","","Aberto","Fechado","Ambos","","",""})
aAdd(aPerg,{cPerg,"Considera Prev Recebimento?" ,"N",01,00,"C","","","Sim","Nao","","","",""})
aAdd(aPerg,{cPerg,"Dt.Prev. de Recebimento De?","D",08,00,"G","","","","","","","",""})
aAdd(aPerg,{cPerg,"Dt.Prev.Recebimento Até?"   ,"D",08,00,"G","NAOVAZIO().AND.MV_PAR14>=MV_PAR13","","","","","","",""})
PutSx1(cPerg,"15",OemToAnsi("Excel ?"),OemToAnsi("Excel ?"),OemToAnsi("Excel ?"),"mv_chc","N",01,0,0,"C","","","","","MV_PAR15","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","",{}, {}, {} )



If !Pergunte(cPerg,.T.)// Pergunta no SX1
	Return
Endif

If MV_PAR15 == 1
   lOk := MontaQuery()
   If lOk
      Aadd(aCabec,"Nota- Ser")
      Aadd(aCabec,"Contrato")
      Aadd(aCabec,"Event")
      Aadd(aCabec,"Seq-Descrição")
      Aadd(aCabec,"Dt. Prev.")
      Aadd(aCabec,"Vl. Previsão")
      Aadd(aCabec,"Dt. Fatu.")
      Aadd(aCabec,"Vl. Fatura.")
      Aadd(aCabec,"Dt. Receb.")
      Aadd(aCabec,"Vl. Recebi.")
      Aadd(aCabec,"Prev.Receb")
      Aadd(aCabec,"Vl. Diferença")


      TRB->(dbGoTop())                                         
      While !TRB->(EOF())
          Aadd(aDados,{TRB->Z3_NOTA+"-"+TRB->Z3_SERIE,;
                         Left(TRB->Z3_COD+"-"+Posicione("SZ1",1,xFilial("SZ1")+TRB->Z3_COD,"Z1_NOMINT"),38),;
                         TRB->Z3_EVENTO,;
                         TRB->Z3_SEQ+"-"+Substr(TRB->Z3_DESCEVE,1,50),;
                         stod(TRB->Z3_DTPREV),;
                         TRB->Z3_VALOR,;
                         STod(TRB->Z3_DTNF),;
                         TRB->Z3_VLNF,;
                         stod(TRB->Z3_DTFATUR),;
                         TRB->Z3_VLFATUR,;
                         stod(TRB->Z3_DTRECEB),;
                         TRB->Z3_VALOR-TRB->Z3_VLNF})
          TRB->(dbSkip())
      End
      TRB->(DbCloseArea())

      MsgRun(OemToAnsi("Aguarde, Processando..."),"",{|| CursorWait(), DlgToExcel({{"ARRAY",OemToAnsi("RELATORIO DE EVENTOS"),aCabec,aDados}}) ,CursorArrow()}) 
   EndIf
    
Else
   //-----------------------------------------------------------------------
   // Monta a interface padrao com o usuario...                           
   //-----------------------------------------------------------------------

   wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

   If nLastKey == 27
	   Return
   Endif

   SetDefault(aReturn,cString)

   If nLastKey == 27
      Return
   Endif

   nTipo := If(aReturn[4]==1,15,18)

   //-----------------------------------------------------------------------
   // Processamento. RPTSTATUS monta janela com a regua de processamento. 
   //-----------------------------------------------------------------------

   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Endif

Return



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local nSomaPrev   := 0
Local nSomaFatur  := 0
Local nSomaReceb  := 0
Local nSomaDife   := 0

lOk := MontaQuery()
If !lOk
	Alert('Não foi encontrado nenhum registro para o relatório')
	Return
EndIf                                                                    

SetRegua(TRB->(RecCount()))

TRB->(dbGoTop())                                         
While !TRB->(EOF())
                                                                     
   	//-----------------------------------------------------------------------
   	// Verifica o cancelamento pelo usuario...                             
   	//-----------------------------------------------------------------------

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
	//-----------------------------------------------------------------------
  	// Impressao do cabecalho do relatorio...                             
	//-----------------------------------------------------------------------
  	If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
     	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     	nLin := 9
  	Endif		
/*			
	@nLin,000 PSAY TRB->Z3_NOTA+"-"+TRB->Z3_SERIE
	@nLin,011 PSAY Left(TRB->Z3_COD+"-"+Posicione("SZ1",1,xFilial("SZ1")+TRB->Z3_COD,"Z1_NOMINT"),40)
	@nLin,052 PSAY TRB->Z3_EVENTO
	@nLin,064 PSAY TRB->Z3_SEQ+"-"+Substr(TRB->Z3_DESCEVE,1,54)
	@nLin,124 PSAY stod(TRB->Z3_DTPREV)
	@nLin,134 PSAY TRB->Z3_VALOR                 Picture "@E 9,999,999.99"  
    @nLin,148 PSAY STod(TRB->Z3_DTNF)
	@nLin,158 PSAY TRB->Z3_VLNF                  Picture "@E 9,999,999.99"     
	@nLin,172 PSAY stod(TRB->Z3_DTFATUR)
	@nLin,182 PSAY TRB->Z3_VLFATUR               Picture "@E 9,999,999.99"	
    @nLin,196 PSAY stod(TRB->Z3_DTRECEB)
	@nLin,209 PSAY TRB->Z3_VALOR-TRB->Z3_VLNF    Picture "@E 9,999,999.99"	
*/
//                                10        20        30        40        50        60        70        80        090      100       110       120       130       140       150       160       170       180       190       200       210       220       230
//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//Local Cabec1      :=	"Nota     Ser  Contrato                               Event      Seq Descrição                                            Dt. Prev.  Vl. Previsão  Dt. Fatu. Vl. Fatura.   Dt. Receb. Vl. Recebi.   Prev.Receb  Vl. Diferença"
                         
	@nLin,000 PSAY TRB->Z3_NOTA+"-"+TRB->Z3_SERIE
	@nLin,014 PSAY Left(TRB->Z3_COD+"-"+Posicione("SZ1",1,xFilial("SZ1")+TRB->Z3_COD,"Z1_NOMINT"),38)
	@nLin,053 PSAY TRB->Z3_EVENTO
	@nLin,064 PSAY TRB->Z3_SEQ+"-"+Substr(TRB->Z3_DESCEVE,1,50)
	@nLin,121 PSAY stod(TRB->Z3_DTPREV)
	@nLin,132 PSAY TRB->Z3_VALOR                 Picture "@E 9,999,999.99"  
    @nLin,146 PSAY STod(TRB->Z3_DTNF)
	@nLin,156 PSAY TRB->Z3_VLNF                  Picture "@E 9,999,999.99"     
	@nLin,170 PSAY stod(TRB->Z3_DTFATUR)
	@nLin,181 PSAY TRB->Z3_VLFATUR               Picture "@E 9,999,999.99"	
    @nLin,195 PSAY stod(TRB->Z3_DTRECEB)
	@nLin,207 PSAY TRB->Z3_VALOR-TRB->Z3_VLNF    Picture "@E 9,999,999.99"	

	nSomaPrev  += TRB->Z3_VALOR
	nSomaFatur += TRB->Z3_VLNF
	nSomaReceb += TRB->Z3_VLFATUR
	nSomaDife  += (TRB->Z3_VALOR-TRB->Z3_VLNF)
	
	nLin ++

  	TRB->(dbSkip())
   	
	If nLin > 60                                                      
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 9
	Endif

EndDo

TRB->(DbCloseArea())

If nLin > 60 
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 9
EndIf

nLin++
@nLin,000 PSAY Replicate("-",220)
nLin++
@nLin,115 PSAY "T O T A I S :"
@nLin,134 PSAY nSomaPrev  Picture "@E 9,999,999.99" 
@nLin,158 PSAY nSomaFatur Picture "@E 9,999,999.99" 
@nLin,182 PSAY nSomaReceb Picture "@E 9,999,999.99" 
@nLin,209 PSAY nSomaDife  Picture "@E 9,999,999.99" 

//-----------------------------------------------------------------------
// Finaliza a execucao do relatorio...                                 
//-----------------------------------------------------------------------

SET DEVICE TO SCREEN

//-----------------------------------------------------------------------
// Se impressao em disco, chama o gerenciador de impressao...          
//-----------------------------------------------------------------------

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)                            
Endif

MS_FLUSH()                                  
                                            
Return



Static Function MontaQuery()

Local aArea   := GetArea()
Local _lRet   := .T.
Local _cQuery := ""                                                               

_cQuery := "SELECT * " 
_cQuery += "FROM "+RetSQLName("SZ3")+" SZ3 "
_cQuery += "WHERE Z3_FILIAL = '"+xFilial("SZ3")+"' AND "
_cQuery += "      Z3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
_cQuery += "      Z3_DTPREV BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
If MV_PAR05 == 1
	_cQuery += " AND Z3_DTFATUR BETWEEN '"+DTOS(MV_PAR06)+"' AND '"+DTOS(MV_PAR07)+"' "
EndIf
If MV_PAR08 == 1
	_cQuery += " AND Z3_DTNF BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
EndIf

If MV_PAR12 == 1
	_cQuery += " AND Z3_DTRECEB BETWEEN '"+DTOS(MV_PAR13)+"' AND '"+DTOS(MV_PAR14)+"' "
Endif

If MV_PAR11 == 1
	_cQuery += "AND Z3_VLFATUR = 0 "
ElseIf MV_PAR11 == 2
	_cQuery += "AND Z3_VLFATUR <> 0 "
EndIf

_cQuery += " AND D_E_L_E_T_ <> '*' ORDER BY Z3_COD, Z3_EVENTO"

If Select("TRB") > 0                                                                   
	dbSelectArea("TRB")                                                              
	dbCloseArea()                          
Endif

dbUseArea(.T., "TOPCONN", TCGENQRY(,,_cQuery), "TRB", .F., .T.)
            
TRB->(dbGoTop())
if TRB->(EOF())                                            
	_lRet := .F.                                                          
	TRB->(DbCloseArea())
endif

RestArea(aArea)                                                  

Return _lRet



Static Function ProcTeste()
While .T.
   incProc()
End
Return