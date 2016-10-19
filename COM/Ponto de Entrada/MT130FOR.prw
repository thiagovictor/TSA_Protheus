#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦MT130FOR   ¦ Autor ¦ Gilson Lucas          ¦Data ¦06.07.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦                                                            ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function MT130FOR
************************************************************************
*
**
Local nXi        := 0
Local nFornec	 := 0
Local nUltForn   := 0
Local aRet       := {}
Local aAuxi      := {}
Local nRecnoTrab := 0
Local nAmarracao := MV_PAR06
Local cAliasSC1  := "A130PROCES"
Local aAreaOld   := GetArea()
Local aAreaSC1   := SC1->(GetArea())
Local cChaveTemp := (CALIASSC1)->(C1_FILIAL+C1_NUM+C1_ITEM)


If Empty(aForUse)
   Pergunte("MTA131",.F.)
   nFornec	  := MV_PAR01
   nUltForn   := MV_PAR02    
   (cAliasSC1)->(dbGotop())
   While !(cAliasSC1)->(Eof()) .And. (cAliasSC1)->C1_FILIAL == xFilial("SC1") .And. ( ThisMark() == (cAliasSC1)->C1_OK .Or. ThisInv() ) 
       If (cAliasSC1)->(IsMark("C1_OK",ThisMark(),ThisInv()) )
          aAuXi := Getfornece(nAmarracao,cAliasSC1,nUltForn)
          For nXi := 1 To Len(aAuXi)
              Aadd(aForUse,aAuXi[nXi])
          Next nXi
       EndIf
       (cAliasSC1)->(dbSkip())
   End 
   //Reposiciona o arquivo temporario. Arquivo sem indice. Nao funciona RestArea()
   (cAliasSC1)->(dbGotop())
   While !(cAliasSC1)->(Eof()) 
       If (CALIASSC1)->(C1_FILIAL+C1_NUM+C1_ITEM) == cChaveTemp
          Exit
       EndIf
       (cAliasSC1)->(dbSkip())   
   End
   aRet    := SelFor(aForUse)
   aForUse := aRet
   Pergunte("MTA130",.F.)
Else
   aRet := aForUse
EndIf

RestArea(aAreaOld)
RestArea(aAreaSC1)


Return(aRet)



Static Function SelFor(aReferFor)
************************************************************************
*
**
Local oDlgFor
Local oSelGroup 
Local nXi       := 0
Local aRet      := {}
Local aCabFor   := {} 
Local aDadFor   := {}
Local lConfirm  := .T.
Local cCodFor   := Space(6) // CriaVar("A2_COD",.F.,.F.)
Local cCodLoj   := Space(2) // CriaVar("A2_LOJA",.F.,.F.)
Local cNomFor   := OemToAnsi('???????????????????????????????')
Local oOk       := LoadBitMap(GetResources(), "LBOK")
Local oNo       := LoadBitMap(GetResources(), "LBNO")
Local oFont     := TFont():New( "Times New Roman",,16,,.T.,,,,.F.,.F. )


Aadd(aCabFor,"")              
Aadd(aCabFor,OemToAnsi("Codigo"))
Aadd(aCabFor,OemToAnsi("Loja"))
Aadd(aCabFor,OemToAnsi("Nome"))
Aadd(aCabFor,OemToAnsi("CNPJ"))
Aadd(aCabFor,OemToAnsi("Endereço"))
Aadd(aCabFor,OemToAnsi("Municipio"))

dbSelectArea("SA2")
SA2->(dbSetOrder(1))

For nXi := 1 To Len(aReferFor)
    SA2->(dbSeek(xFilial("SA2")+aReferFor[nXi,1]+aReferFor[nXi,2]))
    If !SA2->(Eof())
       If aScan(aDadFor,{|x| x[2] == SA2->A2_COD .And. x[3] == SA2->A2_LOJA }) == 0
          Aadd(aDadFor,{.T.,;
                        SA2->A2_COD,;
                        SA2->A2_LOJA,;
                        SA2->A2_NOME,;
                        SA2->A2_CGC,;
                        SA2->A2_END,;
                        SA2->A2_MUN,;
                        SA2->(Recno()) })
       EndIf
    EndIf
