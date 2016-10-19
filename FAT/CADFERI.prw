/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |CADFERI   |Autor | Crislei Toledo							| Data  | 03/05/02|	
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

User Function CADFERI()

Private aPos      := {}
Private cCadastro := ""
Private aRotina   := {}

aPos:={08,11,11,70}                       // Posiciona o cCadastro
cCadastro:="Cadastro de Orcamento"
aRotina:={{"Pesquisar" ,"AxPesqui"                         ,0,1},;
          {"Visualizar",'ExecBlock("InputFer",.F.,.F.,"V")',0,2},;    // AxVisualizar - padrao Siga
          {"Incluir"   ,'ExecBlock("InputFer",.F.,.F.,"I")',0,3},;    // AxInclui     - padrao Siga
          {"Alterar"   ,'ExecBlock("InputFer",.F.,.F.,"A")',0,4},;    // AxAltera     - padrao Siga
          {"Excluir"   ,'ExecBlock("InputFer",.F.,.F.,"E")',0,5}}     // AxExclui     - padrao Siga
dbSelectArea("SZK")
dbSetOrder(1)
mBrowse(06,08,22,71,"SZK") // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse

RETURN
