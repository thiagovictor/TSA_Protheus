#include "rwmake.ch"        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Checkd   ³ Autor ³Ricardo E. Rodrigues   ³ Data ³ 15/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao + Rotina para calculo do Check Horizontal posicao 263 a 280 do++
++           + registro detalhe conforme manual do unibanco pag 4 e Exemplo++
++           + na pagina 43                                                ++
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       + Geracao de CNAB de pagamentos-Bordero modelo 01 e 03       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function Checkd 
*****************************************************************************
* Rotina de Calculo
********************
// Abrindo o SA2, para utilizar as variaves A2_BANCO, A2_AGENCIA E A2_NUMCON
// que sao Banco, agencia e numero da conta do fornecedor, estes campo nao
// podem conter ".", entao é aconselhavel passar isto ao pessoal que faz o
// cadastro destes dados

DbSelectArea("SA2")
DbSetOrder(1) //codigo + loja
DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)


// A variavel nd1 esta recebendo os dados banco,agencia e conta do fornecedor
// formando uma unica variavel
if SEA->EA_MODELO = "01"
	nd1	:= "409" + strzero(val(alltrim(sa2->a2_agencia)),4) + strzero(val(alltrim(sa2->a2_numcon)),10)
else 
	if SEA->EA_MODELO $ "03_41_43"
 		nd1	:= strzero(val(alltrim(sa2->a2_banco)),3) + strzero(val(alltrim(sa2->a2_agencia)),4) + strzero(val(alltrim(sa2->a2_numcon)),10)
   endif
endif
// A variavel nd2 recebe o saldo transformado em string sem o ponto decimal
//nd2		:= alltrim(strtran(str(STRZERO(SE2->E2_SALDO*100,13),".",""))
nd2		:= alltrim(strtran(str(SE2->E2_SALDO*100),".",""))

// A variavel ntot recebe a multiplicacao d (nd1+nd2) vezes 5
// A variavel ntot1 recebe o tamanho de ntot, pois iremos verificar 
// se seu tamanho é maior que 18 e caso positivo retornar, a partir
// da 2 posicao, conforme manual do Unibanco pag 4 e Exemplo na pag 43
// As funcoes utilizadas SOMASTR E MULTSTR possuem referencia no quark
if SEA->EA_MODELO $ "01_03"
	ntot    := multstr( (somastr(nd1,nd2)) , "5")
else
	ntot    := multstr( (somastr(nd1,nd2)) , "7")		
endif
ntot1	:= len(ntot)
//dbSelectArea("SA2")
//dbSkip()

// A varivel creturn recebe o conteudo que sera enviado ao banco
if ntot1 < 18
   creturn := "000000000000000000"
   creturn := creturn + multstr( (somastr(nd1,nd2)) , "5")
   creturn := right(creturn,18)
 else
	if ntot1 = 18       
   		creturn := multstr( (somastr(nd1,nd2)) , "5")
	else
		if ntot1 < 18
		   creturn := substr(ntot,2,19)	
        endif
	endif
endif

return(creturn)