
/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |CadDiUt   |Autor | Crislei Toledo							| Data  | 06/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Cadastro de dias uteis                                               |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#Include "rwmake.ch"

User Function CadDiUt()

aPos := {08,11,11,70} //Posiciona o cadastro
cCadastro := "Cadastro de Dias Uteis"
aRotina := {{"Pesquisar" ,"AxPesqui"             ,0,1},;
				{"Visualizar",'U_InputUt("V")'        ,0,2},;
				{"Incluir"   ,'U_InputUt("I")'        ,0,3},;
				{"Alterar"   ,'U_InputUt("A")'        ,0,4},;
				{"Excluir"   ,'U_InputUt("E")'        ,0,5}}
				
dbSelectArea("SZK")
dbSetOrder(1)

mBrowse(06,08,22,71,"SZK")

Return                               