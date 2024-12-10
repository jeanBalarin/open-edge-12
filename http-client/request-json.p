/*************************************************************************************
arquivo..: http-client/request-json.p
Autor....: Jean Marcos 
Objetivo.: Export metodos de geração de Json a partir de temp-tables.  

**************************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING OpenEdge.Net.HTTP.*.
USING OpenEdge.Net.URI.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
USING Progress.Json.ObjectModel.JsonObject.
    
/* chamda htts e retorna um objeto Json */
DEFINE VARIABLE c-verbo AS CHARACTER          NO-UNDO INIT "get".
DEFINE VARIABLE c-url   AS CHARACTER          NO-UNDO INIT "https://httpbin.org/json".
DEFINE VARIABLE o-json    AS JsonObject         NO-UNDO. 

DEFINE VARIABLE o-uri            AS URI                NO-UNDO.
DEFINE VARIABLE o-request        AS IHttpRequest       NO-UNDO. 
DEFINE VARIABLE o-client         AS IHttpClient        NO-UNDO.
DEFINE VARIABLE o-response       AS IHttpResponse      NO-UNDO.
DEFINE VARIABLE o-lib            AS IHttpClientLibrary NO-UNDO. 
DEFINE VARIABLE c-ssl-protocols  AS CHARACTER          NO-UNDO EXTENT 3. 
DEFINE VARIABLE c-ssl-ciphers    AS CHARACTER          NO-UNDO EXTENT 10.
DEFINE VARIABLE lc-json          AS LONGCHAR           NO-UNDO.    

o-uri = URI:Parse(c-url). // url enconde
o-request = RequestBuilder
            :Build(c-verbo, o-uri)
            :AcceptJson()
            //:AddJsonData(o-json) // caso houver necessidade de enviar um body 
            :REQUEST.

// configuração SSL
ASSIGN
    c-ssl-protocols[1] = 'TLSv1.3'
    c-ssl-protocols[2] = 'TLSv1.2'
    c-ssl-ciphers[1]   = 'AES128-SHA256' 
    c-ssl-ciphers[2]   = 'DHE-RSA-AES128-SHA256' 
    c-ssl-ciphers[3]   = 'AES128-GCM-SHA256' 
    c-ssl-ciphers[4]   = 'DHE-RSA-AES128-GCM-SHA256' 
    c-ssl-ciphers[5]   = 'ADH-AES128-SHA256' 
    c-ssl-ciphers[6]   = 'ADH-AES128-GCM-SHA256' 
    c-ssl-ciphers[7]   = 'ADH-AES256-SHA256' 
    c-ssl-ciphers[8]   = 'AES256-SHA256' 
    c-ssl-ciphers[9]   = 'DHE-RSA-AES256-SHA256' 
    c-ssl-ciphers[10]  = 'AES128-SHA' .

o-lib = ClientLibraryBuilder:Build()
   :SetSSLProtocols(c-ssl-protocols) 
   :SetSSLCiphers(c-ssl-ciphers) 
   :Library.

o-client = ClientBuilder:Build()
                        :UsingLibrary(o-lib)
                        :Client.

o-response = o-client:Execute(o-request).

IF TYPE-OF( o-response:entity, JsonObject ) THEN DO:
    
    o-json = CAST(o-response:Entity, JsonObject).
    
    o-json:write(lc-json, TRUE).
              
    MESSAGE STRING(lc-json)
    VIEW-AS ALERT-BOX.    
END.
ELSE DO:

    UNDO, THROW NEW Progress.Lang.AppError(SUBSTITUTE(
        "Erro ao executar requisição, retorno esperado JsonObjetc, não encontrado na chamada! StatusCode: &1 - &2",
        o-response:StatusCode,
        o-response:StatusReason),
        500).
END.            

FINALLY:
    
    DELETE OBJECT o-uri      NO-ERROR. 
    DELETE OBJECT o-request  NO-ERROR. 
    DELETE OBJECT o-client   NO-ERROR. 
    DELETE OBJECT o-response NO-ERROR. 
    DELETE OBJECT o-lib      NO-ERROR. 
       
END FINALLY.
