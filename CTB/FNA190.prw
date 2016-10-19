#Include "rwmake.ch"
#Include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FNA190    ºAutor  ³Tiago               º Data ³  05/20/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste de historico de LP 530/04 Pagto banco               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 - Especifico EPC                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

OBSERVACAO: A ORIGEM DFO LP OBRIGATORIAMENTE TEM QUE TER O SEGUINTE CONTEUDO 

"53004-CH.AJUS.CH*"+SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_FORNECE+SE2->E2_LOJA

*/
User Function FNA190()
Private cQuery

FINA190()

/*
cQuery := " UPDATE "+RetSqlName("SIC")
cQuery += " SET IC_HIST = IC_HIST+' '+E2_NUMBCO, IC_ORIGEM = IC_ORIGEM+'A' "
cQuery += " FROM  "+RetSqlName("SE2")
cQuery += " WHERE "+RetSqlName("SIC")+".D_E_L_E_T_ <> '*' "
cQuery += " AND   "+RetSqlName("SE2")+".D_E_L_E_T_ <> '*' "
cQuery += " AND SUBSTRING(IC_ORIGEM,1,5) = '53004' "
cQuery += " AND SUBSTRING(IC_ORIGEM,18,2) = E2_FILIAL "
cQuery += " AND SUBSTRING(IC_ORIGEM,20,3) = E2_PREFIXO "
cQuery += " AND SUBSTRING(IC_ORIGEM,23,6) = E2_NUM "
cQuery += " AND SUBSTRING(IC_ORIGEM,29,1) = E2_PARCELA "
cQuery += " AND SUBSTRING(IC_ORIGEM,30,6) = E2_FORNECE "
cQuery += " AND SUBSTRING(IC_ORIGEM,36,2) = E2_LOJA "
cQuery += " AND SUBSTRING(IC_ORIGEM,38,1) <> 'A' "
cQuery += " AND E2_NUMBCO <> '' "
cQuery += " AND IC_HIST NOT LIKE '%'+RTRIM(LTRIM(E2_NUMBCO))+'%' "
TcSqlExec(cQuery)
*/                                                                '
/*
cQuery := " UPDATE "+RetSqlName("CTT")
cQuery += " SET CTT_HIST = CTT_HIST+' '+E2_NUMBCO, CTT_ORIGEM = CTT_ORIGEM+'A' "
cQuery += " FROM  "+RetSqlName("SE2")
cQuery += " WHERE "+RetSqlName("CTT")+".D_E_L_E_T_ <> '*' "
cQuery += " AND   "+RetSqlName("SE2")+".D_E_L_E_T_ <> '*' "
cQuery += " AND SUBSTRING(CTT_ORIGEM,1,5) = '53004' "
cQuery += " AND SUBSTRING(CTT_ORIGEM,18,2) = E2_FILIAL "
cQuery += " AND SUBSTRING(CTT_ORIGEM,20,3) = E2_PREFIXO "
cQuery += " AND SUBSTRING(CTT_ORIGEM,23,6) = E2_NUM "
cQuery += " AND SUBSTRING(CTT_ORIGEM,29,1) = E2_PARCELA "
cQuery += " AND SUBSTRING(CTT_ORIGEM,30,6) = E2_FORNECE "
cQuery += " AND SUBSTRING(CTT_ORIGEM,36,2) = E2_LOJA "
cQuery += " AND SUBSTRING(CTT_ORIGEM,38,1) <> 'A' "
cQuery += " AND E2_NUMBCO <> '' "                       
cQuery += " AND CTT_HIST NOT LIKE '%'+RTRIM(LTRIM(E2_NUMBCO))+'%' "
TcSqlExec(cQuery)
*/
Return