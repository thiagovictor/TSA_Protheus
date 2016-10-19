/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP620ISS ¦ Autor ¦ Crislei de A. Toledo  ¦ Data ¦06.06.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Posiciona SC5 para verificar se o cliente recolhe ou nao   ¦
¦          ¦ o ISS. Caso Negativo, retorna o valor do ISS               ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA CBM                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+------------+--------+-------------------------------------------------+
*/
#INCLUDE "Rwmake.ch"

User Function LP620ISS()

Local nRet    := 0 
Local aArqAnt := {Alias(), IndexOrd(), Recno()}
Local aArqSF2 := {"SF2", SF2->(IndexOrd()), SF2->(Recno())}
Local aArqSD2 := {"SD2", SD2->(IndexOrd()), SD2->(Recno())}
Local aArqSA1 := {"SA1", SA1->(IndexOrd()), SA1->(Recno())}


dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

If !Eof()
   dbSelectArea("SC5")
   dbSetOrder(1)
   dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
   If !Eof()
      If SC5->C5_RECISS $ "N/2"
         nRet := SF2->F2_VALISS
      EndIf
   EndIf
EndIf


dbSelectArea(aArqSA1[01])
dbSetOrder(aArqSA1[02])
dbGoTo(aArqSA1[03])

dbSelectArea(aArqSD2[01])
dbSetOrder(aArqSD2[02])
dbGoTo(aArqSD2[03])

dbSelectArea(aArqSF2[01])
dbSetOrder(aArqSF2[02])
dbGoTo(aArqSF2[03])

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(nRet)