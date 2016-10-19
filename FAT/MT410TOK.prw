#Include 'Rwmake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦ MT410TOK  ¦ Autor ¦ Gilson Lucas          ¦Data ¦06.11.2014¦
+----------+------------------------------------------------------------¦
¦Descricao ¦                                               		   		¦
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
User Function MT410TOK()
************************************************************************
**
**
Local nXi  := 0
Local lRet := .T.
For nXi := 1 To Len(aCols)
   If !GdDeleted(nXi)
      If Len(Alltrim(GdFieldGet("C6_MSCOMPL",nXi))) > 500
         MSGBOX("Linha "+Alltrim(Str(Nxi))+" esta com mais de 500 dias.","..: ATENCAO :..","STOP")
         lRet := .F.
      EndIf   
   EndIf   
Next nXi
Return(lRet)