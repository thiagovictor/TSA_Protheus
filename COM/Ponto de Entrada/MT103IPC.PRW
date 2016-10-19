#include "rwmake.ch"
//############################
//##  PONTO DE ENTRADA PARA CARREGAR A DESCRICAO DO PRODUTO QUE ESTA NO PEDIDO DE COMPRAS
//############################

User function MT103IPC

Local nPdescri := aScan(aHeader,{|x| Trim(x[2])=="D1_DESCRIC"})  
Local nMesentr := aScan(aHeader,{|x| Trim(x[2])=="D1_DTREF"})  
ACOLS[PARAMIXB[1],nPdescri] := SC7->C7_DESCRI
ACOLS[PARAMIXB[1],nMesentr] := SC7->C7_DATPRF

Return .T.
