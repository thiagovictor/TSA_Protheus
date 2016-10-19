#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function VALREVI(cAcao)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LRET,CREVISAO,AARQVAL,")

******************************************************************************
* Valida o Campo de Custo do Orcamento.
****

lRet := .T.

// Alterado por Crislei Toledo - 29/01/02
If INCLUI
	If ! Empty(cRevisao)
	   aArqVal := { Alias() , IndexOrd() , Recno() }
	   dbSelectArea("SZB")
	   dbSetOrder(1)
	   dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao)
	   If ! Eof()	     
	      MsgBox("Este orcamento ja existe. Selecione a opcao 'Alterar'","Validacao","INFORMATION")
	      lRet := .F.
	   EndIf
	   dbSelectArea(aArqVal[1])
	   dbSetOrder(aArqVal[2])
	   dbGoTo(aArqVal[3])
	EndIf
EndIf

If Empty(cRevisao)
   MsgStop("Numero da Revisao deve ser informada")
   lRet := .F.
EndIf                                       



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return(lRet)
Return(lRet)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
