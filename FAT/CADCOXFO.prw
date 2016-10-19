#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function CADCOXFO()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("APOS,CCADASTRO,AROTINA,")

aPos:={08,11,11,70}                       // Posiciona o cCadastro
cCadastro:="Cadastro de Contrato X Fornecedor"
aRotina:={{"Pesquisar" ,"AxPesqui"                         ,0,1},;
          {"Visualizar",'ExecBlock("InpCoXFo",.F.,.F.,"V")',0,2},;    // AxVisualizar - padrao Siga
          {"Incluir"   ,'ExecBlock("InpCoXFo",.F.,.F.,"I")',0,3},;    // AxInclui     - padrao Siga
          {"Alterar"   ,'ExecBlock("InpCoXFo",.F.,.F.,"A")',0,4},;    // AxAltera     - padrao Siga
          {"Excluir"   ,'ExecBlock("InpCoXFo",.F.,.F.,"E")',0,5}}     // AxExclui     - padrao Siga
dbSelectArea("SZC")
dbSetOrder(1)
mBrowse(06,08,22,71,"SZC") // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse

RETURN
