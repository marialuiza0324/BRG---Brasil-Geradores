# WSCON006 — Inclusão de Orçamento Contábil

Serviço REST para inclusão de orçamento contábil na **CV2** (cabeçalho) e na **CV1** (períodos).
Versão REST da rotina **ATUCTB001**, que faz a mesma importação por arquivo CSV — mesma regra de negócio.

| | |
|---|---|
| **Método** | `POST` |
| **Rota** | `http://172.49.49.3:59200/rest/WSCON006/new` |
| **Content-Type** | `application/json` |
| **Sucesso** | `201 Created` |
| **Grava** | CV2, CV1 |
| **Valida contra** | CTO, CTG, CTE, CT1, CTT |
| **Fonte** | `Marlon/WEBSERVICE/CONTABILIDADE/WSCON006.PRW` |

O prefixo `/rest` depende da configuração do `appserver.ini` do ambiente.
Não há parâmetro na query string — tudo vai no body.

---

## Como o orçamento é montado

> **Regra central** — cada item do JSON vira **12 registros na CV1**, um por período do exercício.
> O cabeçalho vira **1 registro na CV2**.

```
1 item (conta 3302010036)
   |
   +-- periodo 01 (jan)  CV1_VALOR = valores[1]
   +-- periodo 02 (fev)  CV1_VALOR = valores[2]
   +-- ...
   +-- periodo 12 (dez)  CV1_VALOR = valores[12]
```

Para cada período `n`:

- `CV1_PERIOD` = `StrZero(n, 2)`
- `CV1_DTINI` = primeiro dia do mês `n` do exercício (`FirstDate`)
- `CV1_DTFIM` = último dia do mês `n` do exercício (`LastDate`)
- `CV1_VALOR` = `valores[n]`

O `CV1_SEQUEN` é a **posição do item no array**: o primeiro item recebe `0001` nos seus 12
registros, o segundo recebe `0002`, e assim por diante.

**O número do orçamento é sempre gerado pelo Protheus**, pelo semáforo do `CV2_ORCMTO`.
Não envie o número no JSON — ele volta na resposta.

---

## Campos

### cabecalho

