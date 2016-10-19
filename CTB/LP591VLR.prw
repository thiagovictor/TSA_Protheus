/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP591VLR ¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦01.12.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ POSICIONA NO SE2 PARA TESTAR OS CAMPOS E RETORNAR A CONTA  ¦
¦          ¦ CONTABIL CORRESPONDENTE                                    ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO                                                 ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
+-----------------------------------------------------------------------+
*/

#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function LP591VLR(cTipoOp)

Local aArqAnt := {Alias(), IndexOrd(),Recno()}
Local aArqSEF := {"SEF", SEF->(IndexOrd()), SEF->(Recno())}
Local aArqSE2 := {"SE2", SE2->(IndexOrd()), SE2->(Recno())}
Local aArqSA2 := {"SA2", SA2->(IndexOrd()), SA2->(Recno())}
Local aArqSED := {"SED", SED->(IndexOrd()), SED->(Recno())}

Local nRet    := 0
Local cQuery  := ""

/*
dbSelectARea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO)

If !Eof()
   Do Case
      Case cTipoOp $ "VL"
           nRet := (SEF->EF_VALOR-SE2->E2_ACRESC+SE2->E2_DECRESC)
      Case cTipoOp $ "DC"
           nRet := SE2->E2_DECRESC
      Case cTipoOp $ "JR"
           nRet := SE2->E2_ACRESC
      OtherWise
           nRet := 0
   EndCase
EndIf
*/

cQuery := "SELECT MAX(E5_SEQ) E5_SEQ FROM " + RetSqlName("SE5")
cQuery += " WHERE E5_NUMERO = '" + SEF->EF_TITULO + "' AND "
cQuery += " E5_PREFIXO = '" + SEF->EF_PREFIXO + "' AND "
cQuery += " E5_PARCELA = '" + SEF->EF_PARCELA + "' AND "
cQuery += " E5_TIPO    = '" + SEF->EF_TIPO    + "' AND "
cQuery += " E5_CLIFOR  = '" + SEF->EF_FORNECE + "' AND "
cQuery += " E5_LOJA    = '" + SEF->EF_LOJA    + "' AND "
cQuery += " E5_TIPODOC NOT IN('DC','JR','MT','ES','EC') AND "
cQuery += " D_E_L_E_T_ <> '*'"
      
TCQUERY cQuery ALIAS "QSEQ" NEW

dbSelectARea("SE5")
dbSetOrder(7)
dbSeek(xFilial("SE5")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA+QSEQ->E5_SEQ)
//dbSkip(-1)

While !Eof() .And. ;
   SEF->EF_PREFIXO == SE5->E5_PREFIXO .And. ; 
   SEF->EF_TITULO  == SE5->E5_NUMERO  .And. ;
   SEF->EF_PARCELA == SE5->E5_PARCELA .And. ;
   SEF->EF_TIPO    == SE5->E5_TIPO    .And. ;
   SEF->EF_FORNECE == SE5->E5_CLIFOR  .And. ;
   SEF->EF_LOJA    == SE5->E5_LOJA
           
   If SE5->E5_TIPODOC $ ('DC/JR/MT/ES/EC')
      dbSelectArea("SE5")
      dbSkip()
      Loop
   EndIf
   
   Do Case
      Case cTipoOp $ "VL"
           nRet := (SEF->EF_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO)
      Case cTipoOp $ "DC"
           nRet := SE5->E5_VLDESCO
      Case cTipoOp $ "JR"
           nRet := SE5->E5_VLMULTA+SE5->E5_VLJUROS
      Case cTipoOp $ "PI"
           dbSelectArea("SE2")
           dbSetOrder(1)
           dbSeek(xFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
           nRet := SE2->E2_VRETPIS
      Case cTipoOp $ "CF"
           dbSelectArea("SE2")
           dbSetOrder(1)
           dbSeek(xFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
           nRet := SE2->E2_VRETCOF
      Case cTipoOp $ "CS"
           dbSelectArea("SE2")
           dbSetOrder(1)
           dbSeek(xFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
           nRet := SE2->E2_VRETCSL
      OtherWise
           nRet := 0
   EndCase
   Exit
End

dbSelectArea("QSEQ")
dbCloseArea()

dbSelectArea(aArqSED[01])
dbSetOrder(aArqSED[02])
dbGoTo(aArqSED[03])
                         
dbSelectArea(aArqSA2[01])
dbSetOrder(aArqSA2[02])
dbGoTo(aArqSA2[03])
                   
dbSelectArea(aArqSE2[01])
dbSetOrder(aArqSE2[02])
dbGoTo(aArqSE2[03])

dbSelectArea(aArqSEF[01])
dbSetOrder(aArqSEF[02])
dbGoTo(aArqSEF[03])

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(nRet)