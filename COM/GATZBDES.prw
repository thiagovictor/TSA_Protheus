/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |GATZBDES  |Autor | CLAUDIO SILVA  			       | Data  |26/01/06 |
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Gatiho campo ZB_DESCRI                                               |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao   				 |
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao											 |
|             |           |                                                      |
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"
#include "TopConn.ch"

User Function GATZBDES(xVar)

Local lRet := .T.
Local aArea:= GetArea()

//If SM0->M0_CODIGO == "02" //TSA
	fMontTela()
//EndIf

RestArea(aArea)

Return(xVar)



User Function VALZBDES
*****************************************************************************
* Validacao campo ZB_DESCRI
*
***
Local lRet := .T.
Local aArea:= GetArea()

//If SM0->M0_CODIGO == "02" //TSA
	lRet:= fMontTela()
//EndIf

If GdFieldGet("ZB_TIPO") == 'A'     
	dbSelectArea("SN3")
	SN3->(dbSetOrder(1))
	SN3->(dbSeek('97'+SN1->(N1_CBASE+N1_ITEM)+'01'))
	If !SN3->(Eof())
		GdFieldPut("ZB_VLREVEN",SN3->N3_VORIG1,n)
	EndIf
EndIf
        
RestArea(aArea)

Return(lRet)



Static Function fMontTela()
*****************************************************************************
* Monta tela para consullta padrao
*
***

Local oDlgSecond
Local cDescri	:= GdFieldGet("ZB_DESC2")
Local cRendi 	:= GdFieldGet("ZB_VLREVEN") //Incluido por Daniel Moreira - 21.02.06
Local cConsF3  := ""
Local cVartit  := ""
Private cTipo 	:= GdFieldGet("ZB_TIPO")                          
Private cCodigo	:= GdFieldGet("ZB_DESCRI")

//Posicao do F3 - Consulta Padrao
Do Case
	Case cTipo == "F" //Fornecedor
		cConsF3:= "ORF"
		cVarTit:= "Fornecedor"
	Case cTipo == "C" //Cliente
		cConsF3:= "ORC"
		cVarTit:= "Cliente"
	Case cTipo == "E" //Empregado
		cConsF3:= "ORE"
		cVarTit:= "Empregado"
	Case cTipo == "D" //Diversos
		cConsF3:= "ORD"
		cVarTit:= "Diversos"
	Case cTipo == "V" //Evento
		cConsF3:= "USZ3" //-> incluído por Daniel Morera em 20.02.06
		cVarTit:= "Evento"
	Case cTipo == "A" //Ativo Fixo
		cConsF3:= "SN1PRV" //"SN1" 
		cVarTit:= "Ativo Fixo"
	Otherwise	
		cConsF3:= ""
		cVarTit:= ""
EndCase


//Montagem da tela
@ 000,000 To 100,350 DIALOG oDlgSecond Title "Dados Complementares"
@ 005,005 To 030,170 Title "Informe Dados"
@ 015,010 SAY cVarTit+": "
@ 015,040 Get cCodigo Picture "@!" F3 cConsF3 Valid VldCod(cCodigo,@cDescri) Size 40,07 Object oCodigo
@ 015,080 Get cDescri Picture "@!" When .F. Size 70,07
@ 030,100 BMPBUTTON Type 01 Action FConfirm(cCodigo, cDescri,oDlgSecond, cRendi)

If cTipo == "V" //por Daniel Moreira em 20.02.06
	oCodigo:bLostFocus := {|| cDescri:=SZ3->Z3_DESCEVE, cRendi:=SZ3->Z3_VALOR}
EndIf

Activate Dialog oDlgSecond Centered      
            
lRet:= !Empty(cCodigo)            

If !lRet
	MSGBOX("Informe um valor.","Atencao","STOP")
EndIf
                              
Return(lRet)



Static Function FConfirm(cCodigo,cDescri,oDlgSecond,cRendi)
*****************************************************************************
* Confirmacao dos campos digitados
*
***

GDFieldPut("ZB_DESCRI", cCodigo)
GDFieldPut("ZB_DESC2" , cDescri)
GDFieldPut("ZB_VLREVEN" ,cRendi)

Close(oDlgSecond)

Return(.t.)



Static Function VldCod(cCodigo,cDescri)
************************************************************************************************************************************************
* Valida o Código Digitado
*
***
Local lRet:=.F.
//Posicao do F3 - Consulta Padrao
Do Case
	Case cTipo == "F" //Fornecedor
		If SA2->(dbSeek(Xfilial("SA2")+Alltrim(cCodigo)))
			lRet:=.T.
			cDescri:=SA2->A2_NOME
		Endif
	Case cTipo == "C" //Cliente
		If SA1->(dbSeek(Xfilial("SA1")+Alltrim(cCodigo)))
			lRet:=.T.
			cDescri:=SA1->A1_NOME
		Endif
	Case cTipo == "E" //Empregado
		If SZD->(dbSeek(Xfilial("SZD")+Alltrim(cCodigo)))
			lRet:=.T.
			cDescri:=SZD->ZD_NOMEFUN
		Endif
	Case cTipo == "A" // Ativo Fixo
		dbSelectArea("SN1")
		SN1->(dbSetOrder(1))
		SN1->(dbSeek('97'+Alltrim(cCodigo)))
		If !SN1->(Eof())
			lRet:=.T.
			cDescri:= SN1->N1_DESCRIC
		Endif
	Case cTipo == "D" //Diversos
		lRet:=.T.
	Case cTipo == "V" //Evento
		lRet:=.T.
	OtherWise
		lRet:=.T.	
EndCase
If GdFieldGet("ZB_TIPO")=='F'
	cQuery:=" SELECT RA_MAT,RA_NOME,RA_SALARIO FROM "+RetSqlName("SRA")
	cQUERY+=" WHERE RA_FOR='"+Alltrim(Left(cCodigo,6))+"' AND RA_FILIAL='97'"
	cQuery+=" AND D_E_L_E_T_<>'*' AND RA_DEMISSA=''" 
	TcQuery cQuery Alias QPJ New
	aListFun:={}
	nListFun:=0
	dbSelectArea("QPJ")
	While !Eof()	
		nListFun:=1
		Aadd(aListFun,QPJ->(RA_MAT+'-'+RA_NOME))
		dbSelectArea("QPJ")
		dbSkip()
	EndDo
	dbSelectArea("QPJ")
	dbCloseArea()
	If Len(aListFun)>1
		@ 000,000 To 150,250 Dialog oDlgPJ Title "Selecione o Funcionário"
		@ 02,02 LISTBOX nListFun ITEMS aListFun SIZE 120,50
		@ 055,02 BmpButton Type 01 Action oDlgPJ:End()
		Activate Dialog oDlgPJ Center                
	Endif
	If Len(aListFun)>0
		GdFieldPut("ZB_MATPJ",Left(aListFun[nListFun],6))
	Endif
Endif

Return(lRet)