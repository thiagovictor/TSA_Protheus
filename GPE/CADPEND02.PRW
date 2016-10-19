/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCCOM01  ¦ Autor ¦ Jane Mariano Duval                         | Data  ¦ 10.09.2007¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Rotina cadastrar pendencias de PJ's                    ¦ 
+----------+-----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                                               ¦
+----------+-----------------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                                   ¦
+------------+--------+------------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                                    ¦
+------------+--------+------------------------------------------------------------------------+
¦            ¦        ¦                                                                        ¦
+------------+--------+------------------------------------------------------------------------+
*/

#include "protheus.ch"
#include "topconn.ch"
#include "colors.ch"

User Function CADPEND02()

Private cFilialIn := Space(02)
Private cFilialFi := Space(02)
Private dDtEntIni := CTOD("")
Private dDtEntFim := CTOD("")
Private nRadOpc   := 0
Private nOpcao    := 1
Private oRadOpc

//Monta tela solicitando ao usuario o periodo de digitacao das NF's
//Define MSDialog oDlgParam Title OemToAnsi("Parâmetros da Conferencia") From 005,010 TO 200,255 Of oMainWnd Pixel
Define MSDialog oDlgParam Title OemToAnsi("Parâmetros da Conferencia") From 005,010 TO 280,255 Of oMainWnd Pixel

//oGroupConf := TGroup():New(007,008,050,120,OemToAnsi("Parâmetros:"),,CLR_HBLUE,,.T.)
oGroupConf := TGroup():New(007,008,070,120,OemToAnsi("Parâmetros:"),,CLR_HBLUE,,.T.)

@ 013,013 SAY oSay1 Var OemToAnsi("Filial Inicial") Of oDlgParam Pixel 
@ 023,013 GET oFilialIn Var cFilialIn Of oDlgParam Pixel //F3 "SM0"
@ 013,070 SAY oSay2 Var OemToAnsi("Filial Final") Of oDlgParam Pixel 
@ 023,080 GET oFilialFi Var cFilialFi Of oDlgParam Pixel //F3 "SM0"

@ 043,013 SAY oSay3 Var OemToAnsi("Digitação Inicial") Of oDlgParam Pixel 
@ 053,013 GET oDtEntIni Var dDtEntIni Of oDlgParam Pixel 
@ 043,070 SAY oSay4 Var OemToAnsi("Digitação Final") Of oDlgParam Pixel 
@ 053,080 GET oDtEntFim Var dDtEntFim Of oDlgParam Pixel //Valid FValMes()

//PARAMETROS PARA DEFINIR O TIPO DE TELA QUE SERA APRESENTADA: MARCACAO DE NF'S OU INFORMACAO DA CIDADE ONDE É DEVIDO O ISS DA NF
oGroupOpc := TGroup():New(073,008,115,120,OemToAnsi("Selecione uma opção de conferencia"),,CLR_HBLUE,,.T.)

@ 013, 013 RADIO oRadOpc VAR  nRadOpc
oRadOpc :=  TRadMenu():New(083,013, {OemToAnsi("Marcar NF's Conferidas"),OemToAnsi("Definir Municipio para pagto de ISS")},;
                      bSETGET(nOpcao), oDlgParam,,,,,OemToAnsi("Selecione a opção"),,,100,15)

Define SButton From 120,030 Type 1 Action (SelectReg() .And. oDlgParam:End()) Enable Of oDlgParam
Define SButton From 120,070 Type 2 Action (oDlgParam:End()) Enable Of oDlgParam

//Define SButton From 075,030 Type 1 Action (SelectReg() .And. oDlgParam:End()) Enable Of oDlgParam
//Define SButton From 075,070 Type 2 Action (oDlgParam:End()) Enable Of oDlgParam

ACTIVATE MSDIALOG oDlgParam CENTERED
//ACTIVATE MSDIALOG oDlgParam ON INIT FCriateBar(oDlgParam,{|| nOpca := 1,oDlgParam:End()},{|| nOpca := 3,oDlgParam:End()}) 


