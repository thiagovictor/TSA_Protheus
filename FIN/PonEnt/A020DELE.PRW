/*
+----------+----------+-------+---------------------+-----+-----------------+
|Programa  |M020INC   |Autor  |Crislei de A. Toledo |Data |  15/02/06       |
+----------+----------+-------+---------------------+-----+-----------------+
|Desc.     |Ponto de Entrada na exclusão do fornecedor para excluir item    |
|          |contabil automaticamente na exclusao do fornecedor              |
+----------+----------------------------------------------------------------+
|            ALTERACOES REALIZADAS DESDE A CRIACAO                          |
+----------+-------------+--------------------------------------------------+
| DATA     | PROGRAMADOR | DESCRICAO                                        |
+----------+-------------+--------------------------------------------------+
|          |             |                                                  |
+----------+-------------+--------------------------------------------------+
*/



#include "rwmake.ch"

User Function A020DELE()

Local aAliasAnt := {Alias(),IndexOrd(),RecNo()}
Local aAliasCTD := {"CTD",CTD->(IndexOrd()),CTD->(Recno())}

dbSelectArea("CTD")
dbSetOrder(1)
If dbseek(xFilial("CTD")+SA2->A2_COD+SA2->A2_LOJA)
    DbSelectArea("CTD")
    RecLock("CTD",.F.)
    dbDelete()
Else
    MsgBox("O item contabil, "+ SA2->A2_COD+SA2->A2_LOJA +" ,usado para este fornecedor não foi deletado. Verifique!", "Mensagem", "INFO")
    Return(.T.)
EndIf

dbSelectArea(aAliasCTD[1])
dbSetOrder(aAliasCTD[2])
dbGoTo(aAliasCTD[3])

dbSelectArea(aAliasAnt[1])
dbSetOrder(aAliasAnt[2])
dbGoTo(aAliasAnt[3])

Return(.T.)
