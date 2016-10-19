#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | MSD2520 | Claudio Silva            |  Data  |                  |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Ponto de Entrada - Apos atualizar SD2                          |
|            |                                                                |
+------------+----------------------------------------------------------------+
| Uso        | Especifico                                                     |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
|27/01/06 |Claudio Silva| Atualizacao SZ3.                                    |
|         |             |                                                     |
+---------+-------------+-----------------------------------------------------+
*/

User Function MSD2520()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ1,AARQ2,AARQ3,AARQ4,CANO,CMES")
SetPrvt("CREV,CCCUSTO,CDESCRI,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MSD2520 ³ Autor ³Ederson Dilney Colen M.³ Data ³13/01/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Gravacao do Saldo - pois esta excluindo a nota.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±³          ³ Usado sobre o ponto de entrada.                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

aArq1:= { Alias() , IndexOrd() , Recno() }
aArq2:= { SD2->(Alias()) , SD2->(IndexOrd()) , SD2->(Recno()) }
aArq3:= { SC5->(Alias()) , SC5->(IndexOrd()) , SC5->(Recno()) }
aArq4:= { SE1->(Alias()) , SE1->(IndexOrd()) , SE1->(Recno()) }

cAno	:= SubStr(DtoS(SC5->C5_DATAREF),1,4)
cMes    := SubStr(DtoS(SC5->C5_DATAREF),5,2)
cRev    := "000"
cCCusto := SD2->D2_SUBC+Space(11-Len(SD2->D2_SUBC))
cDescri := SD2->D2_CLIENTE+SD2->D2_LOJA+Space(10-Len(SD2->D2_CLIENTE+SD2->D2_LOJA))

dbSelectArea("SZB")
dbSetOrder(1)
dbSeek(xFilial("SZB")+cCCusto+cAno)

While (! Eof())                                          .And. ;
      (Alltrim(SZB->ZB_CCUSTO) == Alltrim(SD2->D2_SUBC)) .And. ;
      (SZB->ZB_ANO             == cAno)

  If Val(cRev) < Val(SZB->ZB_Revisao)
     cRev := SZB->ZB_Revisao
  EndIf

  dbSelectArea("SZB")
  dbSkip()

EndDo

dbSelectArea("SZB")
dbSetOrder(2)
dbSeek(xFilial("SZB")+cCCusto+cAno+cRev+cDescri)

While (!Eof())                                                 .And. ;
      (Alltrim(SZB->ZB_CCUSTO) == Alltrim(SD2->D2_SUBC))       .And. ;
      (SZB->ZB_Ano             == cAno)                        .And. ;
      (SZB->ZB_Revisao         == cRev)                        .And. ;
      (Alltrim(SZB->ZB_Descri) == SD2->D2_CLIENTE+SD2->D2_LOJA)

   dbSelectArea("SZ1")
   dbSetOrder(1)
   dbSeek(xFilial("SZ1")+SC5->C5_CONTRAT+SD2->D2_CLIENTE+SD2->D2_LOJA)

   If Eof()
      MSGSTOP("Para este titulo nao existe um Contrato cadastrado.")
      dbSelectArea("SZB")
      dbSkip()
      Loop
   EndIf

   dbSelectArea("SZB")
   RecLoCk("SZB",.F.)
   Do Case
      Case cMes == "01"
           Replace ZB_SALD01 With SZB->ZB_SALD01 - SD2->D2_TOTAL
      Case cMes == "02"
           Replace ZB_SALD02 With SZB->ZB_SALD02 - SD2->D2_TOTAL
      Case cMes == "03"
           Replace ZB_SALD03 With SZB->ZB_SALD03 - SD2->D2_TOTAL
      Case cMes == "04"
           Replace ZB_SALD04 With SZB->ZB_SALD04 - SD2->D2_TOTAL
      Case cMes == "05"
           Replace ZB_SALD05 With SZB->ZB_SALD05 - SD2->D2_TOTAL
      Case cMes == "06"
           Replace ZB_SALD06 With SZB->ZB_SALD06 - SD2->D2_TOTAL
      Case cMes == "07"
           Replace ZB_SALD07 With SZB->ZB_SALD07 - SD2->D2_TOTAL
      Case cMes == "08"
           Replace ZB_SALD08 With SZB->ZB_SALD08 - SD2->D2_TOTAL
      Case cMes == "09"
           Replace ZB_SALD09 With SZB->ZB_SALD09 - SD2->D2_TOTAL
      Case cMes == "10"
           Replace ZB_SALD10 With SZB->ZB_SALD10 - SD2->D2_TOTAL
      Case cMes == "11"
           Replace ZB_SALD11 With SZB->ZB_SALD11 - SD2->D2_TOTAL
      Case cMes == "12"
           Replace ZB_SALD12 With SZB->ZB_SALD12 - SD2->D2_TOTAL
   EndCase

   MsUnLock()

   dbSelectArea("SZB")
   dbSkip()

EndDo

//Atualiza campos da tabela Contrato X Evento
//If SM0->M0_CODIGO == "02" //TSA
U_fAtuaSZ3("E")
//EndIf

SD2->(DbSelectArea(aArq2[1]))
SD2->(DbSetOrder(aArq2[2]))
SD2->(DbGoTo(aArq2[3]))

SC5->(DbSelectArea(aArq3[1]))
SC5->(DbSetOrder(aArq3[2]))
SC5->(DbGoTo(aArq3[3]))

SE1->(DbSelectArea(aArq4[1]))
SE1->(DbSetOrder(aArq4[2]))
SE1->(DbGoTo(aArq4[3]))

DbSelectArea(aArq1[1])
DbSetOrder(aArq1[2])
DbGoTo(aArq1[3])

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
