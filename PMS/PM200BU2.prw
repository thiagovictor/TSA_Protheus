#include "rwmake.ch"

User function PM200BU2()

AADD(aButton,{"PRODUTO",{|| FTipoDoc()},"Tipos de Doctos."})

Return(aButton)


Static Function FTipoDoc()

MsgBox("Teste de Tipo de Documento!!","Tipo Documento","INFO")

Return