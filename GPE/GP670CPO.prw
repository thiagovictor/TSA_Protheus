/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  | GP670CPO  | Autor    | Daniel A. Moreira       |Data  |04.10.2005 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | PE apos gravar Titulo (Integracao Financeiro)                     |
+----------+-------------------------------------------------------------------+
| USO      |  Especifico POLIKINI                                              |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+
*/ 

User Function GP670CPO

Local aAreaOLD := GetArea()
Local cNomeFun := ""

If !Empty(RC1->RC1_MAT)
	cNomeFun := Posicione("SRA",1,xFilial("SRA")+RC1->RC1_MAT,"RA_NOME")
	
	Reclock("SE2",.F.)
	Replace E2_HIST With cNomeFun
	MsUnlock()
EndIf

RestArea(aAreaOLD)

Return