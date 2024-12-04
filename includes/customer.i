/********************************************************************************
Arquivo..: customer.i
autor....: Jean Marcos
Objetivo.: Define estruturas da tabela do banco Custumer.
*********************************************************************************/

DEFINE TEMP-TABLE tt-customer /* LIKE Customer */
  FIELD Address      AS CHARACTER              FORMAT "x(35)"          SERIALIZE-NAME "endereco"
  FIELD Address2     AS CHARACTER              FORMAT "x(35)"          SERIALIZE-NAME "endereco_2"
  FIELD Balance      AS DECIMAL     DECIMALS 2 FORMAT "->,>>>,>>9.99"  //SERIALIZE-NAME ""
  FIELD City         AS CHARACTER              FORMAT "x(25)"          SERIALIZE-NAME "Cidade"
  FIELD Comments     AS CHARACTER              FORMAT "x(80)"          SERIALIZE-NAME "Observacoes"
  FIELD Contact      AS CHARACTER              FORMAT "x(30)"          SERIALIZE-NAME "contato"
  FIELD Country      AS CHARACTER              FORMAT "x(20)"          SERIALIZE-NAME "pais"
  FIELD CreditLimit  AS DECIMAL     DECIMALS 2 FORMAT "->,>>>,>>9"     SERIALIZE-NAME "limieteCredito"
  FIELD CustNum      AS INTEGER                FORMAT ">>>>9"          SERIALIZE-NAME "codigo"
  FIELD Discount     AS INTEGER                FORMAT ">>9%"           SERIALIZE-NAME "descontos"
  FIELD EmailAddress AS CHARACTER              FORMAT "x(50)"          SERIALIZE-NAME "email"
  FIELD Fax          AS CHARACTER              FORMAT "x(20)"          SERIALIZE-NAME "fax"
  FIELD Name         AS CHARACTER              FORMAT "x(30)"          SERIALIZE-NAME "nome"
  FIELD Phone        AS CHARACTER              FORMAT "x(20)"          SERIALIZE-NAME "telefone"
  FIELD PostalCode   AS CHARACTER              FORMAT "x(10)"          SERIALIZE-NAME "codigoPOstal"
  FIELD SalesRep     AS CHARACTER              FORMAT "x(4)"           SERIALIZE-NAME "representante"
  FIELD State        AS CHARACTER              FORMAT "x(20)"          SERIALIZE-NAME "estado"
  FIELD Terms        AS CHARACTER              FORMAT "x(20)"          SERIALIZE-NAME "termos"
  INDEX id AS PRIMARY UNIQUE custNum.
