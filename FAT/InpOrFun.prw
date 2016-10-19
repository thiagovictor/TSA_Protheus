/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |INPORFUN  |Autor |Crislei Toledo  						| Data  |08/05/02 |	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Cadastro de Orcamento                                                |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|             |        	  |                                                      |
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function InpOrFun()

SetPrvt("AARQINP,LREINDEX,NOPCX,CCCUSTO,CANO,CREVISAO")
SetPrvt("LEDIT,NSEQ,CCONTRAT,CTIPODES,NUSADO,AHEADER")
SetPrvt("NPOSDESC,ACOLS,NXI,CTITULO,AC,AR")
SetPrvt("ACGD,CLINHAOK,CTUDOOK,LRETMOD2,NPOSITE,NXJ")
SetPrvt("NPOSOR,")
Private nRendFunc := 0

aArqInp  := { Alias() , IndexOrd() , Recno() }
lReindex := .F.

DO CASE
   CASE (PARAMIXB $"I/A")
        nOpcx:=3   // 3 = PODE EDITAR O DADO
   CASE (PARAMIXB $"V/E/C")
        nOpcx:=2   // 2 = PODE VISUALIZUR O DADO
ENDCASE

If PARAMIXB == "I"
   cCodFun  := Space(10)
   cNomeFun := Space(30)
   cAno     := Space(04)
   cRevisao := Space(03)
   cReviCop := Space(03) //Revisao Copia
   cContrat := ""
	cTipoDes := ""
Else
   cCodFun  := SZB->ZB_DESCRI
   cNomeFun := SZB->ZB_DESC2 
   cAno     := SZB->ZB_ANO
   cRevisao := SZB->ZB_REVISAO
//   FConsContr()

EndIf

IF PARAMIXB == "A"
   lEdit := .F.
Else
   lEdit := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZB")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZB")

   IF X3USO(x3_usado)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_DESCRI"   .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_ANO"      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_REVISAO"  .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_DESC2"
      nUsado := nUsado + 1
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho, ;
           x3_decimal, ,  x3_usado, x3_tipo, x3_arquivo, x3_context, x3_F3 } )

    Endif
    dbSkip()
End

nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZB_CCUSTO"})

If PARAMIXB == "I"
   If !MsgBox("Deseja Copiar alguma revisao anterior?","Copia Revisao","YESNO")
	   FMontaAcols()
	Else
		FTela()
		dbSelectArea("SZB")
   	dbSetOrder(4)
	   dbSeek(xFilial("SZB")+cCodFun+cAno+cReviCop)
      
	   If Eof()
	   	MsgBox("Os dados informados nao existem no cadastro!","Inlcusao Orcamento","INFO")
	   	FMontaAcols()
		Else
			aCols := {}

		   While (! eof())                            .And. ;
	   	      (xFilial("SZB")  == SZB->ZB_Filial)  .And. ;
	      	   (SZB->ZB_DESCRI  == cCodFun  )       .And. ;
	         	(SZB->ZB_ANO     == cAno     )       .And. ;
	         	(SZB->ZB_REVISAO == cReviCop)
	    	   /*
	    	   //So serao carregados para o acols orcamentos de funcionarios do grupo gerencial 000007
	    	   If SZB->ZB_GRUPGER <> "000007"
	    	   	dbSelectArea("SZB")
	    	   	dbSkip()
	    	   	Loop
	    	   EndIf
	    	   */
		      Aadd(aCols,Array(Len(aHeader)+1))
	   	   For nxI := 1 to Len(aHeader)
	      	   aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
		      Next
	   	   aCols[Len(aCols),Len(aHeader)+1] := .F.
	
	      	dbSelectArea("SZB")
	      	dbSkip()
		   EndDo
		EndIf
	EndIf
Else
   dbSelectArea("SZB")
   dbSetOrder(4)
   dbSeek(xFilial("SZB")+cCodFun+cAno+cRevisao)
   
   //CRISLEI TOLEDO - 08/05/02 - TRATAMENTO DOS ORCAMENTOS APROVADOS          
   If PARAMIXB == "A"
		If SZB->ZB_APROVA == "S"
		 	 MsgBox("Esta Revisao nao pode ser alterada, pois ja foi aprovada","Alterar Orcamento","STOP")
	 		 Return
		EndIf
	EndIf	
	
   aCols := {}

   While (! eof())                            .And. ;
         (xFilial("SZB")  == SZB->ZB_Filial)  .And. ;
         (SZB->ZB_DESCRI  == cCodFun  )       .And. ;
         (SZB->ZB_ANO     == cAno     )       .And. ;
         (SZB->ZB_REVISAO == cRevisao )
   	/*
   	//So serao carregados para o acols orcamentos de funcionarios do grupo gerencial 000007
	   If SZB->ZB_GRUPGER <> "000007"
	     	dbSelectArea("SZB")
	     	dbSkip()
	     	Loop
	   EndIf
	   */ 	   
      Aadd(aCols,Array(Len(aHeader)+1))
      For nxI := 1 to Len(aHeader)
         aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.

      dbSelectArea("SZB")
      dbSkip()
   EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Cadastro de Orcamento"

aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"cCodFun",  {15,10} ,"Funcionario" ,"@!","ExecBlock('ValFunc',.F.,.F.)","SZD",lEdit})
AADD(aC,{"cNomeFun", {15,122},"Nome","@!",".T.",,.F.})
AADD(aC,{"cAno",     {30,10},"Ano Orcamento","9999","ExecBlock('ValAno',.F.,.F.)",,lEdit})
AADD(aC,{"cRevisao", {30,122},"Revisao      ","999","ExecBlock('ValidRev',.F.,.F.)",,})

aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//aCGD:={29,5,118,315}
aCGD:={45,5,122,315}

cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

If lRetMod2 .And. nOpcx <> 2
   Processa()
ElseIf lRetMod2 .And. PARAMIXB == "E"
   FDelete()
ElseIf lRetMod2 .And. PARAMIXB == "C"
	FAprova()
Endif

//If lReindex
   dbSelectArea(aArqInp[1])
   dbSetOrder(aArqInp[2])
//   dbReIndex(aArqInp[1])
   dbGoTo(aArqInp[3])
//EndIf

Return


Static Function Processa()
******************************************************************************
*
*
****

nSeq := 0
nPosIte := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_ITEMORC"})
nPosCC  := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_CCUSTO"})

dbSelectArea("SZB")
dbSetOrder(2)//FILIAL+C.CUSTO+ANO+REVISAO+FUNCIONARIO

//If INLCUI
	For nxI := 1 To Len(aCols)
		If ! aCols[nxI,Len(aHeader)+1]
// 	   	dbSeek(xFilial("SZB")+aCols[nxI,nPosCC]+cAno+cRevisao+aCols[nxI,nPosIte])
 	   	dbSeek(xFilial("SZB")+aCols[nxI,nPosCC]+cAno+cRevisao+cCodFun)
 	   	If !Eof()
	 	   		nSeq := Val(SZB->ZB_ItemOrc)
			Else
				dbSelectArea("SZB")
				dbSetOrder(1)
		 	  	dbSeek(xFilial("SZB")+aCols[nxI,nPosCC]+cAno+cRevisao)
 	   		While !Eof() .And. ;
		 				ZB_CCusto  == aCols[nxI,nPosCC] .And. ;
						ZB_Ano		== cAno					.And. ;
			 		 	ZB_Revisao == cRevisao
		 	 	
				 	 	nSeq := Val(SZB->ZB_ItemOrc)
		 	 	
				 		dbSelectArea("SZB")
				 		dbSkip()
					End
				 	nSeq += 1
	 	   EndIf
 	   	//Localiza registro novamente para gravacao das alteracoes.
 	   	dbSelectArea("SZB")
			dbSetOrder(2)//FILIAL+C.CUSTO+ANO+REVISAO+FUNCIONARIO
		   dbSeek(xFilial("SZB")+aCols[nxI,nPosCC]+cAno+cRevisao+cCodFun)		 	
 		   If RecLock("SZB",Eof())
		  		For nxJ := 1 To Len(aHeader)
         	  nPosOr := FieldPos(aHeader[nxJ,2])
           	  FieldPut(nPosOr,aCols[nxI,nxJ])
	      	Next

        	   If FieldGet(FieldPos("ZB_REVISAO")) <> cRevisao
         		lReindex := .T.
		      EndIf

	   	   Replace ZB_FILIAL  With xFilial()
	      	Replace ZB_DESCRI  With cCodFun
	      	Replace ZB_DESC2   With cNomeFun
	         Replace ZB_ANO     With cAno
	         Replace ZB_REVISAO With cRevisao
	         Replace ZB_ITEMORC With StrZero(nSeq,2)
				//       nSeq := nSeq + 1
	         MsUnlock()
	         FGravMes("A")
	      EndIf
		Else
         If ! Eof()
          	RecLock("SZB",.F.)
	          dbDelete()
	          MsUnlock()
	          FGravMes("E")
	      EndIf
	   EndIf
	Next
//EndIf

Return


Static Function FDelete()
*****************************************************************************
* Deleta registros dos arquivos SZB
*
********

dbSelectArea("SZB")
dbSetOrder(4)
dbSeek(xFilial("SZB")+cCodFun+cAno+cRevisao)

