/*
+----------------------------------------------------------------------------+
¦Programa  ¦ VNATANALI¦ Autor ¦ Crislei de Almeida Toledo  ¦ Data ¦27.02.2006¦
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

User Function VNatAnali()

Local lRet       := .T.
Local cCmpNat    := ReadVar()
Local cClasseNat := ""

cClasseNat := Posicione("SED",1,xFilial("SED")+&cCmpNat,"ED_CLASSE")

If cClasseNat <> "A"
   MsgBox(OemToAnsi("A natureza informada é sintética. Informe uma Natureza da classe Analitica!"),"Valida Natureza","STOP")
   lRet := .F.
EndIf

Return(lRet)
