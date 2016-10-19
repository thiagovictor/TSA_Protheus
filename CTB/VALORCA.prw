#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VALORCA   |Autor |                 			   		| Data  |         |	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Valida o Campo de Custo do Orcamento			               			|
+--------------------------------------------------------------------------------+
|									Especifico para EPC												|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
|CLSILVA      |31/10/05	  |Alteracao SI3 para CTT           							|
+-------------+-----------+------------------------------------------------------+
*/

User Function VALORCA()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LRET,CALIVAL,CCONTRAT,")

lRet := .T.

If !Empty(cCCusto)
   cAliVal := Alias()
   dbSelectArea("CTT")
   dbSetOrder(1) //CTT_FILIAL+CTT_CUSTO
   dbSeek(xFilial("CTT")+Alltrim(cCCusto))
   If Eof()
      MsgStop("Numero do Centro de Custo deve estar cadastrado")
      lRet := .F.
   EndIf

   dbSelectArea("SZ2")
   dbSetOrder(3)
   dbSeek(xFilial("SZ2")+Alltrim(cCCusto))
   cContrat := SZ2->Z2_COD
   dbSelectArea(cAliVal)
Else
   MsgStop("Numero do Centro de Custo deve ser informado")
   lRet := .F.
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return(lRet)
Return(lRet)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
