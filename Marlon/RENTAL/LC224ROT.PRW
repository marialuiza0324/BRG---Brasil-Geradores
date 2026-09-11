#Include "Protheus.ch"
#Include "FWMVCDef.ch"

#DEFINE LC224_TIT_MAN  "Enviar p/ Manutenção"
#DEFINE LC224_TIT_RET  "Libera Equipamento (Manutenção)"
#DEFINE LC224_STAREN   "70"

/*/{Protheus.doc} LC224ROT
Ponto de entrada da rotina LOCA224 (Gerenciamento de Bens).

Acrescenta ao aRotina duas ações que controlam a manutenção gerencial da BRG,
sem passar pelo fluxo padrão e sem gerar OS:

- "Enviar p/ Manutenção"            : status de origem (MV_STATORI) -> MV_STATMAN
- "Libera Equipamento (Manutenção)" : qualquer status em manutenção -> disponível

As duas ficam no primeiro nível de Outras Ações, na ordem de uso: o envio para
manutenção e, logo abaixo, a liberação.

@type   User Function
@author BRG - TI
@since  24/06/2026
@return array, aRotina da LOCA224 acrescido das ações customizadas

@obs 10/09/2026 - Correção do chamado de liberação de bem.
     A versão anterior gravava apenas ST9->T9_STATUS, sem gerar o movimento
     correspondente na FQ4. Isso deixava cadastro e histórico divergentes
     (T9_STATUS = 30 e último FQ4_STATUS = 25) e fechava todas as saídas do
     status: a LOCA250 barrava na validação de status 50/60, a LOCA250A não
     listava o bem (só lista bens cujo último movimento da FQ4 esteja em
     00/50/60/70) e a LOCA250B estornava o movimento errado.
     Passa a gravar FQ4 + ST9 na mesma transação, como fazem as rotinas
     padrão LOCA250 (linhas 131-136), LOCA250B (linhas 210-228) e
     LIBER250 (linhas 478-483).

@obs 10/09/2026 - Ciclo fechado no ponto de entrada.
     O retorno da manutenção NÃO usa a liberação padrão. Motivo: a LOCA250 só
     libera status mapeado no FQD_STAREN 50 ou 60 (e a válvula de escape dela,
     a tabela FQ1, libera o usuário para QUALQUER status, inclusive bem em
     locação); e a LOCA250A resolve o status de manutenção com
     "cTemps70 := FQD_STATQY" (MontaLista, linhas 310-312), sem acumular, de
     modo que apenas um dos FQD_STATQY do STAREN 70 é reconhecido.
     A ação daqui aceita TODOS os status mapeados no STAREN 70, portanto
     atende tanto o status gerencial novo (30) quanto os bens que já estavam
     em manutenção pelo fluxo com OS (99) antes desta personalização.
/*/
User Function LC224ROT()

    Local aArea    := FWGetArea()
    Local aParam   := PARAMIXB
    Local aRotina  := {}

    // Recupera o aRotina enviado pela LOCA224
    If ValType(aParam) == "A" .And. Len(aParam) > 0
        aRotina := aParam[1]
    EndIf

    If ValType(aRotina) <> "A"
        aRotina := {}
    EndIf

    // Ordem de uso: envio para manutenção e, logo abaixo, a liberação.
    LC224Add(@aRotina, LC224_TIT_MAN, "U_LOCA224MAN()")
    LC224Add(@aRotina, LC224_TIT_RET, "U_LOCA224RET()")

    FWRestArea(aArea)

Return aRotina


