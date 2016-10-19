#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  | GP670CPO  | Autor    | Jane M. Duval           |Data  |08.01.2007 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Cadastro de Pedencias                                             |
+----------+-------------------------------------------------------------------+
| USO      |  Especifico                                                       |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+  
 */ 
                                                     

User Function CADPEND()
********************************************************************************************************
*
*
****

SetPrvt("APOS,CCADASTRO,AROTINA,")

aPos:={08,11,11,70}                                        
cCadastro:="Pendencias de PJ"
aRotina:={{"Pesquisar"       ,'AxPesqui  '   ,0,1},;    
          {"Visualizar"      ,'U_TelaPend'   ,0,2},;    
          {"Incluir Pend"    ,'U_TelaPend'   ,0,3},;    
          {"Alterar Pend"    ,'U_TelaPend'   ,0,4},;    
          {"Baixa Pend"      ,'U_BaixaPend'  ,0,5},;   
          {"Env e-mail"      ,'U_EnvMail'    ,0,6},;
          {"Cancela Pend"    ,'U_CanPend'    ,0,7}}
          
//Definir o Mes de Referencia e Email do Responsavel pelo cadastro
aPerg := {}
cPerg :="CADPEN"
AADD(aPerg,{cPerg,"Ano/Mês(AAAAMM)Ref.?","C",06,0,"G","U_TestPerg(MV_PAR01)","","","","","",""}) 
AADD(aPerg,{cPerg,"Email Do Responsavel?","C",30,0,"G","","","","","","",""}) 



Pergunte(cPerg,.T.)                                                                
dbSelectArea("SZW")         
dbSetOrder(1)               //Filial+Codigo

mBrowse(06,08,22,71,"SZW",,'ZW_DTBAIXA')   // variaveis aPos, cCadastro, aRotina utilizadas(Tamanho da Janela)
                                          //Aparecer as bolinhas verde ou vermelha     no mBrowse

Return() 


    
User Function TestPerg(MV_PAR01)
****************************************************************************************************************
* Testa se o campo Ano/Mes de Referencia se é válido
*
************ 
Local   lRet      := .t.  
 
If VAL(Left(MV_PAR01,4)) < year(DATE())-1 .or. VAL(Left(MV_PAR01,4)) > year(DATE())+1 .or. VAL(Right(MV_PAR01,2))<=0 .or. VAL(Right(MV_PAR01,2))>=13
	Alert("Ano/Mes de Referencia Invalido") 
	lRet:=.f. 
EndIf	                 

Return(lRet)

User Function TelaPend(cAlias,nRecno,nOpc)
****************************************************************************************************************
* Apresenta a Tela de Inclusão das Pendencias
*
*****  
private oDlg 
private dDatbaix
Private cMesRef     := MV_PAR01
Private cEmaRef     := MV_PAR02  
Private cPesquisar  := Space(60)  
Private cMatricula  := Space(60)
Private cFornecedor := Space(70)
Private cObserv     := Space(200)  
Private cDemissa    := ""
Private lCheckCRF   := .f.   
Private lcheckGPS   := .f.
Private lcheckCND   := .f.   
Private lcheckMED   := .f.  


Pergunte(cPerg,.F.)  

  
If  nOpc <> 3  
	If nOpc == 4
		If !AltPend()
			Return()			
		Endif 
	EndIf 
   cMesRef:=ZW_MESREF
 	cMatricula:=SZW->ZW_MAT+'-'+ZW_NOME
	cFornecedor:=SZW->ZW_CODFOR+'-'+ZW_NOMEFOR
	cObserv:=SZW->ZW_MEMO
	lCheckCRF   := If(Empty(ZW_CRF),.F.,.T.)   
	lcheckGPS   := If(Empty(ZW_GPS),.F.,.T.)   
	lcheckCND   := If(Empty(ZW_CND),.F.,.T.)      
	lcheckMED   := If(Empty(ZW_MED),.F.,.T.)  

	                                           
EndIf
   

  If cPerg ="CADPEN" 
     cMesRef:=MV_PAR01
  Else  		
     cMesRef:=ZW_MESREF
  EndIf 

