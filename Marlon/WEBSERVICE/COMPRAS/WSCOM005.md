# WSCOM005 — Alteração de Solicitação de Compras

Serviço REST para alteração de Solicitação de Compras (**SC1**) e do rateio dos itens (**SCX**),
pela rotina automática **MATA110**, opção 4.

| | |
|---|---|
| **Método** | `PUT` |
| **Rota** | `/rest/WSCOM005/update?id={C1_NUM}` |
| **Content-Type** | `application/json` |
| **Sucesso** | `200 OK` |
| **Tabelas** | SC1, SCX |
| **Fonte** | `Marlon/WEBSERVICE/COMPRAS/WSCOM005.PRW` |

O prefixo `/rest` depende da configuração do `appserver.ini` do ambiente.
O `id` vai na **query string**, não no body.

---

## A regra que governa o serviço

> **Alteração parcial** — todo campo é opcional, exceto os que identificam o registro.
> O que não vem no JSON é lido do registro atual e reenviado sem alteração; nunca é apagado.

Na prática: para mudar só a quantidade de um item, mande só a quantidade. Produto, armazém, data
de necessidade, tipo de rateio, centro de custo e as linhas da SCX permanecem exatamente como estão
na base.

Isso vale porque o serviço monta os arrays do ExecAuto **completos** — a MATA110 localiza cada campo
por `AScan` e indexa o resultado direto, então um array incompleto derruba a rotina com
*array out of bounds*. O efeito de "campo opcional" vem da releitura do registro, não da omissão
do campo.

---

## Campos

### Identificam o registro — nunca são alterados

| JSON | Campo | | Observação |
|---|---|---|---|
| `id` (query) | `C1_NUM` | chave | Número da Solicitação de Compras |
| `cabecalho.filial` | `C1_FILIAL` | chave | Se omitido, assume a filial do ambiente |
| `itens[].itemC1` | `C1_ITEM` | obrigatório | Identifica a linha da SC a ser alterada |

### cabecalho

| JSON | Campo | Tipo | Descrição |
|---|---|---|---|
| `solicit` | `C1_SOLICIT` | string | Solicitante |
| `xurgen` | `C1_XURGEN` | string | Urgência da SC — `"1"` Sim · `"2"` Não. Vale para todos os itens enviados |

### itens[]

| JSON | Campo | Tipo | Descrição |
|---|---|---|---|
| `produto` | `C1_PRODUTO` | string | Código do produto |
| `quant` | `C1_QUANT` | number | Quantidade — sem aspas |
| `local` | `C1_LOCAL` | string | Armazém |
| `dtentrega` | `C1_DATPRF` | string | Data de necessidade no formato `YYYY-MM-DD` |
| `rateio` | `C1_RATEIO` | string | `"1"` rateado · `"2"` centro de custo único |
| `ccusto` | `C1_CC` | string | Centro de custo — considerado somente quando `rateio` = `"2"` |
| `xurgen` | `C1_XURGEN` | string | Urgência da SC — `"1"` Sim · `"2"` Não. Sobrepõe o valor informado no cabeçalho |

### itens[].rateioCX[] — quando `rateio` = `"1"`

| JSON | Campo | Tipo | Descrição |
|---|---|---|---|
| `perc` | `CX_PERC` | number | Percentual da faixa — maior que 0 e até 100 |
| `cc` | `CX_CC` | string | Centro de custo da faixa |

### Não alteráveis por este serviço

Campos de controle do Protheus: `C1_EMISSAO`, `C1_APROV`, `C1_APROVC`, `C1_PEDIDO`, `C1_QUJE`,
`C1_USER`, `C1_ORIGEM`, `C1_FOIBLQ` e demais campos de aprovação.

---

## Comportamento do rateioCX

O array do rateio segue a mesma regra dos demais campos, com uma diferença importante:
quando informado, ele **substitui integralmente** o rateio do item — não faz merge faixa a faixa.

| Situação | Resultado |
|---|---|
| Omitido | O rateio gravado na SCX é relido e reenviado igual |
| Preenchido | Substitui integralmente as faixas do item |
| `[]` ou não-array | Erro `NEW008` — para manter o rateio atual, omita o campo |
| Item rateado sem SCX | Erro `NEW016` — aí o `rateioCX` é realmente necessário |

> **Atenção** — o `CX_ITEM` é regerado pela ordem do array. Enviar 2 faixas onde havia 3 renumera
> as faixas para `0001` e `0002`; a terceira deixa de existir. Um campo `item` enviado dentro do
> `rateioCX` é ignorado.

> **Atenção** — o serviço valida cada percentual individualmente (maior que 0, até 100), mas
> **não** valida a soma. Um rateio que não fecha 100% é recusado pela MATA110 e retorna `UPD009`
> com o motivo no arquivo de log.

---

## Comportamento do xurgen

O `xurgen` grava o `C1_XURGEN`, que indica se a Solicitação de Compras é urgente:
`"1"` = Sim, `"2"` = Não. Como todo campo do serviço, é opcional.

