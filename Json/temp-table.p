/*********************************************************************************
arquivo..: Json/temp-tables.p
Autor....: Jean Marcos 
Objetivo.: Export metodos de geração de Json a partir de temp-tables.
**********************************************************************************/
{customer.i}

RUN p-row-serialize. // imprime tt em cada linha sendo possivel gerar comente o objeto da linha.

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
