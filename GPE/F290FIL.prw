User function F290FIL()
********************************************************************************************************************
* Faz um filtro baseando nos títulos de Fatura a pagar somente dos titulos de ISS
*
*****
Local cFilt:=""
If cTipo=='ISS'
	// Solicita ao usuário o arquivo gerado pelo sistema ISS - DIGITAL
	AADD(aPerg,{cPerg,"Nome do Arquivo ISS DIGITAL ?","C",60,0,"G","!Empty(MV_PAR01)","","","","","",""})
   ExecBlock("TestaSX1",.F.,.F.,{cPerg,aPerg})
   If  Pergunte('ISSDI',.T.)
   	cFile:=MV_PAR01
		cFilt:=PrcTitISS(cFile)   	
   Endif
Endif
Return(cFilt)



User Function PrcTitISS()
********************************************************************************************************************
*
*
*****
Local cFilt:=""
Local nFile:=0
Local nLidos :=0

nFile:=Fopen(cFile)
nTamFile := Fseek(nFile,0,2)
FSeek(nFile,0,0)
nLidos := 0
While nLidos < nTamFile
	nTamReg :=
   FRead(nFile,@cBuffer,nTamReg)
   nLidos := nLidos+nTamReg
EndDo
FCLOSE(nHdlAlca)

Return()
