#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | MSD2460 | Claudio Silva            |  Data  |                  |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Ponto de Entrada - Apos atualizar SD2                          |
|            |                                                                |
+------------+----------------------------------------------------------------+
| Uso        | Especifico                                                     |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
+---------+-------------+-----------------------------------------------------+
|27/01/06 |Claudio Silva| Gravacao D2_EVENTO a partir de C6_EVENTO            |
|         |             | Atualizacao SZ3.                                    |
+---------+-------------+-----------------------------------------------------+
|27/02/06 |Crislei      | Gravacao D2_NATOPER (Natureza da operacao)          |
+---------+-------------+-----------------------------------------------------+
*/

User Function MSD2460()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ,CPEDIDO,CITEM,CPRODUTO,")

aArq:={Alias(),IndexOrd(),Recno()}
cPedido :=SD2->D2_PEDIDO
cItem   :=SD2->D2_ITEMPV
cProduto:=SD2->D2_COD
DbSelectArea("SC6")
DbSetOrder(1)
If DbSeek(xFilial("SC6")+cPedido+cItem+cProduto)
   DbSelectArea("SD2")
   If RecLock("SD2",.F.)
      Replace SD2->D2_SUBC    With SC6->C6_SUBC
      Replace SD2->D2_NATOPER With SC6->C6_NATOPER //CRISLEI TOLEDO - 27/02/06
	  // Alterações Leandro P J Monteiro em 18/10/13
	  Replace SD2->D2_XCO     With SC6->C6_XCO     
	  Replace SD2->D2_XOPER   With SC6->C6_XOPER   
	  Replace SD2->D2_CC      With SC6->C6_SUBC      
	  Replace SD2->D2_XPCO    With SC6->C6_XPCO    
	  // -----	  
	//If SM0->M0_CODIGO == "02" //TSA - Alterado dia 24/06/2015
      	Replace SD2->D2_EVENTO With SC6->C6_EVENTO
	//	EndIf
      MsUnlock()
   EndIF
EndIf

//Atualiza campos da tabela Contrato X Evento
//If SM0->M0_CODIGO == "02" //TSA - Alterado dia 24/06/2015
  	U_fAtuaSZ3("I")
//EndIf

DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])

return
