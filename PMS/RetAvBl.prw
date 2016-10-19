
#include "rwmake.ch"
#include "topconn.ch"

User function RetAvBl()

Local nRet   := 0
Local cQuery := ""

cQuery := "SELECT MAX(AFF_DATA) AS AFF_DATA "
cQuery += "FROM " + RetSqlName("AFF")
cQuery += " WHERE AFF_PROJET = '" + AF8->AF8_PROJET + "' AND "
cQuery += "       AFF_REVISA = '" + AF8->AF8_REV_BL + "' AND "
cQuery += "       AFF_TAREFA = '" + M->AF9_TAREFA   + "' AND "
cQuery += "       D_E_L_E_T_ <> '*'"

TcQuery cQuery Alias "QAFF" New

dbSelectArea("QAFF")
dbGoTop()

If !Eof()
   dbSelectArea("AFF")
   dbSetOrder(1)
   dbSeek(xFilial("AFF")+AF8->AF8_PROJET+AF8->AF8_REV_BL+M->AF9_TAREFA+QAFF->AFF_DATA)
   
   If !Eof()
      nRet := AFF->AFF_QUANT * 100
   EndIf
EndIf

dbSelectArea("QAFF")
dbCloseArea()

Return(nRet)