Next nXi

If Empty(aDadFor)
   Aadd(aDadFor,{.T.,;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 0 })

Endif

If !Empty(aDadFor)
   oDlgFor := MSDialog():New(000,000,310,600,OemToAnsi('Seleção de Fornecedores'),,,,/*nor(DS_MODALFRAME,WS_POPUP,WS_CAPTION,WS_VISIBLE)*/,,,,,.T.,,,)
   oDlgFor:lESCClose := .F.
  
   TGroup():New(005,005,030,295,"",oDlgFor,,,.T.,.T.)
   TSay():New(013,010,{|| OemToAnsi('Fornecedor:') },oDlgFor,,oFont,,,,.T.,,,280,050)
   TGet():New(010,045,{|U| IIf(PCount()==0,cCodFor,cCodFor:=U )},oDlgFor,025,09,"@!",{|| VdlSA2(cCodFor,cCodLoj,@cNomFor) },,,oFont, .F.,, .T.,, .F.,{||.T.}, .F., .F.,, .F., .F. ,"SA2COM","cCodFor")
   TGet():New(010,085,{|U| IIf(PCount()==0,cCodLoj,cCodLoj:=U )},oDlgFor,015,09,"@!",{|| VdlSA2(cCodFor,cCodLoj,@cNomFor) },,,oFont, .F.,, .T.,, .F.,{||.T.}, .F., .F.,, .F., .F. ,,"cCodLoj")
   TSay():New(013,110,{|| Left(cNomFor,30) },oDlgFor,,oFont,,,,.T.,,,280,050)   
   
   TGroup():New(005,230,030,232,"",oDlgFor,,,.T.,.T.)
   TButton():New(010,240,'&Adicionar'  ,oDlgFor,{|| AddSA2(@aDadFor,cCodFor,cCodLoj,@oSelGroup)  },040,14,,,,.T.)
   
   oSelGroup := TWBrowse():New(035,005,290,085,,aCabFor,,oDlgFor,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
   oSelGroup:SetArray(aDadFor)
   oSelGroup:bLDblClick   := {|| aDadFor[oSelGroup:nAt,1] := !aDadFor[oSelGroup:nAt,1],oSelGroup:DrawSelect() }
   oSelGroup:bLine        := {|| {If(aDadFor[oSelGroup:nAt,1],oOk,oNo),;
                                     aDadFor[oSelGroup:nAT][2],;
                                     aDadFor[oSelGroup:nAT][3],;
                                     aDadFor[oSelGroup:nAT][4],;
                                     aDadFor[oSelGroup:nAT][5],;
                                     aDadFor[oSelGroup:nAT][6],;
                                     aDadFor[oSelGroup:nAT][7]}}
   oSelGroup:bHeaderClick :=  {|oList,nCol| MarkAll(@oSelGroup,nCol,@aDadFor)}
   TGroup():New(125,005,150,295,"",oDlgFor,,,.T.,.T.)
   TButton():New(130,010,'Con&firmar'  ,oDlgFor,{|| lConfirm := .T.,oDlgFor:End()},040,14,,,,.T.)
   TButton():New(130,060,'&Cancelar'   ,oDlgFor,{|| lConfirm := .F.,oDlgFor:End()},040,14,,,,.T.)
   oDlgFor:Activate(,,, .T.,{||  }, ,{||  /*EnchoiceBar(oDlgFor,{|| nOpcX := 1 ,oDlgFor:End()  },{|| oDlgFor:End()})*/ })
   
   If lConfirm
       For nXi := 1 To Len(aDadFor)
           If aDadFor[nXi][1] .And. !Empty(aDadFor[nXi][2])
              Aadd(aRet,{ aDadFor[nXi][2],; // Codigo
                          aDadFor[nXi][3],; // Loja
                          "",;
                          "SA2",;
                          aDadFor[nXi][8]}) // Recno
           EndIf               
       Next nXi
   EndIf
EndIf                     

Return(aRet)



Static function VdlSA2(cCodFor,cCodLoj,cNomFor)
************************************************************************
*
**
Local lRet := .T.
If !Empty(cCodFor) .And. !Empty(cCodLoj)
   dbSelectArea("SA2")
   SA2->(dbSetOrder(1))
   SA2->(dbSeek(xFilial("SA2")+cCodFor+cCodLoj))
   If !SA2->(Eof())
      cNomFor :=  SA2->A2_NOME
   Else
      lRet :=.F.
      MsgBox(OemToAnsi("Fornecedor não encontrado."),OemToAnsi("Atenção"),"STOP")
   EndIf
EndIf

Return(lRet)



Static function AddSA2(aDadFor,cCodFor,cCodLoj,oSelGroup)
************************************************************************
*
**
Local nLin := 0
If !Empty(cCodFor) .and. !Empty(cCodLoj)
   If (nLin := aScan(aDadFor,{|aAux| Alltrim(aAux[2]) == cCodFor  .And.  Alltrim(aAux[3]) == cCodLoj    })) # 0
      MsgBox(OemToAnsi("Fornecedor ja existe no grid.Veja linha.")+Alltrim(Str(nLin)),OemToAnsi("Atenção"),"STOP")
   Else
      dbSelectArea("SA2")
      SA2->(dbSetOrder(1))
      SA2->(dbSeek(xFilial("SA1")+cCodFor+cCodLoj))
      If !SA2->(Eof())
          Aadd(aDadFor,{.T.,;
                        SA2->A2_COD,;
                        SA2->A2_LOJA,;
                        SA2->A2_NOME,;
                        SA2->A2_CGC,;
                        SA2->A2_END,;
                        SA2->A2_MUN,;
                        SA2->(Recno()) })   
          oSelGroup:DrawSelect()                     
      EndIf
   EndIf
EndIf

Return



Static Function Getfornece(nAmarracao,cAliasSC1,nUltForn)
************************************************************************
*
**
Local aFornec	  := {}
Local aUltFor	  := {}
Local cQuery	  := ""
Local cRefGrd     := ""
Local nCntFor	  := 0
Local nCont		  := 0
Local cAliasSA5	  := "SA5"
Local cAliasSAD	  := "SAD"
Local aArea		  := GetArea()
Local aAreaSC1	  := SC1->(GetArea())
Local aAreaSB1	  := SB1->(GetArea())
Local aAreaSA2	  := SA2->(GetArea())
Local aAreaSA5	  := SA5->(GetArea())
Local aAreaSAD	  := SAD->(GetArea())
Local aStruSA5	  := SA5->(dbStruct())
Local aStruSAD	  := SAD->(dbStruct())


dbSelectArea("SA2")
dbSetOrder(1)
MsSeek( xFilial("SA2")+(cAliasSC1)->C1_FORNECE+(cAliasSC1)->C1_LOJA)

If nAmarracao == 1 .Or. nAmarracao == 3 //Produto
	If !Empty(SC1->C1_FORNECE)
		cRefGrd:=Pad( AtuSA5((cAliasSC1)->C1_FORNECE,(cAliasSC1)->C1_LOJA,(cAliasSC1)->C1_PRODUTO,MV_PAR11==2),14)
	Else
		cRefGrd := (cAliasSC1)->C1_PRODUTO
		cRefGrd := Pad(cRefGrd,14)
	EndIf
EndIf

If nAmarracao == 1 .Or. nAmarracao == 3  //Produto
   cQuery := "SELECT SA5.*,SA5.R_E_C_N_O_ SA5RECNO  "
   cQuery += "FROM "+RetSqlName("SA5")+" SA5 "
   cQuery += "WHERE SA5.A5_FILIAL='"+xFilial("SA5")+"' AND "
   cQuery += "SA5.A5_PRODUTO='"+(cAliasSC1)->C1_PRODUTO+"' AND "
   If !Empty((cAliasSC1)->C1_FORNECE)
      cQuery += "SA5.A5_FORNECE='"+(cAliasSC1)->C1_FORNECE+"' AND "
   EndIf
   If !Empty((cAliasSC1)->C1_LOJA) 
      cQuery += "SA5.A5_LOJA='"+(cAliasSC1)->C1_LOJA+"' AND "
   EndIf
   cQuery += "SA5.D_E_L_E_T_<>'*'"
   cQuery += "UNION "
   cQuery += "SELECT SA5.*,SA5.R_E_C_N_O_ SA5RECNO  "
   cQuery += "FROM "+RetSqlName("SA5")+" SA5 "
   cQuery += "WHERE SA5.A5_FILIAL='"+xFilial("SA5")+"' AND "
   cQuery += "SA5.A5_REFGRD='"+cRefGrd+"' AND "
   If !Empty((cAliasSC1)->C1_FORNECE) 
      cQuery += "SA5.A5_FORNECE='"+(cAliasSC1)->C1_FORNECE+"' AND "
   EndIf
   If !Empty((cAliasSC1)->C1_LOJA) 
      cQuery += "SA5.A5_LOJA='"+(cAliasSC1)->C1_LOJA+"' AND "
   EndIf
   cQuery += "SA5.D_E_L_E_T_<>'*'"
   cQuery += "AND NOT EXISTS ( SELECT * FROM "+RetSqlName("SA5")+" SA52 "
   cQuery += "WHERE SA52.A5_PRODUTO='"+(cAliasSC1)->C1_PRODUTO+"'  "
   If MaConsRefG()
      cQuery += "AND SA5.A5_FORNECE=SA52.A5_FORNECE "
   EndIf
   cQuery += "AND SA52.D_E_L_E_T_<>'*' )"
   cQuery := ChangeQuery(cQuery)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"A130GRAVA",.T.,.T.)
   cAliasSA5 := "A130GRAVA"
   For nCntFor := 1 To Len(aStruSA5)
       If ( aStruSA5[nCntFor][2] $ "NDL" ) 
            TcSetField(cAliasSA5,aStruSA5[nCntFor][1],aStruSA5[nCntFor][2],aStruSA5[nCntFor][3],aStruSA5[nCntFor][4])
       EndIf
   Next nCntFor

   dbSelectArea(cAliasSA5)
   While ( !Eof() .And. xFilial("SA5") == (cAliasSA5)->A5_FILIAL .And.;
		((cAliasSC1)->C1_PRODUTO== (cAliasSA5)->A5_PRODUTO .Or. cRefGrd==(cAliasSA5)->A5_REFGRD)  .And.;
		((cAliasSC1)->C1_FORNECE == (cAliasSA5)->A5_FORNECE .Or. Empty((cAliasSC1)->C1_FORNECE)) .And.;
		((cAliasSC1)->C1_LOJA == (cAliasSA5)->A5_LOJA .Or. Empty((cAliasSC1)->C1_LOJA)) )

	    //Verifica se o Produto x Fornecedor nao foi bloqueado pela Qualidade
	    If QieSitFornec((cAliasSA5)->A5_FORNECE,(cAliasSA5)->A5_LOJA,(cAliasSC1)->C1_PRODUTO,.F.)
		   aadd(aFornec,{(cAliasSA5)->A5_FORNECE,(cAliasSA5)->A5_LOJA,"","SA5",IIF(lQuery,(cAliasSA5)->SA5RECNO,SA5->(Recno())) })
	    EndIf

		dbSelectArea(cAliasSA5)
		dbSkip()

   EndDo


   dbSelectArea(cAliasSA5)
   dbCloseArea()
   dbSelectArea("SA5")


