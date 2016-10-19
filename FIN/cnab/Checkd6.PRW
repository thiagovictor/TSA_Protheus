#include "rwmake.ch"        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Checkd6  ³ Autor ³Joao Carlos Fonseca    ³ Data ³ 30/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao + Rotina para calculo do Check Horizontal posicao 263 a 280 do++
++           + registro detalhe conforme manual do unibanco pag 4 e Exemplo++
++           + na pagina 43                                                ++
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       + Geracao de CNAB de pagamentos-Bordero modelo 30 e 31       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function Checkd6
*****************************************************************************
* Rotina de Calculo
********************
// Buscando os dados conforme a Digitacao do Campo E2_IPTE, ou Codigo de Barras

// A variavel nd1 esta recebendo os dados banco,agencia e conta do fornecedor
// formando uma unica variavel
/*
If Empty(SE2->E2_IPTE)
	If Left(SE2->E2_CODBARR,3) = '409'
		nd1		:= Left(SE2->E2_CODBARR,3)+ strzero(val(Substr(SE2->E2_CODBARR,28,5)),6)+ ;
		           STRZERO(VAL(SA6->A6_AGENCIA),4) + "00" 
	Else
		nd1		:= Left(SE2->E2_CODBARR,3)+ "00000000000000"
	EndIF
Else
	If Left(SE2->E2_IPTE,3) = '409'
		nd1		:= Left(SE2->E2_IPTE,3)+ strzero(val(Substr(SE2->E2_IPTE,14,5)),6)+ ;
		           STRZERO(VAL(SA6->A6_AGENCIA),4) + "00" 
	Else
		nd1		:= Left(SE2->E2_CODBARR,3)+ "00000000000000"
	EndIF
EndIf
*/
nd1  := STRZERO(VAL(SA2->A2_BANCO),4) + "00000000000000"
// A variavel nd2 recebe o saldo transformado em string sem o ponto decimal
//nd2		:= alltrim(strtran(str(SE2->E2_SALDO),".",""))// 
nd2		:= alltrim(strtran(str(SE2->E2_SALDO*100),".",""))
//nd2		:= STR(STRZERO(SE2->E2_SALDO*100,13))
// A variavel ntot recebe a multiplicacao d (nd1+nd2) vezes 5
// A variavel ntot1 recebe o tamanho de ntot, pois iremos verificar 
// se seu tamanho é maior que 18 e caso positivo retornar, a partir
// da 2 posicao, conforme manual do Unibanco pag 4 e Exemplo na pag 43
// As funcoes utilizadas SOMASTR E MULTSTR possuem referencia no quark
ntot    := multstr( (somastr(nd1,nd2)) , "7")
ntot1	  := len(ntot)
//dbSelectArea("SA2")
//dbSkip()

// A varivel creturn recebe o conteudo que sera enviado ao banco

If ntot1 < 18 
   creturn := "000000000000000000"
   creturn := creturn + multstr( (somastr(nd1,nd2)) , "5")
   creturn := right(creturn,18)
else
   if ntot1 = 18
       creturn :=  multstr( (somastr(nd1,nd2)) , "5")
   else 
       if ntot1 > 18
   		  creturn := substr(ntot,2,19)
	   endif
   endif
endif

return(creturn)