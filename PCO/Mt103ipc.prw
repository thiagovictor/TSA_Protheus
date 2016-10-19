#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT103IPC  บ Autor ณ RODRIGO ALVES   บ Data ณ  28/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa feito para o SIGAPCO que Carrega os dados do     บฑฑ
ฑฑบ          ณ Pedido de Compras para a NF Entrada                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Alterado ณ 17/10/13 Leandro P J Monteiro 							  นฑฑ
ฑฑบ 		 Mesclando orinal com arquivo existente na TSA, que carrega	  นฑฑ
ฑฑบ 		 a descricao do produto que estแ no pedido de compras		  นฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MT103IPC


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
LOCAL n 
LOCAL F

  nPos1 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_COD"})
//nPos2 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_ESPECIF"})
//nPos3 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_PEDIDO"})
//nPos4 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_ITEMPC"})
nPos2 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XCO"})
nPos3 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XCLASSE"})
nPos4 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XOPER"})
nPos5 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XORCAME"})
nPos6 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_CC"})
//nPos10:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_ORDEM"})
//nPos11:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_DESCRI"})
//nPos12:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_NFROTA"}) 
nPos7:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XPCO"})
nPos8:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XPCO1"}) 
// Incluido por Leandro P J Monteiro em 17/10/2013
nPos12:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_DESCRIC"}) 
nPos13:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_DTREF"}) 
// ------------------------------------------------


n:=len(aCols)
IF ALLTRIM(ACOLS[N,nPos1])<>""
    
    ACOLS[N,nPos2]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XCO")  
    ACOLS[N,nPos3]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XCLASSE")  
	ACOLS[N,nPos4]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XOPER")  
	ACOLS[N,nPos5]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XORCAME")
    ACOLS[N,nPos6]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_CC") 
   // ACOLS[N,nPos11]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_DESCRI")
    //ACOLS[N,nPos2]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_ESPECIF")
   //	ACOLS[N,nPos12]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_NFROTA")
    ACOLS[N,nPos7]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XPCO")
    ACOLS[N,nPos8]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XPCO1")
   // ACOLS[N,nPos13]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XPCO")
   // ACOLS[N,nPos14]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XPCO1") 
	// Incluido por Leandro P J Monteiro em 17/10/2013
    ACOLS[N,nPos12]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_DESCRI") 
    ACOLS[N,nPos13]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_DATPRF") 
   // ------------------------------------------------
 IF ALLTRIM(ACOLS[N,nPos6])=="0" 
      ACOLS[N,nPos10]:=LEFT(RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_OP"),6)
 ENDIF  
ENDIF 
       
Return .T.