@ 000,001 TO 350,530 DIALOG oDlg TITLE "Cadastro de Pendencias"
@ 012,003 Say "Mes Ref" Object oSay1
@ 012,050 Get cMesRef When Empty(cMesRef)
@ 027,003 Say "Pesquisar" Object oSay2
@ 027,050 Get cPesquisar When nOpc <> 4 Valid IIF(Empty(cPesquisar),ZERCAM(),VldPesq(cPesquisar)) Object oPesquisa Size 150,30
@ 042,003 Say "Nome" Object oSay3
@ 042,050 Get cMatricula When .F. Object Teste2 Size 150,30		
@ 057,003 Say "Cód Fornecedor" Object oSay4
@ 057,050 Get cFornecedor When Empty(cFornecedor) Size 150,30
@ 072,003 Checkbox "CRF " VAR lCheckCRF   Object oCheckCRF    
@ 072,050 Checkbox "CRF VENCIDA " VAR lCheckGPS	Object oCheckGPS 
@ 072,120 Checkbox "GPS/CND " VAR lCheckCND   Object oCheckCND 
@ 072,174 Checkbox "MEDIÇÃO ASSINADA " VAR lcheckMED Object oCheckMED
@ 087,003 Get cObserv MEMO SIZE 250,30 Object oMemo  
@ 123,003 Say "Informações Gerais"
@ 132,003 TO 170,253
@ 136,005 Say "Data e-mail:" Object oSay5 
@ 142,005 Say "E-mail :"     Object oSay6
@ 148,005 Say "Hora e-mail:" Object oSay13
@ 154,005 Say "Data Baixa :" Object oSay7
@ 160,005 Say "Responsavel:" Object oSay8 

If nOpc<>3
	@ 136,040 Say Dtoc(SZW->ZW_DTMAIL)   Object oSay9
	@ 142,025 Say SZW->ZW_EMAIL   		 Object oSay10
	@ 148,040 Say SZW->ZW_HRMAIL   		 Object oSay10
	@ 154,040 Say Dtoc(SZW->ZW_DTBAIXA)  Object oSay11
	@ 160,040 Say SZW->ZW_RPBAIX         Object oSay12	
Endif  



If nOpc<>2
	@ 012,230 BMPBUTTON TYPE 01 ACTION IIF(Empty(cMatricula) .OR. Empty(cFornecedor)  ,Alert ("Preencher Campo Obrigatorio"),GravPend(nOpc)) 
EndIf	
   @ 027,230 BMPBUTTON TYPE 02 ACTION oDlg:END()

If nOpc=2
    oSay1    :lReadOnly:=.T.
	 oCheckCRF:lReadOnly:=.T. 
    oCheckGPS:lReadOnly:=.T.
    oCheckCND:lReadOnly:=.T.
    oCheckMed:lReadOnly:=.T.	
    oPesquisa:lReadOnly:=.T.
    oMemo    :lReadOnly:=.T.	
Endif



ACTIVATE Dialog oDlg CENTERED
                                   
Return()



Static Function ZerCam() 
*******************************************************************************************************************
* Função para Zerar Campos
*
***
 
cPesquisar  := Space(60)  
cMatricula  := Space(60)
cFornecedor := Space(70)
cObserv     := Space(200)
lCheckCRF   := .f.   
lcheckGPS   := .f.
lcheckCND   := .f.   
lcheckMED   := .f.    

Return



Static Function VldPesq(cString)
**************************************************************************************************************
* Função que faz a pesquisa 
*
*****
Local cQuery:=""
Local cQuery1:=""
Local lRet:=.t.
Local lExi:=.t.  
cMatricula  := Space(60)
cFornecedor := Space(70)    

dbSelectArea("SZW") 

cQuery:=" SELECT RA_MAT,RA_NOME,A2_COD,A2_NOME,RA_CC,RA_DEMISSA "
cQuery+=" FROM "+RetSqlName("SRA")+" SRA "
cQuery+=" INNER JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD=RA_FOR AND SA2.D_E_L_E_T_<>'*') "
cQuery+=" WHERE   ( RA_NOME LIKE '%"+UPPER(Alltrim(cString))+"%' OR RA_MAT LIKE '%"+Alltrim(cString)+"%' OR A2_NOME LIKE '%"+UPPER(Alltrim(cString))+"%' )  AND SRA.D_E_L_E_T_<>'*'"
cQuery+="     AND A2_FILIAL='"+Xfilial("SA2")+"'"


