/*
+-----------------------------------------------------------------------------+
| Programa  |IniPadSFC | Desenvolvedor |                     | Data |         |
|-----------------------------------------------------------------------------|
| Descricao |  Inicializador Padrão dos Campos da EDT                         |
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC                                                  |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  | 
+--------------+-----------+--------------------------------------------------+
*/
User Function IniPadAFC()
**********************************************************************************************************************
*
*
*****
Local aVldCmp:={}
Local nPos:=0
Local cRet:=""

Aadd(aVldCmp,{"AFC_ARNEG"  ,'002','0',AF8->AF8_ARNEG })
Aadd(aVldCmp,{"AFC_TIPPRJ" ,'005',Replicate('0',TamSx3("AFC_TIPPRJ")[1]),AFC->AFC_TIPPRJ})
Aadd(aVldCmp,{"AFC_DISC"   ,'006',Replicate('0',TamSx3("AFC_DISC")[1])  ,AFC->AFC_DISC  })
Aadd(aVldCmp,{"AFC_SUBDIS" ,'007',Replicate('0',TamSx3("AFC_SUBDIS")[1]),AFC->AFC_SUBDIS})
Aadd(aVldCmp,{"AFC_ESCOPO" ,'008',Replicate('0',TamSx3("AFC_ESCOPO")[1]),AFC->AFC_ESCOPO})

nPos:=Ascan(aVldCmp,{|x| x[1]==AllTrim(SX3->X3_CAMPO)})
If nPos>0
	If (Val(AFC->AFC_NIVEL)+1)==Val(aVldCmp[nPos,2]) // Sequencia Obrigatória
		cRet:=Space(SX3->X3_TAMANHO)
		
	ElseIf (Val(AFC->AFC_NIVEL)+1) < Val(aVldCmp[nPos,2]) // Sequencia Acima valor da EDT anterior
		cRet:=aVldCmp[nPos,3]
		
	Else	
		cRet:=aVldCmp[nPos,4] // Sequencia abaixo -> '0000' Não se Aplica
		
	Endif	
Endif	
	
Return(cRet)