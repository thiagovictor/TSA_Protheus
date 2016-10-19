/*
+----------------------------------------------------------------------------+
¦Programa  ¦ VALIDNAT ¦ Autor ¦ Crislei de Almeida Toledo  ¦ Data ¦27.02.2006¦
+----------+-----------------------------------------------------------------+
¦Descriçào ¦ Validacao do codigo da natureza                                 ¦
+----------+-----------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                             ¦
+----------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 ¦
+----------------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                  ¦
+------------+--------+------------------------------------------------------+
¦            ¦        ¦                                                      |
+----------------------------------------------------------------------------+
*/

#INCLUDE "RWMAKE.CH"

User Function ValidNat()

Local lRet := .T.

If Len(AllTrim(M->ED_CODIGO)) <> 1 .And. ;
   Len(AllTrim(M->ED_CODIGO)) <> 3 .And. ; 
   Len(AllTrim(M->ED_CODIGO)) <> 5
   MsgBox("Codigo da Natureza podera ter apenas 1, 3 ou 5 digitos!","Cadastro de Naturezas","SOTP")
   lRet := .F.
EndIf

If !(SubStr(AllTrim(M->ED_CODIGO),1,1) $ "1/2/3")
   MsgBox(OemToAnsi("Codigo da Natureza deverá começar com o digito, 1, 2 ou 3"),"Cadastro de Naturezas","STOP")
   lRet := .F.
EndIf
   
Return(lRet)