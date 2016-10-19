/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LPDTNFS  ³ Autor ³ Eduardo Carraro       ³ Data ³ 24.01.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RDMAKE para Gravacao das Datas de Caixa e Referencia       ³±±
±±³          ³ no lancamento padrao no caso de notas fiscais de saida.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO PARA EPC                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ EXEMPLO  ³ EXECBLOCK("LPDTNFS",.F.,.F.,{Nota,Serie,"ORIGEM"})         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR ³ DATA    ³ MOTIVO DA ALTERACAO                            ª±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ CRISLEI    ³30-03-06 ³ TRATAMENTO PARA BUSCAR O PEDIDO ATRAVES DO     ³±±
±±³            ³         ³ PARAMIXB, QUE JA PASSA O NUMERO DO PEDIDO      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Parametros
1 - Nota
2 - Serie
3 - Origem
4 - Pedido 
*/


#include "rwmake.ch"        


User Function LPDTNFS()

SetPrvt("AARQSC5,AARQSE1,CNUMNOTA,CSERIENF,CHISTOR,CDATARF")
SetPrvt("CDATACX,CHISTORICO,")


aArqAtu := { Alias(), IndexOrd(), Recno()}
aArqSC5 := { SC5->(IndexOrd()),SC5->(Recno()) }
aArqSC6 := { SC6->(IndexOrd()),SC6->(Recno()) } 
aArqSE2 := { SE2->(IndexOrd()),SE2->(Recno()) }
aArqSE1 := { SE1->(IndexOrd()),SE1->(Recno()) }
cNumNota:= PARAMIXB[1]
cSerieNF:= PARAMIXB[2]
cHistor := PARAMIXB[3]
cPedido := PARAMIXB[4]

DbSelectArea("SC5")
DbSetOrder(1) //Pedido
DbSeek(xFilial("SC5")+cPedido)

cDataRF:=substr(DTOC(SC5->C5_DATAREF),1,6)+substr(DTOC(SC5->C5_DATAREF),7,2)

If !(SubStr(cHistor,3,3) $ "630/635")
   If !(SD2->D2_TIPO $ "D/B")
      DbSelectArea("SE1")
      DbSetOrder(2) //CLIENTE+LOJA+PREFIXO+NUMERO+PARCELA+TIPO
      DbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)

      cDataCX:=substr(DTOC(SE1->E1_VENCREA),1,6)+substr(DTOC(SE1->E1_VENCREA),7,2)
   Else
      dbSelectArea("SE2")
      dbSetOrder(6)
      dbSeek(xFilial("SE2")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)
   
      cDataCX:=substr(DTOC(SE2->E2_VENCREA),1,6)+substr(DTOC(SE2->E2_VENCREA),7,2)
   EndIf
Else
   DbSelectArea("SE1")
   cDataCX:=substr(DTOC(SE1->E1_VENCREA),1,6)+substr(DTOC(SE1->E1_VENCREA),7,2)
EndIf   

cHistorico:= "CX:" + cDataCX + " RF:" + cDataRF + " - " + cHistor


//Restaurando o ambiente
DbSelectArea("SE1")
DbSetOrder(aArqSE1[1])
DbGoTo(aArqSE1[2]) 

DbSelectArea("SE2")
DbSetOrder(aArqSE2[1])
DbGoTo(aArqSE2[2]) 

DbSelectArea("SC5")
DbSetOrder(aArqSC5[1])
DbGoTo(aArqSC5[2])

DbSelectArea("SC6")
DbSetOrder(aArqSC6[1])
DbGoTo(aArqSC6[2])

DbSelectArea(aArqAtu[01])
DbSetOrder(aArqAtu[02])
DbGoTo(aArqAtu[03])


Return(cHistorico)