Return


Static Function SelectReg()
****************************************************************************************************
* Selecao das Notas Fiscais digitadas no periodo definido pelo usuario
*
****

Local aCampos    := {}
Local aStruct    := {}
Local cQuery     := ""
Local nFreeze    := 0
Private lInverte := .F.
Private cMarca   := GetMark()
Private aHeader  := {}
Private bteste

Private aRotina :={{"Pesq"	,"AxPesq", 0, 1},; 
                   {"Visu","AxVisual", 0, 2}}  // aRotina é uma variável que é chamada no MsGetDB e deve ser declarada senão da pau!

dbSelectArea("SZW")
dbSetOrder(1)

Aadd(aStruct,{"ZW_OK "     ,"C",02,0})
Aadd(aStruct,{"ZW_MESREF"  ,"C",06,0})
Aadd(aStruct,{"ZW_MAT "    ,"C",06,0})
Aadd(aStruct,{"ZW_CODFOR"  ,"C",06,0})
Aadd(aStruct,{"ZW_NOMEFOR ","C",40,0})
Aadd(aStruct,{"ZW_NOME "   ,"C",40,0})

AADD(aCampos,{"ZW_OK      "    ,,"Ok"           ,PesqPict("SZW","ZW_OK")})       
AADD(aCampos,{"ZW_MESREF  "    ,,"MesRef"       ,PesqPict("SZW","ZW_MESREF")}) 
Aadd(aCampos,{"ZW_MAT     "    ,,"Matricula"    ,PesqPict("SZW","ZW_MAT")})
Aadd(aCampos,{"ZW_CODFOR  "    ,,"Cod. Forn"    ,PesqPict("SZW","ZW_CODFOR")})
Aadd(aCampos,{"ZW_NOMEFOR "    ,,"Empresa "     ,PesqPict("SZW","ZW_NOMEFOR")})
Aadd(aCampos,{"ZW_NOME    "    ,,"Funcionario"  ,PesqPict("SZW","ZW_NOME")})



cFileWork := CriaTrab(aStruct,.T.)

USE &cFileWork ALIAS TRB EXCLUSIVE NEW
IndRegua("TRB",cFileWork,"ZW_OK+ZW_MESREF+ZW_MAT",,,OemToAnsi("Selecionando Registros")) 

cQuery:=" SELECT SZW.*,SZW.ZW_MAT MATRICULA,ISNULL(SA2.A2_EMAIL,'') EMAIL,CTT_MATRES,CASE WHEN SRARES.RA_FILIAL = '97'THEN ISNULL(SA2RES.A2_EMAIL,'')ELSE ISNULL(SRARES.RA_EMAIL,'')  END COOD"
cQuery+=" FROM "+RetSqlName("SZW")+" SZW "
cQuery+=" INNER JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD=ZW_CODFOR AND SA2.D_E_L_E_T_<>'*' ) "
cQuery+=" INNER JOIN "+RetSqlName("SRA")+" SRA ON (SRA.RA_DEMISSA ='' AND SRA.RA_MAT=ZW_MAT AND SRA.D_E_L_E_T_<>'*') "
cQuery+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON (SRA.RA_CC=CTT_CUSTO AND CTT.D_E_L_E_T_<>'*') "
cQuery+=" LEFT OUTER JOIN "+RetSqlName("SRA")+" SRARES ON (SRARES.RA_MAT=CTT_MATRES AND SRARES.D_E_L_E_T_<>'*') "
cQuery+="LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2RES ON ( SRARES.RA_FOR = SA2RES.A2_COD AND SA2RES.D_E_L_E_T_<>'*'  ) "
cQuery+=" WHERE ZW_DTBAIXA = '' AND (ZW_CRF <> '' OR ZW_GPS <>'' OR ZW_CND <>'' OR ZW_MED <> '')"  