EndIf

If nAmarracao == 2 .Or. nAmarracao == 3 // Grupo
   cQuery := "SELECT SAD.*,SAD.R_E_C_N_O_ SADRECNO  "
   cQuery += "FROM "+RetSqlName("SAD")+" SAD "
   cQuery += "WHERE SAD.AD_FILIAL='"+xFilial("SAD")+"' AND "
   cQuery += "SAD.AD_GRUPO='"+SB1->B1_GRUPO+"' AND "
   If !Empty((cAliasSC1)->C1_FORNECE) 
      cQuery += "SAD.AD_FORNECE='"+(cAliasSC1)->C1_FORNECE+"' AND "
   EndIf
   If !Empty((cAliasSC1)->C1_LOJA) 
      cQuery += "SAD.AD_LOJA='"+(cAliasSC1)->C1_LOJA+"' AND "
   EndIf
   cQuery += "SAD.D_E_L_E_T_<>'*'"
   cQuery := ChangeQuery(cQuery)
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"A130GRAVA",.T.,.T.)
   cAliasSAD := "A130GRAVA"
   For nCntFor := 1 To Len(aStruSAD)
       If ( aStruSAD[nCntFor][2] $ "NDL" ) 
          TcSetField(cAliasSAD,aStruSAD[nCntFor][1],aStruSAD[nCntFor][2],aStruSAD[nCntFor][3],aStruSAD[nCntFor][4])
       EndIf
   Next nCntFor

   dbSelectArea(cAliasSAD)
   While ( !Eof() .And. xFilial("SAD") == (cAliasSAD)->AD_FILIAL .And.;
           SB1->B1_GRUPO== (cAliasSAD)->AD_GRUPO .And.;
			((cAliasSC1)->C1_FORNECE == (cAliasSAD)->AD_FORNECE .Or. Empty((cAliasSC1)->C1_FORNECE)) .And.;
			((cAliasSC1)->C1_LOJA == (cAliasSAD)->AD_LOJA .Or. Empty((cAliasSC1)->C1_LOJA)) )

		If aScan(aFornec,{|x| x[1] == (cAliasSAD)->AD_FORNECE .And. x[2] == (cAliasSAD)->AD_LOJA}) == 0
			aadd(aFornec,{(cAliasSAD)->AD_FORNECE,(cAliasSAD)->AD_LOJA,"","SAD",IIF(lQuery,(cAliasSAD)->SADRECNO,SAD->(Recno())) })
		EndIf

		dbSelectArea(cAliasSAD)
		dbSkip()
	EndDo


    dbSelectArea(cAliasSAD)
	dbCloseArea()
	dbSelectArea("SAD")


