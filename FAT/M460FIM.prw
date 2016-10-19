/*/
+-------------------------------+---------------------------------------------+
| Programa  | M460FIM   | Autor | Crislei de A. Toledo     | Data |27/02/06   |
|-------------------------------+---------------------------------------------|
| Descricao | Ponto de entrada no final da gravacao da NF de saida            |
|           | utilizado para gravacao do campo F3_NATOPER                     |
|-----------------------------------------------------------------------------|
| Uso       |                                                                 |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  |
+--------------+-----------+--------------------------------------------------+
/*/

#INCLUDE "RWMAKE.CH"

User Function M460FIM()

Local aSalAmb   := {Alias(),IndexOrd(),Recno()}
Local aSalSD2   := {"SD2",SD1->(IndexOrd()),SD1->(Recno())}
Local aSalSF2   := {"SF2",SF1->(IndexOrd()),SF1->(Recno())}
Local aSalSF3   := {"SF3",SF3->(IndexOrd()),SF3->(Recno())}

dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF2")+DTOS(SF2->F2_EMISSAO)+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

While !Eof() .And. ; 
		SF3->F3_ENTRADA = SF2->F2_EMISSAO .And. ;
		SF3->F3_NFISCAl = SF2->F2_DOC     .And. ;
		SF3->F3_SERIE   = SF2->F2_SERIE   .And. ;
		SF3->F3_CLIEFOR = SF2->F2_CLIENTE .And. ;
		SF3->F3_LOJA    = SF2->F2_LOJA    		

   If Reclock("SF3",.F.)
      Replace F3_NATOPER With SD2->D2_NATOPER
      Replace F3_CFOEXT  With SD2->D2_NATOPER
//      Replace F3_TOTPROD With SF1->F1_VALBRUT      
      MsUnLock()
   EndIf
	
	dbSelectarea("SF3")
	dbSkip()
   
EndDo

dbSelectArea(aSalSD2[1])
dbSetOrder(aSalSD2[2])
dbGoto(aSalSD2[3])

dbSelectArea(aSalSF3[1])
dbSetOrder(aSalSF3[2])
dbGoto(aSalSF3[3])

dbSelectArea(aSalSF2[1])
dbSetOrder(aSalSF2[2])
dbGoto(aSalSF2[3])

dbSelectArea(aSalAmb[1])
dbSetOrder(aSalAmb[2])
dbGoto(aSalAmb[3])

Return
