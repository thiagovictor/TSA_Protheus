#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function CADAORC()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("APOS,CCADASTRO,AROTINA,")
Private aCores    := {{"U_MosCoVrm()","BR_VERMELHO"},;
					  {"U_MosCoVer()","BR_VERDE"   }}

aPos:={08,11,11,70}                       // Posiciona o cCadastro
cCadastro:="Cadastro de Orcamento"
aRotina:={{"Pesquisar" ,"AxPesqui"                         ,0,1},;
          {"Visualizar",'ExecBlock("InputeOr",.F.,.F.,"V")',0,2},;    // AxVisualizar - padrao Siga
          {"Incluir"   ,'ExecBlock("InputeOr",.F.,.F.,"I")',0,3},;    // AxInclui     - padrao Siga
          {"Incluir Lote",'U_CriaLot()'                    ,0,3},;    // AxInclui     - padrao Siga
          {"Alterar"   ,'ExecBlock("InputeOr",.F.,.F.,"A")',0,4},;    // AxAltera     - padrao Siga
          {"Excluir"   ,'ExecBlock("InputeOr",.F.,.F.,"E")',0,5},;    // AxExclui     - padrao Siga
          {"Legenda"   ,'ExecBlock("FLegenda")'            ,0,3},;
          {"Aprovacao" ,'ExecBlock("PrcAprova",.F.,.F.)',0,2}}     // AxVisualizar - padrao Siga
          
//If cEmpAnt='02'
If cEmpAnt <> '01'
	Aadd(aRotina,{"Copiar C.Custo"    ,'ExecBlock("CopyOrc",.F.,.F.,"E")' ,0,4}) // Copia Ano/Mes
Endif          
          
dbSelectArea("SZB")
SZB->(dbSetOrder(1))
mBrowse(06,08,22,71,"SZB",,,,,,aCores) // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse

RETURN


User Function FLegenda
**********************************************************************
* Exibe janela com legenda do sistema
*
***

Private cCadLegen := "Legenda Aprovacao Orcamento"

Private aCores2 := { { 'BR_VERMELHO', "Orcamento Aprovado"                },;
							{ 'BR_VERDE'   , "Orcamento em Aberto"               }}

BrwLegenda(cCadLegen,"Legenda do Browse",aCores2)

Return   




User Function HabVlr()
***************************************************************************************************
*
**
Local lRet:=.F.
If GdFieldGet("ZB_TIPO")='E' .And. Posicione("SZD",1,Xfilial("SZD")+GdFieldGet("ZB_DESCRI"),"ZD_SALAFUN")<=0
	lRet:=.T.
Endif

Return(lRet)



User Function CriaLot()
***************************************************************************************************
*
**

ExecBlock("InputeOr",.F.,.F.,"L")
Return