/*cQuery += " SA2.D_E_L_E_T_ <> '*' "
cQuery += " WHERE F1_DTENT BETWEEN '" + DTOS(dDtEntIni) + "' AND '" + DTOS(dDtEntFim) + "' AND "
cQuery += " F1_FILIAL BETWEEN '" + cFilialIn + "' AND '" + cFilialFi + "' AND "
cQuery += " F1_CONFERE IN('') AND SF1.D_E_L_E_T_ <> '*' "*/

//Wladimir 


cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QSF1', .F., .T.)

For ni := 1 to Len(aStruct)
   If aStruct[ni,2] != 'C'
     TCSetField('QSF1', aStruct[ni,1], aStruct[ni,2], aStruct[ni,3], aStruct[ni,4])
   Endif
Next

dbSelectArea("QSF1")
dbGoTop()

While !Eof()
   dbSelectArea("TRB")
   RecLock("TRB",.T.)
      For ni := 1 to QSF1->(FCount())
          TRB->(FieldPut(nI,QSF1->(FieldGet(ni))))
      Next
   MsUnLock()
   
   dbSelectArea("QSF1")
   dbSkip()
End
                                     
dbSelectArea("QSF1")
dbCloseArea()
              
dbSelectArea("TRB")
dbGoTop()
		
DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Conferencia de Notas Fiscais") From 9,0 To 28,80 OF oMainWnd
//@ 015,015  SAY OemToAnsi("Selecione as Notas conferidas:") COLOR CLR_HBLUE
@ 017,015 SAY oSayPrinc Var OemToAnsi("Selecione as Notas conferidas:") Of oDlg2 Pixel COLOR CLR_HBLUE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Monta a tela de acordo com a opcao selecionada na tela de parametros
If nOpcao == 1 
   oMark := MsSelect():New("TRB","ZW_OK","",aCampos,@lInverte,@cMarca,{35,1,143,315})
   oMark:oBrowse:lHasMark    := .T.
   oMark:oBrowse:lCanAllMark := .T.
   oMark:oBrowse:cToolTip := "Clique em 'Ok' para marcar/desmarcar todos" 
   oMark:oBrowse:lModified := .T.
Else  
   //aadd(aHeader,{"Tecnico","NomeTecn","@!",30,0,.T.,SX3->x3_usado,"C", "TMP", SX3->x3_context } )
     aAdd(aHeader,{"MesRef"       ,"ZW_MESREF"  ,PesqPict("SZW","ZW_MES")     ,06,0,.T.,SX3->X3_USADO,"C","TRB",SX3->X3_CONTEXT})
     aAdd(aHeader,{"Matricula"    ,"ZW_MAT "    ,PesqPict("SZW","ZW_MAT")     ,40,0,.T.,SX3->X3_USADO,"C","TRB",SX3->X3_CONTEXT})
     aAdd(aHeader,{"CodForne"     ,"ZW_CODFOR"  ,PesqPict("SZW","ZW_CODFOR")  ,20,0,.T.,SX3->X3_USADO,"C","TRB",SX3->X3_CONTEXT})
     aAdd(aHeader,{"Empresa"      ,"ZW_NOMEFOR" ,PesqPict("SZW","ZW_NOMEFOR") ,08,0,.T.,SX3->X3_USADO,"D","TRB",SX3->X3_CONTEXT})
     aAdd(aHeader,{"Funcionario"  ,"ZW_NOME   " ,PesqPict("SF1","ZW_NOME   ") ,14,2,.T.,SX3->X3_USADO,"N","TRB",SX3->X3_CONTEXT})
     
   //oObj  := MsGetDb():New(nT,nL,nB,nR,nOpcX ,cLinhaOk       ,cTudoOk        ,cIniCpos,lDeleta,aAlter         ,nFreeze,lEmpty,nMax,cTrb,cFieldOk,lCondicional,lAppend)
     oMark := MsGetDb():New(035,001,143,315,2 ,"allwaystrue()","allwaystrue()",""      ,.F.    ,{"TRB->ZW_NOME"},nFreeze,.F.   ,    ,"TRB")
     oMark:oBrowse:lModified := .T.
     oMark:oBrowse:lMChange  := .T.
     oMark:oBrowse:lColDrag  := .T.
     //oMark:oBrowse:blDblClick := {||FGetMunic()}
