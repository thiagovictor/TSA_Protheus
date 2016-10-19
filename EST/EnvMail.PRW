#Include "ap5mail.ch"

User Function SD3240I()

EnvMail()


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
Local cSendBy   := GetMv("MV_MAILATF",,'wr.fernandes@epcbh.com.br')

cMens:='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
cMens+='<HTML>'
cMens+='<HEAD> '
cMens+='<IMG SRC="http://www.epc.com.br/img/logo.jpg" ALIGN="top" WIDTH="100" HEIGHT="80">'
cMens+='<TITLE>AMPLIAÇÃO DE BENS</TITLE>'
cMens+='</HEAD>                             '
cMens+='<br><B><FONT FACE="@Arial Unicode MS" COLOR="#000080">Ampliação de Bens por Requisição:</FONT></B>'
cMens+='<HR ALIGN="left" COLOR="#000000" NOSHADE WIDTH="600">                                              '
cMens+='<FONT FACE="@Arial Unicode MS" >Foi realizada uma requisição de estoque para ampliação dos bens conforme</FONT>'
cMens+='<br><FONT FACE="@Arial Unicode MS" > dados abaixo: </FONT>'
cMens+='<br><FONT FACE="@Arial Unicode MS" > Item:<b>'+SD3->D3_COD+'-'+Alltrim(Posicione("SB1",1,Xfilial("SB1")+SD3->D3_COD,"B1_DESC"))+'</b></FONT>'
cMens+='<br><FONT FACE="@Arial Unicode MS" > Nro Documento:<b>'+SD3->D3_DOC+'</b></FONT>'
cMens+='<br><FONT FACE="@Arial Unicode MS" > Bem:<b> '+SD3->D3_CODBEM+'-'+SD3->D3_ITEMBEM+' </B></FONT>'
cMens+='<br><FONT FACE="@Arial Unicode MS" > Data:<b> '+Dtoc(SD3->D3_EMISSAO)+' </b></FONT>'
cMens+='<br><FONT FACE="@Arial Unicode MS" > Valor Movimentação:<b> R$'+Alltrim(Transform(SD3->D3_CUSTO1,'@E 99,999,999.999'))+'</B></FONT>'
cMens+='<br><FONT FACE="@Arial Unicode MS" > Responsável:<b>'+cUsername+'</B></FONT>'
cMens+='<BODY BGCOLOR="#DBE6F4">"'
cMens+='</BODY>'
cMens+='</HTML>'  

CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
SEND MAIL FROM  cSendBy TO  cCtaMail ; 
SUBJECT 'Requisição de Estoque para Ampliação' ;
BODY cMens

DISCONNECT SMTP SERVER

Return