EndIf

aUltFor		:= a130UlForn(nUltForn,(cAliasSC1)->C1_PRODUTO)
For nCntFor := 1 To Len(aUltFor)
    nCont := aScan(aFornec,{|x| x[1]==aUltFor[nCntFor][1] .And. x[2]==aUltFor[nCntFor][2]})
    If nCont == 0 
       SA2->(MsSeek( xFilial("SA2")+aUltFor[nCntFor][1]+aUltFor[nCntFor][2]))
       aadd(aFornec,{ aUltFor[nCntFor][1],aUltFor[nCntFor][2],aUltFor[nCntFor][3],"SA2",SA2->(Recno())})
    Else
       aFornec[nCont][3] := aUltFor[nCntFor][3]
    EndIf
Next nCntFor
	

RestArea(aArea)
RestArea(aAreaSC1)
RestArea(aAreaSB1)
RestArea(aAreaSA2)
RestArea(aAreaSA5)
RestArea(aAreaSAD)

Return(aFornec)



User Function M130PROC
************************************************************************
*
**
Public aForUse := {}


Return



Static Function MarkAll(oQ,nCol,aDadDel)
************************************************************************
* 
**  
Local nXi := 0


If nCol == 1
   For nXi := 1 To Len(aDadDel)
       aDadDel[nXi][1] := !aDadDel[nXi][1]
   Next nXi
   oQ:DrawSelect()
   oQ:Refresh()
EndIf

Return