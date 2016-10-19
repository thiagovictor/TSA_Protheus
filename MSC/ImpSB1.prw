#Include "RwMake.ch"
#Include "Colors.ch"
/*
+-----------------------------------------------------------------------+
¦Programa  ¦ IMPSB1  ¦ Autor ¦ Gilson Lucas          ¦Data ¦30.09.2012  ¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Importacao do SB1                                           ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦ Carraro    ¦ VARIAS ¦ Implementacoes Diversas                         ¦
+-----------------------------------------------------------------------+
*/
User Function ImpSB1()
*************************************************************************
* 
**
Local  oDlgMrg
Local  oNomArq
Local  oScr01
Local  cNomFile  := ""
Local  aCadBas   := {}
Local  nCadBas   := 1
Local  nMeter    := 0
Local  lDeleta   := .F.
Local  oFont     := TFont():New( "Arial",,16,,.T.,,,,.F.,.F. )
Static lRunning  := .F.

Aadd(aCadBas,"SB1 - Cadastro de Produto")


oDlgMrg:=MSDialog():New(000,000,320,420,OemToAnsi("Importação do Produtos"),,,,,CLR_BLACK,CLR_WHITE,,,.T.)
oDlgMrg:lEscClose:=.F.  //Nao permite sair ao se pressionar a tecla ESC.
oDlgMrg:lMaximized:=.T. //Inicia Maximixado

oScr01   := TScrollBox():New(oDlgMrg,005,003,070,200,.T.,.F.,.T.) 
TRadMenu():New(005,005,aCadBas,{|u|if(PCount()>0,nCadBas:=u,nCadBas)},oScr01,,,,,,,,160,11,,,,.T.)

TGroup():New( 078,003,123,208,"",oDlgMrg,,,.T.,.T.)
TSay():New(085,010,{|| OemToAnsi('Nome do Arquivo')},oDlgMrg,,oFont,,,,.T.,,,280,050)

oNomArq  := TGet():New(097,010,{|u| if(PCount()>0,cNomFile :=u,cNomFile) }, oDlgMrg, 110,10,,{|| AllWaysTrue()  },,,,,,.T.,,,{|| .F.},,,,,.F.,,"cNomFile") 
TButton():New(097,130,'...'  ,oDlgMrg,{|| cNomFile := cGetFile("*.DBF|*.DBF|*.*|*.*","Selecione o arquivo...",;
0,'SERVIDOR\IMP_ATIVO\',.F.,GETF_NETWORKDRIVE)},015,10,,,,.T.)


TButton():New(084,162,'&Importar',oDlgMrg,{|| MsgRun(PadC("Aguarde, Obtendo dados ...",100),,;
{|| CursorWait(),PrcImp(oMeter,nCadBas,cNomFile,lDeleta),;
CursorArrow()}) },040,14,,,,.T.)

TButton():New(103,162,'&Fechar'  ,oDlgMrg,{|| oDlgMrg:End()},040,14,,,,.T.)

TGroup():New(124,003,137,208,"",oDlgMrg,,,.T.,.T.)
TCheckBox():New(125,005,OemToAnsi("Deleta registros antes da importação."),{|U| IIf(PCount()==0,lDeleta,lDeleta:=U )}, oDlgMrg, 180, 010,,{|| },oFont,,CLR_HRED,,, .t., OemToAnsi("Indica se limpa as tabelas antes de importar."),,{|| })


TGroup():New(137,003,157,208,"Processamento",oDlgMrg,,,.T.,.T.)
oMeter   := tMeter():New(144,010,{|u|if(Pcount()>0,nMeter:=u,nMeter)},100,oDlgMrg,185,08,,.T.)

oDlgMrg:Activate(,,,.T.,{|| AllwaysTrue() },,)

Return



Static Function PrcImp(oMeter,nCadBas,cNomFile,lDeleta)
*************************************************************************
* Processa Importacao
***

If lRunning      
   Return 
Endif 

lRunning := .T.  // Necessario para ajuste da barra de progressao.
oMeter:Set(10)
oMeter:Refresh()

If MonTrab(cNomFile,lDeleta)
  	ProcCad(nCadBas,oMeter,lDeleta)
EndIf	

lRunning := .F.
dbSelectArea("TRAB")                                           
TRAB->(dbCloseArea())


Return



Static Function MonTrab(cNomFile,lDeleta)
*************************************************************************
* Importacao de Dados
*****

If lDeleta

Else
   If !Empty(cNomFile)
      If !File(cNomFile)
         MsgBox(OemToAnsi("Arquivo não encontrado."),OemToAnsi("Atenção"),"STOP")
      Else
         dbUseArea(.T.,"dbfcdxads",cNomFile,"TRAB",.F.,.F.)
      EndIf
   EndIf
EndIf
	
Return((Select("TRAB") > 0))



Static Function ProcCad(nOpcCad,oMeter,lDeleta)
*************************************************************************
* Processa Importacao
** 
Local cQuery         := ""
Local nCont          := 0
Private M->B1_GRUPO  := ""

dbSelectArea("TRAB")
TRAB->(dbGoTop())
oMeter:nTotal := TRAB->(RecCount())

Do Case
   Case nOpcCad == 1
        If lDeleta
           /*******cQuery := "DELETE FROM "+RetSqlName("SB1")+ " WHERE B1_DESC2 = 'IMPORTADO' "
           TcSqlExec(cQuery)
           TcRefresh("SB1")
           */
        EndIf   
        dbSelectArea("SB1")
        SB1->(dbSetOrder(9)) //B1_FILIAL+B1_CODREF
        While !TRAB->(Eof())
            nCont++
            oMeter:Set(nCont)
            oMeter:Refresh()
            SB1->(dbSeek(xFilial("SB1")+Alltrim(TRAB->COD_REF)))
            If SB1->(Eof())
               M->B1_GRUPO := Alltrim(TRAB->GRUPO)
               cCodProd    := U_SEQGRUPO()
            Else
               M->B1_GRUPO := SB1->B1_GRUPOO
               cCodProd    := SB1->B1_COD          
            EndIf
            If RecLock("SB1",SB1->(Eof()))
               Replace B1_FILIAL  With xFilial("SB1"),;
                       B1_GRUPO   With M->B1_GRUPO,;
                       B1_COD     With cCodProd,;
                       B1_CODREF  With Alltrim(TRAB->COD_REF),;
                       B1_DESC    With Alltrim(TRAB->DESC),;
                       B1_TIPO    With Alltrim(TRAB->TIPO),; // F3 Tipo do Produto
                       B1_LOCPAD  With StrZero(Val(TRAB->LOCAPAD),2),; // F3 Local padrão
                       B1_UM      With Alltrim(TRAB->UNID),; // F3 Unidade de Medida
                       B1_CONTA   With Alltrim(TRAB->CONTA1),; // Conta contabil
                       B1_ORIGEM  With Alltrim(TRAB->ORIGEM),; // F3 Origem do produto
                       B1_CTACONS With Alltrim(TRAB->CONTA2),; // F3 conta Contabil
                       B1_DESC2   With 'IMPORTADO'
               SB1->(MsUnLock())
            EndIf
            TRAB->(dbSkip())
        End  		
EndCase


Return