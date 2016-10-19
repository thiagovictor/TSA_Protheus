#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function MT010INC()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CALIAS,CGRUPO,NCODIGO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �MATA010   � Autor � Luiz Carlos da Cruz   � Data � 05.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gravar no SX5, na tabela 90, o sequencial de cada produto,  ���
���          �por grupo, quando da confirmacao da entrada do registro.    ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Apos confirmacao do registro.                               ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Caso o ponto de entrada n�o venha de uma inclus�o,
// retornar sem fazer nada.
If !INCLUI  // Inclui � uma fun��o l�gica do SIGA.
   return
Endif

// Guardar o alias atual
cAlias := alias()
cGrupo := SB1->B1_GRUPO

// Localizar o registro pela chave correspondente ao grupo
//
dbSelectArea("SX5")
dbSeek(xFilial("SBM")+cGrupo)
nCodigo := val(SBM->BM_GRUPO)+1
RecLock("SBM",.F.)
//Guardar o sequencial desse grupo, na tabela
replace BM_GRUPO with strzero(nCodigo,4)
MsUnLock()
dbSelectArea(cAlias)
Return