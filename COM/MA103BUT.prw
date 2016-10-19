#Include "Rwmake.ch"
#Include "VKEY.CH"
/*
+-----------+------------+----------------+---------------+--------+------------+
| Programa  | MA103BUT   | Desenvolvedor  | Mr. Carraro   | Data   | 22/08/02   |
+-----------+------------+----------------+---------------+--------+------------+
| Descricao | Botao Adicional a Nota Fiscal de Entrada                          |
+-----------+-------------------------------------------------------------------+
| Uso       | Expecifico EPC/TSA                                                |
+-----------+-------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                   |
+-------------+---------+-------------------------------------------------------+
| Humano      | Data    | Motivo                                                |
+-------------+---------+-------------------------------------------------------+
+-------------+---------+-------------------------------------------------------+
*/

User Function MA103BUT()

Local aBtNew := {}

AAdd( aBtNew,{ "PRODUTO", { || U_A103F4ItemPC() } ,"Pedidos de Compra - EPC/TSA <F10>" } )

SetKey(VK_F10, { || U_A103F4ItemPC() })
Return(aBtNew)                       

MT103VPC()

