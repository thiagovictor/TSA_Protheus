/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |INPUTFER  |Autor | Crislei Toledo							| Data  | 06/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Cadastro de dias uteis                                 									|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function InputUt(PARAMIXB)

SetPrvt("AARQINP,LREINDEX,NOPCX,CCCUSTO,CANO,CREVISAO")
SetPrvt("LEDIT,NSEQ,CCONTRAT,CTIPODES,NUSADO,AHEADER")
SetPrvt("NPOSDESC,ACOLS,NXI,CTITULO,AC,AR")
SetPrvt("ACGD,CLINHAOK,CTUDOOK,LRETMOD2,NPOSITE,NXJ")
SetPrvt("NPOSOR,")

aArqInp  := { Alias() , IndexOrd() , Recno() }
lReindex := .F.

DO CASE
   CASE (PARAMIXB $"I/A")
        nOpcx:=3   // 3 = PODE EDITAR O DADO
   CASE (PARAMIXB $"V/E")
        nOpcx:=2   // 2 = PODE VISUALIZUR O DADO
ENDCASE

If PARAMIXB == "I"
   cCodiCont := Space(06)
Else
   cCodiCont := SZK->ZK_CODCONT
EndIf

IF PARAMIXB == "A"
   lEdit := .F.
Else
   lEdit := .T.
EndIf

*???nSeq := 1

//cContrat := ""
//cTipoDes := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZK")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZK")

   IF X3USO(x3_usado)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZK_CODCONT" 

      nUsado := nUsado + 1
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho, ;
           x3_decimal, ,  x3_usado, x3_tipo, x3_arquivo, x3_context, x3_F3 } )
    Endif
    dbSkip()
End

//nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZI_DESCRI"})

If PARAMIXB == "I"
   aCols:=Array(1,nUsado+1)
   dbSelectArea("SX3")
   dbSeek("SZK")
   nUsado:=0
   While !Eof() .And. (X3_ARQUIVO == "SZK")
      IF X3USO(X3_USADO)                         .And. ;
         cNivel >= x3_nivel                      .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZK_CODCONT"
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
Else
   dbSelectArea("SZK")
   dbSetOrder(1)
   dbSeek(xFilial("SZK")+cCodiCont)

   aCols := {}

   While (! eof())                            .And. ;
         (xFilial("SZK")  == SZK->ZK_Filial)  .And. ;
         (SZK->ZK_CODCONT == cCodiCont )
         
      Aadd(aCols,Array(Len(aHeader)+1))
      For nxI := 1 to Len(aHeader)
         aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.

      dbSelectArea("SZK")
      dbSkip()
   EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Cadastro de Feriados  x Contrato"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"cCodiCont",  {15,10} ,"Contrato" ,"@!","","SZ1",lEdit})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape do Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCGD:={29,5,118,315}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

If lRetMod2 .And. nOpcx <> 2
   Processa()
ElseIf lRetMod2 .And. PARAMIXB == "E"
   FDelete()
Endif

//If lReindex
   dbSelectArea(aArqInp[1])
   dbSetOrder(aArqInp[2])
   dbReIndex(aArqInp[1])
   dbGoTo(aArqInp[3])
//EndIf

Return


Static Function Processa()
******************************************************************************
*
*
****

nSeq := 1
nPosIte := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZK_DATA"})

dbSelectArea("SZK")
dbSetOrder(1)

For nxI := 1 To Len(aCols)

    dbSeek(xFilial("SZK")+cCodiCont+DTOS(aCols[nxI,nPosIte]))

    If ! aCols[nxI,Len(aHeader)+1]
	    If RecLock("SZK",Eof())
	       For nxJ := 1 To Len(aHeader)
   	        nPosOr := FieldPos(aHeader[nxJ,2])
	           FieldPut(nPosOr,aCols[nxI,nxJ])
   	    Next

//	       If FieldGet(FieldPos("ZB_REVISAO")) <> cRevisao
 //  	       lReindex := .T.
 //      	 EndIf
	       Replace ZK_FILIAL  With xFilial()
   	    Replace ZK_CODCONT With cCodiCont
          MsUnlock()
		 EndIf
    Else
       If ! Eof()
          If RecLock("SZK",.F.)
          	 dbDelete()
          	 MsUnlock()
          EndIf
       EndIf       
    EndIf    
Next

Return


Static Function FDelete()
*****************************************************************************
* Deleta registros dos arquivos SZB
*
********

dbSelectArea("SZK")
dbSetOrder(1)
dbSeek(xFilial("SZK")+cCodiCont)

While (! Eof()) 			   .And. ;
      (xFilial("SZK")  == SZK->ZK_Filial)  .And. ;
      (SZK->ZK_CODCONT == cCodiCont )
   If RecLock("SZK",.F.)
	   dbDelete()
   	MsUnLock()
   	dbSkip()
   EndIf
EndDo

Return