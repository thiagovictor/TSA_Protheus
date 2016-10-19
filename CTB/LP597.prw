#include "rwmake.ch"

User Function LP597()

IIF(SE5->E5_MOTBX=="CMP" .AND. ALLTRIM(SE5->E5_TIPO) = "PA" .AND. SUBSTR(SE5->E5_DOCUMEN,10,3)<>"ACV",SE5->E5_VALOR,0)

Return