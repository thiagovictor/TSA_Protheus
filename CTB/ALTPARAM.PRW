#Include "Protheus.ch"
/*
+------------------------------------------------------------------------------------+
¦Programa  ¦       ¦ Autor ¦ Ricardo Diniz - NM / Gilson Lucas-NM ¦Data ¦27.05.2010  ¦
+----------+-------------------------------------------------------------------------¦
¦Descricao ¦ ALTPARAM                                   		             ¦
+----------+-------------------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA PARÂMETROS DE BLOQUEIO                                  ¦
+------------------------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                         ¦
+------------------------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             	     ¦
+------------+--------+--------------------------------------------------------------¦
¦            ¦        ¦                                                		     ¦
+------------------------------------------------------------------------------------+
*/
User Function ALTPARAM()

Local dDtaFin := GetMv("MV_DATAFIN")
Local dDtaFis := GetMv("MV_DATAFIS")
Local oFont    := TFont():New( "Times New Roman",,16,,.T.,,,,.F.,.F. )
Local oDlgPar
Local oBar
Local lOk := .f.

oDlgPar:=MSDialog():New(000,000,200,350,OemToAnsi("Altera Parâmetros de Bloqueio de Data"),,,,,CLR_BLACK,CLR_WHITE,,,.T.)
oDlgPar:lEscClose:=.F.  //Nao permite sair ao se pressionar a tecla ESC.

oBar:=tBar():New(oDlgPar,,,.t.,,,,.f.)
TBtnBmp():NewBar("OK"    ,,,,OemToAnsi("Confirma"),{|| lOk:=.t.,oDlgPar:End()},,oBar,,,OemToAnsi("Confirma Execução"),,,,,,,,,)
TBtnBmp():NewBar("CANCEL",,,,OemToAnsi("Cancela") ,{|| lOk:=.f.,oDlgPar:End()},,oBar,,,OemToAnsi("Sai da Rotina"),,,,,,,,,)

TGroup():New(015,005,050,172,"",oDlgPar,,,.T.,.T.)
TSay():New(022,010,{|| OemToAnsi("Data Limite de Operações Financeiras.")},oDlgPar,,oFont,,,,.T.,,,280,050)
TSay():New(037,010,{|| OemToAnsi("Bloqueio Financeiro:") },oDlgPar,,oFont,,,,.T.,,,280,050)
TGet():New(035,085,{|u| if(PCount()>0,dDtaFin:=u,dDtaFin)}, oDlgPar, 50, 10, , {|| ! Empty(dDtaFin) }, CLR_HBLUE, CLR_WHITE,,,,.T.,,,{|| .t. },,,/*CHANGE*/,.F.,.F.,,"dDtaFin")

TGroup():New(055,005,090,172,"",oDlgPar,,,.T.,.T.)
TSay():New(062,010,{|| OemToAnsi("Última Data de Encerramento de Operações Fiscais.") },oDlgPar,,oFont,,,,.T.,,,280,050)
TSay():New(077,010,{|| OemToAnsi("Bloqueio Fiscal:")},oDlgPar,,oFont,,,,.T.,,,280,050)
TGet():New(075,085,{|u| if(PCount()>0,dDtaFis:=u,dDtaFis)}, oDlgPar, 50, 10, , {|| ! Empty(dDtaFis) }, CLR_HBLUE, CLR_WHITE,,,,.T.,,,{|| .t. },,,/*CHANGE*/,.F.,.F.,,"dDtaFis")

oDlgPar:Activate(,,,.T.,{|| AllwaysTrue() },,)

If lOk //Testa Confirmacao
	If ! Empty(dDtaFin)
		PutMv("MV_DATAFIS",dDtaFis)
	EndIf
	
	If ! Empty(dDtaFis)
		PutMv("MV_DATAFIN",dDtaFin)
	EndIf
EndIf

Return