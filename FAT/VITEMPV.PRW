#Include "Rwmake.ch"
/*
+-----------+------------+----------------+------------------+--------+------------+
| Programa  | VITEMPV    | Desenvolvedor  | Davis Magalhaes  | Data   | 29/05/2003 |
+-----------+------------+----------------+------------------+--------+------------+
| Descricao | Validação da Digitação do Item da LM no Pedido de Venda              |
+-----------+----------------------------------------------------------------------+
| Uso       | Especifico EPC/TSA                                                   |
+-----------+----------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                      |
+-------------+---------+----------------------------------------------------------+
| Humano      | Data    | Motivo                                                   |
+-------------+---------+----------------------------------------------------------+
+-------------+---------+----------------------------------------------------------+
*/

User Function VITEMPV()


Local nPosITEM      := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM" })
Local nPosITLM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEMLM" })
Local nContAux      := 0
Local cChvProc      := ""
Local cItemAtu      := ""
Local lItemOk       := .T.

                        
cChvProc := M->C6_ITEMLM

If Empty(M->C6_ITEMLM)
   Return(.T.)
EndIf


For nContAux = 1 To Len(aCols)

    If Empty(aCols[ nContAux,nPosITEM ])
       Exit
    Endif 
    
    If nContAux # n 
       If aCols[ nContAux,nPosITLM ] == cChvProc
          cItemAtu := aCols[ nContAux,nPosITEM ]                           
          
          MSGBOX("Item da LM já foi informado no Item "+cItemAtu+" desse Pedido", "..: ATENCAO :..","STOP")
          lItemOk := .F.
          Exit
       EndIf
    EndIf
Next nContAux

Return(lItemOk)