While (! Eof()) 			   .And. ;
      (xFilial("SZB")  == SZB->ZB_Filial)  .And. ;
      (SZB->ZB_DESCRI  == cCodFun  )	   .And. ;
      (SZB->ZB_ANO     == cAno	   )	   .And. ;
      (SZB->ZB_REVISAO == cRevisao )
   RecLock("SZB",.F.)
   dbDelete()
   MsUnLock()
   FGravMes("E")
   dbSkip()
EndDo

MsUnLock()

Return
                         

Static Function FConsContr()
*****************************************************************************
* Consulta o numero do contrato
*
********

aArqAnt := {Alias(),IndexOrd(),Recno()}

dbSelectArea("SZ2")
dbSetOrder(3)
dbSeek(xFilial("SZ2")+cCodFun)

If !Eof()
	cContrat := SZ2->Z2_COD
EndIf

dbSelectArea(aArqAnt[1])
dbSetOrder(aArqAnt[2])
dbGoto(aArqAnt[3])

Return


Static Function FGravMes(cAcao)
*****************************************************************************
* Grava registros no arquivo de meses do Orcamento (SZI)
*
********

Local aArqSZB := { "SZB", IndexOrd(), Recno()}

Local cSZBMes   := ""
Local nQtdeHora := 0
Local nTotaHora := 0
Local cValrMes  := ""

//Apaga registros antigos
dbSelectArea("SZI")
dbSetOrder(3)
dbSeek(xFilial("SZI")+SZB->ZB_DESCRI+SZB->ZB_ANO+SZB->ZB_REVISAO+SZB->ZB_CCUSTO+SZB->ZB_ITEMORC)

While (! Eof()) 			   .And. ;
      (xFilial("SZI")  == SZI->ZI_Filial)  .And. ;
      (SZI->ZI_DESCRI  == SZB->ZB_DESCRI)  .And. ;
      (SZI->ZI_ANO     == SZB->ZB_ANO)     .And. ;
      (SZI->ZI_REVISAO == SZB->ZB_REVISAO) .And. ;
      (SZI->ZI_CCUSTO  == SZB->ZB_CCUSTO)  .And. ;
      (SZI->ZI_ITEMORC == SZB->ZB_ITEMORC)
   If RecLock("SZI",.F.)
   	dbDelete()
   	MsUnLock()
   	dbSkip()
   EndIf
EndDo

//Grava novos registros
If cAcao <> "E"
	//cria um registro para cada mes do arquivo SZB
   For nXA := 1 To 12
   	cSZBMes  := "SZB->ZB_HRMES" + StrZero(nXA,2)
   	cValrMes := "SZB->ZB_MES" + StrZero(nXA,2)
   	If AllTrim(&cSZBMes) <> ":" .And. AllTrim(&cSZBMes) <> ""
			If RecLock("SZI",.T.)
				Replace ZI_FILIAL  With xFilial("SZI")
	   		Replace ZI_CCUSTO  With SZB->ZB_CCUSTO
   			Replace ZI_ANO     With SZB->ZB_ANO   			
   			Replace ZI_GRUPGER With SZB->ZB_GRUPGER		
			   Replace ZI_REVISAO With SZB->ZB_REVISAO
			   Replace ZI_ITEMORC With SZB->ZB_ITEMORC
	   		Replace ZI_DESCRI  With SZB->ZB_DESCRI //Codigo do funcionario
		  		Replace ZI_DESC2	 With SZB->ZB_DESC2
   			Replace ZI_RENDI	 With SZB->ZB_RENDI
   			Replace ZI_MESANO  With StrZero(nXA,2)+"/"+SZB->ZB_ANO
            //O usuario informara o numero de horas realizadas pelo funcionario e nao o 
            //  valor que ele recebera
	   		Replace ZI_HORAMES With &cSZBMes
	   		//Transforma a qtde. de horas informadas em número
	   		nQtdeHora := ((Val(SubStr(AllTrim(SZI->ZI_HORAMES),1,3))*60) + (Val(SubStr(AllTrim(SZI->ZI_HORAMES),5,2))))/60
	   		//Calculo das horas no mes
	   		nTotaHora := ExecBlock("CalcHora",.F.,.F.,{AllTrim(SZB->ZB_DESCRI),SZI->ZI_MESANO})
            //Calculo do valor a ser pago ao funcionario
	   		Replace ZI_VALRMES With ((SZI->ZI_RENDI/nTotaHora)*nQtdeHora)
	   			   		
	   		dbSelectArea("SZI")
				MsUnLock()
				//Grava o valor no SZB
				//dbSelectARea("SZB")
				//If RecLock("SZB",.F.)
				//   Replace &cValrMes With SZI->ZI_VALRMES
				//   MsUnlock()
				//EndIf			
			EndIf
		EndIf
	Next
EndIf

dbSelectArea(aArqSZB[01])
dbSetOrder(aArqSZB[02])
dbGoTo(aArqSZB[03])

Return