TCQUERY cQuery Alias QTMP New
dbSelectArea("QTMP")
dbGotop()
If !EOF()
    //Verifica se há mais de um funcionário
	aListFun:={}
	nListFun:=0
	dbSelectArea("QTMP")
	While !Eof()	
		nListFun:=1 		
		Aadd(aListFun,QTMP->(RA_MAT+'-'+Alltrim(RA_NOME) +'  - ('+A2_COD+'-'+Alltrim(A2_NOME)+')'+'.'))
		dbSelectArea("QTMP")
		dbSkip()
	EndDo
	dbGotop()
	If Len(aListFun)>1
		@ 000,000 To 150,510 Dialog oDlgPJ Title "Selecione o Funcionário"
		@ 02,02 LISTBOX nListFun ITEMS aListFun SIZE 250,50
		@ 55,02 BmpButton Type 01 Action oDlgPJ:End()
		Activate Dialog oDlgPJ Center
		If nListFun>1
			dbSkip(nListFun-1)
		Endif 
	Endif 

	cQuery:=" SELECT COUNT(*) NPEND "
	cQuery+=" FROM "+RetSqlName("SZW")+" SZW"  
	cQuery+=" WHERE (ZW_MAT = " + QTMP ->RA_MAT + " ) AND ZW_DTBAIXA=''" 
	
	Tcquery cquery Alias QPEND new
	dbSelectArea("QPEND")  
	
	
	
	cQuery1:=" SELECT ZW_CODFOR "
	cQuery1+=" FROM "+RetSqlName("SZW")+" SZW"  
	cQuery1+=" WHERE ZW_MESREF = '" + cMesRef + "'" 
	
	Tcquery cQuery1 Alias QSZW new
	dbSelectArea("QSZW")
	While !Eof()
		If QTMP->A2_COD == QSZW->ZW_CODFOR 
			lExi:=.f.
		EndIf 
	dbSelectArea("QSZW")
	dbSkip()
	EndDo
	dbCloseArea("QSZW")
	
	
	if QPEND->NPEND ==0
		//Posiciona no Registro
		dbSelectArea("SZW")
		dbSetOrder(1)
		if !SZW->(dbSeek(xFilial("SZW")+QTMP->RA_MAT+cMesRef)) .AND. lExi
		    //Atualiza o valor dos campos
			cMatricula  := QTMP->RA_MAT+"-"+QTMP->RA_NOME
			cFornecedor := QTMP->A2_COD+"-"+QTMP->A2_NOME 
			If Empty(QTMP->RA_DEMISSA) 
				cObserv:="" 
			ELSE
			//   cDemissa:= QTMP->RA_DEMISSA
				cObserv:="Funcionario foi demitido em " +DTOC(STOD(QTMP->RA_DEMISSA))+"."
			EndIf
		Else  
		      msgbox("Já existe Cadastro de Pendencias para este Fornecedor")
				ZerCam()     
		Endif	
	Else
		msgbox("Já existe Cadastro de Pendencias para este contratado")
        ZerCam()  
	Endif
	dbSelectArea("QPEND")
	dbCloseArea()	
Else
	lRet:=.f.
	//Emite Mensagem para o Usuário
	MSGBOX("Nome / Matricula não encontrado !!!")
Endif
dbSelectArea("QTMP")
dbCloseArea()

Return(lRet)   



Static Function AltPend()
********************************************************************************************************************
*   Aletera Pendencia
*
****
If !Empty(ZW_DTBAIXA)
   	MSGBOX("Pendência ja Baixada !!!")
    Return(.f.)
EndIf   

cMatricula:=SZW->ZW_MAT+'-'+ZW_NOME
cFornecedor:=SZW->ZW_CODFOR+'-'+ZW_NOMEFOR
cObserv:=SZW->ZW_MEMO
lCheckCRF   := If(Empty(ZW_CRF),.F.,.T.)   
lcheckGPS   := If(Empty(ZW_GPS),.F.,.T.)   
lcheckCND   := If(Empty(ZW_CND),.F.,.T.)      
lcheckMED   := If(Empty(ZW_MED),.F.,.T.)    

