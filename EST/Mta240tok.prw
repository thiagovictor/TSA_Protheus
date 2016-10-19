User Function Mt240tok()
***********************************************************************************************************************
* Esta rotina tem como Objetivo validar o campo D3_CBASE(Código do Bem) para as requisições de ampliação do BEM
*
*****
Local lRet:=.T.

If M->D3_TM$GetMv('MV_TMAMPL',,'801') .And. (Empty(M->D3_CODBEM))
	MsGBox('Para este tipo de Movimentação é necessário informar o código do BEM')
	lRet:=.f.
Endif

Return(lRet)
