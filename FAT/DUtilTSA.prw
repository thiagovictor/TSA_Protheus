/*
+-------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦DUtilTSA ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 07.04.2006¦
+----------+--------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Copia para cada setor da TSA os dias uteis da EPC.                               ¦ 
+----------+----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA CBM                                                              ¦
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

User Function DUtilTSA()

Local cQueryEPC := ""
Local cQueryTSA := ""
Local cSetor    := ""


If !(cEmpAnt $ "02")
   MsgStop("Esta rotina deve ser executada apenas na empresa TSA!")
   Return()
EndIf

cQueryEPC := "SELECT * FROM SZK010 "
cQueryEPC += "WHERE ZK_CODCONT = '131210' AND D_E_L_E_T_ <> '*' "

TCQUERY cQueryEPC ALIAS "SZKEPC" NEW


cQueryTSA := "SELECT * FROM SZ4020 "
cQueryTSA += "WHERE Z4_SETOR > 59000 AND D_E_L_E_T_ <> '*' "

TCQUERY cQueryTSA ALIAS "SZ4TSA" NEW 


dbSelectArea("SZ4TSA")
dbGoTop()

While !Eof() 

   cSetor := SZ4TSA->Z4_SETOR
        
   dbSelectArea("SZKEPC")
   dbGoTop()
   While !Eof()                       .And. ;
          SZ4TSA->Z4_SETOR == cSetor
      
      dbSelectArea("SZK")
      dbSetOrder(1)
      dbSeek(xFilial("SZK")+SZ4TSA->Z4_SETOR+SZKEPC->ZK_MESANO+SZKEPC->ZK_DATA)
      
      If RecLock("SZK",Eof())
         Replace ZK_CODCONT With SZ4TSA->Z4_SETOR
         Replace ZK_MESANO  With SZKEPC->ZK_MESANO
         Replace ZK_DATA    With CTOD(SubStr(SZKEPC->ZK_DATA,7,2)+"/"+SubStr(SZKEPC->ZK_DATA,5,2)+"/"+SubStr(SZKEPC->ZK_DATA,1,4))
         MsUnlock()
      EndIf
   
      dbSelectArea("SZKEPC")
      dbSkip()
   End
   dbSelectArea("SZ4TSA")
   dbSkip()
End
   
Return