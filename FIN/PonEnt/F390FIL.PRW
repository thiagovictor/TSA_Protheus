/*
+-----------------------------------------------------------------------+
¦Programa  ¦ F390FIL   ¦ Autor ¦ Crislei de A. Toledo ¦ Data ¦31.03.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Inclusao de Filtro de Bordero no Ch S/ Titulos             |
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO                                                 ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
+-----------------------------------------------------------------------+
*/

#include "rwmake.ch"

User Function F390FIL()

Local cFilter:=""
Local oDlgFilter
Local cNumBor:=Space(06)
Local aAnt:={Alias(),IndexOrd(),Recno()}
Local aSEA:={SEA->(IndexOrd()),SEA->(Recno())}

Return(cFilter)

@ 000,000 To 100,150 Dialog oDlgFilter Title "Selecao de Bordero"
@ 005,005 To 030,073 Title "Informe Bordero"
@ 015,010 Get cNumBor Valid Empty(cNumBor) .or. TestBor(cNumBor) Size 40,07
@ 035,035 BMPBUTTON Type 01 Action Close(oDlgFilter)
ACTIVATE DIALOG oDlgFilter Centered

If ! Empty(Alltrim(cNumbor))   
   cFilter:='SE2->E2_NUMBOR == "' + cNumBor + '"'
EndIf

//Retorna Ambiente
DbSelectArea("SEA")
DbSetOrder(aSEA[1])
DbGoTo(aSEA[2])

DbSelectarea(aAnt[1])
DbSetOrder(aAnt[2])
DbGoTo(aAnt[3])

Return(cFilter)


Static Function TestBor(cNumBor)
************************************************************************************
* Testa Existencia de Bordero
***

LOCAL lRetorna := .T. 

cNumBor := IIF(Len(cNumBor) < 6, PADR(cNumBor,6),cNumBor)

DbSelectArea("SEA")
dbSetOrder(1)
If dbSeek( xFilial("SEA")+cNumBor,.t.)
   lRetorna:=.t.
Else
   lRetorna:=.f.
   MsgBox("Atencao, Numero de Bordero Inexistente no Sistema, Verifique!!!","::Erro!!!::","STOP")
EndIf

Return(lRetorna)