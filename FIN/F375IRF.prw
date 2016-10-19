/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  F375IRF ³ Autor ³ Crislei Toledo        ³ Data ³ 10/08/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada p/ gravar o codigo de Retencao no titulo  ³±±
±±³          ³ de IR gerado a partir da Rotina de Apuracao de IR          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³          ³             ª                                              ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"
#include "topconn.ch"

User Function F375IRF()

Local cRet     := "1708"
Local cQuery   := ""
Local cParcela := ""


cQuery := "SELECT MAX(E2_PARCELA) AS PARCELA FROM " + RetSqlName("SE2")
cQuery += " WHERE E2_TIPO = 'TX' AND "
cQuery += " E2_NUM = '" + SE2->E2_NUM + "' AND "
cQuery += " E2_PREFIXO = '" + SE2->E2_PREFIXO + "' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TcQuery cQuery ALIAS "QSE2" NEW

dbSelectArea("QSE2")
dbGoTop()

If !Eof()
   cParcela := Soma1(QSE2->PARCELA)
   dbSelectArea("SE2")
   Replace E2_PARCELA With cParcela
Else
   cParcela := "001"
EndIf

dbSelectArea("QSE2")
dbCloseArea()

Return(cRet)