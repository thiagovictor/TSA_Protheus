
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function LPATF()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local cHISTORICO

If SubStr(DTOC(SE5->E5_DATA),1,2)> "28"  .and. SubStr(DTOC(SE5->E5_DATA),4,2) < "11"
   cHistorico:= "CX: 01/"+SubStr(DTOC(SE5->E5_DATA),4,2) + "2" + SubStr(DTOC(SE5->E5_DATA),9,2)+" RF: 01/" +SubStr(DTOC(SE5->E5_DATA),4,2)+"1"+SubStr(DTOC(SE5->E5_DATA),9,2)
Endif
If SubStr(DTOC(SE5->E5_DATA),1,2)> "28"  .and. SubStr(DTOC(SE5->E5_DATA),4,2) = "11"
   cHistorico:= "CX: 01/01" + SubStr(DTOC(SE5->E5_DATA),9,2)+"1"+" RF: 01/12"+SubStr(DTOC(SE5->E5_DATA),9,2)  
Endif   
If SubStr(DTOC(SE5->E5_DATA),1,2)> "28"  .and. SubStr(DTOC(SE5->E5_DATA),4,2) = "12"
   cHistorico:= "CX: 01/02" + SubStr(DTOC(SE5->E5_DATA),9,2)+"1"+" RF: 01/01"+SubStr(DTOC(SE5->E5_DATA),9,2)+"1"  
Endif   
                                                                            
If SubStr(DTOC(SE5->E5_DATA),1,2)< "28"  .and. SubStr(DTOC(SE5->E5_DATA),4,2) < "11"
   cHistorico:= "CX: 01/"+SubStr(DTOC(SE5->E5_DATA),4,2) + "1" + SubStr(DTOC(SE5->E5_DATA),9,2)+" RF: 01/" +SubStr(DTOC(SE5->E5_DATA),4,7)
Endif
If SubStr(DTOC(SE5->E5_DATA),1,2)< "28"  .and. SubStr(DTOC(SE5->E5_DATA),4,2) = "11"
   cHistorico:= "CX: 01/12" + SubStr(DTOC(SE5->E5_DATA),9,2) +" RF: 01/11"+ SubStr(DTOC(SE5->E5_DATA),9,2)  
Endif   
If SubStr(DTOC(SE5->E5_DATA),1,2)< "28"  .and. SubStr(DTOC(SE5->E5_DATA),4,2) = "12"
   cHistorico:= "CX: 01/01" + SubStr(DTOC(SE5->E5_DATA),9,2)+"1"+" RF: 01/12"+SubStr(DTOC(SE5->E5_DATA),9,2)  
Endif   
  
//Restaurando Ambiente
RestArea(aArea)

Return(cHistorico)