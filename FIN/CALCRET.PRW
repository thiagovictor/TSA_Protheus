#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function CALCRET()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ,CROT,CCONTRATO,VRETURN,DDATAREF,")
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  CALCRET ³ Autor ³ Joao Carlos Fonseca   ³ Data ³ 14/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Calculo dos Impostos Retidos COFINS, PIS e CLSS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±³          ³ Usado sobre os LP`s                                       ³±±
- EXECBLOCK("CALCRET",.F.,.F.,{"4",SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA)})
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
aArq:= { Alias() , IndexOrd() , Recno() }
aOrdSE1 := SE1->(IndexOrd()) 
aRecSE1 := SE1->(Recno()) 
vReturn := 0
/*
PARAMIXB = 1 = Calcula COFINS
PARAMIXB = 2 = Calcula PIS
PARAMIXB = 3 = Calcula CSLL
PARAMIXB = 4 = Calcula Todos
*/
dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(PARAMIXB[2])
do While !eof() .And. ;
		PARAMIXB[2] = SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA)
		
	If PARAMIXB[1] $ "1_4" .AND. SE1->E1_TIPO == 'CF-'
		vReturn := vReturn + SE1->E1_VLCRUZ
	EndiF
	If PARAMIXB[1] $ "2_4" .AND. SE1->E1_TIPO == 'PI-'
		vReturn := vReturn + SE1->E1_VLCRUZ
	EndiF
	If PARAMIXB[1] $ "3_4" .AND. SE1->E1_TIPO == 'CS-'
		vReturn := vReturn + SE1->E1_VLCRUZ
	EndiF                                                       	
	
	dbSkip()
Enddo
// Voltando SE1
dbSetOrder(aOrdSE1)
dbGoto(aRecSE1)

dbSelectArea(aArq[1])
dbSetOrder(aArq[2])
dbGoTo(aArq[3])

Return(vReturn)