#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function TIPOF3()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIINP,")

******************************************************************************
* Este Rdmake tem como funcao diponibilizar o tipo de F3 de acordo com
* o campo cadastrado no contrato (Fornecedor/Cliente/Empregado).
****

cAliInp := Alias()
cAliF3  := ""

dbSelectArea("SZA")
dbSetOrder(1)
dbSeek(xFilial("SZA")+M->ZB_GRUPGER)

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek(aHeader[nPosDesc,2])

Do Case
   Case SZA->ZA_FOCLFU == "F"
        If !Eof()
            RecLoCk("SX3",.F.)
*???            Replace X3_F3  With "SZC"
            Replace X3_F3  With "ORF"            
            MsUnLock()
            cAliF3 := "ORF"
        EndIf
   Case SZA->ZA_FOCLFU == "C"
        If !Eof()
            RecLoCk("SX3",.F.)
            Replace X3_F3  With "ORC"
            MsUnLock()
            cAliF3 := "ORC"
        EndIf
   Case SZA->ZA_FOCLFU == "E"
        If !Eof()
           RecLoCk("SX3",.F.)
*???           Replace X3_F3  With "SZD"
           Replace X3_F3  With "ORE"
           MsUnLock()
           cAliF3 := "ORE"
        EndIf
   Case SZA->ZA_FOCLFU == "D"
        If !Eof()
           RecLoCk("SX3",.F.)
           Replace X3_F3  With "ORD"
           MsUnLock()
           cAliF3 := "ORD"
        EndIf

   Case SZA->ZA_FOCLFU == "A"
        If !Eof()
           RecLoCk("SX3",.F.)
           Replace X3_F3  With "SN1PRV" //"SN1"
           MsUnLock()
           cAliF3 := "SN1PRV" //"SN1"
        EndIf

EndCase

dbSelectArea("SX3")
dbSetOrder(1)

dbSelectArea(cAliInp)

/*
//CRISLEI TOLEDO 17/04/06 - POSICIONA TABELA DE ACORDO COM O F3 SELECIONADO ACIMA.
dbSelectArea("SXB")
dbSetOrder(1)
dbSeek(cAliF3+"   1")
If !Eof()
   cConteudo := AllTrim(SXB->XB_CONTEM)
   //Posicione(cConteudo,1,xFilial(cConteudo),"")
   aHeader[nPosDesc,9] := cConteudo
   //dbSelectArea(cConteudo)
   //dbSetOrder(1)

   RecLock("SX7",.F.)
   Replace X7_SEEK  With "S"
   Replace X7_ALIAS With cConteudo
   Replace X7_ORDEM With 1
   Replace X7_CHAVE With xFilial(cCounteudo)
   MsUnlock()
EndIf
*/

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return(M->ZB_GRUPGER)
Return(M->ZB_GRUPGER)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

