#INCLUDE "PROTHEUS.CH"
#Include "TOPCONN.CH"
/*
+-----------------------------------------------------------------------------+
| Programa  | PMSNUMAF9| Desenvolvedor |                  | Data | 29/08/2006 |
|-----------------------------------------------------------------------------|
| Descricao | Ponto de entrada para gerar o código das tarefas                |
|-----------------------------------------------------------------------------|
|                                           								  |
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC Engenharia                                       |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  |
+--------------+-----------+--------------------------------------------------+
*/
User Function PMSNUMAF9()
Local lAF9:=.F.
/*
For nXi:=1 To 100
	If Upper(Alltrim(ProcName(nXi)))=='PMSNUMAF9'
		lAF9:=.T.
		Exit
	Endif
Next nXi	


If lAF9
	//Posiciona a tabela AFC
	cCodTrefa:=TelaClass()
Else	
	cCodTrefa:=Paramixb[1]
Endif
*/                 

Return(Paramixb[1])


Static Function TelaClass()
************************************************************************************************************
* Tela para a Classificação das Tarefas
*
*******

// Variaveis Locais da Funcao
Local aArNeg :={}
Local aEspo	 :={}
Local aTpo	 :={}
Local cDescDisc	 := Space(30)
Local cDescSubD	 := Space(30)
Local oDiscip
Local oSubDisc
Local oDescDisc
Local oDescSubD
// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
Private nSai:=0
Private cDiscip	 := Space(1)
Private cSubDisc := Space(2)
Private cAreaNeg :="   "
Private cEscopo  :=" "
Private cTipo    :=" "
Private cSeqTar	 := Space(4)
Private oSeq
Private lAltSeq:=.F.

Aadd(aArNeg,{" ","    "})
Aadd(aArNeg,{"P","Projeto"})
Aadd(aArNeg,{"G","Gerenciamento"})
Aadd(aArNeg,{"S","Suprimento"})
Aadd(aArNeg,{"A","Administrativo"})

Private aAreaNeg:={"    ","Projeto","Gerenciamento","Suprimento","Administrativo"}



Aadd(aTpo,{" ","  "})
Aadd(aTpo,{"B","Básico"})
Aadd(aTpo,{"D","Detalhado"})
Aadd(aTpo,{"C","Conceitual"})
Private aTipo:={" ","Básico","Detalhado","Conceitual"}

Aadd(aEspo,{" ","   "})
Aadd(aEspo,{"D","Dentro do Escopo"})
Aadd(aEspo,{"F","Fora do Escopo" })
Aadd(aEspo,{"N","Não se Aplica"})
Private aEscopo:={"   ","Dentro do Escopo","Fora do Escopo","Não se Aplica"}



// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        

cQuery:=" SELECT AF9_TIPPRJ,AF9_DISCIP,AF9_ESCOPO,AF9_ARNEG,AF9_SUBDIS "
cQuery+=" FROM "+RetSqlName("AF9")
cQuery+=" WHERE AF9_PROJET='"+PARAMIXB[2]+"' AND AF9_EDTPAI='"+PARAMIXB[5]+"' AND AF9_REVISA='"+PARAMIXB[3]+"'"
cQuery+=" AND D_E_L_E_T_<>'*' AND AF9_FILIAL='"+Xfilial("AF9")+"'"
TcQuery cQuery Alias QTMP New
dbSelectArea("QTMP")
dbGotop()
If !Eof()
	cTipo    :=aTpo[ascan(aTpo,{|x| x[1]==QTMP->AF9_TIPPRJ}),2]
    cAreaNeg :=aArNeg[ascan(aArNeg,{|x| x[1]==QTMP->AF9_ARNEG}),2]
	cEscopo  :=aEspo[Ascan(aEspo,{|x| x[1]==QTMP->AF9_ESCOPO}),2]
	cDiscip	 :=QTMP->AF9_DISCIP
	cSubDisc :=AllTrim(QTMP->AF9_SUBDIS)
	GerSeq()                                                    
