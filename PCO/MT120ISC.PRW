#INCLUDE "Rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA120ISC  � Autor � Rodrigo Alves    � Data �  19/12/07  ���
�������������������������������������������������������������������������͹��
���Descricao � Esse programa grava os dados do SIGAPCO da Solicitacao para���
���          � pedido de compras direto                                   ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT120ISC() 

LOCAL n
//LOCAL ctes  

dBSelectArea('SB1')
dbSetOrder(1)
dbSeek(xFilial("SB1")+SC1->C1_PRODUTO)
//ctes    := SB1->B1_TE 

nPos1 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XORCAME"})
nPos2 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XCO"})
nPos3 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XCLASSE"})
nPos4 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XOPER"})
nPos5 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_DATPRF"})
nPos6 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XPCO"})
//nPos7 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_NFROTA"}) 
nPos8 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XPCO1"})  

n:=len(aCols)
ACOLS[N,nPos1]:=SC1->C1_XORCAME  
ACOLS[N,nPos2]:=SC1->C1_XCO
ACOLS[N,nPos3]:=SC1->C1_XCLASSE
ACOLS[N,nPos4]:=SC1->C1_XOPER
ACOLS[N,nPos5]:=CTOD(" / / ")
ACOLS[N,nPos6]:=SC1->C1_XPCO 
//ACOLS[N,nPos7]:=SC1->C1_NFROTA
ACOLS[N,nPos8]:=SC1->C1_XPCO1	  

       
Return