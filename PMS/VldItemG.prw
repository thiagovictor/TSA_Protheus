/*
+-----------------------------------------------------------------------------+
| Programa  |CadSZM | Desenvolvedor |                     | Data |            |
|-----------------------------------------------------------------------------|
| Descricao |  Valida os Campo com Informações                                |
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

User Function VldItemG()
*******************************************************************************************************************
*
*
******
Local aVldCmp:={}
Local lRet:=.T.	
Local cMens:=""
Local cEol:=Chr(13)+Chr(10)
//Já esta posicionado no AFC
If M->AFC_NIVEL<>'001'
	If (StrZero(Val(M->AFC_NIVEL)-1,3)==AFC->AFC_NIVEL)
		Aadd(aVldCmp,{M->AFC_ARNEG  ,'002','Area de Negócio',AFC->AFC_ARNEG  })
		Aadd(aVldCmp,{M->AFC_TIPPRJ ,'005','Tipo de Projeto',AFC->AFC_TIPPRJ })
		Aadd(aVldCmp,{M->AFC_DISC   ,'006','Disciplina'     ,AFC->AFC_DISC   })
		Aadd(aVldCmp,{M->AFC_SUBDISC,'007','Sub-Disciplina' ,AFC->AFC_SUBDISC})
		Aadd(aVldCmp,{M->AFC_ESCOPO ,'008','Escopo'         ,AFC->AFC_ESCOPO })
		
		
		
		For nXi:=1 To aVldCmp
			If !M->AFC_NIVEL$'003/004'
				If Val(M->AFC_NIVEL) = Val(aVldCmp[nXi,2])
					If Empty(aVldCmp[nXi,1])
						cMens+="Campo:"+aVldCmp[nXi,3]+" Não Preenchido para o Nível "+M->AFC_NIVEL+" da Estrutura."+cEol
					Else
						If aVldCmp[nXi,1]<>aVldCmp[nXi,2]
							cMens:="Campo:"+aVldCmp[nXi,3]+" Deve ter o mesmo ter o mesmo conteudo da EDT anterior "+cEol
						Endif					
					Endif	
				Else
					If Val(M->AFC_NIVEL) > Val(aVldCmp[nXi,2])
						If aVldCmp[nXi,1]<>aVldCmp[nXi,2]
							cMens:="Campo:"+aVldCmp[nXi,3]+" Deve ter o mesmo ter o mesmo conteudo da EDT anterior "+cEol
						Endif										
					Endif
				Endif
			Endif
		Next nXi
	Endif	
Endif
	
Return()