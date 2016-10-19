/*
+-------------+---------+-------------+-------------------+-------+----------------------+
| Programa    | VALIDCC | Programador | Eduardo Carraro   | Data  | 21/08/01             |
+-------------+---------+-------------+-------------------+-------+----------------------+
| Descricao   | Validacao de Centro de Custos                                            |
+-------------+--------------------------------------------------------------------------+
| Uso         | U_VALIDCC("Campo que esta sendo utilizado para validacao")                                                              |
+-------------+--------------------------------------------------------------------------+
|                          Modificacoes efetuadas no Programa                            |
+---------+-------------+----------------------------------------------------------------+
| Data    | Responsavel | Motivo                                                         |
+---------+-------------+----------------------------------------------------------------+
|         |             |                                                                |
+---------+-------------+----------------------------------------------------------------+
*/
#Include "RWMAKE.CH"

User Function ValidCC(cVar)

Local aAnt:={Alias(),IndexOrd(),Recno()}
Local aAntCTT:={CTT->(IndexOrd()),CTT->(Recno())}
Local lRet:=.t.
Local cConta:= &("M->" + cVar)

DbSelectArea("CTT")
DbSetOrder(1)
If DbSeek(xFilial("CTT")+cConta) .and. CTT->CTT_SITUAC $ "1_2_3"
   MsgBox("Atencao, Este Contrato encontra-se Encerrado ou Inativo e Nao Pode Ser Utilizado!","Erro...","STOP")
   lRet:=.f.
EndIf

//Restaura Ambiente Inicial
DbSelectArea("CTT")
DbSetOrder(aAntCTT[1])
DbGoTo(aAntCTT[2])

DbSelectArea(aAnt[1])
DbSetOrder(aAnt[2])
DbGoTo(aAnt[3])

Return(lRet)