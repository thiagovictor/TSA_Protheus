/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VALIDREV  |Autor |Crislei Toledo  						| Data  |08/05/02 |	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Validacao da Revisao do orcamento - Funcionario                      |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|             |        	  |                                                      |
+-------------+-----------+------------------------------------------------------+
*/
#include "rwmake.ch"

User Function ValidRev(cAcao)


SetPrvt("LRET,CREVISAO,AARQVAL,")

lRet := .T.

If Len(Alltrim(cRevisao)) < 3
   cRevisao := Replicate("0",3-Len(Alltrim(cRevisao))) + Alltrim(cRevisao)
EndIf

If INCLUI
	If ! Empty(cRevisao)
	   aArqVal := { Alias() , IndexOrd() , Recno() }
	   dbSelectArea("SZB")
	   dbSetOrder(4)
	   dbSeek(xFilial("SZB")+cCodFun+cAno+cRevisao)
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

Return(lRet)
