#INCLUDE "Rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA130C8  º Autor ³ Rodrigo Alves  º Data ³  28/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esse programa grava os dados do SIGAPCO da Solicitacao paraº±±
±±º          ³ a cotacao                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Mta130C8() 

Private aAreaTrb := GetArea()
Private aSalvArq := {Alias(),IndexOrd(),Recno()} 
private  ctes :=" "
dBSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SC8->C8_PRODUTO)
ctes:= SB1->B1_TE

dbSelectArea("SC8")
RecLock("SC8",.F.)
Replace SC8->C8_XCO     With  SC1->C1_XCO
Replace SC8->C8_XCLASSE With  SC1->C1_XCLASSE     
Replace SC8->C8_XOPER   With  SC1->C1_XOPER
REPLACE SC8->C8_XORCAME WITH  SC1->C1_XORCAME
REPLACE SC8->C8_XPCO     WITH  SC1->C1_XPCO 
REPLACE SC8->C8_XPCO1     WITH  SC1->C1_XPCO1


  


MsUnlock()

dbSelectArea(aSalvArq[1])
dbSetOrder(aSalvArq[2])
dbGoto(aSalvArq[3])

RestArea(aAreaTrb)

Return