#include "rwmake.ch"        
User Function LP65002()

Local nTotal   :=  0    // Soma o total por item
Local cMenosIS := "S"   // Utilizada para auxiliar na verificacao do IS

nTotal := SF1->F1_ISS

Return(nTotal)