/*/{Protheus.doc} LOCA224MAN
Ação customizada da LOCA224 que envia o bem para o status de manutenção
gerencial da BRG, sem geração de OS.

Regras:
- O bem é o posicionado no browse da LOCA224 (alias ST9), mesma premissa
  adotada pela LOCA250 padrão.
- Status de destino  : MV_STATMAN (obrigatório, cadastrado na FQD/TQY).
- Status de origem   : MV_STATORI (opcional, default "25"). Aceita lista
                       separada por vírgula, ex.: "25,40".
- O status de destino precisa estar cadastrado na tabela de status do bem
  (FQD quando MV_LOCBAC = .T., TQY quando .F.). Sem esse cadastro o bem
  fica sem legenda e sem descrição na LOCA224.
- O bem precisa estar ativo (T9_SITMAN e T9_SITBEM = "A").
- Grava o movimento na FQ4 e o status na ST9 dentro da mesma transação,
  herdando projeto, obra, AS, cliente e datas do movimento anterior.

@type   User Function
@author BRG - TI
@since  24/06/2026
@return logical, .T. quando o status foi alterado
/*/
User Function LOCA224MAN()

    Local aArea     := FWGetArea()
    Local aStatOri  := {}
    Local cStatMan  := AllTrim(SuperGetMV("MV_STATMAN", .F., ""))
    Local cStatOri  := AllTrim(SuperGetMV("MV_STATORI", .F., "25"))
    Local cCodBem   := ""
    Local cStatAtu  := ""
    Local cStaRen   := ""
    Local cDesSts   := ""
    Local cMsg      := ""
    Local nRegST9   := 0
    Local lRet      := .F.

    If !LC224Bem(@cCodBem, @cStatAtu, @nRegST9)
        FWRestArea(aArea)
        Return .F.
    EndIf

    // ------------------------------------------------------------------
    // Parametrização
    // ------------------------------------------------------------------
    If Empty(cStatMan)
        LC224Msg("O parâmetro MV_STATMAN não está cadastrado ou está em branco. " + ;
                 "Cadastre nele o status de manutenção gerencial do bem.")
        FWRestArea(aArea)
        Return .F.
    EndIf

    If cStatAtu == cStatMan
        LC224Msg("Este bem já está no status [" + cStatMan + "].")
        FWRestArea(aArea)
        Return .F.
    EndIf

    aStatOri := Separa(cStatOri, ",", .T.)

    If AScan(aStatOri, {|cSts| AllTrim(cSts) == cStatAtu}) == 0
        LC224Msg("Só é permitido enviar para manutenção quando o status atual do bem " + ;
                 "for [" + cStatOri + "]. Status atual: [" + cStatAtu + "].")
        FWRestArea(aArea)
        Return .F.
    EndIf

    // ------------------------------------------------------------------
    // Situação do bem
    // ------------------------------------------------------------------
    If ST9->T9_SITMAN <> "A" .Or. ST9->T9_SITBEM <> "A"
        LC224Msg("O bem precisa estar ativo (T9_SITMAN e T9_SITBEM = 'A') para ser " + ;
                 "enviado para manutenção.")
        FWRestArea(aArea)
        Return .F.
    EndIf

    // ------------------------------------------------------------------
    // Status de destino precisa estar cadastrado na tabela de status
    // ------------------------------------------------------------------
    If !LC224Sts(cStatMan, @cStaRen, @cDesSts)
        LC224Msg("O status [" + cStatMan + "] não está cadastrado na tabela de status " + ;
                 "do bem. Cadastre-o com o status Rental (FQD_STAREN) igual a " + ;
                 LC224_STAREN + " - Em manutenção.")
        FWRestArea(aArea)
        Return .F.
    EndIf

    // ------------------------------------------------------------------
    // Confirmação
    // ------------------------------------------------------------------
    cMsg := "Confirma o envio do bem [" + AllTrim(cCodBem) + "] para manutenção?" + CRLF + CRLF
    cMsg += "Status atual   : " + cStatAtu + CRLF
    cMsg += "Status destino : " + cStatMan + " - " + cDesSts + CRLF

    If cStaRen <> LC224_STAREN
        cMsg += CRLF + "Atenção: o status Rental cadastrado não é " + LC224_STAREN + ;
                " (Em manutenção). O bem não será aceito pela ação de liberação."
    EndIf

    If !MsgYesNo(cMsg, "LOCA224")
        FWRestArea(aArea)
        Return .F.
    EndIf

    // ------------------------------------------------------------------
    // Gravação - herda as informações do movimento anterior
    // ------------------------------------------------------------------
    lRet := LC224Grv(cCodBem, cStatAtu, cStatMan, nRegST9, .T.)

    If lRet
        MsgInfo("Bem [" + AllTrim(cCodBem) + "] enviado para manutenção. " + ;
                "Status alterado para [" + cStatMan + "].", "LOCA224")
    EndIf

    FWRestArea(aArea)

