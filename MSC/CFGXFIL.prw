#Include 'Rwmake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦ CFGXFIL   ¦ Autor ¦ Desconhecido          ¦Data ¦ N/A      ¦
+----------+------------------------------------------------------------¦
¦Descricao ¦ Encapsulamento de Parametros no Configurador (CFGX017)     |
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA TSA                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function CFGXFIL()

Local  aIndexSX6  := {}
Local  cQuery     := ""
Local  cFilt      := ""
Local  cPerg      := "FILPAR"
Local  bFiltraBrw := {|| Nil}

PutSx1(cPerg,"01",OemToAnsi("Palavra Chave ?"),OemToAnsi("Palavra Chave ?"),OemToAnsi("Palavra Chave ?"),"mv_ch1","C",20,0,1,"C","","","","","mv_par01","","","","","","","","","","","","","","","","",{}, {}, {} )

If Pergunte(cPerg,.T.)
   If ! Empty(MV_PAR01)
      cFilt := "'"+ Upper(Alltrim(MV_PAR01)) + "' $ Upper(X6_VAR+X6_CONTEUD+X6_DESCRIC+X6_DESC1+X6_DESC2)"
     
      bFiltraBrw := {|x| IIf(x==Nil,FilBrowse("SX6",@aIndexSX6,@cFilt),cQuery)}
      Eval(bFiltraBrw)

      dbSelectArea("SX6")
      CFGX017()
      
      dbSelectArea("SX6")
      //RetIndex("SX6")
      dbClearFilter()
   Else
      CFGX017()
   EndIf
EndIf

//Select SX6
//Set Filter to

Return