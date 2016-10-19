/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  |FA070CAN   | Autor    | Daniel A. Moreira       |Data  |20.02.2006 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Ponto de Entrada no cancelamento da baixa de um Título a Receber  |
+----------+-------------------------------------------------------------------+
| USO      | Especifico TSA                                                    |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+
*/  

User Function FA070CAN

Local aAreaOLD := GetArea()
Local aAreaSZ3 := {}
Local aAreaSC5 := {}
Local aAreaSD2 := {}
Local aAreaSF2 := {}

If SM0->M0_CODIGO == "02" //TSA

	dbSelectArea("SC5")
	aAreaSC5:=GetArea()
	
	dbSelectArea("SZ3")
	aAreaSZ3:=GetArea()
	
	dbSelectArea("SF2")
	aAreaSF2:=GetArea()
	dbSetOrder(1)
	dbSeek(xFilial("SF2")+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA)	
	
	dbSelectArea("SD2")
	aAreaSD2:=GetArea()
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA)
	
	While !Eof() .AND. SD2->D2_FILIAL == xFilial("SD2") ;
	 				 .AND. SD2->D2_DOC    == SE1->E1_NUM    ;
					 .AND. SD2->D2_SERIE  == SE1->E1_PREFIXO;
					 .AND. SD2->D2_CLIENTE== SE1->E1_CLIENTE;
					 .AND. SD2->D2_LOJA   == SE1->E1_LOJA
	
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
				
		dbSelectArea("SZ3")
		dbSetOrder(2) //Z3_FILIAL+Z3_COD+Z3_EVENTO
		If dbSeek(xFilial("SZ3")+SC5->C5_CONTRAT+SD2->D2_EVENTO)
			If Reclock("SZ3",.F.)
				Replace 	Z3_DTFATUR With CTOD("  /  /  ")
				Replace 	Z3_VLFATUR With SZ3->Z3_VLFATUR-(SD2->D2_TOTAL/SF2->F2_VALBRUT*SE5->E5_VALOR)
		 		MsUnlock()
			EndIf
		EndIf
	
		dbSelectArea("SD2")
		dbSkip()
	EndDo

	RestArea(aAreaSF2)	
	RestArea(aAreaSD2)
	RestArea(aAreaSC5)
	RestArea(aAreaSZ3)
	
EndIf

RestArea(aAreaOLD)

Return Nil