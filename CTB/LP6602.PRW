#include "rwmake.ch"        
User Function LP6602()

Local nTotal   :=  0    // Soma o total por item
Local cMenosIR := "S"   // Utilizada para auxiliar na verificacao do IR

nTotal := SF1->F1_IRRF

Return(nTotal)