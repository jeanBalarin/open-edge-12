/*********************************************************************************
arquivo..: dataset-customer-order.i
Autor....: Jean Marcos 
Objetivo.: Dataset para Customer
**********************************************************************************/
USING Progress.Json.ObjectModel.JsonObject.

{includes/dsCustomerOrder.i}

DEF VAR ix     AS INT NO-UNDO.
DEF VAR i-reg  AS INT NO-UNDO.
DEF VAR oJson  AS JsonObject.

DEFINE DATA-SOURCE src-customer FOR Customer.
DEFINE DATA-SOURCE src-order    FOR Order.
DEFINE DATA-SOURCE src-orderLine FOR OrderLine.

//RUN p-for-each-fill-dataset.
//DATASET dsCustomerOrder:WRITE-JSON("File", "c:\temp\ds-custorder.json", TRUE).

RUN p-fill-method-dataset.

oJson = NEW   JsonObject().
DATASET dsCustomerOrder:WRITE-JSON("JsonObject", oJson).

oJson:ADD("quantidadeRegistros", i-reg).

oJson:WriteFile("c:\temp\dsCustOrderFillDts.Json", TRUE).



PROCEDURE p-fill-method-dataset:
/* carrega os dados das temp-tables com o metodo fill usando datasources */

    DATASET dsCustomerOrder:EMPTY-DATASET().

    BUFFER tt-customer:ATTACH-DATA-SOURCE(DATA-SOURCE src-customer:HANDLE).
    BUFFER tt-order:ATTACH-DATA-SOURCE(DATA-SOURCE src-order:HANDLE).
    BUFFER tt-orderLine:ATTACH-DATA-SOURCE(DATA-SOURCE src-orderLine:HANDLE).
    
    /* forma de chamar uma procedure para customizar os campos da tt */
    BUFFER tt-customer:SET-CALLBACK-PROCEDURE("after-row-fill", "p-cont-registros", THIS-PROCEDURE /* ou handle*/).
    
    /* define a quantidade de registros (tamanho do lote) */
    BUFFER tt-customer:BATCH-SIZE = 100.
    
    /* Parametros que podem ser passados como filtros*/
    DATA-SOURCE src-customer:FILL-WHERE-STRING = "WHERE CustNum >= 4000".
    
     i-reg = 0.
    DATASET dsCustomerOrder:FILL().
    
   

END PROCEDURE.

PROCEDURE p-for-each-fill-dataset:
/* Carrega os dados do dataset via for each convencional */
    
    // equivale a fazer empty temp-table para todas as tts do conjunto.
    DATASET dsCustomerOrder:EMPTY-DATASET().
    
    FOR EACH Customer NO-LOCK,
        EACH Order OF Customer NO-LOCK,
            EACH OrderLine OF Order NO-LOCK    
        BY Customer.custNUm
        ix = 1 TO 100:
        
        IF NOT CAN-FIND(FIRST tt-customer NO-LOCK WHERE
                            tt-customer.custNum = Customer.custNum) THEN DO:
            CREATE tt-customer.
            BUFFER-COPY Customer TO tt-customer.
            
        END.
        
        IF NOT CAN-FIND(FIRST tt-order NO-LOCK WHERE tt-order.orderNum = Order.OrderNum) THEN DO:
            
            CREATE tt-order.
            BUFFER-COPY Order TO tt-order.
            
        END.
        
        CREATE tt-orderLine.
        BUFFER-COPY OrderLine TO tt-orderLine.

    END.
    

END PROCEDURE.

PROCEDURE p-cont-registros PRIVATE:
/* callback a ser chamada no fill atrelada ao buffer da tt-customer 
    essa procedure mostra como calcular campos customizados apos a criação da tt-customer 
    
    o registro atual da iteração esta disponivel no momento da execução dessa procedure.   */

    DEFINE INPUT PARAM DATASET FOR dsCustomerOrder.
    
    i-reg = i-reg + 1.
    
END PROCEDURE.