Return lRet


/*/{Protheus.doc} LOCA224RET
Ação customizada da LOCA224 que devolve para disponível qualquer bem em
manutenção, independente de como ele chegou lá.

Aceita TODOS os status mapeados no FQD_STAREN "70", o que cobre:
- o status de manutenção gerencial criado por esta personalização (30);
- os bens que já estavam em manutenção pelo fluxo com OS antes dela (99).

Substitui a liberação padrão para esses status porque:
- a LOCA250 recusa qualquer status que não esteja mapeado no FQD_STAREN 50 ou
  60, emitindo "Este equipamento não está com o status NF Retorno gerado."
  (linhas 93-98), e a exceção dela (tabela FQ1) autoriza o usuário a liberar
  QUALQUER status, inclusive bem em locação;
- a LOCA250A resolve o status de manutenção sem acumular os FQD_STATQY
  (MontaLista, linhas 310-312), reconhecendo apenas um deles.

Status de destino: LOCA224K(), a mesma função que as rotinas padrão usam para
obter o status disponível (FQD_STATQY do FQD_STAREN "00").

Limpa projeto, obra, AS, cliente e datas no novo movimento, como faz a
LOCA250B ao disponibilizar o bem (linhas 162-174).

@type   User Function
@author BRG - TI
@since  10/09/2026
@return logical, .T. quando o status foi alterado
/*/
User Function LOCA224RET()

    Local aArea     := FWGetArea()
    Local cStatDis  := LOCA224K() // status disponível, conforme cadastro
    Local cLista    := ""
    Local cCodBem   := ""
    Local cStatAtu  := ""
    Local cStaRen   := ""
    Local cDesSts   := ""
    Local cOS       := ""
    Local cMsg      := ""
    Local nRegST9   := 0
    Local lRet      := .F.

    If !LC224Bem(@cCodBem, @cStatAtu, @nRegST9)
        FWRestArea(aArea)
        Return .F.
    EndIf

    // ------------------------------------------------------------------
    // Status de manutenção cadastrados (FQD_STAREN = "70")
    // ------------------------------------------------------------------
    If !LC224Man(@cLista)
        LC224Msg("Não existe nenhum status cadastrado com o status Rental " + ;
                 LC224_STAREN + " (Em manutenção) na tabela de status do bem.")
        FWRestArea(aArea)
        Return .F.
    EndIf

    If !((cStatAtu + "*") $ cLista)
        LC224Msg("Esta ação libera apenas bens em manutenção, ou seja, nos status " + ;
                 "[" + AllTrim(StrTran(cLista, "*", " ")) + "]. Status atual do bem: " + ;
                 "[" + cStatAtu + "]. Para os demais status use a opção Libera " + ;
                 "Equipamento padrão.")
        FWRestArea(aArea)
        Return .F.
    EndIf

    If AllTrim(cStatDis) == cStatAtu
        LC224Msg("O status disponível retornado pelo cadastro é o mesmo status atual " + ;
                 "do bem. Verifique o cadastro de status do bem (FQD_STAREN = '00').")
        FWRestArea(aArea)
        Return .F.
    EndIf

    LC224Sts(cStatAtu, @cStaRen, @cDesSts)
    cOS := LC224OS(cCodBem)

    // ------------------------------------------------------------------
    // Confirmação
    // ------------------------------------------------------------------
    cMsg := "Confirma a liberação do bem [" + AllTrim(cCodBem) + "] para disponível?" + CRLF + CRLF
    cMsg += "Status atual   : " + cStatAtu + " - " + cDesSts + CRLF
    cMsg += "Status destino : " + IIf(Empty(cStatDis), "(em branco - disponível)", AllTrim(cStatDis)) + CRLF + CRLF
    cMsg += "As informações de projeto, obra, AS, cliente e datas serão limpas no " + ;
            "novo movimento do bem."

    If !Empty(cOS)
        cMsg += CRLF + CRLF + "Atenção: o último movimento deste bem está vinculado à " + ;
                "OS [" + cOS + "]. Confirme com a manutenção antes de liberar."
    EndIf

    If !MsgYesNo(cMsg, "LOCA224")
        FWRestArea(aArea)
        Return .F.
    EndIf

    // ------------------------------------------------------------------
    // Gravação - limpa as informações de locação
    // ------------------------------------------------------------------
    lRet := LC224Grv(cCodBem, cStatAtu, cStatDis, nRegST9, .F.)

    If lRet
        MsgInfo("Bem [" + AllTrim(cCodBem) + "] disponibilizado.", "LOCA224")
    EndIf

    FWRestArea(aArea)

