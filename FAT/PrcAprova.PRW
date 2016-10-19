/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |PRCAPROVA |Autor | Crislei Toledo				   | Data  | 10/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Aprovacao de orcamento                                               |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao   				 |
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao											 |
+-------------+-----------+------------------------------------------------------+
|Leo Alves	  |02/01/06   |Criação de um objeto Button pra sair da Dialog        |
|             |           |alteração no processamento da rotina                  |
+-------------+-----------+------------------------------------------------------+
*/

#include "Rwmake.ch"

User Function PrcAprova()

Private cRevisao := Space(TamSx3("ZB_REVISAO")[1])

FMontTela()   	

Return


Static Function FMontTela()
***********************************************
* 
* 
****

   @ 000,000 To 140,220 Dialog oDlg Title "Aprovacao de Revisao" 
   @ 005,005 To 045,110
   @ 020,035 Say "Informe a Revisao : "
   @ 030,040 GET cRevisao VALID VldCopy() PICTURE "@!" SIZE 20,30   
   @ 055,035 BmpButton Type 01 Action OkPrc()
   @ 055,065 BmpButton Type 02 Action Close(oDlg)/*Criado em 02/01/2006 Leonardo Alves*/
   Activate Dialog oDlg Center                
   
Return

Static Function VldCopy()
****************************************************************************************************************
*
*
*****
Local lRet:=.t.
dbSelectArea("SZB")
dbSetOrder(5)
If !SZB->(dbSeek(Xfilial("SZB")+cRevisao))
	MsgBox("Revisão Não encontrada !!","Validação")
	lRet:=.f.
Endif	
Return(lRet)




Static Function OkPrc()
***********************************************
* 
* 
****
If !Empty(cRevisao)
	/*Alteração do processamento */
	dbSelectArea("SZB")
	dbSetOrder(5)
	dbSeek(xFilial("SZB")+cRevisao)

	While !Eof() 						.And. ;
	   xFilial("SZB") == SZB->ZB_Filial .And. ;
	   cRevisao == SZB->ZB_Revisao
   
	   If SZB->ZB_Aprova == "S"
   			MsgBox("Esta revisao ja foi aprovada!","Aprovacao de Revisao","INFO")
   			Return
  	 	EndIf
   
		If Reclock("SZB",.F.)
			Replace ZB_Aprova With "S"
			MsUnlock()
		EndIf
	
		dbSelectArea("SZB")
		dbSkip()
	EndDo
	Close(oDlg)
Else
	MsgBox("E necessario informara Revisao!","Inconsistencia","STOP")
EndIf
Return
