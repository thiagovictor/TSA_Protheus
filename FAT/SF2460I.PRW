/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  SF2460I ³ Autor ³ Eduardo Carraro       ³ Data ³ 23/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada p/ calculo de ISS avaliando SZ8           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³21/02/06  ³ Crislei     ª Alteracao para buscar o Municipio do Cadastro³±±
±±ª          ³             ª de Pedidos de Venda para calculo do ISS      ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function SF2460I()

SetPrvt("AARQ,AARQSD2,AARQSC5,AARQSA1,AARQSZ8,AARQSF2")
SetPrvt("CCLIENTE,CLOJA,CDOC,CSERIE,CCONTRAT,DDATAREF")
SetPrvt("nAliqISS,nValISS,")


aArq   :={Alias(),IndexOrd(),Recno()}
aArqSD2:={SD2->(IndexOrd()),SD2->(Recno())}
aArqSC5:={SC5->(IndexOrd()),SC5->(Recno())}
aArqSA1:={SA1->(IndexOrd()),SA1->(Recno())}
aArqSZ8:={SZ8->(IndexOrd()),SZ8->(Recno())}
aArqSF2:={SF2->(IndexOrd()),SF2->(Recno())}
aArqSE2:={SE2->(IndexOrd()),SE2->(Recno())}

cCliente  := SF2->F2_CLIENTE
cLoja     := SF2->F2_LOJA
cDoc      := SF2->F2_DOC
cSerie    := SF2->F2_SERIE
cContrat  := Space(05)
dDataRef  := Ctod("  /  /  ")
cMunicISS := ""

cCONTRAT  := SC5->C5_CONTRAT
dDataRef  := SC5->C5_DATAREF
cMunicISS := SUBSTR(SC5->C5_MUNICIS,1,4)

nAliqISS := 0
nValISS  := 0

/*
   DbSelectArea("SD2")
   DbSetOrder(3) //Filial + Documento + Serie + Cliente +Loja + Produto + Item
   DbSeek(xFilial("SD2")+cDoc+cSerie+cCliente+cLoja)
   While xFilial("SD2") == D2_FILIAL .and. D2_DOC == cDoc .and. D2_SERIE == cSerie .and. D2_CLIENTE == cCliente .and. D2_LOJA == cLoja .and. ! Eof()
       DbSelectArea("SZ8")
       DbSetOrder(1) //Filial+Produto+Municipio
       If DbSeek(xFilial("SZ8")+SD2->D2_COD+cMunicISS)
          DbSelectArea("SD2")
          If RecLock("SD2")
             Replace D2_VALICM With (D2_TOTAL*(SZ8->Z8_ISS/100))
             Replace D2_BASEICM With SD2->D2_TOTAL //SZ8->Z8_ISS
             Replace D2_PICM With SZ8->Z8_ISS
             //Incluido por Alcides em 10-02-04 -> Tratamento do Campo D2_VALISS
             Replace D2_VALISS  With (D2_TOTAL*(SZ8->Z8_ISS/100))
             Replace D2_ALIQISS With SZ8->Z8_ISS
             //Termino Alteracao Alcides em 10-02-04
             MSUnlock()
          EndIf
          nValISS := nValISS + (SD2->D2_TOTAL*(SZ8->Z8_ISS/100))
       EndIf
       DbSelectArea("SD2")
       DbSkip()
   End
//EndIf
If nValISS >  0
   DbSelectArea("SF2")
   If RecLock("SF2",.f.)
      Replace F2_VALISS With nValISS
      MSUnlock()
   Else //jah estah lockado
      Replace F2_VALISS With nValISS
   EndIf
EndIf
If ! Empty(cContrat)
   DbSelectArea("SF2")
   If RecLock("SF2",.f.)
      Replace F2_CONTRAT With cContrat
      Replace F2_DTREF   With dDataRef
      MSUnlock()
   Else //Jah estah Lockado
      Replace F2_CONTRAT With cContrat
      Replace F2_DTREF   With dDataRef
   EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVACAO DO ISS NO TITULO DO CONTAS A PAGAR                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nValISS > 0
   DbSelectArea("SE2")
   DbSetOrder(1) //Filial+Prefixo+Numero
   If DbSeek(xFilial("SE2")+SF2->F2_SERIE+SF2->F2_DOC)
      If Alltrim(E2_TIPO) == "TX" .and. Upper(Alltrim(E2_ORIGEM)) == "MATA460"
         If RecLock("SE2",.f.)
            Replace E2_SALDO  With nValISS
            Replace E2_VALOR  With nValISS
            Replace E2_VLCRUZ With nValISS
            //CRISLEI TOLEDO - 21/02/06 - Atualização do campo Municipio ISS
            Replace E2_MUNICIS With SC5->C5_MUNICIS
            Replace E2_DCMUNIS With Tabela("89",SC5->C5_MUNICIS)
            MsUnLock()
         EndIf
      EndIf
   Else
      MsgStop("Titulo de ISS Nao Encontrado na Carteira de Titulos a Pagar!")
   EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVACAO DO ISS NO TITULO DO CONTAS A RECEBER              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nValISS > 0
   DbSelectArea("SE1")
   DbSetOrder(1) //Filial+Prefixo+Numero
   If DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
      While SE1->E1_PREFIXO+SE1->E1_NUM == SF2->F2_SERIE+SF2->F2_DOC .AND. ! EOF()
         If Alltrim(E1_TIPO) == "NF"
            If RecLock("SE1",.f.)
               Replace E1_ISS With nValISS
               MsUnLock()
            EndIf
         EndIF
         DbSkip()
      End
   EndIf
EndIf

nValISS:=0
nAliqISS:=0
*/