Return lRet


/*/{Protheus.doc} LC224Grv
Grava o novo status na ST9 e o movimento correspondente na FQ4, dentro de uma
única transação.

A ordem das operações copia a LOCA250 (linhas 132-135) e a LIBER250 (linhas
480-483): primeiro o status na ST9, depois a LOCXITU21, que é a função padrão
responsável por incluir o movimento na FQ4.

O movimento recém incluído é localizado pelo maior R_E_C_N_O_ dos movimentos
do bem, e não pela posição em que a LOCXITU21 deixou o alias. Assim funciona
tanto se ela deixar a FQ4 posicionada no registro novo quanto se ela restaurar
a área de trabalho.

Em seguida o registro é completado com os campos de projeto, cliente, obra e
datas, como faz a LOCA250B (linhas 210-228), e também com o FQ4_STATUS. Essa
última gravação garante que o último movimento da FQ4 e o T9_STATUS da ST9
nunca fiquem divergentes - que é justamente a inconsistência que originou esta
correção.

Se nenhum movimento novo aparecer, a transação é descartada por inteiro e a
mensagem devolve os valores lidos, para diagnóstico.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cCodBem, character, código do bem (ST9->T9_CODBEM)
@param  cStatAtu, character, status atual do bem
@param  cStatNew, character, status de destino
@param  nRegST9, numeric, RecNo da ST9 do bem
@param  lHerda, logical, .T. herda as informações do movimento anterior,
        .F. limpa as informações de locação (bem disponível)
@return logical, .T. quando FQ4 e ST9 foram gravadas
/*/
Static Function LC224Grv(cCodBem, cStatAtu, cStatNew, nRegST9, lHerda)

    Local aAreaFQ4 := FQ4->(GetArea())
    Local cProjet  := ""
    Local cObra    := ""
    Local cAS      := ""
    Local cCodCli  := ""
    Local cNomCli  := ""
    Local cCodMun  := ""
    Local cMunic   := ""
    Local cEst     := ""
    Local cLojCli  := ""
    Local cDiag    := ""
    Local dDtIni   := CToD("")
    Local dDtFim   := CToD("")
    Local dPreDes  := CToD("")
    Local nReg     := 0
    Local nRecAnt  := 0
    Local nRecNew  := 0
    Local lRet     := .T.

    Default lHerda := .T.

    // Movimento mais recente do bem, de onde as informações são herdadas
    nReg := LC224Ult(cCodBem)

    If nReg > 0 .And. lHerda
        FQ4->(DbGoTo(nReg))
        cProjet := FQ4->FQ4_PROJET
        cObra   := FQ4->FQ4_OBRA
        cAS     := FQ4->FQ4_AS
        cCodCli := FQ4->FQ4_CODCLI
        cNomCli := FQ4->FQ4_NOMCLI
        cCodMun := FQ4->FQ4_CODMUN
        cMunic  := FQ4->FQ4_MUNIC
        cEst    := FQ4->FQ4_EST
        cLojCli := FQ4->FQ4_LOJCLI
        dDtIni  := FQ4->FQ4_DTINI
        dDtFim  := FQ4->FQ4_DTFIM
        dPreDes := FQ4->FQ4_PREDES
    EndIf

    // Maior R_E_C_N_O_ atual: identifica o registro que a LOCXITU21 incluir
    nRecAnt := LC224Rec(cCodBem)

    If nReg > 0
        FQ4->(DbGoTo(nReg))
    EndIf

    Begin Transaction

        // 1. Status do bem
        ST9->(DbGoTo(nRegST9))
        ST9->(RecLock("ST9", .F.))
        ST9->T9_STATUS := cStatNew
        ST9->(MsUnlock())

        // 2. Movimento na FQ4
        LOCXITU21(cStatAtu, cStatNew, cProjet, "", "")

        // 3. Localiza o movimento incluído
        nRecNew := LC224Rec(cCodBem)

        // Sem movimento novo nada é gravado: um RecLock(.F.) aqui
        // sobregravaria o último movimento do bem, destruindo o histórico.
        If nRecNew <= nRecAnt

            cDiag := "Bem [" + AllTrim(cCodBem) + "] status [" + AllTrim(cStatAtu) + ;
                     "] para [" + AllTrim(cStatNew) + "]. FQ4: ultimo mov [" + ;
                     cValToChar(nReg) + "] maior recno antes [" + cValToChar(nRecAnt) + ;
                     "] depois [" + cValToChar(nRecNew) + "]. Alias posicionado em [" + ;
                     cValToChar(FQ4->(RecNo())) + "] eof [" + ;
                     IIf(FQ4->(Eof()), "S", "N") + "] bem [" + ;
                     AllTrim(FQ4->FQ4_CODBEM) + "] status [" + ;
                     AllTrim(FQ4->FQ4_STATUS) + "]."

            lRet := .F.
            DisarmTransaction()
            Break
        EndIf

        // 4. Completa o movimento incluído
        FQ4->(DbGoTo(nRecNew))
        FQ4->(RecLock("FQ4", .F.))
        FQ4->FQ4_STATUS := cStatNew
        FQ4->FQ4_PROJET := cProjet
        FQ4->FQ4_OBRA   := cObra
        FQ4->FQ4_AS     := cAS
        FQ4->FQ4_CODCLI := cCodCli
        FQ4->FQ4_NOMCLI := cNomCli
        FQ4->FQ4_CODMUN := cCodMun
        FQ4->FQ4_MUNIC  := cMunic
        FQ4->FQ4_EST    := cEst
        FQ4->FQ4_LOJCLI := cLojCli
        FQ4->FQ4_DTINI  := dDtIni
        FQ4->FQ4_DTFIM  := dDtFim
        FQ4->FQ4_PREDES := dPreDes
        FQ4->(MsUnlock())

    End Transaction

    RestArea(aAreaFQ4)

    If !lRet
        LC224Msg("O movimento não foi gerado na FQ4 pela LOCXITU21 e a alteração foi " + ;
                 "descartada. Nenhum dado foi gravado." + CRLF + CRLF + ;
                 "Informe estes dados à TI: " + cDiag)
    EndIf