Endif
dbSelectArea("QTMP")
dbCloseArea()
// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1,@_aArea,@_aAlias,{"SA1","SA2"}) // GetArea

dbSelectArea("AFC")
While nSai==0
	DEFINE MSDIALOG _oDlg TITLE "Classificação da Tarefa" FROM C(193),C(209) TO C(404),C(607) PIXEL
	// Cria as Groups do Sistema
	@ C(001),C(002) TO C(107),C(199) LABEL "| Classificação |" PIXEL OF _oDlg
	// Cria Componentes Padroes do Sistema
	@ C(007),C(051) ComboBox cAreaNeg Items aAreaNeg Valid GerSeq() Size C(145),C(010) PIXEL OF _oDlg
	@ C(009),C(009) Say "Area de negócio:" Size C(042),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(021),C(008) Say "Tipo:" Size C(014),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(022),C(051) ComboBox cTipo Items aTipo Valid GerSeq() Size C(072),C(010) PIXEL OF _oDlg
	@ C(037),C(008) Say "Disciplina:" Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(038),C(051) MsGet oDiscip   Var cDiscip F3 'SZM' Valid ExistCpo("SZM") .And. GerSeq() Size C(019),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(038),C(075) MsGet oDescDisc Var cDescDisc When .f. Size C(119),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(052),C(051) MsGet oSubDisc  Var cSubDisc F3 'SZU' valid ExistCpo("SZU",cDiscip+cSubDisc) .And. GerSeq() Size C(019),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(052),C(076) MsGet oDescSubD Var cDescSubD When .f. Size C(118),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(054),C(009) Say "Subdisciplina:" Size C(034),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(066),C(010) Say "Escopo:" Size C(021),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(066),C(050) ComboBox cEscopo Items aEscopo Valid GerSeq() Size C(072),C(010) PIXEL OF _oDlg
	@ C(067),C(154) MsGet oSeq Var cSeqTar PICTURE "@! 9999" When lAltSeq Valid Len(AllTrim(cSeqTar))==4 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(068),C(127) Say "Sequência:" Size C(029),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(085),C(009) Button "OK"  Action ValidOK()Size C(037),C(012) PIXEL OF _oDlg
    ////	@ C(085),C(052) Button "Cancela" Size C(037),C(012) PIXEL OF _oDlg
	@ C(067),C(179) Button "Alt "  Action {||cSeqTar:="    ",lAltSeq:=.T.} Size C(015),C(010) PIXEL OF _oDlg
                                                           
	CtrlArea(2,_aArea,_aAlias) // RestArea
	ACTIVATE MSDIALOG _oDlg CENTERED 
	
EndDo

Return(Left(cAreaNeg,1)+Left(cTipo,1)+cDiscip+cSubDisc+Left(cEscopo,1)+cSeqTar)

Static Function ZeraSeq()
****************************************************************************************************************
*
*
**** 
cSeqTar:=Space(4)
Return(.t.)



User Function GerCodTar(cAreaNeg,cTipProj,cDisc,cSubDisc,cEscopo)
**************************************************************************************************************
*
*
****   
Local cReturn:="    "
Local cQuery:=""
Local aArea:=GetArea()
cQuery:=" SELECT COUNT(*) SEQU FROM "+RetSqlName("AF9")
cQuery+=" WHERE AF9_PROJET='"+Paramixb[2]+"' AND "
cQuery+=" Left(AF9_TAREFA,6)='"+cAreaNeg+cTipProj+cDisc+cSubDisc+cEscopo+"' AND "
cQuery+=" AF9_REVISA='"+AF8->AF8_REVISA+"' AND "
cQuery+=" AF9_FILIAL='"+Xfilial("AF9")+"'  AND "
cQuery+=" D_E_L_E_T_<>'*' "
	                                              