Return(.t.)



Static Function GravPend(nOpc)
*******************************************************************************************************************
*  Grava pendencias no Banco
*
**** 


If (nOpc=2)
  Return()
Endif
if nOpc<>5  	
	dbSelectArea("SZW")
	dbSetOrder(1)
	RecLock('SZW',!dbSeek(Xfilial("SZW")+Left(cMatricula,6)+cMesRef))
	Replace ZW_FILIAL With xFilial('SZW')
	Replace ZW_MESREF With cMesRef 
	Replace ZW_MAT With Left(cMatricula,6)
	Replace ZW_NOME With Substr(cMatricula,8)
	Replace ZW_CODFOR With Left(cFornecedor,6)
	Replace ZW_NOMEFOR With Substr(cFornecedor,8)
	Replace ZW_CRF  With If(lCheckCRF,"S","")
	Replace ZW_GPS  With If(lCheckGPS,"S","")
	Replace ZW_CND  With If(lCheckCND,"S","")
	Replace ZW_MED  With If(lcheckMED,"S","") 
	Replace ZW_MEMO With cObserv
	MsunLock() 
Endif  

If nOpc = 3
	MSGBOX("Dados Gravados com Sucesso!!!")  
	If Empty(ZW_CRF) .AND. Empty(ZW_GPS) .AND. Empty(ZW_CND) .AND. Empty(ZW_MED) .AND. Empty(ZW_MEMO) 
	    GravBaixa()
	EndIf  
	ZerCam()    
Else 
    If nOpc = 4
       MSGBOX("Dados Alterados com Sucesso!!!")
       If Empty(ZW_CRF) .AND. Empty(ZW_GPS) .AND. Empty(ZW_CND) .AND. Empty(ZW_MED) .AND. Empty(ZW_MEMO) 
	    GravBaixa()
	EndIf 
       oDlg:END()
    Endif 
Endif 
    
Return()



User Function BaixaPend ()
********************************************************************************************************************
*  Funcão que baixa Pendencias
*
****
Local aButton  := {}
Local aSay := {} 
Local cDesc1 := "Confima a Baixa do Prestador de Serviços:"
Local cDesc2 := SZW->ZW_MAT+'-'+ZW_NOME
Local cDesc3 := SZW->ZW_CODFOR+"-"+ZW_NOMEFOR

If !Empty(ZW_DTBAIXA)

  MSGBOX("Pendência ja Baixada !!!")	
	Return()
EndIf   

aAdd( aSay, cDesc1 ) // Texto explicativo na janela FormBatch.
aAdd( aSay, cDesc2 ) // Texto explicativo na janela FormBatch. 
aAdd( aSay, cDesc3 ) // Texto explicativo na janela FormBatch.
aAdd( aButton, {  1, .T., {|| nOpc := 1,GravBaixa(),FechaBatch()  }} ) // Botao 0k
aAdd( aButton, {  2, .T., {|| FechaBatch(), lCanc := .T. }} )// Botao fecha

FormBatch( "Cadastro de Pendencias - [Baixar Pendencias]", aSay, aButton ) 
dbSelectArea("SZW")
dbGotop()
Return(.t.) 



Static Function GravBaixa() 
****************************************************************************************************************
*
*
****

If !Empty(ZW_DTBAIXA)
 MSGBOX("Pendência ja Baixada !!!")	
 Return(.F.)
Endif
                  
dbSelectArea("SZW")
RecLock('SZW',.F.) 

Replace ZW_DTBAIXA With Date()
Replace ZW_RPBAIX  With cUserName 
MsunLock()


Return(.T.)

User Function EnvMail()
************************************************************************************************************************
*
*
*******


Local cMail:=""
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP") 
Local cQuery1   :=""
Local lRet      :=.t. 
Private nQtdEml := 0 
Private nQtdEmn := 0
Private cEol    :=Chr(10)+Chr(13) 



