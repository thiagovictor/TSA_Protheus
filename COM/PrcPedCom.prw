/*
+-----------------------------------------------------------------------+
¦Programa  ¦ PrcPedCom ¦ Autor ¦Crislei Toledo        ¦ Data ¦20.08.2007¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Rotina para preparar tabela para listar os pedidos de      ¦
¦          ¦ compras em aberto para analise financeira                  ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 |
+------------+--------+-------------------------------------------------+
*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function PrcPedCom()

Local cQuery := ""
Local cPerg  := "PRCPED"
Local aPerg  := {}

//                titulo               tipo  tam. dec. GET/Choice Valid
AADD(aPerg,{cPerg,"Da Emissao         ?","D",08,0,"G","","","","","","",""}) 
AADD(aPerg,{cPerg,"Ate Emissao        ?","D",08,0,"G","","","","","","",""}) 
AADD(aPerg,{cPerg,"Numero de Dias     ?","N",03,0,"G","","","","","","",""}) 



If !Pergunte(cPerg,.T.)
   Return()
EndIf

//Nao posso listar apenas Pedidos de compra em Aberto, pois embora ja tenha sido emitido, pode estar vencendo
//dentro do periodo analisado.
cQuery := "SELECT  * FROM " + RetSqlName("SC7") + " SC7 " 
cQuery += "INNER JOIN " + RetSqlName("SE4") + " SE4 ON E4_CODIGO = C7_COND AND SE4.D_E_L_E_T_ <> '*' "
cQuery += "WHERE SC7.D_E_L_E_T_ <> '*' "

TcQuery cQuery Alias "QSC7" New

dbSelectArea("QSC7")
dbGoTop()
While !Eof()

   dbSelectArea("QSC7")
   dbSkip()
End


Return