TcQuery cQuery Alias QTMP2 New 
dbSelectArea("QTMP2")
cReturn:=StrZero((QTMP2->SEQU+1)*10,4)
	
// Fecha a Tabela e restaura o ambiente
dbSelectArea("QTMP2")
dbCloseArea()
RestArea(aArea)

Return(cReturn) 



Static Function GerSeq()
**************************************************************************************************************
*
*
***
If !Empty(cAreaNeg) .And. !Empty(cTipo) .And. !Empty(cDiscip) .And. !Empty(cSubDisc) .and. ;
   !Empty(cEscopo) ///.And. Empty(cSeqTar)  
	 
	cSeqTar:=U_GerCodTar(Left(cAreaNeg,1) ,Left(cTipo,1),cDiscip,cSubDisc,Left(cEscopo,1))
	If Type('oSeq')=='O'
		oSeq:Refresh()
	Endif
	
Endif	
Return(.t.)



Static Function ValidOK()
**************************************************************************************************************
*
*
*
**
lReturn:=.T.
//Valida se Todos os Campos estão Digitados
If lReturn .And. (Empty(cAreaNeg) .Or. Empty(cTipo) .Or. Empty(cDiscip) .Or. Empty(cSubDisc) .Or. Empty(cEscopo))
	lReturn:=.F.
	Alert("É Necessário que todos os campos desta tela seja preenchido !","Atenção")
Endif

//Valida Se o Código Já Existe
If lReturn
	cQuery:=" SELECT COUNT(*) SEQU FROM "+RetSqlName("AF9")
	cQuery+=" WHERE AF9_PROJET='"+Paramixb[2]+"' AND "
	cQuery+=" AF9_TAREFA='"+Left(cAreaNeg,1)+Left(cTipo,1)+cDiscip+cSubDisc+Left(cEscopo,1)+cSeqtar+"' AND "
	cQuery+=" AF9_REVISA='"+AF8->AF8_REVISA+"' AND "
	cQuery+=" D_E_L_E_T_<>'*'
	
	TcQuery cQuery Alias QTMP New 
	dbSelectArea("QTMP")
	If QTMP->SEQU>0
		Alert("Já Existe Uma Tarefa Cadastrada com esta Sequencia !")
		lReturn:=.F.
	Endif
	dbSelectArea("QTMP")
	dbCloseArea()
Endif	
If lReturn
	_oDlg:End()
	nSai=1 //Variável que faça a Saida do While Principal 
Endif

Return()

Static Function C(nTam)                                                         
*******************************************************************************************************************
*Funcao responsavel por manter o Layout independente da       
*resolucao horizontal do Monitor do Usuario.                  
*****

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
	nTam *= 0.8                                                                
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
	nTam *= 1                                                                  
Else	// Resolucao 1024x768 e acima                                           
	nTam *= 1.28                                                               
EndIf                                                                         
                                                                               
//³Tratamento para tema "Flat"³                                               
If "MP8" $ oApp:cVersion                                                      
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
		nTam *= 0.90                                                            
	EndIf                                                                      
EndIf 

Return Int(nTam)                                                                


Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)                       
*******************************************************************************************************************
*
*
*****
Local _nN                                                                    
	// Tipo 1 = GetArea()                                                      
	If _nTipo == 1                                                             
		_aArea   := GetArea()                                                   
		For _nN  := 1 To Len(_aArqs)                                            
			DbSelectArea(_aArqs[_nN])                                            
			AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})                        
		Next                                                                    
	// Tipo 2 = RestArea()                                                     
	Else                                                                       
		For _nN := 1 To Len(_aAlias)                                            
			DbSelectArea(_aAlias[_nN,1])                                         
			DbSetOrder(_aAlias[_nN,2])                                           
			DbGoto(_aAlias[_nN,3])                                               
		Next                                                                    
		RestArea(_aArea)                                                        
	Endif                                                                      
Return Nil                                                                   


