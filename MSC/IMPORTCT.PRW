#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function IMPORTCT()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NCTNOVO,NSEQ,CCONTA,")

Processa( {|| RunProc() },"Importacao de Contratos/Itens","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Importacao de Contratos/Itens","Importando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SZ1")  // CONTRATOS
dbSetOrder(1)        // Filial + Codigo
nCTNovo:=0

DbUseArea( .T.,, "G:\BD\XEN_FOX\TSA\SICAR05.DBF", "IT", if(.T. .OR. .F., !.F., NIL), .F. )
DbSelectArea("IT")

IndRegua("IT","ITIND","COD_CTO",,,"Selecionando Registros...")

DbUseArea( .T.,, "G:\BD\XEN_FOX\TSA\SICAR03.DBF", "CT", if(.T. .OR. .F., !.F., NIL), .F. )
DbSelectArea("CT")
dbGoTop()
ProcRegua(RecCount())

While ! Eof()
   DbSelectArea("SA1")
   DbSetOrder(5) //Cod_ANt
   If DbSeek(xFilial("SA1")+CT->COD_CLI)
      DbSelectArea("SZ1")
      dbSetOrder(1)
      DbSeek(xFilial("SZ1")+CT->COD_CTO)
      If Reclock("SZ1",! Found())
         Replace Z1_FILIAL    With XFilial("SZ1")
         Replace Z1_COD       With CT->COD_CTO
         Replace Z1_TIPO      With IIf(CT->COD_CTO >= "E7000","I","E")
         Replace Z1_CODCLI    With SA1->A1_COD
         Replace Z1_CLIENTE   With SA1->A1_NOME
         Replace Z1_NOME      With CT->NOME_CTO
         Replace Z1_LOJA      With SA1->A1_LOJA
         Replace Z1_NREDUZ    With SA1->A1_NREDUZ
         Replace Z1_DTINI     With CT->DATAI_CTO
         Replace Z1_DTFIM     With CT->DATAT_CTO
         Replace Z1_VRPREV    With CT->VALP_CTO
         Replace Z1_VRADIT1   With CT->VALA_CTO
         Replace Z1_EVENTO    With IIF(CT->VALA_CTO>0,"S","N")
         Replace Z1_SITUAC    With CT->SIT_CTO
         Replace Z1_NOMINT    With CT->NOMINT_CTO
         Replace Z1_DIAFAT    With "01"
         nCTNovo := nCTNovo + 1
         MsUnlock()
      EndIf
      DbSelectArea("IT")
      DbSetOrder(1) //Codigo_Contrato
      If DbSeek(CT->COD_CTO)   //Se existir Itens
         nSeq:=1
         While ! Eof() .and. IT->COD_CTO == CT->COD_CTO
         If SubStr(IT->COD_CTA,5,1) == " "    //Letra
            DbSkip()
            Loop
         EndIf
            DbSelectArea("SZ2")
            If RecLock("SZ2",.T.)
               Replace Z2_COD    With IT->COD_CTO
               Replace Z2_SEQ    With StrZero(nSeq,2)
               Replace Z2_OS     With IT->COD_OS
               Replace Z2_SETOR  With IT->COD_SET
               Replace Z2_GEREN  With IT->COD_GRT
               Replace Z2_LETRA  With SubStr(IT->COD_CTA,5,1)
               Replace Z2_CONTA  With SubStr(IT->COD_CTA,1,4)
               Replace Z2_SUBC   With SubStr(IT->COD_CTA,1,4)+IIF(SubStr(IT->COD_CTA,5,1)==" ","A",SubStr(IT->COD_CTA,5,1))
               Replace Z2_DESC   With IT->DESCR_CTA
               Replace Z2_DTINI  With IT->DATAI_CTA
               Replace Z2_DTFIM  With IT->DATAT_CTA
               Replace Z2_SITUAC With IT->SITUA_CTA
               cConta:=SubStr(IT->COD_CTA,1,4)
               MsUnlock()
            EndIf
            nSeq:=nSeq+1
            DbSelectArea("IT")
            DbSkip()
         End
         DbSelectArea("SZ1")
         If Reclock("SZ1",.F.)
            Replace Z1_CONTA With cConta
            MsUnlock()
         EndIf
      EndIf
   EndIf
   DbSelectArea("CT")
   IncProc("Gravando Contrato : "+StrZero(Recno(),6))
   DbSkip()
EndDo

dbSelectArea("CT")
Use

dbSelectArea("IT")
Use

MSGSTOP(Str(nCTNovo,6) + " Reg. Incluidos Com Exito !" )

Return
