#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#include "topconn.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function SEQGRUPO()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetPrvt("CINIGRUPO,NCONTADOR,CCONTADOR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SEQGRUPO  ³ Autor ³ Luiz Carlos da Cruz   ³ Data ³ 05-10-98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³Montar um contador de c¢digo de produto do SB1, para cada   ³±±
±±³          ³grupo de material. Esses contadores, nesse rdmake, estÆo na ³±±
±±³          ³tabela 98, do SX5.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Fun‡Æo disparada pelo gatilho 001 do B1_GRUPO.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³1) Criar uma tabela no SX5: na chave p“r o nome dos grupos e no conte£-³±±
±±³   do o sequencial de cada um. Nesse rdmake a tabela ‚ 98;             ³±±
±±³2) Tornar o B1_GRUPO obrigat¢rio e anterior do B1_COD. Colocar o B1_COD³±±
±±³   inibido para digita‡Æo;                                             ³±±
±±³3) Criar um gatilho do B1_GRUPO para o B1_COD, chamando esse rdmake;   ³±±
±±³4) Este rdmake posiciona o SX5  na tabela 90, no grupo digitado e re-  ³±±
±±³   torna o conte£do acrescido de um.                                   ³±±
±±³5) Colocar no diret¢rio \SIGAADV o programa MATA010 que quando da con- ³±±
±±³   firma‡Æo da entrada do registro grava o sequencial na tabela 98.    ³±±
±±³6) Notas: 6.1: as inclusäes no SB1, via F3, devem ser inibidas.        ³±±
±±³          6.2: nÆo poderÆo ser digitados produtos de um mesmo grupo,   ³±±
±±³               por mais de um usu rio, simultaneamente.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*cInigrupo := Posicione("SBM",1,xFilial("SBM")+M->B1_GRUPO,"SBM->BM_GRUPO")                                
nContador:= val(cInigrupo)+1  
cContador:=" " 
cContador:=strzero(nContador,4)
cInigrupo:= alltrim(M->B1_GRUPO) + cContador*/

Local cGrupo := M->B1_GRUPO
Local cQuery := "" 
Local cIniGrupo := ""
Local cGrupoA := AllTrim(cGrupo)

If !Empty(cGrupo)
   cQuery := "SELECT MAX(CAST(SUBSTRING(B1_COD,"+Alltrim(Str(Len(cGrupoA)+1))+",LEN(B1_COD)) AS INTEGER))+1  AS MAXIMO FROM "+RetSqlName("SB1")+ " WHERE B1_GRUPO = '"+cGrupo+"' AND D_E_L_E_T_ <> '*'"

   TCQUERY cQuery ALIAS "QSB1" NEW

   cIniGrupo := QSB1->MAXIMO

   dbCloseArea("QSB1")

   cIniGrupo := StrZero(cIniGrupo,6)
   cIniGrupo := Alltrim(cGrupoA) + Alltrim(cIniGrupo)
EndIf

Return(cInigrupo)