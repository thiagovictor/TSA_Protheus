#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LP59101  ³ Autor ³ Tiago Augusto Gomes   ³ Data ³ 05.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RDMAKE para localizacao da Conta Contabil correta a ser    ³±±
±±³          ³ creditada o Valor de ISSQN.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO PARA EPC                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR ³ DATA  ³ MOTIVO DA ALTERACAO                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³       ³                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP59101()

SetPrvt("CCHEQUE,CPREFIXO,CTITULO,CCODCLI,CLOJCLI,CCONTAISS,NREC,")

cCheque    := SEF->EF_NUM
dbSelectArea("SEF")
nRec := Recno()
dbSetOrder(5)
If dbSeek(xFilial("SEF")+cCheque+"01")
   	If Alltrim(SEF->EF_FORNECE) == "MUNIC"
		cPrefixo := SEF->EF_PREFIXO	        // Recebe o Prefixo do Título de ISSQN
		cTitulo  := SEF->EF_TITULO	     	// Recebe o Numero do Título de ISSQN
		dbSelectArea("SE1")
		dbSetOrder(1)
		If dbSeek(xFilial("SE1")+cPrefixo+cTitulo)
			cCodCli := SE1->E1_CLIENTE
			cLojCli := SE1->E1_LOJA
    		// Descobrir a Conta Contábil de ISS no Cadastro de Clientes
    		DbSelectArea("SA1")
    		DbSetOrder(1)
    		If DbSeek(xFilial("SA1")+cCodCli+cLojCli)
   				cContaISS := AllTrim(SA1->A1_CONTISS)
    		EndIf
		  Else
   			cContaISS := "TRES"  // Criado para que o Sistema nao tente retornar um variavel inexistente
		EndIf      
	  Else
   		cContaISS := "DOIS"  // Criado para que o Sistema nao tente retornar um variavel inexistente
	Endif
  Else
   	cContaISS := "UM"  // Criado para que o Sistema nao tente retornar um variavel inexistente
Endif
DbSelectArea("SEF")
DbGoTo(nRec)
Return(cContaISS)     // Retorna a conta contabil que sera debitada.    		