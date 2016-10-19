/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |CADHRTO   |Autor | Crislei Toledo							| Data  | 07/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Cadastro de total de horas por setor											|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/


#include "rwmake.ch"

User Function CadHrTo()

Private aPos      := {}
Private cCadastro := ""
Private aRotina   := {}

aPos:={08,11,11,70}                       // Posiciona o cCadastro
cCadastro:="Cadastro de Total de Horas por Setor"
aRotina:={{"Pesquisar" ,"AxPesqui"                         ,0,1},;
          {"Visualizar",'ExecBlock("InpHrTot",.F.,.F.,"V")',0,2}}    // AxVisualizar - padrao Siga

dbSelectArea("SZL")
dbSetOrder(1)
mBrowse(06,08,22,71,"SZL") // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse

RETURN
