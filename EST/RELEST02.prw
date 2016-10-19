/*
+-----------------------------------------------------------------------+
¦Programa  ¦RELEST02  ¦ Autor ¦Crislei de A. Toledo   ¦ Data |22/11/2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦Relatorio de Estoque (Quantidade e custo) por Contrato      ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA TSA / EPC                                  ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
|            |        |                                                 |  
+-----------------------------------------------------------------------+
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function RELEST02()

Local cPerg     := "EEST02"
Local aPerg     := {}

Local cParam    := ""
Local cLoteInic := Space(10)
Local cLoteFina := Space(10)
Local cProdInic := Space(15)
Local cProdFina := Space(15)
Local nTipoSald := 0
Local dDataFech := CTOD("")

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PARAMETROS DO RELATORIO:                                 ³
//³                                                         ³
//³MV_PAR01   Do Lote                                       ³
//³MV_PAR02   Ate Lote                                      ³
//³MV_PAR03   Do Produto                                    ³
//³MV_PAR04   Ate Produto                                   ³
//³MV_PAR11   Saldo a considerar (Atual / Ultimo Fechamento)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

AADD(aPerg,{cPerg,"Do Lote            ?","C",10,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Ate Lote           ?","C",10,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Do Produto         ?","C",15,0,"G","","SB1","","","","",""})
AADD(aPerg,{cPerg,"Ate Produto        ?","C",15,0,"G","","SB1","","","","",""})
AADD(aPerg,{cPerg,"Considerar Custo   ?","N",01,0,"C","","","Ult. Fechamento","Atual","","",""})


If !Pergunte(cPerg,.T.)
	Return
EndIf

cLoteInic := MV_PAR01
cLoteFina := MV_PAR02
cProdInic := MV_PAR03
cProdFina := MV_PAR04
nTipoSald := MV_PAR05 // 1 = Ultimo Fechamento; 2 = Saldo Atual

dDataFech := GetMv("MV_ULMES")

If TcSpExist('EPCEST002')
   Processa({||TcSPExec ('EPCEST002',cLoteInic,cLoteFina,cProdInic,cProdFina,nTipoSald,DTOS(dDataFech),SM0->M0_CODIGO)},"Gerando informacoes do Estoque. Aguarde...")

   cParam := cLoteInic+";"+cLoteFina+";"+cProdInic+";"+cProdFina+";"+Str(nTipoSald,1)+";"+DTOC(dDataFech)+";"+SM0->M0_CODIGO
   //cOptions := "1;0;1;POSIÇÃO DOS TÍTULOS PAGOS"
                
   CallCrys("EST002",cParam) //,cOptions)   
Else
   MsgBox("Nao existe a sp 'EPCEST002', portanto este relatorio nao podera ser gerado!","Mensagem do Administrador", "STOP")        
EndIf

Return