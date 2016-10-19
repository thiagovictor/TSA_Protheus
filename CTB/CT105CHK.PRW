/*
+-----------------------------------------------------------------------+
¦Programa  ¦CT105CHK  ¦ Autor ¦Wladimir Fernandes     ¦ Data |19/04/2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦PE para validacao dos lancamentos contabeis                 ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA CLIENTES MICROSIGA                         ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
|            |        |                                                 |  
+-----------------------------------------------------------------------+
*/

User Function CT105CHK()

Local lRet    := .T.
Local cOrigem := "" 
Local cMens1:=""
Local cMens2:=""
Local aSavArq := {Alias(),IndexOrd(),Recno()}
Local aSavCTT := {"CTT",CTT->(IndexOrd()),CTT->(Recno())}
Local aSavCT1 := {"CT1",CT1->(IndexOrd()),CT1->(Recno())}


cOrigem := Upper(Alltrim(FunName()))

CursorWait()

If !(cOrigem $ "CONA050_CTBA101")
	dbSelectArea("TMP")
	dbGoTop()
	While !Eof()
		/*
		//Valida delecao de lancto gerado pelo sistema    
      If !Empty(TMP->CT2_ROTINA)
         If TMP->CT2_FLAG
            lRet:=.f.
            cMens1:="Não é possível excluir linhas geradas pelo sistema"
            CursorArrow()
         EndIf
      EndIf
      */
		If TMP->CT2_CREDIT==TMP->CT2_DEBITO
			cMens2:="Existem contas de debito e credito iguais é necessário conferir"
//			lRet:=.f.
			CursorArrow()
		Endif
      
     	dbSelectArea("TMP")
   	dbSkip()
	EndDo

EndIf

If !lRet
	MsgStop(cMens1+Chr(10)+Chr(13)+cMens2)
Endif
CursorArrow()

dbSelectArea(aSavCTT[01])
dbSetOrder(aSavCTT[02])
dbGoTo(aSavCTT[03])

dbSelectArea(aSavCT1[01])
dbSetOrder(aSavCT1[02])
dbGoTo(aSavCT1[03])

dbSelectArea(aSavArq[01])
dbSetOrder(aSavArq[02])
dbGoTo(aSavArq[03])

Return(lRet)