| Situação | Resultado |
|---|---|
| Omitido no cabeçalho e nos itens | O valor gravado na SC1 é mantido |
| Informado no cabeçalho | Aplicado a todos os itens enviados na requisição |
| Informado no item | Sobrepõe o valor do cabeçalho, somente naquele item |
| Diferente de `"1"` e `"2"` | Erro `NEW017` — nada é gravado |

> O valor pode chegar como string (`"1"`) ou como número (`1`); ambos são aceitos, mesmo
> tratamento dado ao `rateio`.

---

## Exemplos

### Alterar somente a quantidade — tudo o mais é preservado

```http
PUT /rest/WSCOM005/update?id=000001
Content-Type: application/json
```

```json
{
  "cabecalho": { "filial": "0101" },
  "itens": [
    { "itemC1": "0001", "quant": 25 }
  ]
}
```

### Alterar vários campos de um item de centro de custo único

```json
{
  "cabecalho": {
    "filial": "0101",
    "solicit": "000001"
  },
  "itens": [
    {
      "itemC1": "0001",
      "produto": "PROD001",
      "quant": 15,
      "local": "01",
      "dtentrega": "2026-09-30",
      "rateio": "2",
      "ccusto": "20010006",
      "xurgen": "2"
    }
  ]
}
```

### Redistribuir o rateio de um item — substitui as faixas atuais

```json
{
  "cabecalho": { "filial": "0101" },
  "itens": [
    {
      "itemC1": "0002",
      "rateio": "1",
      "rateioCX": [
        { "perc": 60, "cc": "20010006" },
        { "perc": 40, "cc": "20010007" }
      ]
    }
  ]
}
```

### Vários itens na mesma requisição

```json
{
  "cabecalho": { "filial": "0101" },
  "itens": [
    { "itemC1": "0001", "quant": 25 },
    { "itemC1": "0002", "dtentrega": "2026-10-15" }
  ]
}
```

---

## Respostas

### 200 OK

```json
{
  "success": true,
  "message": "Solicitacao de Compras alterada com sucesso.",
  "note": "Registro alterado com sucesso",
  "num": "000001",
  "filial": "0101",
  "itensAlterados": 1
}
```

### Erro — mesmo formato em todos os status

```json
{
  "success": false,
  "message": "<orientação para resolver>",
  "errorId": "NEW012",
  "error": "<natureza do erro>",
  "solution": "<orientação para resolver>"
}
```

O `errorId` é o campo estável para tratamento programático. O `message` e o `solution` carregam
o mesmo texto, escrito para leitura humana.

---

## Códigos de erro

Na ordem em que as validações ocorrem. As três primeiras acontecem antes de qualquer acesso à base.

| ID | HTTP | Causa |
|---|---|---|
| `UPD005` | 400 | Requisição sem body. Confirme o envio do JSON e o header `Content-Type` |
| `UPD008` | 400 | JSON malformado. A mensagem traz o erro do parse e a quantidade de bytes recebidos — vírgula sobrando antes de `]` ou `}` é a causa mais comum |
| `UPD006` | 400 | `id` não informado na query string |
| `UPD010` | 400 | Falta o objeto `cabecalho` |
| `NEW007` | 400 | Falta o array `itens`, ou ele veio vazio |
| `UPD011` | 409 | A filial informada é diferente da filial do ambiente |
| `UPD007` | 404 | Solicitação de Compras não encontrada na filial |
| `NEW009` | 400 | Um elemento do array `itens` não é um objeto |
| `NEW010` | 400 | `itemC1` ausente — é ele que identifica a linha da SC |
| `NEW012` | 404 | O item não existe na Solicitação de Compras |
| `NEW013` | 400 | `dtentrega` inválida. Use `YYYY-MM-DD` |
| `NEW014` | 400 | `rateio` diferente de `"1"` e `"2"` |
| `NEW017` | 400 | `xurgen` diferente de `"1"` e `"2"` — no cabeçalho ou no item |
| `NEW008` | 400 | `rateioCX` informado mas vazio ou não-array |
| `NEW016` | 400 | Item marcado como rateado, sem rateio na SCX e sem `rateioCX` no JSON |
| `NEW011` | 400 | Uma linha do `rateioCX` não é um objeto |
| `NEW015` | 400 | `perc` menor ou igual a zero, ou maior que 100 |
| `UPD009` | 500 | A MATA110 recusou a alteração. O motivo real está no arquivo de log — o caminho vem na mensagem |

---

## Notas de operação

- **Filial do ambiente.** A rotina automática opera na filial corrente. Alterar uma SC de outra
  filial exige conectar no ambiente daquela filial — caso contrário retorna `UPD011`.
- **Transação.** Não há `RecLock` manual nem `Begin Transaction` no serviço: a MATA110 controla
  transação e bloqueio dos registros.
- **Log de erro.** Quando a MATA110 falha, o retorno da rotina é gravado em
  `\x_logs\WSCOM005_Upd_<data>_<hora>.log` e também vai para o console do AppServer. É lá que
  está o motivo real de um `UPD009`.
- **Atomicidade.** A requisição inteira é validada antes de chamar o ExecAuto. Se qualquer item
  falhar na validação, nada é gravado.
- **Consulta.** Para ler a SC e o rateio antes de alterar, use o `WSCOM006`.