Return lRet


/*/{Protheus.doc} LC224Ult
Devolve o RecNo do movimento mais recente do bem na FQ4, considerando o maior
FQ4_SEQ.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cCodBem, character, código do bem
@return numeric, RecNo do movimento, ou 0 quando o bem não tem movimento
/*/
Static Function LC224Ult(cCodBem)

    Local aArea  := FQ4->(GetArea())
    Local cChave := xFilial("FQ4") + PadR(cCodBem, TamSX3("FQ4_CODBEM")[1])
    Local cSeq   := ""
    Local nReg   := 0

    FQ4->(DbSetOrder(1))

    If FQ4->(DbSeek(cChave))
        While !FQ4->(Eof()) .And. FQ4->(FQ4_FILIAL + FQ4_CODBEM) == cChave
            If Empty(cSeq) .Or. FQ4->FQ4_SEQ > cSeq
                cSeq := FQ4->FQ4_SEQ
                nReg := FQ4->(RecNo())
            EndIf
            FQ4->(DbSkip())
        EndDo
    EndIf

    RestArea(aArea)

Return nReg


/*/{Protheus.doc} LC224Rec
Devolve o maior R_E_C_N_O_ entre os movimentos do bem na FQ4.

Serve para identificar com precisão o registro que a LOCXITU21 acabou de
incluir, comparando o valor antes e depois da chamada. Não depende da posição
em que ela deixa o alias nem da sequência gravada no FQ4_SEQ.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cCodBem, character, código do bem
@return numeric, maior RecNo encontrado, ou 0 quando o bem não tem movimento
/*/
Static Function LC224Rec(cCodBem)

    Local aArea  := FQ4->(GetArea())
    Local cChave := xFilial("FQ4") + PadR(cCodBem, TamSX3("FQ4_CODBEM")[1])
    Local nRec   := 0

    FQ4->(DbSetOrder(1))

    If FQ4->(DbSeek(cChave))
        While !FQ4->(Eof()) .And. FQ4->(FQ4_FILIAL + FQ4_CODBEM) == cChave
            If FQ4->(RecNo()) > nRec
                nRec := FQ4->(RecNo())
            EndIf
            FQ4->(DbSkip())
        EndDo
    EndIf

    RestArea(aArea)

