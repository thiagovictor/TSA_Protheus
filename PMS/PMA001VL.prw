User Function PMA001VL()
*********************************************************************************************************************
*
*
*****
Local x:=0

For nx=1 to len(aTxt)
	aTxt[nx,3]:=Upper(NoAcento(AnsiToOem(aTxt[nx,3])))
Next nx


Return(.t.)