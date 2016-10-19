/*
+-----------------------------------------------------------------------+
¦Programa  ¦ INCITMCGC¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦15.03.2007¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Inclusao de CNPJ de clientes como Item Contabil            ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO                                                 ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
+-----------------------------------------------------------------------+
*/

#include "rwmake.ch"

User Function IncItmCGC()


cCabecalho := OemToAnsi("Atualização do Item Contabil - CNPJ - Clientes")
cMsgRegua  := "Processando..."
Processa( {|| InputItm()} ,cCabecalho,cMsgRegua )

Return
   

 Static Function InputItm()
 *****************************************************************************************************
 * Inclusao de CNPJ de clientes como Item contabil   
 *
 ****

dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()

While !Eof()
     
   //Inclusao do Item Contabil para CNPJ de Cliente -- CRISLEI TOLEDO 15/03/07
   dbSelectArea("CTD") // Item Contabil
   dbSetOrder(1)
   dbSeek(xFilial("CTD")+SA1->A1_CGC)
   If Eof()
      RecLock("CTD",.T.)
      Replace CTD_FILIAL With xFilial("CTD") , ;
              CTD_ITEM   With SA1->A1_CGC    , ; 
              CTD_DESC01 With SA1->A1_NOME   , ;
              CTD_CLASSE With "2"            , ; 
              CTD_TIPOIT With "C"            , ;
              CTD_DTEXIS With CTOD("01/01/1980") , ;
              CTD_BLOQ   With "2"                , ;
              CTD_SITUAC With "0"                , ;
              CTD_CLASSI With "N" 
              
      MsUnlock()
   EndIf

   dbSelectArea("SA1")
   dbSkip()
End

Return