EndIf

//ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{|| nOpca := 1,FOk()},{|| nOpca := 2,FCancel()})
ACTIVATE MSDIALOG oDlg2 ON INIT FCriateBar(oDlg2,{|| nOpca := 1,FOk()},{|| nOpca := 3,FCancel()}) 

    
Return(.T.)


Static Function FOk()
*********************************************************************************************
*
*
****

/*dbSelectArea("TRB")
dbGoTop()

While !Eof()
   If nOpcao == 1 
      If TRB->F1_CONFERE == cMarca
         cQuery := "UPDATE " + RetSqlName("SZW") + " SET ZW_OK = '" + TRB->ZW_OK + "', "
         cQuery += "F1_DTCONF = '" + DTOS(dDataBase) + "' "
         cQuery += " WHERE "
         cQuery += "F1_DOC = '" + TRB->F1_DOC + "' AND F1_SERIE = '" + TRB->F1_SERIE + "' AND "
         cQuery += "F1_FORNECE = '" + TRB->F1_FORNECE + "' AND F1_LOJA = '" + TRB->F1_LOJA + "' AND "
         cQuery += "F1_FILIAL = '" + TRB->F1_FILIAL + "' AND D_E_L_E_T_ <> '*' " 
         TcSqlExec(cQuery)
      EndIf
   
   EndIf       
   dbSelectArea("TRB")
   dbSkip()
End   

dbSelectArea("TRB")
dbCloseArea()*/

oDlg2:End()

Return

Static Function FCancel()
*********************************************************************************************
*
*
****

dbSelectArea("TRB")
dbCloseArea()

oDlg2:End()

Return


Static Function FCriateBar(oDlg2,bOk,bCancel)
***************************************************************************************************
* Mostra tela com informações das NF's
*
****

Local oBar, bSet15, bSet24, lOk, oBtOk, oBtCan
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg2

DEFINE BUTTON RESOURCE "S4WB005N"		OF oBar 		   ACTION NaoDisp()		TOOLTIP "Recortar"
DEFINE BUTTON RESOURCE "S4WB006N"		OF oBar 		   ACTION NaoDisp()		TOOLTIP "Copiar"
DEFINE BUTTON RESOURCE "S4WB007N"		OF oBar 		   ACTION NaoDisp()		TOOLTIP "Colar"
DEFINE BUTTON RESOURCE "S4WB008N"		OF oBar GROUP	ACTION Calculadora()	TOOLTIP "Calculadora..."
DEFINE BUTTON RESOURCE "S4WB009N"		OF oBar 		   ACTION Agenda()		TOOLTIP "Agenda..."
DEFINE BUTTON RESOURCE "S4WB016N"		OF oBar GROUP 	ACTION HelProg()		TOOLTIP "Help de Programa..."

oBar:nGroups += 50
DEFINE BUTTON RESOURCE "S4WB011N"  		OF oBar GROUP	ACTION FPesqNF()	TOOLTIP OemToAnsi("Pesquisar Nota Fiscal")

oBar:nGroups += 8
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP "Cancelar - <Ctrl-X>"

SetKEY(24,oBtCan:bAction)
oDlg2:bSet15 := oBtOk:bAction
oDlg2:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}

Return


Static Function FPesqNF()
****************************************************************************************************
* Pesquisa de NF's no browse
*
****

Local oCbxPesq 
Local oDlgPesq
Local oTextPesq
Private cCbxPesq  := ""
Private cTextPesq := Space(60)
Private aItens    := {}

