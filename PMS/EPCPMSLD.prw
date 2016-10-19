/*
+-------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCPMSLD ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 26.06.2007¦
+----------+--------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Executa procedure de preparacao da tabela para emissao da Lista de Documentos    ¦ 
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

User Function EPCPMSLD()

Local cPerg     := "LDEDT2"

Local cCodProj  := Space(10)
Local dDtPrvIni := CTOD("")
Local dDtPrvFim := CTOD("")
Local cTarInic  := Space(30)
Local cTarFina  := Space(30)
Local cNumClie  := Space(20)
Local cNumEPC   := Space(20)
Local nLstDocs  := 0
Local cSbDisIni := Space(02)
Local cSbDisFim := Space(02)
Local cNumEPC   := Space(20)
Local nRevisao  := 0
Local dDtEmiIni := CTOD("")
Local dDtEmiFim := CTOD("")
Local cRevLD    := Space(02)


Local cParam    := ""

If !Pergunte(cPerg,.T.)
	Return
EndIf

cCodProj  := MV_PAR01
dDtPrvIni := MV_PAR02
dDtPrvFim := MV_PAR03
cTarInic  := MV_PAR04
cTarFina  := MV_PAR05
cNumClie  := MV_PAR06
cNumEPC   := MV_PAR07
nLstDocs  := MV_PAR08
cSbDisIni := MV_PAR09
cSbDisFim := MV_PAR10
nRevisao  := MV_PAR11
dDtEmiIni := MV_PAR12
dDtEmiFim := MV_PAR13
cRevLD    := MV_PAR14


If TcSpExist('PRC_EAP_PMS')
   Processa({||TcSPExec ('PRC_EAP_PMS',cCodProj)},"Gerando informacoes do Projeto. Aguarde...")

   cParam := cCodProj+";"+DTOC(dDtPrvIni)+";"+DTOC(dDtPrvFim)+";"+cTarInic+";"+cTarFina+";"+cNumClie+";"+cNumEPC+";"+Str(nLstDocs,1)+";"+cSbDisIni+";"+cSbDisFim+";"+Str(nRevisao,1)+";"+DTOC(dDtEmiIni)+";"+DTOC(dDtEmiFim)+";"+cRevLD
      //cOptions := "1;0;1;POSIÇÃO DOS TÍTULOS PAGOS"
                
   CallCrys("LDEDT2",cParam) //,cOptions)   
Else
   MsgBox("Nao existe a sp 'PRC_EAP_PMS', portanto este relatorio nao podera ser gerado!","Mensagem do Administrador", "STOP")        
EndIf


Return