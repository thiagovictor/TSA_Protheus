#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦MTA097MNU  ¦ Autor ¦ Gilson Lucas          ¦Data ¦19.09.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Adiciona impressao da ordem de compra na liberacao do PC    ¦
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
User Function MTA097MNU
*************************************************************************
*
**

aAdd(aRotina,{OemToAnsi("Ordem de Compra"),'U_ImpOrdCr()',  0 , 2, 0, nil})
//aAdd(aRotina,{"Conhecimento" ,"MsDocument", 0, 4, 0, Nil }) //
Return



User Function ImpOrdCr()
*************************************************************************
*
**
dbSelectArea("SC7")
SC7->(dbSetOrder(1))
SC7->(dbSeek(xFilial("SC7")+Alltrim(SCR->CR_NUM)))
If !SC7->(Eof())
   If MsgBox(OemToAnsi("Deseja imprimir ordem de compra?"),OemToAnsi("Atencao"),"YESNO",2)
      ExecBlock("PComGrf", .F., .F., { "SC7", SC7->(Recno()), 2 } )
   EndIf
EndIf

Return