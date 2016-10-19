#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
/*
+-----------------------------------------------------------------------------+
| Programa  |CodTarCli | Desenvolvedor |                     | Data |         |
|-----------------------------------------------------------------------------|
| Descricao |  Gera o Código Inteligente da Tarefa                            |
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC                                                  |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  | 
+--------------+-----------+--------------------------------------------------+
*/

User Function CodTarCli()
********************************************************************************************************************
*Gera o Código específico da EPC para tarefa automaticamente
*
****   

Local cReturn:=""
Local cQuery:=""
Local aArea:=GetArea()

cQuery:=" SELECT COUNT(*) SEQU FROM "+RetSqlName("AF9")
cQuery+=" WHERE AF9_PROJET='"+AF8->AF8_PROJET+"' AND "
cQuery+=" Left(AF9_TARCLI,15)='"+AFC->(Left(AFC_PROJET,7)+AFC_ARNEG+AFC_TIPPRJ+AFC_DISC+AFC_SUBDIS+AFC_ESCOPO)+"' AND "
cQuery+=" AF9_REVISA='"+AF8->AF8_REVISA+"' AND "
cQuery+=" D_E_L_E_T_<>'*' "

TcQuery cQuery Alias QTMP New 

dbSelectArea("QTMP")
cReturn:=AFC->(Left(AFC_PROJET,7)+AFC_ARNEG+AFC_TIPPRJ+AFC_DISC+AFC_SUBDIS+AFC_ESCOPO)+StrZero(QTMP->SEQU+1,4)


// Fecha a Tabela e restaura o ambiente
dbSelectArea("QTMP")
dbCloseArea()
RestArea(aArea)

Return(cReturn)