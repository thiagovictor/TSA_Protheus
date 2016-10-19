
#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"
       

User Function CADSZX()        


cCadastro:="Cadastro de Contrato X Atividades FIP"
aRotina:={{"Pesquisar" ,"AxPesqui",0,1},;
          {"Visualizar","AxVisual",0,2},;
          {"Incluir"   ,"AxInclui",0,3},;
          {"Alterar"   ,"AxAltera",0,4},;
          {"Excluir"   ,"AxDeleta",0,5},;
          {"Copia Atividades "   ,"U_PergCont",0,5}}

dbSelectArea("SZX") 
dbSetOrder(1)       

mBrowse(06,08,22,71,"SZX")

Return  

User Function PergCont(cAlias,nRecno,nOpc)
****************************************************************************************************************
*
*
*****
aPerg := {}
cPerg :="COPATI"
AADD(aPerg,{cPerg,"Contrato Origem ?","C",05,0,"G","  ExistCpo('SZ1',MV_PAR01)","","","","","",""}) 
AADD(aPerg,{cPerg,"Contrato Destino ?","C",05,0,"G"," ExistCpo('SZ1',MV_PAR02)","","","","","",""}) 



If Pergunte(cPerg,.T.).AND. MV_PAR01 <> MV_PAR02
	U_CopAtiv()
ELSE 
   Alert('Codigo do Contrado de Origem  e Destino Iguais')
EndIf
                                    
Return() 



User Function CopAtiv() 
****************************************************************************************************************
* Faz a Cópia das atividades para o contrato
*
*****
 
Local cQuery:=""

//Compatibiliza o tamanho com campo
MV_PAR02:=MV_PAR02+Space(20-len(MV_PAR02))

dbSelectArea("SZX") 
cQuery:=" SELECT ZX_CODATIV "
cQuery+=" FROM "+RetSqlName("SZX")+" SZX "
cQuery+=" WHERE  SZX.D_E_L_E_T_<>'*' AND   ZX_CCUSTO = '" +MV_PAR01+ "'"  
TCQUERY cQuery Alias QTMP New
dbSelectArea("QTMP")         

dbGotop()
If !EOF()  
	While !Eof()	
		dbSelectArea("SZX") 
		dbSetOrder(1)
		RecLock('SZX',!dbSeek(Xfilial("SZX")+MV_PAR02+QTMP->ZX_CODATIV)) 
		Replace ZX_CCUSTO  With MV_PAR02
		Replace ZX_CODATIV With QTMP->ZX_CODATIV 		
	  	MsunLock()
		dbSelectArea("QTMP")
		dbSkip()
	EndDo 
	Alert ("Atividade copiada com sucesso!")  
ELSE
	Alert ("Contrato não tem Atividades Cadastradas")
EndIf
dbCloseArea("QTMP")
Return()


