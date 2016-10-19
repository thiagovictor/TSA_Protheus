#Include 'Rwmake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Ricardo Diniz         ¦Data ¦24.09.2008¦
+----------+------------------------------------------------------------¦
¦Descricao ¦                                                            ¦
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
User Function FILPAR()
************************************************************************
*
*****
Local  aIndexSX6  := {}
Local  cQuery     := ""
Local  cFilt      := ""
Local  cPerg      := "FILPAR"
Local  bFiltraBrw := {|| Nil}


PutSx1(cPerg,"01","Palavra Chave ?","Palavra Chave ?","Palavra Chave ?","mv_ch1","C",20,0,1,"C","","","","","mv_par01","","","","","","","","","","","","","","","","",{ ,}, {}, {} )


If Pergunte(cPerg,.T.)
   If !Empty(MV_PAR01)
      cFilt   := "'"+ Alltrim(MV_PAR01) + "' $ Upper(X6_VAR+X6_CONTEUD+X6_DESCRIC+X6_DESC1+X6_DESC2)"

      bFiltraBrw      := {|x| IIf(x==Nil,FilBrowse("SX6",@aIndexSX6,@cFilt),cQuery)}
      Eval(bFiltraBrw)

      dbSelectArea("SX6")
      CFGX017()
      
      dbSelectArea("SC6")
      RetIndex("SC6")
      dbClearFilter()
   Else
      CFGX017()
   EndIf
EndIf

Select SX6
Set Filter to

Return