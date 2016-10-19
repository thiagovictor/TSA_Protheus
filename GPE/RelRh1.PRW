#Include "PROTHEUS.Ch"
#Include "TopConn.ch"
/*
+-----------+------------+----------------+---------------+--------+------------+
| Programa  | RelRh    |Desenvolvedor  | Jane Duval   | Data       | 17/04/07   |
+-----------+------------+----------------+---------------+--------+------------+
| Descricao | Relatorio Funcionario por Gerencia                                |
+-----------+-------------------------------------------------------------------+
| Uso       | Expecifico EPC/TSA                                                |
+-----------+-------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                   |
+-------------+---------+-------------------------------------------------------+
|Desenvolvedor| Data    | Motivo                                                |
+-------------+---------+-------------------------------------------------------+
+-------------+---------+-------------------------------------------------------+
*/
User Function RelRh()
******************
// Define Variaveis
Local   aPerg     :={}
Local   cPerg    	:="RELFRH"
Private titulo   := "Funcionário por Gerência"
Private wnrel    := "RelRh"           

AADD(aPerg,{cPerg,"Filial De      ?","C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Filial Ate     ?","C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"CCusto De      ?","C",05,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"CCusto Ate     ?","C",05,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Funcao De      ?","C",04,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Funcao Ate     ?","C",04,0,"G","","","","","","",""}) 
AADD(aPerg,{cPerg,"Tipo Func      ?","N",01,0,"C","","","Todos","CLT","PJ","EST",""})
AADD(aPerg,{cPerg,"Data Ref De    ?","D",08,0,"G","","","","","","",""}) 
AADD(aPerg,{cPerg,"Data Ref Ate   ?","D",08,0,"G","","","","","","",""})   
AADD(aPerg,{cPerg,"Quebra pagina  ?","N",01,0,"C","","","Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Tipo Relatorio ?","N",01,0,"C","","","Analítico","Sintético","","",""})     


ExecBlock("TestaSX1",.F.,.F.,{cPerg,aPerg})

Pergunte(cPerg,.T.)

cFilDe       :=MV_PAR01
cFilAte      :=MV_PAR02
cCustoDe     :=MV_PAR03
cCustoAte    :=MV_PAR04
cFuncaoDe    :=MV_PAR05
cFuncaoAte   :=MV_PAR06
nTipoFunc    :=MV_PAR07
cDatRefDe    :=DTOS(MV_PAR08)
cDatRefAte   :=DTOS(MV_PAR09)
cQPagina     :=StrZero(MV_PAR10,1)
cTipoRel     :=StrZero(MV_PAR11,1)

cCabecalho := "Processando os Dados"
cMsgRegua  := "Processando "

Processa( {|| GravTrab()} ,"Processando os Dados","Aguarde....")

cOptions:="1;0;1;Funcionários"
cParams := '"'+cQPagina+'";"'+cTipoRel+'"'

Callcrys("RelRH",cParams,cOptions)

Return()
        

Static Function GravTrab()
*********************************************************************************************************
*
*
****

TcSqlExec("DROP TABLE R_RELRH")
cQuery:= "SELECT RA_FILIAL AS FILIAL,RA_MAT AS Matricula ,RA_NOME AS Nome ,RA_ADMISSA AS Admissao, RA_CC AS CCusto ,CTT.CTT_DESC01 AS Setor ,SRJ.RJ_FUNCAO AS CodFunc,"
cQuery+= " SRJ.RJ_DESC AS Funcao,CTTGER.CTT_CUSTO as CCUSTOGEN,CTTGER.CTT_DESC01 AS Gerencia,RA_DEMISSA AS Demissao, "
cQuery+= " (CASE WHEN RA_FILIAL = 97 THEN 'PJ'"
cQuery+= "     ELSE CASE WHEN (RA_FILIAL <>97 AND RA_CATFUNC ='E') THEN 'EST'"
cQuery+= "               ELSE 'CLT'   "                
cQuery+= "          END  " 
cQuery+= " END) AS Tipo"
cQuery+= " INTO  R_RELRH "
cQuery+= " FROM "+RetSqlName("SRA")+" SRA "
cQuery+= " INNER JOIN "+RetSqlName("CTT")+" CTT ON (CTT_CUSTO=RA_CC AND CTT.D_E_L_E_T_<>'*') "   
cQuery+= " INNER JOIN "+RetSqlName("CTT")+" CTTGER ON (CTTGER.CTT_CUSTO=LEFT(SRA.RA_CC,2)+'000' AND CTTGER.D_E_L_E_T_<>'*') "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SRJ")+" SRJ ON (SRJ.RJ_FUNCAO=RA_CODFUNC AND SRJ.D_E_L_E_T_<>'*') "
cQuery+= " WHERE "   
cQuery+= "  SRA.D_E_L_E_T_<>'*'  "
cQuery+= " AND SRA.RA_FILIAL  >= '"+cFilDe+  "'  AND  SRA.RA_FILIAL  <='"+cFilAte+"'"
cQuery+= " AND CTT.CTT_CUSTO  >= '"+cCustoDe+"'  AND  CTT.CTT_CUSTO  <='"+cCustoAte+"'"
cQuery+= " AND SRA.RA_CODFUNC >= '"+cFuncaoDe+"' AND  SRA.RA_CODFUNC <='"+cFuncaoAte+"'"  
Do Case
	Case nTipoFunc == 2
	     cQuery+= "AND RA_FILIAL <>'97' AND RA_CATFUNC <> 'E'" 
	Case nTipoFunc == 3 
        cQuery+= " AND RA_FILIAL = '97'"
 	Case nTipoFunc == 4 
		  cQuery+= " AND	RA_CATFUNC = 'E'
EndCase   
cQuery+= "AND RA_ADMISSA >='"+cDatRef+"'"  
cQuery+= "AND (RA_DEMISSA <'"+cDatRef+"'OR RA_DEMISSA='')"

TcSqlExec(cQuery)

Return()