| JSON | Campo | | Descrição |
|---|---|---|---|
| `filial` | — | obrigatório | Validado como não vazio e devolvido na resposta. Veja [Atenção — filial](#atenção--filial) |
| `descricao` | `CV2_DESCRI`<br>`CV1_DESCRI` | obrigatório | Descrição do orçamento, replicada em todos os registros |
| `calendario` | `CV2_CALEND`<br>`CV1_CALEND` | obrigatório | Calendário contábil — precisa ter os 12 períodos do exercício cadastrados na CTG |
| `moeda` | `CV2_MOEDA`<br>`CV1_MOEDA` | obrigatório | Moeda contábil da CTO, com amarração moeda × calendário na CTE |
| `revisao` | `CV2_REVISA`<br>`CV1_REVISA` | obrigatório | Normalizado com `StrZero` — enviar `"1"` grava `001` |
| `exercicio` | — | obrigatório | Ano com 4 dígitos. Monta as datas dos períodos e busca o calendário; não é gravado como campo próprio |

### itens[]

| JSON | Campo | | Descrição |
|---|---|---|---|
| `conta` | `CV1_CT1INI`<br>`CV1_CT1FIM` | obrigatório | Conta contábil analítica e desbloqueada. Gravada como início e fim da faixa |
| `ccusto` | `CV1_CTTINI`<br>`CV1_CTTFIM` | condicional | Obrigatório quando a conta tem `CT1_INDNAT = '4'` (despesa/custo) |
| `clvl` | `CV1_CTHINI`<br>`CV1_CTHFIM` | opcional | Classe de valor. Envie `""` quando não usar |
| `valores` | `CV1_VALOR` | obrigatório | Array de exatamente 12 posições, na ordem jan → dez |

### Preenchidos pelo serviço

| Campo | Valor | Origem |
|---|---|---|
| `CV2_ORCMTO`<br>`CV1_ORCMTO` | gerado | Semáforo `GetSXENum`, com avanço até um número livre |
| `CV2_STATUS`<br>`CV1_STATUS` | `'1'` | Fixo |
| `CV2_STATSL` | `' '` | Fixo, em branco |
| `CV2_APROVA`<br>`CV1_APROVA` | `cUserName` | Usuário da conexão REST, não um aprovador informado no JSON |
| `CV1_PERIOD` | `'01'`…`'12'` | Índice da posição no array `valores` |
| `CV1_DTINI`<br>`CV1_DTFIM` | data | `FirstDate` e `LastDate` do mês do período no exercício |
| `CV1_SEQUEN` | `'0001'`… | Posição do item no array `itens` |
| `CV1_CTDINI`<br>`CV1_CTDFIM` | `' '` | Item contábil — sempre em branco |

---

## O array de valores

São **12 posições fixas**, uma por período. Um array com qualquer outro tamanho recusa o item —
não há preenchimento automático de meses faltantes.

Cada posição aceita **número** ou **texto no formato brasileiro**. As duas formas abaixo gravam
o mesmo `CV1_VALOR`:

```jsonc
// numero - sem aspas, ponto como separador decimal
"valores": [3833.33, 3833.33, 11747.86, ...]

// texto no padrao brasileiro - ponto de milhar, virgula decimal
"valores": ["3.833,33", "3.833,33", "11.747,86", ...]
```

Vale escolher uma das duas e manter — misturar formatos no mesmo array funciona, mas dificulta
conferir o arquivo de origem.

---

## Validações

> **Tudo antes de gravar** — nada é escrito enquanto houver crítica pendente, e todas as críticas
> voltam juntas numa única resposta, o mesmo comportamento do diálogo da ATUCTB001.

Na ordem em que ocorrem:

| Verificação | Tabela | Recusa quando |
|---|---|---|
| Moeda contábil | CTO | A moeda não está cadastrada |
| Calendário | CTG | Falta qualquer um dos 12 períodos do exercício — a crítica nomeia o período faltante |
| Moeda × calendário | CTE | A amarração entre os dois não existe |
| Conta | CT1 | Não cadastrada · bloqueada (`CT1_BLOQ = '1'`) · sintética (`CT1_CLASSE = '1'`) |
| Centro de custo | CT1, CTT | Exigido e ausente quando `CT1_INDNAT = '4'` · não cadastrado · bloqueado (`CTT_BLOQ = '1'`) |
| Array de valores | — | Não é array, ou não tem exatamente 12 posições |

Todas essas críticas voltam agrupadas em **NEW008**, no campo `solution`, com o número do item
à frente de cada uma.

---

## Exemplos

### Exemplo mínimo — dois itens

Dois itens do mesmo centro de custo — gera 24 registros na CV1.

```http
POST /rest/WSCON006/new
Content-Type: application/json
```

```json
{
  "cabecalho": {
    "filial":     "0101",
    "descricao":  "19010001 - CONSELHO ADMINISTRATIVO",
    "calendario": "003",
    "moeda":      "01",
    "revisao":    "001",
    "exercicio":  "2026"
  },
  "itens": [
    {
      "conta":   "3302010036",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [3833.33, 3833.33, 3833.33, 3833.33,
                  3833.33, 3833.33, 3833.33, 3833.33,
                  3833.33, 3833.33, 3833.33, 3833.33]
    },
    {
      "conta":   "3302010040",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [11747.86, 11747.86, 11747.86, 11747.86,
                  11747.86, 11747.86, 11747.86, 11747.86,
                  11747.86, 11747.86, 11747.86, 11747.86]
    }
  ]
}
```

### Body real — orçamento do Conselho Administrativo

Este é o body usado na carga do exercício 2026 do centro de custo `19010001`. Serve como
referência de escala e de formatação real.

| | |
|---|---|
| Itens | 37 |
| Registros gerados na CV1 | 37 × 12 = **444** |
| Registros gerados na CV2 | 1 |
| Centro de custo | `19010001` em todos os itens |
| Classe de valor | `""` em todos os itens |
| Formato dos valores | numérico, com ponto decimal |
| Valor idêntico nos 12 períodos | sim — orçamento linear |

Repare que algumas contas aparecem mais de uma vez: a `3302010037` nos itens 12 a 15 e a
`3302010020` nos itens 16 a 19. **O serviço não consolida contas repetidas** — cada ocorrência
vira um `CV1_SEQUEN` próprio com seus 12 períodos. É assim que se orça a mesma conta em rubricas
diferentes dentro do mesmo centro de custo.

<details>
<summary><b>Body completo — 37 itens</b> (clique para expandir)</summary>

```json
{
  "cabecalho": {
    "filial":     "0101",
    "descricao":  "19010001 - CONSELHO ADMINISTRATIVO",
    "calendario": "003",
    "moeda":      "01",
    "revisao":    "001",
    "exercicio":  "2026"
  },
  "itens": [
    {
      "conta":   "3302010036",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [3833.33, 3833.33, 3833.33, 3833.33,
                  3833.33, 3833.33, 3833.33, 3833.33,
                  3833.33, 3833.33, 3833.33, 3833.33]
    },
    {
      "conta":   "3302010040",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [11747.86, 11747.86, 11747.86, 11747.86,
                  11747.86, 11747.86, 11747.86, 11747.86,
                  11747.86, 11747.86, 11747.86, 11747.86]
    },
    {
      "conta":   "3302010026",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [118.55, 118.55, 118.55, 118.55,
                  118.55, 118.55, 118.55, 118.55,
                  118.55, 118.55, 118.55, 118.55]
    },
    {
      "conta":   "3302010031",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [19766.16, 19766.16, 19766.16, 19766.16,
                  19766.16, 19766.16, 19766.16, 19766.16,
                  19766.16, 19766.16, 19766.16, 19766.16]
    },
    {
      "conta":   "3301010027",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [810.00, 810.00, 810.00, 810.00,
                  810.00, 810.00, 810.00, 810.00,
                  810.00, 810.00, 810.00, 810.00]
    },
    {
      "conta":   "3301010021",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [865.11, 865.11, 865.11, 865.11,
                  865.11, 865.11, 865.11, 865.11,
                  865.11, 865.11, 865.11, 865.11]
    },
    {
      "conta":   "3301010023",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [36.00, 36.00, 36.00, 36.00,
                  36.00, 36.00, 36.00, 36.00,
                  36.00, 36.00, 36.00, 36.00]
    },
    {
      "conta":   "3301010024",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [260.00, 260.00, 260.00, 260.00,
                  260.00, 260.00, 260.00, 260.00,
                  260.00, 260.00, 260.00, 260.00]
    },
    {
      "conta":   "3301010018",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [1084.17, 1084.17, 1084.17, 1084.17,
                  1084.17, 1084.17, 1084.17, 1084.17,
                  1084.17, 1084.17, 1084.17, 1084.17]
    },
    {
      "conta":   "3301010011",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [12.50, 12.50, 12.50, 12.50,
                  12.50, 12.50, 12.50, 12.50,
                  12.50, 12.50, 12.50, 12.50]
    },
    {
      "conta":   "3302010032",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [4.17, 4.17, 4.17, 4.17,
                  4.17, 4.17, 4.17, 4.17,
                  4.17, 4.17, 4.17, 4.17]
    },
    {
      "conta":   "3302010037",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [168.33, 168.33, 168.33, 168.33,
                  168.33, 168.33, 168.33, 168.33,
                  168.33, 168.33, 168.33, 168.33]
    },
    {
      "conta":   "3302010037",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [110.33, 110.33, 110.33, 110.33,
                  110.33, 110.33, 110.33, 110.33,
                  110.33, 110.33, 110.33, 110.33]
    },
    {
      "conta":   "3302010037",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [1.92, 1.92, 1.92, 1.92,
                  1.92, 1.92, 1.92, 1.92,
                  1.92, 1.92, 1.92, 1.92]
    },
    {
      "conta":   "3302010037",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [6.75, 6.75, 6.75, 6.75,
                  6.75, 6.75, 6.75, 6.75,
                  6.75, 6.75, 6.75, 6.75]
    },
    {
      "conta":   "3302010020",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [54.63, 54.63, 54.63, 54.63,
                  54.63, 54.63, 54.63, 54.63,
                  54.63, 54.63, 54.63, 54.63]
    },
    {
      "conta":   "3302010020",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [290.40, 290.40, 290.40, 290.40,
                  290.40, 290.40, 290.40, 290.40,
                  290.40, 290.40, 290.40, 290.40]
    },
    {
      "conta":   "3302010020",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [73.33, 73.33, 73.33, 73.33,
                  73.33, 73.33, 73.33, 73.33,
                  73.33, 73.33, 73.33, 73.33]
    },
    {
      "conta":   "3302010020",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [12.25, 12.25, 12.25, 12.25,
                  12.25, 12.25, 12.25, 12.25,
                  12.25, 12.25, 12.25, 12.25]
    },
    {
      "conta":   "3301010022",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [1602.55, 1602.55, 1602.55, 1602.55,
                  1602.55, 1602.55, 1602.55, 1602.55,
                  1602.55, 1602.55, 1602.55, 1602.55]
    },
    {
      "conta":   "3302010039",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [6500.00, 6500.00, 6500.00, 6500.00,
                  6500.00, 6500.00, 6500.00, 6500.00,
                  6500.00, 6500.00, 6500.00, 6500.00]
    },
    {
      "conta":   "3302010009",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [12.06, 12.06, 12.06, 12.06,
                  12.06, 12.06, 12.06, 12.06,
                  12.06, 12.06, 12.06, 12.06]
    },
    {
      "conta":   "3301010029",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [40.00, 40.00, 40.00, 40.00,
                  40.00, 40.00, 40.00, 40.00,
                  40.00, 40.00, 40.00, 40.00]
    },
    {
      "conta":   "3302010011",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [1909.59, 1909.59, 1909.59, 1909.59,
                  1909.59, 1909.59, 1909.59, 1909.59,
                  1909.59, 1909.59, 1909.59, 1909.59]
    },
    {
      "conta":   "3302010012",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [4316.37, 4316.37, 4316.37, 4316.37,
                  4316.37, 4316.37, 4316.37, 4316.37,
                  4316.37, 4316.37, 4316.37, 4316.37]
    },
    {
      "conta":   "3302010013",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [526.05, 526.05, 526.05, 526.05,
                  526.05, 526.05, 526.05, 526.05,
                  526.05, 526.05, 526.05, 526.05]
    },
    {
      "conta":   "3302010016",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [8750.00, 8750.00, 8750.00, 8750.00,
                  8750.00, 8750.00, 8750.00, 8750.00,
                  8750.00, 8750.00, 8750.00, 8750.00]
    },
    {
      "conta":   "3302010018",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [669.38, 669.38, 669.38, 669.38,
                  669.38, 669.38, 669.38, 669.38,
                  669.38, 669.38, 669.38, 669.38]
    },
    {
      "conta":   "3302010024",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [492.80, 492.80, 492.80, 492.80,
                  492.80, 492.80, 492.80, 492.80,
                  492.80, 492.80, 492.80, 492.80]
    },
    {
      "conta":   "3302010025",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [26049.91, 26049.91, 26049.91, 26049.91,
                  26049.91, 26049.91, 26049.91, 26049.91,
                  26049.91, 26049.91, 26049.91, 26049.91]
    },
    {
      "conta":   "3302010028",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [408.63, 408.63, 408.63, 408.63,
                  408.63, 408.63, 408.63, 408.63,
                  408.63, 408.63, 408.63, 408.63]
    },
    {
      "conta":   "3302010029",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [50.75, 50.75, 50.75, 50.75,
                  50.75, 50.75, 50.75, 50.75,
                  50.75, 50.75, 50.75, 50.75]
    },
    {
      "conta":   "3302010035",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [19317.81, 19317.81, 19317.81, 19317.81,
                  19317.81, 19317.81, 19317.81, 19317.81,
                  19317.81, 19317.81, 19317.81, 19317.81]
    },
    {
      "conta":   "3302010049",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [26.25, 26.25, 26.25, 26.25,
                  26.25, 26.25, 26.25, 26.25,
                  26.25, 26.25, 26.25, 26.25]
    },
    {
      "conta":   "3302010052",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [493.90, 493.90, 493.90, 493.90,
                  493.90, 493.90, 493.90, 493.90,
                  493.90, 493.90, 493.90, 493.90]
    },
    {
      "conta":   "3302030001",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [255.94, 255.94, 255.94, 255.94,
                  255.94, 255.94, 255.94, 255.94,
                  255.94, 255.94, 255.94, 255.94]
    },
    {
      "conta":   "3302010007",
      "ccusto":  "19010001",
      "clvl":    "",
      "valores": [514.27, 514.27, 514.27, 514.27,
                  514.27, 514.27, 514.27, 514.27,
                  514.27, 514.27, 514.27, 514.27]
    }
  ]
}
```

</details>

---

## Respostas

### 201 Created

```json
{
  "note":      "Orcamento 000042 incluido com sucesso",
  "orcamento": "000042",
  "filial":    "0101",
  "revisao":   "001",
  "itens":     2,
  "periodos":  24
}
```

Confira sempre `periodos` — ele deve ser igual a `itens × 12`. Para o body real acima, a resposta traz `"itens": 37` e `"periodos": 444`.

### Erro — mesmo formato em todos os status

```json
{
  "errorId":  "NEW008",
  "error":    "Validacao do orcamento",
  "solution": "Item 3: conta 3302010036 e sintetica. Item 7: ..."
}
```

O `errorId` é o campo estável para tratamento programático; o `solution` carrega o texto para
leitura humana.

---

## Códigos de erro

| ID | HTTP | Causa |
|---|---|---|
| `NEW001` | 400 | JSON malformado — vírgula sobrando antes de `]` ou `}` é a causa mais comum |
| `NEW002` | 500 | Não foi possível abrir uma das tabelas necessárias. A mensagem lista quais |
| `NEW003` | 400 | Falta o objeto `cabecalho` |
| `NEW004` | 400 | Falta o array `itens`, ou ele veio vazio |
| `NEW005` | 400 | Falta `filial`, `descricao`, `calendario`, `moeda` ou `revisao` |
| `NEW006` | 400 | `exercicio` sem 4 dígitos ou não numérico |
| `NEW008` | 422 | Críticas de cadastro — moeda, calendário, amarração, conta, centro de custo ou tamanho do array de valores. Todas vêm agrupadas |
| `NEW009` | 500 | A gravação não fechou a contagem esperada. A transação é desfeita e a numeração reservada é devolvida — nenhum registro é mantido |

---

## Notas de operação

- **Transação única.** Cabeçalho e itens gravam dentro de um mesmo `Begin Transaction`. Falha em
  qualquer ponto desfaz tudo — não existe orçamento gravado pela metade.
- **Numeração.** O número só é confirmado (`ConfirmSX8`) depois da contagem bater. Se não bater,
  o `RollBackSX8` devolve o número ao semáforo.
- **Tabelas.** A thread REST não herda as tabelas abertas de um módulo, então o serviço abre
  CV1, CV2, CT1, CTT, CTO, CTG e CTE por conta própria e falha cedo com `NEW002` se alguma não abrir.
- **Origem da regra.** É a mesma regra de negócio da ATUCTB001, a importação por CSV — inclusive
  as 12 colunas de valor e a lista de críticas agrupadas.


### Atenção — duplicidade

Não há verificação de orçamento já existente. Postar o mesmo body duas vezes cria dois orçamentos,
com números diferentes, para o mesmo calendário, moeda e revisão. Uma repetição por falha de rede
não é detectada pelo serviço.