Return nRec


/*/{Protheus.doc} LC224OS
Devolve a OS vinculada ao movimento mais recente do bem.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cCodBem, character, código do bem
@return character, número da OS, ou vazio quando não há OS vinculada
/*/
Static Function LC224OS(cCodBem)

    Local aArea := FQ4->(GetArea())
    Local cOS   := ""
    Local nReg  := LC224Ult(cCodBem)

    If nReg > 0
        FQ4->(DbGoTo(nReg))
        cOS := AllTrim(FQ4->FQ4_OS)
    EndIf

    RestArea(aArea)

Return cOS


/*/{Protheus.doc} LC224Man
Monta a lista dos status do bem mapeados como Em manutenção
(FQD_STAREN / TQY_STTCTR = "70"), no formato "99*30*".

Acumula todos os status, como faz a LOCA250B (linha 59), em vez de considerar
apenas um deles, como fazem a LOCA250 e a LOCA250A.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cLista, character, referência - lista dos status em manutenção
@return logical, .T. quando existe pelo menos um status cadastrado
/*/
Static Function LC224Man(cLista)

    Local aArea     := FWGetArea()
    Local lMvLocBac := SuperGetMV("MV_LOCBAC", .F., .F.)

    cLista := ""

    If lMvLocBac
        FQD->(DbSetOrder(1))
        FQD->(DbGoTop())
        While !FQD->(Eof())
            If AllTrim(FQD->FQD_FILIAL) == AllTrim(xFilial("FQD")) .And. ;
               FQD->FQD_STAREN == LC224_STAREN .And. !Empty(FQD->FQD_STATQY)
                cLista += AllTrim(FQD->FQD_STATQY) + "*"
            EndIf
            FQD->(DbSkip())
        EndDo
    Else
        TQY->(DbSetOrder(1))
        TQY->(DbGoTop())
        While !TQY->(Eof())
            If AllTrim(TQY->TQY_FILIAL) == AllTrim(xFilial("TQY")) .And. ;
               TQY->TQY_STTCTR == LC224_STAREN .And. !Empty(TQY->TQY_STATUS)
                cLista += AllTrim(TQY->TQY_STATUS) + "*"
            EndIf
            TQY->(DbSkip())
        EndDo
    EndIf

    FWRestArea(aArea)

Return !Empty(cLista)


