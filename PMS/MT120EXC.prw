#Include "Rwmake.ch"
/*
+-----------------------------------------------------------------------------+
| Programa  | MT120EXC | Desenvolvedor | Gilson Lucas Jr  | Data | 24/09/2004 |
|-----------------------------------------------------------------------------|
| Descricao | Ponto de entrada que ira atualizar o dados do SZO quando exister|
|-----------------------------------------------------------------------------|
|um AE para o contrato (para exclusao de AE)								  |
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC Engenharia                                       |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  |
+--------------+-----------+--------------------------------------------------+
*/

User Function MT120EXC
/******************************************************************************
* PE que faz a atualização dos dados do SZO (na exclusao da AE)
*
*************************************/


Local aAreaOLD  := GetArea()
Local nXi       := 0
Local cnumPesq  := ""
Local cItemPesq := ""

If FunName() <> "MATA122"
	Return
EndIf


For nXi := 1 To Len(aCols)
	If GDDELETED(nXi)
		Loop
	EndIF
	cNumPesq   := GDFieldGet("C7_NUMSC",nXi)
	cItemPesq  := GDFieldGet("C7_ITEMSC",nXi)
	SZO->(dbSetOrder(1))
	SZO->(dbSeek(xFilial("SZO")+cnumPesq+cItemPesq+"E"))
	If !SZO->(EOF())
		If RecLock("SZO",.F.)
			Replace  ZO_QUJE     With  (GDFieldGet("C7_QUANT",nXi)	- SZO->ZO_QUJE)
			Replace  ZO_ENCER    With  SZO->ZO_STAUXI
			Replace  ZO_STATUS   With  SZO->ZO_STAUXI
			MsUnLock()
		EndIf
		Return
	EndIf
	SZO->(dbSetOrder(1))
	SZO->(dbSeek(xFilial("SZO")+cNumPesq+cItemPesq+"T"))
	If !SZO->(EOF())
		If RecLock("SZO",.F.)
			Replace  SZO->ZO_QUJE     With (GDFieldGet("C7_QUANT",nXi)	- SZO->ZO_QUJE)
			Replace  SZO->ZO_ENCER    With  SZO->ZO_STAUXI
			Replace  SZO->ZO_STATUS   With  SZO->ZO_STAUXI
			MsUnLock()
		EndIf
		Return
	EndIf
	SZO->(dbSetOrder(1))
	SZO->(dbSeek(xFilial("SZO")+cNumPesq+cItemPesq+"C"))
	If !SZO->(EOF())
		If RecLock("SZO",.F.)
			Replace  SZO->ZO_QUJE     With (GDFieldGet("C7_QUANT",nXi)	- SZO->ZO_QUJE)
			Replace  SZO->ZO_ENCER    With  SZO->ZO_STAUXI
			Replace  SZO->ZO_STATUS   With  SZO->ZO_STAUXI
			MsUnLock()
		EndIf
		Return
	EndIf
Next nXi

RestArea(aAreaOLD)


Return
