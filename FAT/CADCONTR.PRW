#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function CADCONTR()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("APOS,CCADASTRO,AROTINA,")

aPos:={08,11,11,70}                       // Posiciona o cCadastro
cCadastro:="Cadastro de Contratos"
aRotina:={{"Pesquisar" ,"AxPesqui"                         ,0,1},;
          {"Visualizar",'ExecBlock("InputCTR",.F.,.F.,"V")',0,2},;    // AxVisualizar - padrao Siga
          {"Incluir"   ,'ExecBlock("InputCTR",.F.,.F.,"I")',0,3},;    // AxInclui - padrao Siga
          {"Alterar"   ,'ExecBlock("InputCTR",.F.,.F.,"A")',0,4},;    // AxAltera - padrao Siga
          {"Excluir"   ,'ExecBlock("InputCTR",.F.,.F.,"E")',0,5},;    // AxExclui - padrao Siga
          {"Aditivo"   ,'ExecBlock("InputCTR",.F.,.F.,"D")',0,6}}

dbSelectArea("SZ1") //Cabecalho do Contrato
dbSetOrder(1)       //Filial+Codigo

mBrowse(06,08,22,71,"SZ1") // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse
RETURN
