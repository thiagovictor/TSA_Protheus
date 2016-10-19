#include "Rwmake.ch"
/*
+-----------+-----------+---------------+--------------+------+-------------+
| Programa  | MTA450T   | Desenvolvedor | Davis        | Data | 16/06/2003  |
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

User Function MTA450T()


Local aArea   := GetArea()
Local cItemLM := SC6->C6_ITEMLM

dbSelectArea("SC6")


dbSelectArea("SC9")

Replace SC9->C9_ITEMLM With cItemLm


RestArea(aArea)

Return
