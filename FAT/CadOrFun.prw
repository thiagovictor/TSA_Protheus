/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |CADORFUN  |Autor | Crislei Toledo				   | Data  | 08/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Cadastro de Orcamentos por funcionario								 |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao       			 |
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao											 |
+-------------+-----------+------------------------------------------------------+
|			  |           |		     											 |
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function CadOrFun()

SetPrvt("APOS,CCADASTRO,AROTINA,")

Private aCores    := {{"U_MosCoVrm()","BR_VERMELHO"},;
							 {"U_MosCoVer()","BR_VERDE"   }}

Private aCampos := {{"Funcionario","ZB_DESCRI"},;							 
						  {"Nome","ZB_DESC2"}}
                      
aPos:={08,11,11,70}                       // Posiciona o cCadastro
cCadastro:="Cadastro de Orcamento"
aRotina:={{"Pesquisar" ,"AxPesqui"                         ,0,1},;
          {"Visualizar",'ExecBlock("InpOrFun",.F.,.F.,"V")',0,2},;    // AxVisualizar - padrao Siga
          {"Incluir"   ,'ExecBlock("InpOrFun",.F.,.F.,"I")',0,3},;    // AxInclui     - padrao Siga
          {"Alterar"   ,'ExecBlock("InpOrFun",.F.,.F.,"A")',0,4},;    // AxAltera     - padrao Siga
          {"Excluir"   ,'ExecBlock("InpOrFun",.F.,.F.,"E")',0,5},;    // AxExclui     - padrao Siga
          {"Legenda"   ,'ExecBlock("FLegenda")'            ,0,3},;
          {"Aprovacao" ,'ExecBlock("PrcAprova",.F.,.F.)',0,2}}     // AxVisualizar - padrao Siga
dbSelectArea("SZB")
dbSetOrder(1)
Set Filter To (SZB->ZB_GrupGer == "000007")

mBrowse(06,08,22,71,"SZB",aCampos,,,,,aCores) // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse


dbSelectArea("SZB")
Set Filter To 
RETURN
