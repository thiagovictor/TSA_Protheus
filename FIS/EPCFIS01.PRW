/*
+-------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCFIS01 ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 22.03.2006¦
+----------+--------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Executa processo de consulta aos titulos para serem listados no relatorio FIS001 ¦ 
+----------+----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                                              ¦
+----------+----------------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                                  ¦
+------------+--------+-----------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                                   ¦
+------------+--------+-----------------------------------------------------------------------+
¦            ¦        ¦                                                                       ¦
+------------+--------+-----------------------------------------------------------------------+
*/
#include "rwmake.ch"
#include "topconn.ch"

User Function EPCFIS01()

Local cPerg     := "EFIS01"

Local cFiliInic := Space(02)
Local cFiliFina := Space(02)
Local dDataInic := CTOD("")
Local dDataFina := CTOD("")
Local nListaNF  := 0
Local nOrderBy  := 0

Local cParam    := ""

If !Pergunte(cPerg,.T.)
	Return
EndIf

dDataInic := MV_PAR01
dDataFina := MV_PAR02
nListaNF  := MV_PAR03
nOrderBy  := MV_PAR04

If TcSpExist('EPCFIS001_1')
   Processa({||TcSPExec ('EPCFIS001_1',DTOS(dDataInic),DTOS(dDataFina),SM0->M0_CODIGO,nOrderBy)},"Gerando informacoes das Notas Fiscais. Aguarde...")

   cParam := DTOC(dDataInic)+";"+DTOC(dDataFina)+";"+Str(nListaNF,1)+";"+Str(nOrderBy,1)+";"+SM0->M0_CODIGO
   //cOptions := "1;0;1;POSIÇÃO DOS TÍTULOS PAGOS"
                
   CallCrys("FIS001",cParam) //,cOptions)   
Else
   MsgBox("Nao existe a sp 'EPCFIS001_1', portanto este relatorio nao podera ser gerado!","Mensagem do Administrador", "STOP")        
EndIf


Return