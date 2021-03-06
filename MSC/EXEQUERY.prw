/*
+-------------+---------+-------------+-------------------+-------+----------------------+
| Programa    |EXEQUERY | Programador | Wladimir R.Fernan | Data  | 10/02/03             |
+-------------+---------+-------------+-------------------+-------+----------------------+
| Descricao   | Querys de atualizacao de dados                                           |
+-------------+--------------------------------------------------------------------------+
| Uso         | Especifico para EPC                                                      |
+-------------+--------------------------------------------------------------------------+
|                          Modificacoes efetuadas no Programa                            |
+---------+-------------+----------------------------------------------------------------+
| Data    | Responsavel | Motivo                                                         |
+---------+-------------+----------------------------------------------------------------+
|         |             |                                                                |
+---------+-------------+----------------------------------------------------------------+
*/

#include "rwmake.ch"      
#include "TopConn.ch"

User Function EXEQUERY(cAno)
************************************************************************************
*
*
****
Local cQuery:=""
/*
cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET Z0_SITUACA ='PROPOSTA EM ANDAMENTO' "
cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND LEFT(Z0_CC,4)='8100' " 
cQuery+="       AND Z0_REVISAO<>'' "
cQuery+="       AND NOT '000034' IN (SELECT ZA_GRUPGER FROM SZA010 WHERE ZA_CONTA=Z0_CONTA ) "
TcSqlExec(cQuery)

cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET Z0_SITUACA ='METAS DE VENDAS' "
cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND LEFT(Z0_CC,4)='8110' "
cQuery+="       AND Z0_REVISAO<>''   "
cQuery+="       AND NOT '000034' IN (SELECT ZA_GRUPGER FROM SZA010 WHERE ZA_CONTA=Z0_CONTA) "
TcSqlExec(cQuery)

cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET Z0_SITUACA ='ESTIMADO' "
cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND (NOT LEFT(Z0_CC,4) IN ('8100','8110')) "
cQuery+="       AND Z0_REVISAO<>''                      "
cQuery+="       AND (NOT '000034' IN (SELECT ZA_GRUPGER FROM SZA010 WHERE ZA_CONTA=Z0_CONTA )) "
TcSqlExec(cQuery)

cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET Z0_SITUACA ='Mao de Obra a Disposicao' "
cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND (NOT LEFT(Z0_CC,4) IN ('8100','8110')) "
cQuery+="       AND Z0_REVISAO<>'' "
cQuery+="       AND LEFT(Z0_CC,3) IN ('932') "
cQuery+="       AND right(Z0_CC,1)IN ('H')  "
cQuery+="       AND (NOT '000034' IN (SELECT ZA_GRUPGER FROM SZA010 WHERE ZA_CONTA=Z0_CONTA )) "
TcSqlExec(cQuery)

cQuery:=" UPDATE "+RetSqlName("SZ0")+"0 SET Z0_SITUACA ='REALIZADO' "
cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_REVISAO='' "
TcSqlExec(cQuery)

cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET Z0_SITUACA ='INVESTIMENTO' "
cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_REVISAO<>''     "
cQuery+="       AND ('000034' IN (SELECT ZA_GRUPGER FROM SZA010 WHERE ZA_CONTA=Z0_CONTA )) "
*/
   	nFile:=FCreate("ExecQueryFluxo.txt")
