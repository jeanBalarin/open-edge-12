/********************************************************************************
Arquivo..: order.i
autor....: Jean Marcos
Objetivo.: Define estruturas da tabela do banco Custumer.
*********************************************************************************/

DEFINE TEMP-TABLE tt-order NO-UNDO SERIALIZE-NAME "orders"
  FIELD BillToID     AS INTEGER     FORMAT "zzzzzzzzz9" 
  FIELD Carrier      AS CHARACTER   FORMAT "x(25)"      
  FIELD CreditCard   AS CHARACTER   FORMAT "x(20)"      
  FIELD CustNum      AS INTEGER     FORMAT ">>>>9"      
  FIELD Instructions AS CHARACTER   FORMAT "x(50)"      
  FIELD OrderDate    AS DATE        INITIAL TODAY       
  FIELD OrderNum     AS INTEGER     FORMAT "zzzzzzzzz9" 
  FIELD OrderStatus  AS CHARACTER   FORMAT "x(20)" 
  FIELD PO           AS CHARACTER   FORMAT "x(20)" 
  FIELD PromiseDate  AS DATE        LABEL "Promised"
  FIELD SalesRep     AS CHARACTER   FORMAT "x(4)"       
  FIELD ShipDate     AS DATE        FORMAT "99/99/9999" 
  FIELD ShipToID     AS INTEGER     FORMAT "zzzzzzzzz9" 
  FIELD Terms        AS CHARACTER   FORMAT "x(20)" 
  FIELD WarehouseNum AS INTEGER     FORMAT "zzzzzzzzz9".
