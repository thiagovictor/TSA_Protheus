#Include 'RwMake.ch'

User Function FINA580A

If RecLock("SE2",.F.)
   Replace E2_DATALIB With dDataBase
   SE2->(MsUnLock())
EndIf
				
Return