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
±±³Uso       + Geracao de CNAB de pagamentos                              ³±±
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
//nd1		:= Alltrim(SA2->A2_BANCO)+Alltrim(SA2->A2_AGENCIA)+Alltrim(SA2->A2_NUMCON)
nd1		:= strzero(val(alltrim(sa2->a2_banco)),3) + strzero(val(alltrim(sa2->a2_agencia)),4) + strzero(val(alltrim(sa2->a2_numcon)),10)
// set decimals to 2
set fixed off
ndv1	:= val(nd1)
//ndv1	:= strzero(val(alltrim(sa2->a2_banco)),3)
//ndv2	:= strzero(val(alltrim(sa2->a2_agencia)),4)
//ndv3    := strzero(val(alltrim(sa2->a2_numcon)),10)
//ndv4    := str(val(ndv1),4,0)
//ndv5 	:= str(val(ndv2),4,0)
//ndv6	:= strzero(val(str(val(ndv3),10,0)),10)
//ndv6	:= str(val(ndv3),10,0)
//ndv7	:= ndv1 + ndv2 + ndv6
//strzero(val(str(val(ndv3),10,0)),10)
// A variavel nd2 recebe o saldo transformado em string e a variavel nd3
// recebe o conteudo da variavel nd2 sem o ponto decimal
nd2		:= val(strtran(str(SE2->E2_SALDO),".",""))
//nd3		:= val(strtran(nd2,".",""))

// A variavel ntot recebe a soma de nd1 e nd3, multiplicado por 5
// A variavel ntot1 recebe o conteudo de ntot em formato de texto para podermos
// posteriormente verificar se seu tamanho é maior que 18 e caso positivo retornar
// a partir da 2 posicao, conforme manual do Unibanco pag 4 e Exemplo na pag 43
//ntot    := ((nd1 + nd3) * 5)
ntot    := ((nd1 + nd2) * 5)
ntot1	:= alltrim(str(ntot))
dbSelectArea("SA2")
dbSkip()

// A varivel creturn recebe o conteudo que sera enviado ao banco
if len(ntot1) > 18
   creturn := substr(ntot,2,19)	
else
   creturn := ntot
endif

return(creturn)