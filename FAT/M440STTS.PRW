#include "Rwmake.ch"
/*
+-----------+-----------+---------------+--------------+------+-------------+
| Programa  | M440STTS  | Desenvolvedor | Davis        | Data | 16/06/2003  |
+-----------+-----------+---------------+--------------+------+-------------+
| Descricao | Ponto de Entrada para colocar campo no SC9- Item Lm           |
+-----------+---------------------------------------------------------------+
| Uso       | Especifico EPC                                                |
+-----------+---------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                  |
+--------------+-----------+------------------------------------------------+
| Responsavel  | Data      | Motivo                                         |
+--------------+-----------+------------------------------------------------+
+--------------+-----------+------------------------------------------------+
*/

User Function M440STTS()


Local aArea   := GetArea()
Local cItemLM := Space(04)
Local cNumPdv := SC5->C5_NUM


dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+cNumPdv+"01")

While ! SC6->(Eof()) .And. ;
      SC6->C6_FILIAL == xFilial("SC6") .And. ;
      SC6->C6_NUM    == cNumPDV
      
      dbSelectArea("SC6")
      cItemLM := SC6->C6_ITEMLM
      
      dbSelectArea("SC9")
      dbSetOrder(2)
      If dbSeek(xFilial("SC9")+SC6->(C6_CLI+C6_LOJA+C6_NUM+C6_ITEM))
         If RecLock("SC9",.F.)
            Replace C9_ITEMLM With cItemLm
            MsUnlock()
         EndIf
      EndIf           

      dbSelectArea("SC6")
      dbSkip()
End
      
RestArea(aArea)

Return
