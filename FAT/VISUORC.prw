/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VISUORC   |Autor | Crislei Toledo							| Data  | 02/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|									Especifico para EPC												|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/


#include "rwmake.ch"

User Function VISUORC()

Private aPos      := {}
Private cCadastro := ""
Private aRotina   := {}

aPos:={08,11,11,70}                       // Posiciona o cCadastro
cCadastro:="Cadastro de Orcamento"
aRotina:={{"Pesquisar" ,"AxPesqui"                         ,0,1},;
          {"Visualizar",'ExecBlock("VisualOr",.F.,.F.,"V")',0,2}}    // AxVisualizar - padrao Siga

dbSelectArea("SZI")
dbSetOrder(1)
mBrowse(06,08,22,71,"SZI") // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse

RETURN
