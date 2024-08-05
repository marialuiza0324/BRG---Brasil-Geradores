#Include 'Protheus.ch'

User Function MTA094RO()

Local aRotina:= PARAMIXB[1]

aAdd(aRotina, {"Detalhamento do Pedido", "U_FSCOM003()", 0, 7, 0, Nil})


Return (aRotina)
