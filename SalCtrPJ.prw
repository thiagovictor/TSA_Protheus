/*
+-----------------------------------------------------------------------+
¦Programa  ¦ GerMedPJ  ¦ Autor ¦ Jane Mariano Duval   ¦ Data ¦29.07.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Rotina para baixa de saldo de contrato do PJ'S             ¦
¦          ¦                                                            ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
*/
#INCLUDE "RWMAKE.CH"
#Include "ap5mail.ch"
#INCLUDE "TOPCONN.CH"  

User Function SalCtrPJ()
*******************************************************************************************************************
*    
*
****   

Private cMailCopia:=" "

aPerg := {}
cPerg :="SALCTR"
AADD(aPerg,{cPerg,"Data Emissão De?" ,   "D",08,0,"G","",""   ,"","","","",""}) 
AADD(aPerg,{cPerg,"Data Emissão Até?",   "D",08,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Num. pedido De? " ,   "C",06,0,"G","","SC7","","","","",""}) 
AADD(aPerg,{cPerg,"Num. pedido Ate?" ,   "C",06,0,"G","","SC7","","","","",""}) 
AADD(aPerg,{cPerg,"Cod. Fornecedor De? ","C",06,0,"G","","SA2","","","","",""}) 
AADD(aPerg,{cPerg,"Cod. Fornecedor Até?","C",06,0,"G","","SA2","","","","",""}) 

If cFilAnt='01'

	IF Pergunte(cPerg,.T.) 
		Processa({||ProcNumPed()},"Aguarde Processando os Dados","Aguarde")
		
		//SE HOUVER ALGUM LOG, GERA TELA EM HTML
		dbSelectArea("TRBC")
		dbGoTop()
		If !Eof()
 		   EnvMail()
 	    EndIf
		
		dbSelectArea("QTMP")
        dbCloseArea()
        dbSelectArea("TRBC")
        dbCloseArea()
        dbSelectArea("SC7")

	Endif  
Else
	MsgBox("Atenção este processo deve ser executado na Filial Matriz")	
Endif 

Return()



Static Function ProcNumPed()
********************************************************************************************************************
*
*
**** 
Local   aStru  := {} 
Local   aParaPed:={}
Local   cQuery:=""
Local   cQuery1:="" 
   
Private cDataDe:=MV_PAR01
Private cDataAt:=MV_PAR02 
Private cNumPDe:=MV_PAR03
Private cNumPAt:=MV_PAR04
Private cFornDe:=MV_PAR05
Private cFornAt:=MV_PAR06 
Private cArqCrit := '' 

//Cria o Arquivo de Criticas 
AADD(aStru, {"MATRIC"  ,"C",06,0})
AADD(aStru, {"NOME"    ,"C",40,0})
AADD(aStru, {"SEQ"     ,"C",01,0}) 
AADD(aStru, {"TIPOCT"  ,"C",02,0})
AADD(aStru, {"CRITICA" ,"C",100,0})
AADD(aStru, {"FORNECE" ,"C",40,0})
AADD(aStru, {"CODFOR"  ,"C",40,0})
AADD(aStru, {"PEDCOMP" ,"C",06,0}) 
AADD(aStru, {"VALPED"  ,"N",12,2}) 

		
cArqCrit := CriaTrab(aStru, .T.)
dbUseArea(.T.,,cArqCrit, "TRBC",.F.)  
IndRegua("TRBC",cArqCrit,"FORNECE+MATRIC+TIPOCT+PEDCOMP",,,"Criando Arquivo Trabalho ...")

//Lista os pedidos  gerados a serem processados
cQuery:=" SELECT DISTINCT A2_NOME,RA_NOME,C7_TIPREG,C7_NUM,C7_MAT,C7_EMISSAO,C7_FORNECE,C7_LOJA,C7_CONTRA,C7_DATPRF,"
cQuery+=" (SELECT SUM(CAST(SC72.C7_TOTAL AS DECIMAL(12,2))) FROM "+RetSqlName("SC7")+"  SC72 WHERE SC72.C7_NUM=SC7.C7_NUM AND SC72.D_E_L_E_T_<>'*') AS TOTALPEDIDO "
cQuery+=" FROM "+RetSqlName("SC7")+" SC7 " 
cQuery+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (RA_MAT=C7_MAT AND SRA.D_E_L_E_T_<>'*')
cQuery+=" INNER JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND SRA.D_E_L_E_T_<>'*')
cQuery+=" WHERE 
cQuery+="     C7_DATPRF   BETWEEN '"+Dtos(cDataDe)+"'AND '"+Dtos(cDataAt)+"'"
cQuery+=" AND C7_FORNECE  BETWEEN '"+cFornDe+"'AND '"+cFornAt+"'" 
cQuery+=" AND C7_NUM      BETWEEN '"+cNumPDe+"'AND '"+cNumPAt+"'"
cQuery+=" AND C7_MAT<>''  AND C7_CONTRA='' AND SC7.D_E_L_E_T_<>'*'"
cQuery+=" ORDER BY C7_MAT,C7_NUM,C7_TIPREG "
	
TCQUERY cQuery Alias "QTMP" New 

dbSelectArea("QTMP")
dbGoTop("QTMP")  
While !Eof() 
	//Variáveis do pedido
	cMesRef:=Left(QTMP->C7_DATPRF,6)
	lRet:=.t.
	cNumContra=""
	cRevisa=""
	dbSelectArea("CNA")
	//Verifica se existe o contrato 	    
	cQuery1:=" SELECT CNA_FILIAL,CNA_MAT,CNA_CONTRA,CNA_REVISA,CNA_VLTOT,CNA_SALDO "
	cQuery1+=" FROM "+RetSqlName("CNA")+" CNA " 
	cQuery1+=" INNER JOIN "+RetSqlName("CN9")+" CN9 ON CN9_NUMERO=CNA_CONTRA AND CN9_REVISA=CNA_REVISA AND CN9_TICONT='"+QTMP->C7_TIPREG+"' AND CN9_SITUAC <'10'"
	cQuery1+=" AND CN9_FILIAL=CNA_FILIAL AND CN9.D_E_L_E_T_<>'*' "
	cQuery1+=" WHERE CNA_MAT = '"+QTMP->C7_MAT+"' AND CNA.D_E_L_E_T_<>'*' AND CNA_FILIAL='"+Xfilial("CNA")+"'"
	TcQuery cQuery1 Alias "QSCON" New  
	dbSelectArea("QSCON") 
	dbGotop() 
	
	If !EOF()  
		cNumContra=QSCON->CNA_CONTRA
		cRevisa=QSCON->CNA_REVISA
		dbSelectArea("CN9")
		If dbSeek(QSCON->(CNA_FILIAL+CNA_CONTRA+CNA_REVISA))
			//Confere o saldo do pedido com o contrato
			IF QTMP->TOTALPEDIDO > QSCON->CNA_SALDO
				FGravaCrit(" Saldo do Contrato("+QSCON->(CNA_CONTRA+"/"+CNA_REVISA)+") insuficiente ")
				FGravaCrit(" Vlr Pedido:"+Str(QTMP->TOTALPEDIDO,12,2)+" Vlr.Contrato "+Str(QSCON->CNA_SALDO,12,2)+") insuficiente ")
				lRet:=.f.
			EndIf
			//Verifica a Vigencia do Contrato
			If !(CN9->CN9_SITUAC='05' .And. Left(DTOS(CN9->CN9_DTFIM),6)>=cMesRef)	
				FGravaCrit("Contrato não esta Vigente e/ou o Periodo referente não esta definido no Contrato")	
				lRet:=.f.
			EndIf
		Else 
			FGravaCrit("Planilha não encontrada para o Contrato:"+CNA->(CNA_CONTRA+"/"+CNA_REVISA))
			lRet:=.f.
		EndIf
 	Else
			FGravaCrit("Contrato não existe para Matricula:"+QTMP->C7_MAT)
			lRet:=.f.
	EndIf 
	dbSelectArea("QSCON")
	dbCloseArea()
	
	dbSelectArea("QTMP")
	If lRet
		aParaPed={QTMP->C7_NUM,QTMP->C7_MAT, QTMP->C7_FORNECE, QTMP->C7_LOJA, Left(QTMP->C7_DATPRF,6),'100',cNumContra,cRevisa}
	   U_AtuCtrPJ(aParaPed)
	 FGravaCrit("Pedido:"+QTMP->C7_NUM+" OK !")
	 //EnvMail()
	EndIf	 
	
	DbSelectArea("QTMP")  
	DbSkip()
EndDo


Return() 



Static Function FGravaCrit(cCritica)
*******************************************************************************************************************
*
*
******
Local aAreaAnt  :=GetArea()
dbSelectArea("TRBC") 
Reclock("TRBC",.t.)
Replace MATRIC  With QTMP->C7_MAT,;
		  FORNECE With QTMP->A2_NOME,;
	     CRITICA With cCritica,;
		  TIPOCT  With QTMP->C7_TIPREG,;
	     NOME    With QTMP->RA_NOME,;
	     CODFOR  With QTMP->C7_FORNECE,;
        PEDCOMP With QTMP->C7_NUM,;
        VALPED  With QTMP->TOTALPEDIDO
		
MsUnlock()
//Grava o numero do Pedido Gerado nos registros  da tabela
/*If PEDCOMP<>''
	dbSelectArea("TRBC")
	dbgotop()
	While !Eof() .and. MATRIC=cMat .AND. TIPOCT=cTipCT
		Reclock("TRBC",.F.)
		Replace PEDCOMP With cPedTRBC
		MsUnlock()
		dbSkip()
	EndDo
Endif
*/

Return()  



Static Function EnvMail()
************************************************************************************************************************
*
*
*******
Local cCabec    := ""
Local cTexto    := ""
Local cRoda     := ""
Local cCtaMail  := ""  
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP") 
Local cSendBy   := GetMv("MV_MAILPJS",,''+cMailCopia)
Local cArqCrit  :=CriaTrab("",.F.)

cCtaMail:=cSendBy
cMat:="*"
cMensMail:=" <HTML><HEAD><TITLE>EPC- Baixa de Contratos </TITLE></HEAD> "
cMensMail+=" <BODY> "
cMensMail+= "<TABLE borderColor=black cellSpacing=0 width=600 border=2> "
cMensMail+= "  <TBODY> "
cMensMail+= "  <TR> "
cMensMail+= "    <TD align=left bgColor=silver colSpan=3> <B> Critica de Baixa dos Contratos de PJS </B> </TD> "
cMensMail+= "  <TR>                                             "
cMensMail+= "    <TD bgColor=silver width=5> </TD>  "
cMensMail+= "    <TD bgColor=silver width=300 >Prestador </TD>  "
cMensMail+= "    <TD bgColor=silver width=300 >Ocorrência </TD> "
cMensMail+= "  </TR> "
cMensMail2:=cMensMail

dbSelectArea("TRBC")
dbGotop()
While !Eof()
	cMensMail+=" <TR>  "
	cMensMail+= "    <TD width=5 border=2 > </TD>  "
   cMensMail+=" <TD> "
	cMensMail+="Fornecedor: "+CODFOR+'-'+FORNECE+"<br>"
   cMensMail+="Matricula: "+TRBC->MATRIC+"-"+NOME+"<br>"
    cMensMail+="</TD> "
   cMensMail+=" <TD> "
   cMensMail+="Tipo de Medição:"+If(TIPOCT='1','CT','OS')+"<br>"
   cMensMail+="Pedido: "+PEDCOMP+"<br>"
   cMensMail+="Valor: "+Alltrim(Str(VALPED,12,2))+"<br>"
   cMensMail+=" </TD>"
   //Linha Inicial de Critica
   cMensMail+=" </TR> "
	cMensMail+=" <TR>  "
	cMensMail+=" <TD width=5 border=2 > </TD>  "
   cMensMail+=" <TD width=5 border=2 ></TD>  "
	cMensMail+=" <TD> "
	dbSelectArea("TRBC")
	cForMail:=TRBC->FORNECE+TIPOCT+MATRIC+PEDCOMP
	While !Eof() .And. cForMail==TRBC->FORNECE+TIPOCT+MATRIC+PEDCOMP
		cMensMail+=TRBC->CRITICA+"<br>"
		dbSkip()
	EndDo 
	dbSkip(-1)
	//Monta a Lista de Itens e Totaliza o Pedido de Compras	
	/*
	If !Empty(TRBC->PEDCOMP)     
		cMensMail+=" <TABLE cellSpacing=0 width=450 border=1> "
	   cMensMail+=" <TD colSpan=4  bgColor=silver >Pedido Compras: "+TRBC->PEDCOMP+" </TD>
		cMensMail+=" <TR> "
		cMensMail+="    	<TD>Item </TD> "
		cMensMail+="    	<TD>Produto </TD> "
		cMensMail+="    	<TD>Item Contabil </TD>"
		cMensMail+="    	<TD>Valor</TD>
		cMensMail+=" </TR>
		nVlrTot:=0
		dbSelectArea("SC7")
		dbSeek(Xfilial("SC7")+TRBC->PEDCOMP)
		While !Eof() .And. SC7->C7_FILIAL=Xfilial("SC7") .And. TRBC->PEDCOMP=SC7->C7_NUM
			cMensMail+=" <TR>"
			cMensMail+="    	<TD>"+SC7->C7_ITEM+"</TD> "
			cMensMail+="    	<TD>"+SC7->C7_PRODUTO+"</TD> "
			cMensMail+="      <TD>"+SC7->C7_ITEMCTA+"</TD>"
			cMensMail+="    	<TD>"+Alltrim(Str(SC7->C7_TOTAL,12,2))+"</TD> "
			cMensMail+=" </TR>"
			nVlrTot+=SC7->C7_TOTAL
			dbSelectArea("SC7")				
			dbSkip()
		EndDo
		cMensMail+=" </TD>
		cMensMail+=" </TR>
		cMensMail+=" <TD CelSpan=4> Total do Pedido:"+Alltrim(Str(nVlrTot,12,2))+"</TD>"
	   cMensMail+=" </TABLE>
	Endif
	*/
	cMensMail+=" </TD> "
	cMensMail+="</TR> 
	dbSelectArea("TRBC")
	dbSkip()
EndDo 
cMensMail+="  </TBODY>"
cMensMail+="  </TABLE>"
cMensMail+=" </BODY>"
cMensMail+="</HTML>"
/*
CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
SEND MAIL FROM  cSendBy TO  cCtaMail ; 
SUBJECT 'Importação do Pedido de Compras para PJ' ;
BODY cMensMail

DISCONNECT SMTP SERVER
*/
//Cria o Arquivo no Servidor Protheus
cHTMPage:="C:\GERMEDPJ.html"
nFile:=FCreate(cHTMPage)
FWrite(nFile,cMensMail)
FClose(nFile)
//Chama o Arquivo Criado
ShellExecute("open", cHTMPage, "", "", 1)

Return()



