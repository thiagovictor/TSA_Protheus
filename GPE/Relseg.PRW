#Include "PROTHEUS.Ch"
#Include "TopConn.ch"

User Function RELSEG()

Local   cTitulo 	:= "Relatório Seguro de Vida"
Local   lRet		:= .T.
Private nLastKey 	:= 0
Private cPerg	 	:= "RELSEG"
Private aLinha		:= {}
Private aPerg:={}
Private cPerg:="RELSEG"
Private nomeProg 	 := "RELSEG"
Private nFile:=00
m_pag		:= 1
AADD(aPerg,{cPerg,"Competência?"         ,"C",07,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Filial de  ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Filial Até ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Centro de Custo de  ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Centro de Custo Até ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Situação da Folha"    ,"C",05,0,"G","fsituacao","","","","","",""})
AADD(aPerg,{cPerg,"Categorias ?"         ,"C",15,0,"G","fcategoria","","","","","",""})
AADD(aPerg,{cPerg,"Ordem de Impressão"   ,"N",09,0,"C","","","Nome","Centro de Custo","Matricula","",""})
AADD(aPerg,{cPerg,"Seguradora"           ,"N",09,0,"C","","","Minas Brasil","Citilsurance","","",""})
AADD(aPerg,{cPerg,"Vlr Limite ?"           ,"N",12,2,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Nro Salarios p/Limite ?","N",03,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Nome do Arquivo(Pasta Relato)?","C",20,0,"G","!Empty(MV_PAR12)","","","","","",""})



Pergunte(cPerg,.F.)

If !Pergunte("RELSEG",.T.)
	Return
EndIf	

wnrel := "RELSEG"            

Processa({|| CursorWait(), ImpRel(cTitulo) ,CursorArrow()},"Aguarde....")
FClose(nfile)

Return

Static Function ImpRel(cTitulo)
******************************************************************************************************************************
*
*
*****
Local cFile:=""
Local oPrint
Local i 	:= 1
 //Define se a folha de parametros sera impressa no inicio
Local cNameFile		:= ""                 
Private nlin 	:= 0                        
Private oFont16, oFont08, oFont10 , oFont14
Private aResTp:={}
Private aRes:={}
Private nPag:=0
Private nValFunc:=0
Private nValConj:=0 

Pergunte("RELSEG",.f.)

lCompAtu:=(MV_PAR01==GetMv("MV_FOLMES"))
cFilDe :=MV_PAR02
cFilAte:=MV_PAR03
cCCdE  :=MV_PAR04
cCCAte :=MV_PAR05
cSitFol:=MV_PAR06
nCateg :=MV_PAR07
nOrdImp:=MV_PAR08
nTpSeg :=MV_PAR09
nVlrLim:=MV_PAR10
nNroSal:=MV_PAR11
cFile:=MV_PAR12
nFile:=Fcreate(Alltrim(__RELDIR+MV_PAR12)+".##R")
If nTpSeg==1
	cLinha:="MATRIC;NOME                          ;ADMISSAO;NASCIMEN;CPF        ;RG             ;ORG;UF;DATA RG ;VALOR DESC;VALOR CONJ"
Else 
	cLinha:="MATRIC;NOME                          ;ADMISSAO;S;NASCIMEN;CPF        ;RG             ;ORG;UF;DATA RG ;VALOR "
Endif
Fwrite(nFile,cLinha)

cQuery:=" SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_SALARIO,RA_SEGUROV,RA_SEXO,RA_CC,RA_CATFUNC,RA_SITFOLH,RA_ADMISSA,RA_NASC,RA_CIC,RA_RG,RA_RGORG,RA_ESTRG,RA_DATARG FROM "+RetSqlName("SRA")+" SRA "
cQuery+=" WHERE (SRA.RA_DEMISSA='' OR LEFT(SRA.RA_DEMISSA,6)='"+MV_PAR01+"')"
cQuery+=" AND RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cQuery+=" AND RA_CC BETWEEN '"+cCCDe+"' AND '"+cCCAte+"'"
cQuery+=" AND  SRA.D_E_L_E_T_<>'*' "
cQuery+=" ORDER BY "
do Case
	Case nOrdImp=1
		cQuery+=" RA_NOME"
	Case nOrdImp=2
		cQuery+=" RA_CC"
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

nLin:=ImpCab(oPrint,1)

dbSelectArea("QSRA")
dbGotop()
While QSRA->(!Eof())
	
	nValFunc:=0
	nValConj:=0
	If !QSRA->RA_SITFOLH$cSitFol .Or. !QSRA->RA_CATFUNC$nCateg
		dbSelectArea("QSRA")
		dbSkip()
		Loop
	Endif
	If lCompAtu
		dbSelectArea("SRC")
		dbSeek(QSRA->(RA_FILIAL+RA_MAT))
		While !Eof() .And. QSRA->RA_MAT==SRC->RC_MAT
			If Left(Dtos(RC_DATA),6)==AllTrim(MV_PAR01)
				If SRC->RC_PD=='458'
					nValFunc:=SRC->RC_VALOR
				ElseIf SRC->RC_PD=='457'
					nValConj:=SRC->RC_VALOR
				Endif
			Endif	
			dbSkip()
		EndDo
	Else
		dbSelectArea("SRD")
		dbSeek(QSRA->(RA_FILIAL+RA_MAT))
		While !Eof() .And. QSRA->RA_MAT==SRD->RD_MAT
			If Left(Dtos(SRD->RD_DATPGT),6)==AllTrim(MV_PAR01)
				If SRD->RD_PD=='458'
					nValFunc:=SRD->RD_VALOR
				ElseIf SRD->RD_PD=='457'
					nValConj:=SRD->RD_VALOR
				Endif
			Endif	
			dbSkip()
		EndDo	
	Endif
	If nTpSeg==1 .And. nValFunc>0
		nLin :=ImpDet(oPrint,nLin)
	Endif	
	If nTpSeg==2  .And. QSRA->RA_SEGUROV='01'
		nLin :=ImpDet(oPrint,nLin)
	Endif	
	
	dbSelectArea("QSRA")
	dbSkip()
EndDo
oPrint:Box(nLin,50,nLin+50,2350)
oPrint:EndPage()
dbSelectArea("QSRA")
dbCloseArea()
oPrint:Preview()  				// Visualiza antes de imprimir

Return()



Static Function ImpCab(oPrint)
****************************************************************************************************************
*
*
*****
///cStartPath := AjuBarPath(cStartPath)
Local aNomSeg:={'Seguro de Vida Minas Brasil','Seguro de Vida Citilsurance'}
nPag++
cNameFile  := "epc"+cEmpAnt+cFilAnt+".bmp"
If !File(cNameFile)
	cNameFile := "epc"+cEmpAnt+".bmp"
Endif
oPrint:SayBitmap(10,05,cNameFile,400,200)
oPrint:Say(100,950,"SEGURO DE VIDA",oFont16)
oPrint:Box(050,2000,180,2350)
oPrint:Say(055,2020 ,"Pagina:"+Str(nPag,2),oFont08)
oPrint:Say(090,2020 ,"Data.:"+Dtoc(Date()),oFont08)
oPrint:Say(120,2020 ,"Hora.:"+Time(),oFont08)
oPrint:Say(200,0050  ,"Ref. a Competencia:"+Left(MV_PAR01,4)+'/'+Right(MV_PAR01,2),oFont14)
Do Case
	Case nTpSeg==1
		oPrint:Box(300,50,350,2350)
		oPrint:Box(350,50,400,2350)
		oPrint:Line(350,195,400,195)
		oPrint:Line(350,795,400,795)  
		oPrint:Line(350,1045,400,1045)
		oPrint:Line(350,1195,400,1195)
		oPrint:Line(350,1395,400,1395)
		oPrint:Line(350,1575,400,1575)
		oPrint:Line(350,1735,400,1735)
		oPrint:Line(350,1795,400,1795)
		oPrint:Line(350,1940,400,1940)
		oPrint:Line(350,2140,400,2140)
		oPrint:Say(300,950 ,aNomSeg[nTpSeg],oFont10)
		
		oPrint:Say(350,60  ,"Matricula"    ,oFont08A)
		oPrint:Say(350,210 ,"Nome"         ,oFont08A)
		oPrint:Say(350,810 ,"Admissão"     ,oFont08A)
		oPrint:Say(350,1060,"Nasc"         ,oFont08A)
		oPrint:Say(350,1210,"CPF"          ,oFont08A)
		oPrint:Say(350,1410,"RG"           ,oFont08A)
		oPrint:Say(350,1580,"Org Emissor"  ,oFont08A)
		oPrint:Say(350,1755,"UF"           ,oFont08A)
		oPrint:Say(350,1810,"Emissao"      ,oFont08A)
		oPrint:Say(350,1950,"Desc. Func."  ,oFont08A)
		oPrint:Say(350,2160,"Desc. Conjuge",oFont08A)	
		nLin:=400
	Case nTpSeg==2
		oPrint:Box(300,50,350,2350)
		oPrint:Box(350,50,400,2350)
		oPrint:Line(350,195,400,195)
		oPrint:Line(350,795,400,795)
		oPrint:Line(350,945,400,945)
		oPrint:Line(350,1045,400,1045)
		oPrint:Line(350,1195,400,1195)
		oPrint:Line(350,1395,400,1395)
		oPrint:Line(350,1575,400,1575)
		oPrint:Line(350,1735,400,1735)
		oPrint:Line(350,1795,400,1795)
		oPrint:Line(350,1990,400,1990)
		oPrint:Say(300,950 ,aNomSeg[nTpSeg],oFont10)	 
		oPrint:Say(350,60  ,"Matricula"    ,oFont08A)
		oPrint:Say(350,210 ,"Nome"         ,oFont08A)
		oPrint:Say(350,810 ,"Admissão"     ,oFont08A)
		oPrint:Say(350,955 ,"Sexo"         ,oFont08A)
		oPrint:Say(350,1060,"Nasc"         ,oFont08A)
		oPrint:Say(350,1210,"CPF"          ,oFont08A)
		oPrint:Say(350,1410,"RG"           ,oFont08A)
		oPrint:Say(350,1580,"Org Emissor"  ,oFont08A)
		oPrint:Say(350,1755,"UF"           ,oFont08A)
		oPrint:Say(350,1810,"Emissao"      ,oFont08A)
		oPrint:Say(350,2000,"Valor Segurado",oFont08A)
		nLin:=400
EndCase

/*  else
For ny:=0 To 2000 Step 100
	oPrint:Say(ny,01,StrZero(ny,4),oFont08A)
Next Ny
For nx:=0 To 3500 Step 100
	oPrint:Say(1,nx,StrZero(nx,4),oFont08A)
Next nx */


Return(nLin)



Static Function ImpDet(oPrint,nLin)
**************************************************************************************************************
*
*
*******          
Local nPosRes:=0
Local nPosTp:=0
Local cEol:=Chr(13)+Chr(10)

If nlin > 3300
	oPrint:Box(nLin,50,nLin+50,2350)
	oPrint:EndPage()
	oPrint:StartPage()
	nLin:=ImpCab(oPrint,1)	
Endif
do Case
	Case nTpSeg==1
		oPrint:Line(nLin,50  ,nLin+50,50)
		oPrint:Line(nLin,195 ,nLin+50,195)
		oPrint:Line(nLin,795 ,nLin+50,795)
		oPrint:Line(nLin,1045,nLin+50,1045)
		oPrint:Line(nLin,1195,nLin+50,1195)
		oPrint:Line(nLin,1395,nLin+50,1395)
		oPrint:Line(nLin,1575,nLin+50,1575)
		oPrint:Line(nLin,1735,nLin+50,1735)
		oPrint:Line(nLin,1795,nLin+50,1795)
		oPrint:Line(nLin,1940,nLin+50,1940)
		oPrint:Line(nLin,2140,nLin+50,2140)
		oPrint:Line(nLin,2350,nLin+50,2350)
		
		oPrint:Say(nLin,060,QSRA->RA_MAT,oFont08A)
		oPrint:Say(nLin,210,QSRA->RA_NOME,oFont08A)
		oPrint:Say(nLin,810,Dtoc(Stod(QSRA->RA_ADMISSA)),oFont08A)
		oPrint:Say(nLin,1060,Dtoc(Stod(QSRA->RA_NASC)),oFont08A)
		oPrint:Say(nLin,1210,Alltrim(QSRA->RA_CIC),oFont08A)
		oPrint:Say(nLin,1410,Alltrim(QSRA->RA_RG),oFont08A)
		oPrint:Say(nLin,1600,Alltrim(QSRA->RA_RGORG),oFont08A)
		oPrint:Say(nLin,1740,Alltrim(QSRA->RA_ESTRG),oFont08A)
		oPrint:Say(nLin,1800,Dtoc(Stod(QSRA->RA_DATARG)),oFont08A)
		
		oPrint:Say(nLin,1945,TransForm(nValFunc,"@E 999,999.99"),oFont10)
		oPrint:Say(nLin,2160,TransForm(nValConj,"@E 999,999.99"),oFont10)
		oPrint:Line(nLin+50,50,nLin+50,2350)
		
		cLinha:=QSRA->RA_MAT+';'+QSRA->RA_NOME+';'+Dtoc(Stod(QSRA->RA_ADMISSA))+';'+Dtoc(Stod(QSRA->RA_NASC))+';'+QSRA->RA_CIC+';'+QSRA->RA_RG+';'+QSRA->RA_RGORG+';'+QSRA->RA_ESTRG+';'+Dtoc(Stod(QSRA->RA_DATARG))+';'+TransForm(nValFunc,"@E 999,999.99")+';'+TransForm(nValConj,"@E 999,999.99")
		cLinha+=cEol

		
		
	Case nTpSeg==2
		nValFunc:=If((QSRA->RA_SALARIO*nNroSal)>=nVlrLim,nVlrLim,(QSRA->RA_SALARIO*nNroSal))
		oPrint:Line(nLin,50  ,nLin+50,50)
		oPrint:Line(nLin,195 ,nLin+50,195)
		oPrint:Line(nLin,795 ,nLin+50,795)
		oPrint:Line(nLin,945,nLin+50,945)
		oPrint:Line(nLin,1045,nLin+50,1045)
		oPrint:Line(nLin,1195,nLin+50,1195)
		oPrint:Line(nLin,1395,nLin+50,1395)
		oPrint:Line(nLin,1575,nLin+50,1575)
		oPrint:Line(nLin,1735,nLin+50,1735)
		oPrint:Line(nLin,1795,nLin+50,1795)
		oPrint:Line(nLin,1990,nLin+50,1990)
		oPrint:Line(nLin,2350,nLin+50,2350)
		
		cAdmissa:=Stod(QSRA->RA_ADMISSA)
		cAdmissa:=Dtoc(cAdmissa)
		oPrint:Say(nLin,060,QSRA->RA_MAT,oFont08A)
		oPrint:Say(nLin,210,QSRA->RA_NOME,oFont08A)
		oPrint:Say(nLin,810,cAdmissa,oFont08A)
		oPrint:Say(nLin,980,QSRA->RA_SEXO,oFont08A)
		oPrint:Say(nLin,1060,Dtoc(Stod(QSRA->RA_NASC)),oFont08A)
		oPrint:Say(nLin,1210,Alltrim(QSRA->RA_CIC),oFont08A)
		oPrint:Say(nLin,1410,Alltrim(QSRA->RA_RG),oFont08A)
		oPrint:Say(nLin,1600,Alltrim(QSRA->RA_RGORG),oFont08A)
		oPrint:Say(nLin,1740,Alltrim(QSRA->RA_ESTRG),oFont08A)
		oPrint:Say(nLin,1800,Dtoc(Stod(QSRA->RA_DATARG)),oFont08A)
		
		oPrint:Say(nLin,2100,TransForm(nValFunc,"@E 999,999.99"),oFont10)
		oPrint:Line(nLin+50,50,nLin+50,2350)	
		
		cLinha:=QSRA->RA_MAT+';'+QSRA->RA_NOME+';'+cAdmissa+';'+QSRA->RA_SEXO+';'+Dtoc(Stod(QSRA->RA_NASC))+';'
		cLinha+=QSRA->RA_CIC+';'+QSRA->RA_RG+';'+QSRA->RA_RGORG+';'+QSRA->RA_ESTRG+';'+Dtoc(Stod(QSRA->RA_DATARG))+';'+TransForm(nValFunc,"@E 999,999.99")
		cLinha+=cEol
EndCase
FWrite(nfile,cLinha)

nLin+=50
Return(nLin)