aPerg := {}
cPerg :="ENVEMA"
AADD(aPerg,{cPerg,"Matricula De? ","C",06,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"Matricula Até?","C",06,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"Cod.Fornecedor De?","C",06,0,"G","",""   ,"","","","",""}) 
AADD(aPerg,{cPerg,"Cod.Fornecedor Até?","C",06,0,"G","",""  ,"","","","",""}) 
AADD(aPerg,{cPerg,"Reenviar Email S/N?","N",1,0,"C","",""   ,"Sim","Não","","",""}) 


Pergunte(cPerg,.T.)    

Private cMatrDe := MV_PAR01
Private cMatrAt := MV_PAR02
Private cFornDe := MV_PAR03
Private cFornAt := MV_PAR04 
Private cRepEma := MV_PAR05

dbSelectArea("SZW") 
                                    

cQuery1:=" SELECT SZW.*,SZW.ZW_MAT MATRICULA,ISNULL(SA2.A2_EMAIL,'') EMAIL,CTT_MATRES,CASE WHEN SRARES.RA_FILIAL = '97'THEN ISNULL(SA2RES.A2_EMAIL,'')ELSE ISNULL(SRARES.RA_EMAIL,'')  END COOD"
cQuery1+=" FROM "+RetSqlName("SZW")+" SZW "
cQuery1+=" INNER JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD=ZW_CODFOR AND SA2.D_E_L_E_T_<>'*' ) "
cQuery1+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (SRA.RA_DEMISSA ='' AND SRA.RA_MAT=ZW_MAT AND SRA.D_E_L_E_T_<>'*') "
cQuery1+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON (SRA.RA_CC=CTT_CUSTO AND CTT.D_E_L_E_T_<>'*') "
cQuery1+=" LEFT OUTER JOIN "+RetSqlName("SRA")+" SRARES ON (SRARES.RA_MAT=CTT_MATRES AND SRARES.D_E_L_E_T_<>'*') "
cQuery1+="LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2RES ON ( SRARES.RA_FOR = SA2RES.A2_COD AND SA2RES.D_E_L_E_T_<>'*'  ) "
cQuery1+=" WHERE ZW_DTBAIXA = '' AND (ZW_CRF <> '' OR ZW_GPS <>'' OR ZW_CND <>'' OR ZW_MED <> '')"  
cQuery1+=" AND ZW_MAT BETWEEN   '"+cMatrDe+"'AND '"+cMatrAt+"'"
cQuery1+=" AND ZW_CODFOR BETWEEN'"+cFornDe+"'AND '"+cFornAt+"'"
If cRepEma = 2
cQuery1+=" AND ZW_DTMAIL = ''"		
Endif   	
	
CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
TCQUERY cQuery1 Alias QTMP1 New

dbSelectArea("QTMP1")
dbGotop() 
While !Eof()
    //Posiciona na tabela SZW
    dbSelectArea("SZW")
    dbGoto(QTMP1->R_E_C_N_O_)
    dbSelectArea("QTMP1")
    
	cMensagem:='<html>'+cEol
 //	cMensagem+='<p><img src="http://www.epc.com.br/img/logo.jpg" width="136" height="87" ></p> '+cEol
	cMensagem+='<body bgcolor = "FFFFFF" Text = "0000FF">'+cEol
	cMensagem+='<p>'+ZW_NOMEFOR +' na entrega de sua  medição foi verificado <br> a falta  dos seguintes documentos: </br></p>'+cEol
	cMensagem+='<form name="form1" method="post" >'+cEol
  	cMensagem+='	<table>    ' +cEol
	cMensagem+='			<input disabled type="checkbox"' + If(Empty(ZW_CRF),"0","CHECKED=CHECKED")+"> CRF " +cEol
	cMensagem+='			<input disabled type="checkbox"' + If(Empty(ZW_GPS),"0","CHECKED=CHECKED")+"> GPS/CND " +cEol
	cMensagem+='			<input disabled type="checkbox"' + If(Empty(ZW_CND),"0","CHECKED=CHECKED")+"> CRF VENCIDA " +cEol
	cMensagem+='			<input disabled type="checkbox"' + If(Empty(ZW_MED),"0","CHECKED=CHECKED")+"> MEDIÇÃO ASSINADA " +cEol
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='	  </tr>'+cEol
	cMensagem+='	</table>'+cEol
	cMensagem+='  <p> Favor regularizar esta(s) pendência(s) até o dia 20/'+SubStr(Dtoc(Date()),4,2)+"/"+SubStr(Dtoc(Date()),7,4) +'. </p>'+cEol
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='		<p> </p>'+cEol 
	cMensagem+='		<p> </p>'+cEol 
	cMensagem+='		<p> </p>'+cEol 
	cMensagem+='		<p> </p>'+cEol
	cMensagem+='		<p>ROSI<br>Prestadores de Serviço<br>Telefone: (31) 2122-5527<br>Fax: (31) 2122-5536</br></br></br></p>'+cEol	
	cMensagem+='</form>'+cEol
	cMensagem+='</body>'+cEol
	cMensagem+='</html>'+cEol                         
                                                                         
 
		If !Empty(QTMP1->EMAIL) 
			SEND MAIL FROM  '' TO (QTMP1->EMAIL)   CC (QTMP1->COOD)  SUBJECT 'Pendencias PJ' ;
			Body cMensagem
	    	//Grava a Data e o e-mail em que foi enviado o e-mail 
	   		GravEmail()
			ELSE
				GravEmail()
	   Endif	
			 
	dbSelectArea("QTMP1")
	dbSkip()
