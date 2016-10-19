/*
+-----------------------------------------------------------------------+
¦Programa  ¦ FA050PAR ¦ Autor ¦ Crislei de A. Toledo  ¦ Data ¦06.07.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Ponto de Entrada na rotina de Contas  a Pagar no Desdobra- ¦
¦          ¦ mento do titulo.                                           ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 |
+-----------------------------------------------------------------------+
*/

#include "rwmake.ch"

User Function FA050PAR()

//ATUALIZA DATA DE REFERENCIA DOS TITULOS GERADOS PELO DESDOBRAMENTO.
//Replace E2_EMISSAO With CTOD("01/"+StrZero(Month(SE2->E2_VENCREA),2)+"/"+StrZero(Year(SE2->E2_VENCREA),4))
Replace E2_DATAREF With CTOD("01/"+StrZero(Month(SE2->E2_VENCREA),2)+"/"+StrZero(Year(SE2->E2_VENCREA),4))


Return()