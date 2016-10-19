#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#INCLUDE "Topconn.ch"
User Function MIGRASET()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
Private nstnovo:=1
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MIGRASET ³ Autor ³Reginaldo Santos       ³ Data ³ 28/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Importacao Cadastro de Setores                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
ProcMigra()

Static Function ProcMigra()

Processa( {|| RunProc() },"Migracao do Cad. de Setores","Importando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(RunProc) },"Migracao do Cad. de Setores","Importando Registro ..." )


Return(nil)       


Static Function RunProc()

Local cQuery:=""
cQuery :="SELECT * FROM IMP_Z4_VW " // VIEW VINCULADA AO BANCO PERSONNE
TCQUERY cQuery ALIAS "DES" NEW

DbSelectArea("DES")
dbGoTop()

While ! Eof()
	IncProc("Gravando Registro : "+StrZero(Recno(),6))
	DbSelectArea("SZ4")
	dbSetOrder(1)
	If ! DbSeek(xFilial("SZ4")+SUBSTR(DES->CODIGO,2,5))
		If RecLock("SZ4",.T.)
			Replace Z4_FILIAL   With XFilial("SZ4")
			Replace Z4_SETOR    With SUBSTR(DES->CODIGO,2,5)
			Replace Z4_DESC     With DES->DESCRICAO
			Replace Z4_SIGLA    With DES->SIGLAGER
			nSTNovo := nSTNovo + 1
			MsUnlock()
		EndIf
	EndIf
	DbSelectArea("DES")
	DbSkip()
EndDo

dbSelectArea("DES")
Use

MSGBOX(Str(nStNovo,6) + " Novos Registros Incluidos Com Exito !","INFO" )

Return

