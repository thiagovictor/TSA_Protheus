#INCLUDE "RWMAKE.CH"

User Function GQREENTR()
/*/
+-----------------------------------------------------------------------------+
| Programa  | GQREENTR  | Desenvolvedor | Wilson Barbosa   | Data |08/10/04   |
|-----------------------------------------------------------------------------|
| Descricao | Ponto de entrada para gravacao de campos no SF3 - DESBH         |
|-----------------------------------------------------------------------------|
| Uso       |                                                                 |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
| Marcos Flavio| 14/10/04  |Alteracao para tratamento de todos os registros   |
|		                     |que sao gravados no SF3, gravar o valor total da  |
|						         |nota.                                             |
+--------------+-----------+--------------------------------------------------+
/*/

Local aSalAmb   := Iif(AllTrim(Alias())<>"",{Alias(),IndexOrd(),Recno()},{"SC7",SC7->(IndexOrd()),SC7->(Recno())})
Local aSalSD1   := {"SD1",SD1->(IndexOrd()),SD1->(Recno())}
Local aSalSF1   := {"SF1",SF1->(IndexOrd()),SF1->(Recno())}
Local aSalSF3   := {"SF3",SF3->(IndexOrd()),SF3->(Recno())}

/*
//Tratamento para o Alias() pois quando informado pedido de compras para a NF, este vem em branco, 
//gerando erro ao retornoar o ambiente                                                           
If AllTrim(Alias()) == ""
   aSalAmb := {"SC7",SC7->(IndexOrd()),SC7->(Recno())}
Else
   aSalAmb := {Alias(),IndexOrd(),Recno()}
EndIf
*/

dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF1")+DTOS(SF1->F1_DTDIGIT)+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

While !Eof() .And. ; 
		SF3->F3_ENTRADA = SF1->F1_DTDIGIT .And. ;
		SF3->F3_NFISCAl = SF1->F1_DOC     .And. ;
		SF3->F3_SERIE   = SF1->F1_SERIE   .And. ;
		SF3->F3_CLIEFOR = SF1->F1_FORNECE .And. ;
		SF3->F3_LOJA    = SF1->F1_LOJA    		

   If Reclock("SF3",.F.)
      Replace F3_NATOPER With SD1->D1_NATOPER
      Replace F3_CFOEXT  With SD1->D1_NATOPER      
//      Replace F3_TOTPROD With SF1->F1_VALBRUT      
      MsUnLock()
   EndIf
	
	dbSelectarea("SF3")
	dbSkip()
   
EndDo

dbSelectArea(aSalSD1[1])
dbSetOrder(aSalSD1[2])
dbGoto(aSalSD1[3])

dbSelectArea(aSalSF3[1])
dbSetOrder(aSalSF3[2])
dbGoto(aSalSF3[3])

dbSelectArea(aSalSF1[1])
dbSetOrder(aSalSF1[2])
dbGoto(aSalSF1[3])

dbSelectArea(aSalAmb[1])
dbSetOrder(aSalAmb[2])
dbGoto(aSalAmb[3])

Return
