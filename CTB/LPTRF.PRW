
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function LPTRF()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local cHISTORICO
                                                                                    
If SubStr(DTOC(SE5->E5_DATA),1,2)>= "28" 
   if SubStr(DTOC(SE5->E5_DATA),4,2) < "08"
      cHistorico:= "CX:01/0"+alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),4,2))+2))+"/" + SubStr(DTOC(SE5->E5_DATA),7,2)+" RF:01/0" +alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),4,2))+1))+"/" +SubStr(DTOC(SE5->E5_DATA),7,2)
      elseIf SubStr(DTOC(SE5->E5_DATA),4,2) <= "10"
      cHistorico:= "CX:01/"+alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),4,2))+2))+"/" + SubStr(DTOC(SE5->E5_DATA),7,2)+" RF:01/" +alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),4,2))+1))+"/" +SubStr(DTOC(SE5->E5_DATA),7,2)
      elseIf SubStr(DTOC(SE5->E5_DATA),4,2) = "11"
      cHistorico:= "CX:01/01/0" + alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),7,2))+1))+" RF:01/12/"+SubStr(DTOC(SE5->E5_DATA),7,2)  
      elseif SubStr(DTOC(SE5->E5_DATA),4,2) = "12"
      cHistorico:= "CX:01/02/0" + alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),7,2))+1))+" RF:01/01/0"+alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),7,2))+1))
   Endif
Endif   

                                                                            
If SubStr(DTOC(SE5->E5_DATA),1,2)< "28"  
   if SubStr(DTOC(SE5->E5_DATA),4,2)< "08"
      cHistorico:= "CX:01/0"+alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),4,2))+1))+"/" + SubStr(DTOC(SE5->E5_DATA),7,2)+" RF:01/" +SubStr(DTOC(SE5->E5_DATA),4,2)+"/"+SubStr(DTOC(SE5->E5_DATA),7,2)
      elseif SubStr(DTOC(SE5->E5_DATA),4,2) <= "10" 
      cHistorico:= "CX:01/"+alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),4,2))+1))+"/" + SubStr(DTOC(SE5->E5_DATA),7,2)+" RF:01/" +SubStr(DTOC(SE5->E5_DATA),4,2)+"/"+SubStr(DTOC(SE5->E5_DATA),7,2)
      elseIf SubStr(DTOC(SE5->E5_DATA),4,2) = "11"
      cHistorico:= "CX:01/12/" + SubStr(DTOC(SE5->E5_DATA),7,2) +" RF:01/11/"+ SubStr(DTOC(SE5->E5_DATA),7,2)  
      elseIf SubStr(DTOC(SE5->E5_DATA),4,2) = "12"
      cHistorico:= "CX:01/01/" + alltrim(str(val(SubStr(DTOC(SE5->E5_DATA),7,2))+1))+" RF:01/12/"+SubStr(DTOC(SE5->E5_DATA),7,2)  
   Endif
Endif   
  
//Restaurando Ambiente
//RestArea(aArea)

Return (cHistorico)  
