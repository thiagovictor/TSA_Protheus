#Include "Rwmake.ch"
/*
+-----------+------------+----------------+------------------+--------+------------+
| Programa  | VITEMPC    | Desenvolvedor  | Davis Magalhaes  | Data   | 28/05/2003 |
+-----------+------------+----------------+------------------+--------+------------+
| Descricao | Validação da Digitação do Item da LM e Nº da EPC no Pedido de Compra |
+-----------+----------------------------------------------------------------------+
| Uso       | Especifico EPC/TSA                                                   |
+-----------+----------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                      |
+-------------+---------+----------------------------------------------------------+
| Humano      | Data    | Motivo                                                   |
+-------------+---------+----------------------------------------------------------+
+-------------+---------+----------------------------------------------------------+
*/

User Function VITEMPC()


Local nPosITEM      := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEM" })
Local nPosITLM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEMLM" })
Local nPosNEPC      := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_NEPC" })
Local nContAux      := 0
Local cChvProc      := ""
Local cItemAtu      := ""
Local lItemOk       := .T.

                        
//cChvProc := (aCols[ n,nPosNEPC ])+(aCols[ n,nPosITLM ])
If ! Empty(aCols[ n,nPosNEPC ])
   cChvProc := (aCols[ n,nPosNEPC ])+M->C7_ITEMLM
EndIf

If Empty(aCols[ n,nPosNEPC ]) .And. Empty(M->C7_ITEMLM)
   Return(.T.)
EndIf

If ! Empty(aCols[ n,nPosNEPC ]) .And. Empty(M->C7_ITEMLM)
   MSGBOX("O Item da LM nao pode ser em branco, pois foi digitado numero Interno da EPC.","..: ATENCAO :..","STOP")
   Return(.F.)
EndIf

If Empty(aCols[ n,nPosNEPC ]) .And. ! Empty(M->C7_ITEMLM)
   MSGBOX("O Item da LM nao pode ser preenchido, pois nao foi digitado numero Interno da EPC.","..: ATENCAO :..","STOP")
   Return(.F.)
EndIf

For nContAux = 1 To Len(aCols)

    If Empty(aCols[ nContAux,nPosITEM ])
       Exit
    Endif 
    
    If nContAux # n 
       If (aCols[ nContAux,nPosNEPC ] + aCols[ nContAux,nPosItLM ]) == cChvProc
          cItemAtu := aCols[ nContAux,nPosITEM ]                           
          
          MSGBOX("Numero Iterno EPC ou Item da LM já foram informados no Item "+cItemAtu+" desse Pedido", "..: ATENCAO :..","STOP")
          lItemOk := .F.
          Exit
       EndIf
    EndIf
Next nContAux

Return(lItemOk)
