#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function TESTE()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ISSPROD   � Autor � Cristiane Lara        � Data � 25.11.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Amarracao Prod. X Municipio X ISS                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
local x:={{"Teste","msgstop('Teste')", 0,3},;
{"Teste","msgstop('Teste')", 0,2 }} 
Local aButtons:= { {'PESQUISA',{||msgstop('Oi!!!')},"Teste"} }
   
local p:= 3

AxCadastro("SZW","Testando agora!!!!!!",,,x,,,,,,,aButtons)
Return
