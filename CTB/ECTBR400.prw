#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
+------------------------------------------------------------------------------------+
¦Programa  ¦ ECTBR400A ¦ Autor ¦ Gilson Lucas                      ¦Data ¦14.11.2011  ¦
+----------+-------------------------------------------------------------------------¦
¦Descricao ¦ Encapsulamento Razao Contabil para Liberar Personalizacao               |
+----------+-------------------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA PARÂMETROS DE BLOQUEIO                                  ¦
+------------------------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                         ¦
+------------------------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             	         ¦
+------------+--------+--------------------------------------------------------------¦
¦            ¦        ¦                                                		         ¦
+------------------------------------------------------------------------------------+
*/
User Function ECTBR400()

//Habilita Tecla F7 para Liberar Personalizacao
SetKey( VK_F7 , { || FReDefRel() } )

//Chama Relatorio Padrao
CTBR400()

//Desabilita Tecla F7
SetKey( VK_F7 , { || Nil } )

Return


Static Function FReDefRel()
********************************************************************************************
* Redefinao Personalizacao
***
Local nXi

For nXi:=1 To Len(oReport:aSection)
    oReport:aSection[nXi]:lReadOnly:=.f.
    oReport:aSection[nXi]:LEDIT := .T.
Next nXi

MsgBox(OemToAnsi("Personalização de Layout Permitida!"),OemToAnsi("Atenção!"),"INFO")

Return