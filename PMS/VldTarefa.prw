#Include "Rwmake.ch"
#Include "TopConn.ch"
/*
+-----------------------------------------------------------------------------+
| Programa  |IniPadSFC | Desenvolvedor |                     | Data |         |
|-----------------------------------------------------------------------------|
| Descricao |  Valida a Exclusão de uma Tarefa                                |
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

User Function VldTarefa(cProj,cTarefa)
****************************************************************************************************************
* Verifica quantos documentos estão amarrados a esta tabela para permitir a exclusão
*
*******
Local lRet   := .T.
Local cQuery := ""

cQuery := " SELECT COUNT(*) NDOCS FROM GEDPMS "
cQuery += " WHERE GED_PROJET='"+cProj+"' AND GED_TAREFA='"+cTarefa+"'"

TcQuery cQuery Alias QVLD New

dbSelectArea("QVLD")
If (QVLD->NDOCS > 0)
	Alert("	Atenção ! "+Chr(13)+"	Existem documentos vinculados a este projeto/Tarefa no sistema "+Chr(13)+;
    		" Meridian que Impede a Exclusão desta Tarefa, é necessário que este vinculo "+Chr(13)+;
			" seja desfeito através do sistema Meridian para possibilitar a Exclusão.")
		 lRet:=.f.
Endif

dbSelectArea("QVLD")
dbCloseArea()

Return(lRet)