//	FWrite(nFile,"Ano:"+cAno+Chr(13)+Chr(10))
	FWrite(nFile,"Inicio do Calculo:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))
   	FClose(nFile)

TcSqlExec(cQuery)
//O grupo Gerencial j� preenchido deve deve ser tratado separadamente
   cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET "
	cQuery+="       Z0_VRPREV  =isNull(SZ1.Z1_VRPREV ,0 ), "
	cQuery+="       Z0_PROP    =IsNull(SZ2.Z2_PROP   ,''), "
	cQuery+="       Z0_SITUAC  =IsNull(SZ2.Z2_SITUAC ,''), "
	cQuery+="       Z0_DESC01  =IsNull(CT1.CT1_DESC01,''), "
	cQuery+="       Z0_FATOR   =IsNull(CT1.CT1_FATOR ,1 ), "
	cQuery+="       Z0_CODCONT =IsNull(SZ1.Z1_COD    ,''), "
	cQuery+="       Z0_DESCSET =IsNull(CTT.CTT_DESC01,''), "
	cQuery+="       Z0_DESGER  =IsNull(SZA.ZA_DESCRI ,''), "
	cQuery+="       Z0_FATORE  =IsNull(SZA.ZA_FATOR  ,1 ), "
	cQuery+="       Z0_CLIENTE =IsNull(SA1.A1_NREDUZ ,''), "
	cQuery+="       Z0_OS      =IsNull(SZ2.Z2_OS     ,''), "
	cQuery+="       Z0_SUBCTA  =Left(Z0_CC,5) ,"
	cQuery+="       Z0_SETOR   =IsNull(SZ2.Z2_SETOR,'')"   
	cQuery+=" FROM "+RetSqlName("SZ0")+" SZ0 "
	cQuery+="	Left Outer Join "+RetSqlName("CT1")+" CT1 ON (SZ0.Z0_CONTA = CT1.CT1_CONTA AND CT1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ2")+" SZ2 ON (SZ0.Z0_CC    = SZ2.Z2_SUBC   AND SZ2.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("CTT")+" CTT ON (SZ2.Z2_SETOR = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ1")+" SZ1 ON (SZ1.Z1_COD   = SZ2.Z2_COD    AND SZ1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZA")+" SZA ON (SZ0.Z0_GRUPGER = SZA.ZA_GRUPGER AND SZA.D_E_L_E_T_<>'*') "
	cQuery+="	Left Outer Join "+RetSqlName("SA1")+" SA1 ON (SA1.A1_COD   = SZ1.Z1_CODCLI   AND SA1.A1_LOJA  = SZ1.Z1_LOJA  AND SA1.D_E_L_E_T_<>'*') "
	cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_GRUPGER<>'' AND SZ0.Z0_DTREF<>'' AND  SZ0.D_E_L_E_T_<>'*' " 
	TcSqlExec(cQuery)
	
	
	cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET "
	cQuery+="       Z0_VRPREV  =IsNull(SZ1.Z1_VRPREV ,0 ), "
	cQuery+="       Z0_PROP    =IsNull(SZ2.Z2_PROP   ,''), "
	cQuery+="       Z0_SITUAC  =IsNull(SZ2.Z2_SITUAC ,''), "
	cQuery+="       Z0_DESC01  =IsNull(CT1.CT1_DESC01,''), "
	cQuery+="       Z0_FATOR   =IsNull(CT1.CT1_FATOR ,1 ), "
	cQuery+="       Z0_CODCONT =IsNull(SZ1.Z1_COD    ,''), "
	cQuery+="       Z0_DESCSET =IsNull(CTT.CTT_DESC01,''), "
	cQuery+="       Z0_GRUPGER =IsNull(SZA.ZA_GRUPGER,''), "
	cQuery+="       Z0_DESGER  =IsNull(SZA.ZA_DESCRI ,''), "
	cQuery+="       Z0_FATORE  =IsNull(SZA.ZA_FATOR  ,1 ), "
	cQuery+="       Z0_CLIENTE =IsNull(SA1.A1_NREDUZ ,''), "
	cQuery+="       Z0_OS      =IsNull(SZ2.Z2_OS     ,''), "
	cQuery+="       Z0_SUBCTA  =Left(Z0_CC,5),"
    cQuery+="       Z0_SETOR   =IsNull(SZ2.Z2_SETOR,'')"  
    cQuery+=" FROM "+RetSqlName("SZ0")+" SZ0 "
	cQuery+="	Left Outer Join "+RetSqlName("CT1")+" CT1 ON (SZ0.Z0_CONTA = CT1.CT1_CONTA AND CT1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ2")+" SZ2 ON (SZ0.Z0_CC    = SZ2.Z2_SUBC   AND SZ2.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("CTT")+" CTT ON (SZ2.Z2_SETOR = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ1")+" SZ1 ON (SZ1.Z1_COD   = SZ2.Z2_COD    AND SZ1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZA")+" SZA ON (CT1.CT1_GRUPO = SZA.ZA_GRUPGER AND SZA.D_E_L_E_T_<>'*') "
	cQuery+="	Left Outer Join "+RetSqlName("SA1")+" SA1 ON (SA1.A1_COD   = SZ1.Z1_CODCLI   AND SA1.A1_LOJA  = SZ1.Z1_LOJA  AND SA1.D_E_L_E_T_<>'*') "
	cQuery+=" WHERE  LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_GRUPGER='' AND SZ0.Z0_DTREF<>'' AND  SZ0.D_E_L_E_T_<>'*' " 
	TcSqlExec(cQuery) 
	
	//Tratamento Espec�fico para o Setor
	cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET "
	cQuery+="       Z0_DESCSET =IsNull(CTT.CTT_DESC01,'') "
	cQuery+=" FROM "+RetSqlName("SZ0")+" SZ0 "
   cQuery+=" INNER JOIN "+RetSqlName("SZ2")+" SZ2 ON (SZ0.Z0_CC=SZ2.Z2_SUBC   AND SZ2.D_E_L_E_T_<>'*')   "
	cQuery+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON (SZ0.Z0_SETOR=CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')   "   
	cQuery+=" WHERE Z0_SETOR='' AND LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_GRUPGER<>'' "
	cQuery+=" AND SZ0.Z0_DTREF<>''" 
	TcSqlExec(cQuery) 
	
Return