/*Aadd(aItens,"Numero NF"      +Space(100)+"01")
Aadd(aItens,"Emissao"        +Space(100)+"02")
Aadd(aItens,"Nome Fornecedor"+Space(100)+"03")

Define MSDialog oDlgPesq Title OemToAnsi("Pesquisar Nota Fiscal") From 005,010 TO 165,450 Of oMainWnd Pixel
oGroupPesq := TGroup():New(003,005,058,220,OemToAnsi("Pesquisar por:"),,CLR_HBLUE,,.T.)
@ 020,013 MSCOMBOBOX oCbxPesq VAR cCbxPesq ITEMS aItens SIZE 140, 15 OF oDlgPesq PIXEL 
@ 040,013 GET oTextPesq Var cTextPesq Of oDlgPesq SIZE 180, 07 Pixel 
Define SButton From 065,140 Type 1 Action (FPesquisar() .And. oDlgPesq:End()) Enable Of oDlgPesq
Define SButton From 065,180 Type 2 Action (oDlgPesq:End()) Enable Of oDlgPesq

Activate MSDialog oDlgPesq Centered*/


Return


Static Function FPesquisar()
*****************************************************************************************************
* Monta tela com historico salarial do funcionario
*
****

cOpcPesq := Right(cCbxPesq,2)

Do Case
   Case cOpcPesq $ "01" // Numero NF
        dbSelectArea("TRB")
        IndRegua("TRB",cFileWork,"ZW_MESREF",,,OemToAnsi("Selecionando Registros"))
        dbSeek(AllTrim(cTextPesq))
   Case cOpcPesq $ "02" // Emissao
        dbSelectArea("TRB")
        IndRegua("TRB",cFileWork,"ZW_MAT",,,OemToAnsi("Selecionando Registros"))
        dbSeek(AllTrim(cTextPesq))
   Case cOpcPesq $ "03" // Nome Fornecedor
        dbSelectArea("TRB")
        IndRegua("TRB",cFileWork,"A2_NOME",,,OemToAnsi("Selecionando Registros"))
        dbSeek(AllTrim(cTextPesq))
EndCase

Return(.T.)


/*Static Function FGetMunic()
**********************************************************************************************************
* Tela para capturar o Municipio onde o ISS é devido.
*
****

Private cMunicipio := Space(20)

Define MSDialog oDlgMunic Title OemToAnsi("ISS devido no Município") From 005,010 TO 200,300 Of oMainWnd Pixel

//oGroupConf := TGroup():New(007,008,050,120,OemToAnsi("Parâmetros:"),,CLR_HBLUE,,.T.)
oGroupConf := TGroup():New(007,008,070,140,OemToAnsi("Informe o Município onde o ISS é devido:"),,CLR_HBLUE,,.T.)

//@ 013,013 SAY oSay1 Var OemToAnsi("Filial Inicial") Of oDlgParam Pixel 
@ 023,013 GET oMunicipio Var cMunicipio Of oDlgMunic Pixel //F3 "SM0"
//@ 013,070 SAY oSay2 Var OemToAnsi("Filial Final") Of oDlgParam Pixel 
//@ 023,080 GET oFilialFi Var cFilialFi Of oDlgParam Pixel //F3 "SM0"

//@ 043,013 SAY oSay3 Var OemToAnsi("Digitação Inicial") Of oDlgParam Pixel 
//@ 053,013 GET oDtEntIni Var dDtEntIni Of oDlgParam Pixel 
//@ 043,070 SAY oSay4 Var OemToAnsi("Digitação Final") Of oDlgParam Pixel 
//@ 053,080 GET oDtEntFim Var dDtEntFim Of oDlgParam Pixel //Valid FValMes()


Define SButton From 075,050 Type 1 Action (FAtuaReg() .And. oDlgMunic:End()) Enable Of oDlgMunic
Define SButton From 075,090 Type 2 Action (oDlgMunic:End()) Enable Of oDlgMunic

ACTIVATE MSDIALOG oDlgMunic CENTERED


Return


Static Function FAtuaReg()
**********************************************************************************************************
* Tela para capturar o Municipio onde o ISS é devido.
*
****

//dbSelectArea("TRB")
TRB->F1_MUNICIS := cMunicipio */


Return(.T.)