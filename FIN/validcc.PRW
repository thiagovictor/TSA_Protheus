#include "rwmake.ch"        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Validcc  ³ Autor ³Joao Carlos            ³ Data ³ 31/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao + Valida a Necessidade Centro de Custo Conforme Natuzeza      ++
++           +                                                            -++
++           +                                                             ++
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       + E1_VALOR, E2_VALOR, E5_VALOR                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function Validcc
*****************************************************************************
*
********************

Local lReturn := .T.
Local cCCusto := IIF(Alltrim(FunName()) = "FINA040", "M->E1_SUBC",    IIF(Alltrim(FunName()) = "FINA050", "M->E2_CC"     , "M->E5_CCC" ) ) // Campo de Centro de Custo
Local cNatPre := IIF(Alltrim(FunName()) = "FINA040", "M->E1_NATUREZ", IIF(Alltrim(FunName()) = "FINA050", "M->E2_NATUREZ", "M->E5_NATUREZ" ) ) // Campo de Centro de Custo Preenchido
Local cOBRCC  := Posicione("SED",1, xFilial("SED") + &cNatPre, "ED_OBRCC")
//'10901_10902_10903_10904_11003_11004_11102_11106_11107_11111_11112_11201_11202_11203_11204_11205_11207
//_11208_11209_11210_11215_11401_11403_11404_11405_11406_11407_11701_11702_11703_11704_11705_11909_11910_
//11911_11937_11938_12001_12004_12101_12102_12103_12201_12202_12203'  // Campo de Centro de Custo Para Validar

If Empty(&cNatPre)
	lReturn := .F.
	Alert("Natureza nao Preenchida!!! Favor Preencher")
EndIf

If Alltrim(FunName()) $ "FINA040_FINA050_FINA100"  .And. lReturn
	If Empty(&cCCusto) .And. cOBRCC == "S"
		lReturn:= .F.
		Alert("Centro de Custo Nao Preenchido e Obrigatorio. Favor Preencher!!!")
	EndIf
EndIf
return(lReturn)