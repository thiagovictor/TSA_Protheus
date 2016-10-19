#include "rwmake.ch"

User function TesteCris()

Local cTeste := ""

MsgBox(DTOC(POSICIONE("AF9",1,xFilial("AF9")+AF8->AF8_PROJET+AF8->AF8_REV_BL+M->AF9_TAREFA,"AF9_START")))

Return(M->AF9_START)