#Include 'Rwmake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Gilson Lucas          ¦Data ¦16.06.2008¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Consulta padrão sn1 customizada                             ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function SN1PREV()
************************************************************************
*
****
VAR_IXB := CriaVar("ZB_DESCRI",.f.,.f.)

VAR_IXB := DialSN1()


Return(.T.)



Static Function DialSN1()
************************************************************************
*
****
Local   oDlgSN1
Local   cRet      := ""
Local   lOk       := .F.
Local   aCabSN1   := {}
Local   cPesq     := Space(150)
Local   aBens     := {}
Local   cChaves   := "Codigo do Bem"                               
Local   aChaves   := {OemToAnsi('Codigo do Bem'),OemToAnsi('Descrição'),OemToAnsi('Centro de Custo')}
Local   oFontCab  := TFont():New("Arial",10,,,.T.,,,,.F.,.F.)   
Private oBens


AAdd(aCabSN1,OemToAnsi('Cod Bem'))
AAdd(aCabSN1,OemToAnsi('Item'))
AAdd(aCabSN1,OemToAnsi('Descrição'))
AAdd(aCabSN1,OemToAnsi('Data Aquisição'))
AAdd(aCabSN1,OemToAnsi('Centro de Custo'))

dbSelectArea("SN3")
SN3->(dbSetOrder(1))  // N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ


dbSelectArea("SN1")
SN1->(dbSetOrder(1))  // N1_FILIAL+N1_CBASE+N1_ITEM
SN1->(dbSeek('97')) // Fixo no fonte por solicitação da Paula. 
While !SN1->(Eof()) .AND. SN1->N1_FILIAL = '97'
	SN3->(dbSeek('97'+SN1->(N1_CBASE+N1_ITEM)+'01'))
	If !SN3->(Eof())
		Aadd(aBens,{SN1->N1_CBASE,SN1->N1_ITEM,SN1->N1_DESCRIC,SN1->N1_AQUISIC,SN3->N3_CCUSTO})	
	EndIf
	SN1->(dbSkip())
End


If Len(aBens) > 0
	DEFINE MSDIALOG oDlgSN1 FROM 000,000 To 300,600 PIXEL TITLE OemToAnsi(cCadastro)
	
	TGroup():New(005,005,042,295,"",oDlgSN1,,,.T.,.T.)
	                        
	TComboBox():New(010,010,{|U|if(PCount()>0,cChaves:=U,cChaves)},aChaves,200,09,oDlgSN1,,,,,,.T.,oFontCab,,,,,,,,"cChaves")
	TGet():New(026,010,{|U| IIf(PCount()==0,cPesq,cPesq:=U )},oDlgSN1,200,09,"@!",{|| PesGrid(aBens,cChaves,cPesq) },,,oFontCab, .F.,, .T.,, .F.,{||.T.}, .F., .F.,, .F., .F. ,,(cPesq))


	TButton():New(010,230,'&OK'   , oDlgSN1 , {|| lOk := .T. , cRet := Alltrim(aBens[oBens:nAT][1]),;
	Iif(Empty(cRet),allwaystrue(),oDlgSN1:End()) },050,12,,,,.T.)
	
	TButton():New(026,230,'&Sair' , oDlgSN1 , {|| lOk := .F. , oDlgSN1:End() },050,12,,,,.T.)
	
	
	
	oBens:= TWBrowse():New(045,005,290,100,,aCabSN1,,oDlgSN1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBens:SetArray(aBens)
	oBens:bLine        := {|| {aBens[oBens:nAT][1],aBens[oBens:nAT][2],aBens[oBens:nAT][3],aBens[oBens:nAT][4],aBens[oBens:nAT][5]}}
			
	TBitMap():New(000,000,270,425,, "PROJETOAP", .T., , , , , , , , , , .T.)			                                             
	Activate MsDialog oDlgSN1 Centered 

	If lOk       
		If ValType(oDlgSN1)!='U'
			oDlgSN1:End()
		EndIf			
	EndIf
EndIf
	        
	
	
	
Return(cRet)



Static function PesGrid(aBens,cChaves,cPesq)
************************************************************************
*
****                 

Local lRet    := .T.
Local nAchou  := 0 
Local nPesq   := 0



If cChaves == 'Codigo do Bem'
	nPesq := 1 
ElseIf cChaves == 'Descrição'
	nPesq := 3
Else          
	nPesq := 5
EndIf
	        
	
aSort(aBens,,,{|x,y| x[nPesq] < y[nPesq]})	
oBens:SetArray(aBens)
oBens:bLine        := {|| {aBens[oBens:nAT][1],aBens[oBens:nAT][2],aBens[oBens:nAT][3],aBens[oBens:nAT][4],aBens[oBens:nAT][5]}}
oBens:Refresh()

If !Empty(cPesq)
	If (nAchou := aScan(aBens,{|Ax| Alltrim(cPesq) $ Ax[nPesq]})) # 0
		oBens:NAT	:= nAchou
		oBens:Refresh()
	Else
		lRet := .F.
		MsgBox(OemToAnsi("Registro não encontrado."),OemToAnsi('Atenção'),'STOP')
	EndIf
EndIf
	
Return(lRet)