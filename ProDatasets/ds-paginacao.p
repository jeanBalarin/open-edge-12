/*********************************************************************************
arquivo..: dataset-customer-order.i
Autor....: Jean Marcos 
Objetivo.: Dataset para Customer
**********************************************************************************/
USING Progress.Json.ObjectModel.JsonObject.

{includes/dsCustomerOrder.i}

DEF VAR ix       AS INT NO-UNDO.
DEF VAR i-reg    AS INT NO-UNDO.
DEF VAR i-pagina AS INT NO-UNDO INIT 0.
DEF VAR l-next   AS LOG NO-UNDO.

DEF VAR oJson  AS JsonObject.

DEFINE DATA-SOURCE src-customer FOR Customer.
DEFINE DATA-SOURCE src-order    FOR Order.
DEFINE DATA-SOURCE src-orderLine FOR OrderLine.

REPEAT ON ENDKEY UNDO, LEAVE:
    /* consome os registro até o final da paginação */
    RUN p-fill-dataset-pag.

    oJson = NEW JsonObject().
    DATASET dsCustomerOrder:WRITE-JSON("JsonObject", oJson).

    oJson:ADD("rowCont", i-reg).
    oJson:ADD("hasNext", l-next).
    oJson:ADD("pag", i-pagina).

    oJson:writeFile("c:\temp\dsPag-" + STRING(i-pagina) + ".json", TRUE).
    
    DISP i-pagina.
    
    IF l-next = NO THEN DO:
        LEAVE.    
    END.
    ELSE DO:
        i-pagina = i-pagina + 1.
    END.
    
    FINALLY:
        DELETE OBJECT oJson NO-ERROR.
    END FINALLY.
    
END.

PROCEDURE p-fill-dataset-pag:
/* carrega os dados das temp-tables com o metodo fill usando datasources */

    DATASET dsCustomerOrder:EMPTY-DATASET().

    BUFFER tt-customer:ATTACH-DATA-SOURCE(DATA-SOURCE src-customer:HANDLE).
    BUFFER tt-order:ATTACH-DATA-SOURCE(DATA-SOURCE src-order:HANDLE).
    BUFFER tt-orderLine:ATTACH-DATA-SOURCE(DATA-SOURCE src-orderLine:HANDLE).
    
    /* forma de chamar uma procedure para customizar os campos da tt */
    BUFFER tt-customer:SET-CALLBACK-PROCEDURE("after-row-fill", "p-cont-registros", THIS-PROCEDURE /* ou handle*/).
    
    
    
    /* define a quantidade de registros (tamanho do lote) */
    BUFFER tt-customer:BATCH-SIZE = 100.

    IF i-pagina > 1 THEN DO:
        DATA-SOURCE src-customer:RESTART-ROW = ((BUFFER tt-customer:BATCH-SIZE * i-pagina) - 1). 
    END.
    ELSE DO:
        i-pagina = 1.
    END.
    
     i-reg = 0.
    DATASET dsCustomerOrder:FILL().
    
    l-next = IF DATA-SOURCE src-customer:NEXT-ROWID <> ? THEN YES ELSE NO.
    
    FINALLY:
    
          BUFFER tt-customer:DETACH-DATA-SOURCE().
          BUFFER tt-order:DETACH-DATA-SOURCE().
          BUFFER tt-orderLine:DETACH-DATA-SOURCE().

    END FINALLY.
    
END PROCEDURE.

PROCEDURE p-cont-registros PRIVATE:
/* callback a ser chamada no fill atrelada ao buffer da tt-customer 
    essa procedure mostra como calcular campos customizados apos a criação da tt-customer 
    
    o registro atual da iteração esta disponivel no momento da execução dessa procedure.   */

    DEFINE INPUT PARAM DATASET FOR dsCustomerOrder.
    
    i-reg = i-reg + 1.
    
END PROCEDURE.
