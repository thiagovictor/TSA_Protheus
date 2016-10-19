/*
+-----------------------------------------------------------------------+
¦Programa  ¦EPCEST02 ¦ Autor ¦ Crislei de A. Toledo   ¦ Data ¦21.06.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Encapsulamento da Nota Fiscal de conhecimento de frete     |
¦          ¦ Tratamento para contabilização off-line                    |
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO                                                 ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
|            |        |                                                 |
+-----------------------------------------------------------------------+
*/

#INCLUDE "rwmake.ch"

User Function EPCEST02()

Private aSalvArea := GetArea()
Private lContAut  := .T.
Private cGrupGer := Space(230)
Private dDataDe
Private dDataAte
Private aColRat  := {}
Private aHeadRat := {}

MATA116()

dbSelectArea("SX1") 
dbSetOrder(1)
dbSeek("CTBNFE")
While ! Eof() .and. X1_GRUPO == "CTBNFE"
   Do Case
      Case X1_ORDEM $ "01"
           If RecLock("SX1",.F.)
              Replace X1_PRESEL WITH 2 
              MsUnlock()
           EndIf          
      Case X1_ORDEM $ "02_03"
           If RecLock("SX1",.F.)
              Replace X1_PRESEL With 1
              MsUnlock()
           EndIf
      Case X1_ORDEM $ "04_05"
           If RecLock("SX1",.F.)
              Replace X1_CNT01 WITH CHR(39)+DTOC(dDataBase)+CHR(39)
              MsUnlock()
           EndIf
      Case X1_ORDEM $ "06" 
           If RecLock("SX1",.F.)
              Replace X1_CNT01 WITH "  "
              MsUnlock()
           EndIf               
      Case X1_ORDEM $ "07" 
           If RecLock("SX1",.F.)
              Replace SX1->X1_CNT01 WITH "ZZ"
              MsUnlock()
           EndIf                       
   EndCase           
   DbSelectArea("SX1")
   DbSkip()
End   

RestArea(aSalvArea) 

If lContAut
   CTBANFE()
EndIf   

Return