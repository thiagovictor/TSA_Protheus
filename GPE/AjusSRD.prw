#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦FISTRFNFE  ¦ Autor ¦ Gilson Lucas          ¦Data ¦29.03.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦                                                            ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function AjusSRD()
*************************************************************************
*
**
Processa({|| ProcSRD() },"Ajustando SRD",'Aguarde......')

Return



Static Function ProcSRD()
*************************************************************************
*Processa tabela srd
**
Local nTot      := 0
Local cQuery    := ""
Local cAliasTMP := GetNextAlias()  
Local cColAdd   := "% MAX(CASE WHEN RD_PD IN ('406') THEN RD_CC ELSE  '' END) RD_CC , MAX(CASE WHEN RD_PD IN ('406') THEN RD_DATPGT ELSE  '' END) RD_DATPGT %"
/*
BeginSql Alias cAliasTMP //Inicio do Embedded SQL
   SELECT RD_FILIAL,RD_MAT,RD_DATARQ,'406' RD_PD,
   ISNULL(SUM(
   CASE
      WHEN RD_PD IN ('406','411','430','431','449','499') THEN RD_VALOR * 1
   END),0)+
   ISNULL(SUM(
   CASE
      WHEN RD_PD IN ('196','305') THEN RD_VALOR * -1
   END),0) RD_VALOR,
   %Exp:cColAdd%
   FROM %table:SRD% SRD
   WHERE SRD.%NotDel%
   AND RD_DATARQ > '200912' AND RD_DATARQ <= '201012'
   AND RD_PD IN ('406','411','430','431','449','499','196','305')
   GROUP BY RD_FILIAL,RD_MAT,RD_DATARQ
EndSql


cQuery := "UPDATE "+RetSqlName("SRD")+ " SET R_E_C_D_E_L_ = R_E_C_N_O_ ,  D_E_L_E_T_ = '*'
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND RD_DATARQ > '200912' AND RD_DATARQ <= '201012' "
cQuery += " AND RD_PD IN ('406','411','430','431','449','499','196','305') "
TcSqlExec(cQuery)
TcRefresh("SRD")



dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGotop())
//ProcRegua(nTot)
While !(cAliasTMP)->(Eof())
   IncProc()
   If RecLock("SRD",.T.)
      Replace RD_FILIAL With (cAliasTMP)->RD_FILIAL,;
              RD_MAT    With (cAliasTMP)->RD_MAT,;
              RD_PD     With (cAliasTMP)->RD_PD,;
              RD_DATPGT With Iif(!Empty((cAliasTMP)->RD_DATPGT),stod((cAliasTMP)->RD_DATPGT),Lastday(stod((cAliasTMP)->RD_DATARQ+'01'))+1),;
              RD_DATARQ With (cAliasTMP)->RD_DATARQ,;
              RD_MES    With Right((cAliasTMP)->RD_DATARQ,2),;  
              RD_TIPO1  With 'V',;
              RD_TIPO2  With 'I',;
              RD_HORAS  With 1,;
              RD_VALOR  With (cAliasTMP)->RD_VALOR,;
              RD_STATUS With 'A',;
              RD_CC     With (cAliasTMP)->RD_CC,;
              RD_FGTS   With 'N',;
              RD_INSS   With 'N',;
              RD_IR     With 'N'
              
              
      SRD->(MsUnlock())
   Endif
   (cAliasTMP)->(dbSkip())
End
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbCloseArea())
*/    

While .T.
   IncProc('Ajustasnto tabela srd')
End
MsgStop("Kbo")

Return