EndDo
Pergunte(cPerg,.F.) 
MsgStop("Foram Enviados "+str(nQtdEml)+" Email's" )
dbSelectArea("QTMP1")
dbCloseArea() 
DISCONNECT SMTP SERVER
dbSelectArea("SZW")
Return 



Static Function GravEmail()
********************************************************************************************************************
*
*
**** 
  
Local cMesEml:=dtoc(Date())+'  Email nao Cadastrado'
Local cMesErr:=dtoc(Date())
Local cMesErr+='  Alerta!!! E-mail do Coodenador/Gerente da disciplina nao esta Cadastrado.'



dbSelectArea("SZW") 
RecLock('SZW',.F.)

If Empty(QTMP1->EMAIL)                 

	Replace ZW_EMAIL  With cMesEml 
	Replace ZW_DTMAIL With Date()
	nQtdEmn:= nQtdEmn+1 
ELSE 
		Replace ZW_DTMAIL With Date()                   
		Replace ZW_HRMAIL With Time()
		Replace ZW_EMAIL  With QTMP1->EMAIL
		nQtdEml:= nQtdEml+1
EndIf  
If Empty(QTMP1->COOD)
	cMesErr:=cMesErr
	Replace ZW_MEMO With cMesErr 
EndIf
		
MsunLock() 
dbCloseArea("SZW")
	
Return 



User Function CanPend (cAlias,nRecno,nOpc)
********************************************************************************************************************
* Cancela pendencia ja esta baixada
*
****   

Local aButton  := {}
Local aSay := {} 
Local cDesc1 := "Confima Cancelamento da  Pendencia do :"
Local cDesc2 := SZW->ZW_MAT+'-'+ZW_NOME
Local cDesc3 := SZW->ZW_CODFOR+'-'+ZW_NOMEFOR

If Empty(ZW_DTBAIXA)
	Alert("Pendencia em Aberto")  
	Return()
Else
	aAdd( aSay, cDesc1 ) // Texto explicativo na janela FormBatch.
	aAdd( aSay, cDesc2 ) // Texto explicativo na janela FormBatch. 
	aAdd( aSay, cDesc3 ) // Texto explicativo na janela FormBatch.
	aAdd( aButton, {  1, .T., {|| nOpc := 1,CanBaixa(),FechaBatch() }} ) // Botao 0k
	aAdd( aButton, {  2, .T., {|| FechaBatch(), lCanc := .T. }} )// Botao fecha

	FormBatch( "Cadastro de Pendencias - [Baixar Pendencias]", aSay, aButton) 
EndIf

Return() 



Static Function CanBaixa() 
******************************************************************************************************************
* Função que cancela pendencia ja baixada
*
****
              
dbSelectArea("SZW") 
RecLock('SZW',.F.)
Replace ZW_DTBAIXA With Ctod("") 
MsunLock()            



Return()
