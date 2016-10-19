#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ACRTSB1A()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Processa( {|| AcerSB1A() },"Acertando as Descricoes do SB1","Alterando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(AcerSB1A) },"Acertando as Descricoes do SB1","Alterando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function AcerSB1A
Static Function AcerSB1A()

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())

While ! Eof()

   IncProc("Alterando Produto : "+Left(SB1->B1_DESC,20))

   DbSelectArea("SB1")
   Reclock("SB1",.F.)
   Replace B1_DESC    With Alltrim(SB1->B1_DESCDET)
//   Replace B1_DESCDET With ""
   Replace B1_DESC2   With ""
   Replace B1_DESC3   With ""
   Replace B1_DESC4   With ""
   MsUnlock()

   DbSelectArea("SB1")
   DbSkip()

EndDo

Return

