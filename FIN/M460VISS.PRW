/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M460VISS ³ Autor ³ Eduardo Carraro       ³ Data ³ 11/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada p/ Gravacao de ISS no SE2                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function M460VISS()

SetPrvt("AARQATU,AARQSA1,AARQSD2,CCLIENTE,CLOJA,CDOC")
SetPrvt("CSERIE,nValISS,")

aArqAtu:={Alias(),IndexOrd(),Recno()}
aArqSA1:={SA1->(IndexOrd()),SA1->(Recno())}
aArqSD2:={SD2->(IndexOrd()),SD2->(Recno())}
aArqSC9:={SC9->(IndexOrd()),SC9->(Recno())}

cClientex := SC5->C5_CLIENTE
cLojax    := SC5->C5_LOJACLI	      
cPedido   := SC5->C5_NUM
cMunicISS := SC5->C5_MUNICIS
nValISS   := 0

/*
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+cClientex+cLojax)
   DbSelectArea("SC9")
   DbSetOrder(1) //Filial + Documento + Serie + Cliente +Loja + Produto + Item
   DbSeek(xFilial("SC9")+cPedido)
   While xFilial("SC9") == C9_FILIAL .and. C9_PEDIDO == cPedido .and. C9_CLIENTE == cClientex .and. C9_LOJA == cLojax .and. ! Eof()
       If !Empty(SC9->C9_NFISCAL)
          dbSkip()
          Loop
       EndIf   
       DbSelectArea("SZ8")
       DbSetOrder(1) //Filial+Produto+Municipio
       If DbSeek(xFilial("SZ8")+SC9->C9_PRODUTO+cMunicISS)
          nValISS := nValISS + (SC9->C9_PRCVEN*(SZ8->Z8_ISS/100))
       EndIf
       DbSelectArea("SC9")
       DbSkip()
   End
EndIf
*/

If Empty(SC9->C9_NFISCAL)
   DbSelectArea("SZ8")
   DbSetOrder(1) //Filial+Produto+Municipio
   If DbSeek(xFilial("SZ8")+SC9->C9_PRODUTO+cMunicISS)
      //nValISS := nValISS + (SC9->C9_PRCVEN*(SZ8->Z8_ISS/100))
      nValISS := nValISS + ((SC9->C9_PRCVEN*SC9->C9_QTDLIB)*(SZ8->Z8_ISS/100))
   EndIf
EndIf

SA1->(DbSetOrder(aArqSA1[1]))
SA1->(DbGoTo(aArqSA1[2]))

SD2->(DbSetOrder(aArqSD2[1]))
SD2->(DbGoTo(aArqSD2[2]))

SC9->(DbSetOrder(aArqSC9[1]))
SC9->(DbGoTo(aArqSC9[2]))

DbSelectArea(aArqAtu[1])
DbSetOrder(aArqAtu[2])
DbGoTo(aArqAtu[3])

Return(nValISS) 