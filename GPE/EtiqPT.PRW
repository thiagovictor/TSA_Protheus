#Include "PROTHEUS.Ch"
#Include "TopConn.ch"

User Function ETIQPT()

Local   cTitulo 	:= ""
Local   lRet		:= .T.
Private nLastKey 	:= 0
Private cPerg	 	:= "ETQPTO"
Private aLinha		:= {}
Private aPerg:={}
Private nomeProg 	 := "ETQPTO"
m_pag		:= 1
AADD(aPerg,{cPerg,"Dt. Referencia?"      ,"D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Filial de  ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Filial Até ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Centro de Custo de  ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Centro de Custo Até ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Situação da Folha"    ,"C",05,0,"C","fsituacao","","","","","",""})
AADD(aPerg,{cPerg,"Categorias ?"         ,"C",15,0,"C","fcategoria","","","","","",""})
AADD(aPerg,{cPerg,"Ordem de Impressão"   ,"N",09,0,"C","","","Nome","C.Custo+Nome","Matricula","",""})



Pergunte(cPerg,.F.)

If !Pergunte("ETQPTO",.T.)
	Return
EndIf	

wnrel := "ETQPTO"

Processa({|| CursorWait(), ImpEtq(cTitulo) ,CursorArrow()},"Aguarde....")

Return



Static Function ImpEtq(cTitulo)
******************************************************************************************************************************
*
*
*****
Local oPrint
Local i 	:= 1
 //Define se a folha de parametros sera impressa no inicio
Local cNameFile		:= ""                 
Private nlin 	:= 150                        
Private oFont16, oFont08, oFont10 , oFont14
Private aResTp:={}
Private aRes:={}
Private nPag:=0
Private nValFunc:=0
Private nValConj:=0         
Private aInfo:={}
Private nCol1:=50
Private nCol2:=1300
Private nCol:=1300
fInfo(@aInfo,SRA->RA_FILIAL)
dDtRef :=MV_PAR01
cFilDe :=MV_PAR02
cFilAte:=MV_PAR03
cCCdE  :=MV_PAR04
cCCAte :=MV_PAR05
cSitFol:=MV_PAR06
nCateg :=MV_PAR07
nOrdImp:=MV_PAR08

cQuery:=" SELECT R_E_C_N_O_ RECN FROM "+RetSqlName("SRA")+" SRA "
cQuery+=" WHERE SRA.RA_DEMISSA='' "
cQuery+=" AND RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cQuery+=" AND RA_CC BETWEEN '"+cCCDe+"' AND '"+cCCAte+"'"
cQuery+=" AND  SRA.D_E_L_E_T_<>'*' "
cQuery+=" ORDER BY "

do Case
	Case nOrdImp=1
		cQuery+=" RA_NOME"
	Case nOrdImp=2
		cQuery+=" RA_CC+RA_NOME"
	Case nOrdImp=3
		cQuery+=" RA_MAT"
EndCase

TcQuery cQuery Alias QSRA New

oFont08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFont08A	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont20	:= TFont():New("Arial",20,20,,.F.,,,,.T.,.F.)

oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont20N	:= TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)

oPrint:= TMSPrinter():New(cTitulo)

dbSelectArea("QSRA")
dbGotop()
While QSRA->(!Eof())
	dbSelectArea("SRA")
	dbGoto(QSRA->RECN)
	
	If !SRA->RA_SITFOLH$cSitFol .Or. !SRA->RA_CATFUNC$nCateg
		dbSelectArea("QSRA")
		dbSkip()
		Loop
	Endif
	nCol:=If(nCol==nCol2,nCol1,nCol2)
	nLin :=ImpDet(oPrint,nLin,nCol)
	dbSelectArea("QSRA")
	dbSkip()
EndDo
oPrint:EndPage()
dbSelectArea("QSRA")
dbCloseArea()
oPrint:Preview() //Visualiza antes de imprimir

Return()



Static Function ImpDet(oPrint,nLin,nCol)
**************************************************************************************************************
*
*
*******          
Local nPosRes:=0
Local nPosTp:=0
Local aEtiq:={}
If nlin > 3000
	oPrint:EndPage()
	oPrint:StartPage()
	nLin:=150
Endif
Aadd(aEtiq,"FUNC: "+SRA->RA_MAT+"-"+SRA->RA_NOME)
Aadd(aEtiq,"CAT:"+fDesc("SX5","28"+SRA->RA_CATFUNC,"X5DESCRI()",11,SRA->RA_FILIAL)+" "+Upper(FDESC_MES(Month(dDtRef),3))+"/"+Right(StrZero(Year(dDtRef),4),2))
Aadd(aEtiq,"FUNÇÃO: "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)+"  CTPS:"+SRA->RA_NUMCP+"/"+SRA->RA_SERCP)

cDescEmp  := aInfo[03]									// Razao Social
cDescEnd  := aInfo[04]									// Endereco
cDescAtiv := StrZero(Val(Subst(aInfo[16],1,5)),5)		// Atividade Economica CNAE
cDescCgc  := aInfo[08]									// CGC/CEI
nTpInsc   := aInfo[15]									// Tipo de Inscricao
cDescCgc  := Transform(Subs(cDescCgc,1,11),"@R ###.###.###-##")+Space(4)
Aadd(aEtiq,"CNPJ:"+cDescCgc+"    "+SRA->RA_CC+"-"+DescCc(SRA->RA_CC,SRA->RA_FILIAL))
Aadd(aEtiq,"HORÁRIO DE TRABALHO       INTERVALO")          
Aadd(aEtiq,Posicione("SR6",1,Xfilial("SR6")+SRA->RA_TNOTRAB,"R6_DESC"))          
/*
For ny:=0 To 2000 Step 100
	oPrint:Say(ny,01,StrZero(ny,4),oFont08A)
Next Ny
For nx:=0 To 3500 Step 100
	oPrint:Say(1,nx,StrZero(nx,4),oFont08A)
Next nx
*/
oPrint:Say(nLin    ,nCol,aEtiq[1],oFont08A)
oPrint:Say(nLin+045,nCol,aEtiq[2],oFont08A)
oPrint:Say(nLin+090,nCol,aEtiq[3],oFont08A)
oPrint:Say(nLin+135,nCol,aEtiq[4],oFont08A)
oPrint:Say(nLin+180,nCol,aEtiq[5],oFont08A)
oPrint:Say(nLin+225,nCol,aEtiq[6],oFont08A)
If nCol==nCol2
	nLin:=nLin+302
Endif

Return(nLin)