/*/{Protheus.doc} LC224Bem
Valida e devolve o bem posicionado no browse da LOCA224.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cCodBem, character, referência - código do bem
@param  cStatAtu, character, referência - status atual do bem
@param  nRegST9, numeric, referência - RecNo da ST9
@return logical, .T. quando há bem posicionado
/*/
Static Function LC224Bem(cCodBem, cStatAtu, nRegST9)

    Local lRet := .T.

    If Select("ST9") == 0 .Or. ST9->(Eof()) .Or. Empty(ST9->T9_CODBEM)
        LC224Msg("Não foi possível identificar o bem selecionado na rotina.")
        lRet := .F.
    Else
        cCodBem  := ST9->T9_CODBEM
        cStatAtu := AllTrim(ST9->T9_STATUS)
        nRegST9  := ST9->(RecNo())
    EndIf

Return lRet


/*/{Protheus.doc} LC224Sts
Devolve o status Rental e a descrição de um status do bem, lendo a tabela de
status conforme o parâmetro MV_LOCBAC (FQD quando .T., TQY quando .F.).

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cStatus, character, status do bem a consultar
@param  cStaRen, character, referência - status Rental (00/10/20/50/60/70)
@param  cDescri, character, referência - descrição do status
@return logical, .T. quando o status está cadastrado
/*/
Static Function LC224Sts(cStatus, cStaRen, cDescri)

    Local aArea     := FWGetArea()
    Local lMvLocBac := SuperGetMV("MV_LOCBAC", .F., .F.)

    cStaRen := ""
    cDescri := ""

    If lMvLocBac
        FQD->(DbSetOrder(2)) // FQD_FILIAL + FQD_STATQY
        If FQD->(DbSeek(xFilial("FQD") + PadR(cStatus, TamSX3("FQD_STATQY")[1])))
            cStaRen := AllTrim(FQD->FQD_STAREN)
            cDescri := AllTrim(FQD->FQD_DESTQY)
        EndIf
    Else
        TQY->(DbSetOrder(1)) // TQY_FILIAL + TQY_STATUS
        If TQY->(DbSeek(xFilial("TQY") + PadR(cStatus, TamSX3("TQY_STATUS")[1])))
            cStaRen := AllTrim(TQY->TQY_STTCTR)
            cDescri := AllTrim(TQY->TQY_DESTAT)
        EndIf
    EndIf

    FWRestArea(aArea)

Return !Empty(cStaRen)


/*/{Protheus.doc} LC224Add
Inclui uma ação no primeiro nível do aRotina da LOCA224, sem duplicar.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  aRotina, array, referência - aRotina da rotina
@param  cTitulo, character, título da ação no menu
@param  cFuncao, character, função executada pela ação
@return nil
/*/
Static Function LC224Add(aRotina, cTitulo, cFuncao)

    If !LC224Has(aRotina, cTitulo)
        AAdd(aRotina, {cTitulo, cFuncao, 0, 7})
    EndIf

Return Nil


/*/{Protheus.doc} LC224Has
Verifica se uma ação já existe no aRotina.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  aRotina, array, aRotina da rotina
@param  cTitulo, character, título procurado
@return logical, .T. quando a ação já existe
/*/
Static Function LC224Has(aRotina, cTitulo)

    Local lRet := .F.
    Local nI   := 0

    For nI := 1 To Len(aRotina)
        If ValType(aRotina[nI]) == "A" .And. Len(aRotina[nI]) > 0
            If AllTrim(cValToChar(aRotina[nI][1])) == cTitulo
                lRet := .T.
                Exit
            EndIf
        EndIf
    Next nI

Return lRet


/*/{Protheus.doc} LC224Msg
Exibe mensagem de inconsistência no padrão de help da rotina.

@type   Static Function
@author BRG - TI
@since  10/09/2026
@param  cSolucao, character, texto da solução apresentada ao usuário
@return nil
/*/
Static Function LC224Msg(cSolucao)

    Help(,, "LC224ROT",, "Inconsistência nos dados.", 1, 0,,,,,, {cSolucao})

Return Nil
