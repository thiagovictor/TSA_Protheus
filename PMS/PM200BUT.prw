#include "rwmake.ch"

User function PM200BUT()

AADD(aButton,{"PRODUTO",{|| FTipoDoc()},"Tipos de Doctos."})

Return(aButton)


Static Function FTipoDoc()

MsgBox("Teste de Tipo de Documento!!","Tipo Documento","INFO")

Return