/*INCLUIDO POR CRISLEI TOLEDO - 08/05/02 - CONTROLE DE APROVACAO DE ORCAMENTO*/
Static Function FAprova()
******************************************************************************
*
*
****

If !MsgBox("Confirma Aprovacao deste Orcamento?","Pergunta","YESNO")
	Return
EndIf

nPosIte := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_ITEMORC"})

dbSelectArea("SZB")
dbSetOrder(4)

For nxI := 1 To Len(aCols)

    dbSeek(xFilial("SZB")+cCodFun+cAno+cRevisao+aCols[nxI,nPosIte])

    If RecLoCk("SZB",.F.)
       Replace ZB_APROVA  With "S"
       MsUnlock()
	 EndIf
Next

Return


Static Function FTela()
***********************************************
* 
* 
****
Private cOk       := .F.

While ! cOk
//   @ 000,000 To 140,220 Dialog oDlg Title "Copia Revisao"
   @ 000,000 To 200,250 Dialog oDlg Title "Copia Revisao"
   @ 005,005 To 075,110  Title "Copia revisao"
   @ 015,007 Say "Cod . Funcionario:"
   @ 015,050 GET cCodFun PICTURE "@!" F3 "SZD" VALID ExecBlock('ValFunc',.F.,.F.) SIZE 40,50
   @ 030,007 Say "Ano:"
   @ 030,050 GET cAno PICTURE "@!" VALID ExecBlock('ValAno',.F.,.F.) SIZE 20,30
   @ 045,007 Say "Copiar Revisao:"
   @ 045,050 GET cReviCop PICTURE "@!" SIZE 20,30
   @ 060,007 Say "Para Revisao:"
   @ 060,050 GET cRevisao PICTURE "@!" VALID ExecBlock('ValidRev',.F.,.F.) SIZE 20,30   
   @ 080,040 BmpButton Type 01 Action OkProc()
   Activate Dialog oDlg Center                
EndDo

Return


Static Function OkProc()
***********************************************
* 
* 
****
If AllTrim(cReviCop) <> "" .And. ;
   AllTrim(cCodFun)  <> "" .And. ;
   AllTrim(cAno)     <> "" .And. ;
   AllTrim(cRevisao) <> ""
   cOk := .T.
	Close(oDlg)
Else
	MsgBox("Alguns dos campos nao foram preenchidos","Inconsistencia","STOP")
EndIf

Return


Static Function FMontaAcols()
***********************************************
* 
* 
****

aCols := {}

aCols:=Array(1,nUsado+1)
dbSelectArea("SX3")
dbSeek("SZB")
nUsado:=0
While !Eof() .And. (X3_ARQUIVO == "SZB")
   IF X3USO(X3_USADO)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_DESCRI"   .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_ANO"      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_REVISAO"  .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_DESC2"
      nUsado := nUsado + 1
      IF nOpcx == 3
         IF X3_TIPO == "C"
            aCols[1][nUsado] := SPACE(x3_tamanho)
         Elseif X3_TIPO == "N"
            aCols[1][nUsado] := 0
         Elseif X3_TIPO == "D"
            aCols[1][nUsado] := dDataBase
         Elseif X3_TIPO == "M"
            aCols[1][nUsado] := ""
         Else
            aCols[1][nUsado] := .F.
         Endif
      Endif
   Endif
   dbSkip()
EndDo
aCols[1][nUsado+1] := .F.

Return


Static Function FGravArq()
******************************************************************************
*
*
****

nSeq := 1
nPosIte := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_ITEMORC"})
nPosCC  := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_CCUSTO"})

dbSelectArea("SZB")
dbSetOrder(4)

For nxI := 1 To Len(aCols)
    dbSeek(xFilial("SZB")+cCodFun+cAno+cRevisao+aCols[nxI,nPosCC]+aCols[nxI,nPosIte]) 
    RecLoCk("SZB",Eof())
    If ! aCols[nxI,Len(aHeader)+1]
       For nxJ := 1 To Len(aHeader)
           nPosOr := FieldPos(aHeader[nxJ,2])
           FieldPut(nPosOr,aCols[nxI,nxJ])
       Next

       If FieldGet(FieldPos("ZB_REVISAO")) <> cRevisao
          lReindex := .T.
       EndIf

       Replace ZB_FILIAL  With xFilial()
       Replace ZB_DESCRI  With cCodFun
       Replace ZB_ANO     With cAno
       Replace ZB_REVISAO With cRevisao
       Replace ZB_ITEMORC With StrZero(nSeq,2)
       nSeq := nSeq + 1
       MsUnlock()
       FGravMes("A")
	 Else

       If ! Eof()
          RecLock("SZB",.F.)
          dbDelete()
          MsUnlock()
          FGravMes("E")
       EndIf

    EndIf
Next

Return