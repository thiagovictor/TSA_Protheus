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
| Leandro      | 18/10/13  | Implantação PCO - Levar campos da SD2 para SE1   |
+--------------+-----------+--------------------------------------------------+
/*/

#INCLUDE "RWMAKE.CH"

User Function M460FIM()

Local aSalAmb   := {Alias(),IndexOrd(),Recno()}
Local _aAREASF2 := SF2->( GETAREA() )
Local _aAREASD2 := SD2->( GETAREA() ) 
Local aSalSD2   := {"SD2",SD1->(IndexOrd()),SD1->(Recno())}
Local aSalSF2   := {"SF2",SF1->(IndexOrd()),SF1->(Recno())}
Local aSalSF3   := {"SF3",SF3->(IndexOrd()),SF3->(Recno())}

/**************************************************************
** Autor : Leandro P J Monteiro 
** Data : 18/10/2013
** Finalidade : Preencher Campos customizados no contas a pagar
****************************************************************/
DbSelectArea("SE1")
SE1->( dbSetOrder(2) ) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
SE1->(dbGoTop())

If SE1->( dbSeek( xFilial("SF2")+SF2->(F2_CLIENTE + F2_LOJA + F2_SERIE + F2_DOC ) ) )

	While SE1->( !Eof() .AND. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC) )
		RecLock("SE1", .F.)

		// pegando os valores da última linha na SD2 posicionada
		SE1->E1_XCO  	:= 	SD2->D2_XCO
		SE1->E1_XOPER 	:= 	SD2->D2_XOPER   
		SE1->E1_SUBC	:= 	SD2->D2_CC      
		SE1->E1_XPCO	:=	SD2->D2_XPCO    

		SE1->( msUnlock() )
		SE1->(DbSkip())
	Enddo

Endif

RESTAREA( _aAREASF2 )
RESTAREA( _aAREASD2 )

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

/*
dbSelectArea(aSalAmb[1])
dbSetOrder(aSalAmb[2])
dbGoto(aSalAmb[3])
*/
Return
