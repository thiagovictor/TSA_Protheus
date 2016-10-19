/*
+----------+----------+-------+---------------------+-----+-----------------+
|Programa  |M020INC   |Autor  |Crislei de A. Toledo |Data |  15/02/06       |
+----------+----------+-------+---------------------+-----+-----------------+
|Desc.     |Ponto de Entrada na inclusão/alteração do fornecedor para gerar |
|          |item contabil automaticamente e atualizar o campo               |
|          |SA2->A2_ITEMCON                                                 |
+----------+----------------------------------------------------------------+
|            ALTERACOES REALIZADAS DESDE A CRIACAO                          |
+----------+-------------+--------------------------------------------------+
| DATA     | PROGRAMADOR | DESCRICAO                                        |
+----------+-------------+--------------------------------------------------+
|          |             |                                                  |
+----------+-------------+--------------------------------------------------+
*/

#include "rwmake.ch"

User Function M020INC()

dbSelectArea("CTD")
dbSetOrder(1)
dbseek(xFilial("CTD")+SA2->A2_COD+SA2->A2_LOJA)
 
If Eof()
   cItemcont:=SA2->A2_COD+SA2->A2_LOJA
   dbSelectArea("CTD")
   Reclock("CTD",.T.)
   Replace CTD_FILIAL With xFilial("CTD") , ;
           CTD_ITEM   With cItemcont      , ; 
           CTD_DESC01 With SA2->A2_NOME   , ;
           CTD_CLASSE With "2"            , ; 
           CTD_TIPOIT With "F"            , ;
           CTD_DTEXIS With CTOD("01/01/1980") , ;
           CTD_BLOQ   With '2'  , ;
           CTD_SITUAC With "0"                        
   MsUnlock("CTD")
EndIf
 
Return