DbSelectArea("SD2")
DbSetOrder(3) //Filial + Documento + Serie + Cliente +Loja + Produto + Item
DbSeek(xFilial("SD2")+cDoc+cSerie+cCliente+cLoja)

While xFilial("SD2") == D2_FILIAL .and. D2_DOC == cDoc .and. D2_SERIE == cSerie .and. D2_CLIENTE == cCliente .and. D2_LOJA == cLoja .and. ! Eof()
	DbSelectArea("SZ8")
	DbSetOrder(1) //Filial+Produto+Municipio
	If DbSeek(xFilial("SZ8")+SD2->D2_COD+cMunicISS)
		DbSelectArea("SD2")
		If RecLock("SD2",.F.)
			Replace D2_PICM    With SZ8->Z8_ISS
			Replace D2_ALIQISS With SZ8->Z8_ISS
			MSUnlock()
		EndIf
	EndIf
	DbSelectArea("SD2")
	DbSkip()
End

If ! Empty(cContrat)
	DbSelectArea("SF2")
	If RecLock("SF2",.f.)
		Replace F2_CONTRAT With cContrat
		Replace F2_DTREF   With dDataRef
		MSUnlock()
	Else //Jah estah Lockado
		Replace F2_CONTRAT With cContrat
		Replace F2_DTREF   With dDataRef
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVACAO DO ISS NO TITULO DO CONTAS A PAGAR                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If nValISS > 0
	DbSelectArea("SE2")
	DbSetOrder(1) //Filial+Prefixo+Numero
	If DbSeek(xFilial("SE2")+SF2->F2_SERIE+SF2->F2_DOC)
		If Alltrim(E2_TIPO) == "TX" .and. Upper(Alltrim(E2_ORIGEM)) == "MATA460"
			If RecLock("SE2",.f.)
				Replace E2_MUNICIS With SC5->C5_MUNICIS
				Replace E2_DCMUNIS With Tabela("89",SC5->C5_MUNICIS)
				MsUnLock()
			EndIf
		EndIf
	EndIf
//EndIf

DbSelectArea("SE2")
DbSetOrder(aArqSE2[1])
DbGoTo(aArqSE2[2])

DbSelectArea("SF2")
DbSetOrder(aArqSF2[1])
DbGoTo(aArqSF2[2])

DbSelectArea("SD2")
DbSetOrder(aArqSD2[1])
DbGoTo(aArqSD2[2])

DbSelectArea("SC5")
DbSetOrder(aArqSC5[1])
DbGoTo(aArqSC5[2])

DbSelectArea("SA1")
DbSetOrder(aArqSA1[1])
DbGoTo(aArqSA1[2])

DbSelectArea("SZ8")
DbSetOrder(aArqSZ8[1])
DbGoTo(aArqSZ8[2])

DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])

return
