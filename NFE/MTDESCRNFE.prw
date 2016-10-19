#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Gilson Lucas          ¦Data ¦04.09.2009¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Ajustes NFES nota fiscal eletronica de servico  	   		¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function MTDESCRNFE
*************************************************************************
* Muda a descricao do servico no RPS
***
Return(SC5->C5_REFER)



User Function MTOBSNFE
*************************************************************************
* Muda a Obsevacao  do servico no RPS
***

Return(Alltrim(SC5->(C5_MENNOT3+SC5->C5_MENNOT4+SC5->C5_MENNOT5+SC5->C5_MENNOT6+SC5->C5_MENNOT7)))



User Function isvitobs
*************************************************************************
* Muda a descricao do na geracao do arquivo TXT
***
Local aAreaOld := GetArea()
Local aAreaSD2 := SD2->(GetArea())
Local cRet     := Alltrim(SC5->(C5_MENNOT3+SC5->C5_MENNOT4+SC5->C5_MENNOT5+SC5->C5_MENNOT6+SC5->C5_MENNOT7))

dbSelectarea("SD2")
SD2->(dbSetOrder(3))
SD2->(dbSeek(xFilial("SD2")+SF3_ISISS->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))  
If !SD2->(Eof())
   dbSelectArea("SC5")
   SC5->(dbSetOrder(1))
   SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
   If !SC5->(Eof())
      If RecLock("T03",.f.)
         Replace DESC With SC5->C5_REFER
         T03->(MsUnLock())
      EndIf
   EndIf
EndIf
RestArea(aAreaOld)
RestArea(aAreaSD2)
Return(cRet)