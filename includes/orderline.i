/********************************************************************************
Arquivo..: customer.i
autor....: Jean Marcos
Objetivo.: Define estruturas da tabela do banco Custumer.
*********************************************************************************/
DEFINE TEMP-TABLE tt-orderline NO-UNDO SERIALIZE-NAME "orderLine"
  FIELD Discount        AS INTEGER                
  FIELD ExtendedPrice   AS DECIMAL     DECIMALS 2 
  FIELD ItemNum         AS INTEGER                
  FIELD LineNum         AS INTEGER                
  FIELD OrderLineStatus AS CHARACTER              
  FIELD OrderNum        AS INTEGER                
  FIELD Price           AS DECIMAL     DECIMALS 2 
  FIELD Qty             AS INTEGER                
  .
