#include "rwmake.ch"

User Function VldSubCta()
********************************************************************************************************************
* Valida a Conta, SubConta, Cliente
*
****
Local lRet:=.t.
If M->AF9_X_CONT<>'' .And. M->AF8_CLIENT<>'' .And. Posicione("SZ1",1,Xfilial("SZ1")+M->AF8_X_CONT,"Z1_CODCLI")<>M->AF8_CLIENT
	MsgBox("Código do Cliente difere do")
Endif

Return(lRet)

