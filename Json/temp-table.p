/*********************************************************************************
arquivo..: Json/temp-tables.p
Autor....: Jean Marcos 
Objetivo.: Export metodos de geração de Json a partir de temp-tables.

Documentação Classe Json 
https://docs.progress.com/pt-BR/bundle/openedge-abl-reference-122/page/Progress.Json.ObjectModel.JsonObject-class.html

Documentação Classe JsonArray
https://docs.progress.com/pt-BR/bundle/openedge-abl-reference-122/page/Progress.Json.ObjectModel.JsonArray-class.html

**********************************************************************************/
USING Progress.Json.ObjectModel.JsonObject.
USING PROGRESS.Json.ObjectModel.JsonArray.

{includes/customer.i}

DEF VAR oJson  AS JsonObject.
DEF VAR oArray AS JsonArray.

RUN p-row-serialize.     // gera um json por linha
RUN p-serialize-tt-data. // gera um json com todos os dados da tt
RUN p-gera-json-manual.  // gera um Json manualmente com os dados da tt.

FINALLY:

    DELETE OBJECT oJson NO-ERROR.
    DELETE OBJECT oArray NO-ERROR.
    
END FINALLY.



PROCEDURE p-serialize-tt-data:
/* gera um Json a partir dos dados da temp-table */
     RUN p-carrega-tt IN THIS-PROCEDURE (10).
     
     oJson = NEW   JsonObject().
     oArray = NEW  JsonArray().
     
     BUFFER tt-customer:WRITE-JSON("JsonArray", oArray, TRUE, "UTF-8", TRUE, TRUE /* imprime somente os dados e omite o nome (serialize-name) da tt */).
     BUFFER tt-customer:WRITE-JSON("JsonObject", oJson, TRUE, "UTF-8", TRUE /* ,false -> nao da para omitir o valor inicial do json object*/ ).
     
     oJson:WriteFile(SESSION:TEMP-DIR + "ttCustomerJson.json", TRUE /*formated*/ ).
     oArray:WriteFile(SESSION:TEMP-DIR + "ttCustomerArray.json", TRUE /*formated*/ ).

END PROCEDURE.

PROCEDURE p-row-serialize:
/* Gera o Json a partir de uma linha da temp-table (Json individual)*/

    RUN p-carrega-tt IN THIS-PROCEDURE (10).
    
    FOR EACH tt-customer:
    
        BUFFER tt-customer:SERIALIZE-ROW( "Json",   /* target-format "JSON" ou XML */
                                          "file",    /* target-type   "JsonObject, File Etc...*/
                                          SESSION:TEMP-DIR + STRING(tt-customer.custNum) + "-row.json" ,   /* como estou usndo file aqui vai o destino do arquivo, caso for JsonObject enviar a variave a ser carregada com o valor*/
                                          TRUE,     /* formatação */
                                          "UTF-8",  /* encode */
                                          TRUE ,    /* omit-initial-values */
                                          TRUE      /* omit-outer-object imprime somente o objeto da linha */ ).
    
    END.

END PROCEDURE.


PROCEDURE p-gera-json-manual:
/* Gera os dados do Json manualmente com os dados da tt */
    RUN p-carrega-tt IN THIS-PROCEDURE (10).
    
    oArray = NEW  JsonArray().
    
    FOR EACH tt-customer:
        oJson = NEW   JsonObject().

        oJson:ADD("endereco"      , tt-customer.Address      ).
        oJson:ADD("endereco_2"    , tt-customer.Address2     ).
        oJson:ADD("Balance"       , tt-customer.Balance      ).
        oJson:ADD("Cidade"        , tt-customer.City         ).
        oJson:ADD("Observacoes"   , tt-customer.Comments     ).
        oJson:ADD("contato"       , tt-customer.Contact      ).
        oJson:ADD("pais"          , tt-customer.Country      ).
        oJson:ADD("limieteCredito", tt-customer.CreditLimit  ).
        oJson:ADD("codigo"        , tt-customer.CustNum      ).
        oJson:ADD("descontos"     , tt-customer.Discount     ).
        oJson:ADD("email"         , tt-customer.EmailAddress ).
        oJson:ADD("fax"           , tt-customer.Fax          ).
        oJson:ADD("nome"          , tt-customer.Name         ).
        oJson:ADD("telefone"      , tt-customer.Phone        ).
        oJson:ADD("codigoPOstal"  , tt-customer.PostalCode   ).
        oJson:ADD("representante" , tt-customer.SalesRep     ).
        oJson:ADD("estado"        , tt-customer.State        ).
        oJson:ADD("termos"        , tt-customer.Terms        ).
        oJson:ADD("CampoCustomizado", STRING(TIME, "hh:mm:ss")).
        
        oArray:ADD(oJson).
        
    END.
    
    oJson = NEW   JsonObject().
    oJson:ADD("tt-customer", oArray).
    
    oJson:WriteFile(SESSION:TEMP-DIR + "ttCustomerManualJson.json", TRUE /*formated*/ ).
    oArray:WriteFile(SESSION:TEMP-DIR + "ttCustomerManualArray.json", TRUE /*formated*/ ).
    
    
END PROCEDURE.

PROCEDURE p-carrega-tt:
/* carrega dados da tabela do banco para a temp-table */
                                                 
    DEFINE INPUT PARAM ipi-quantidade AS INT NO-UNDO.
    DEF VAR ix AS INTEGER NO-UNDO.

    FOR EACH customer NO-LOCK
        ix = 1 TO ipi-quantidade:
        
        CREATE tt-customer.
        BUFFER-COPY customer TO tt-customer.
        
    END.

END PROCEDURE.
