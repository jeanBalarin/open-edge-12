/*************************************************************************************
arquivo..: http-client/request-binary.p
Autor....: Jean Marcos 
Objetivo.: Export metodos de geração de Json a partir de temp-tables.  



**************************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING OpenEdge.Net.HTTP.*.
USING OpenEdge.Net.URI.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
USING Progress.Json.ObjectModel.JsonObject.
USING OpenEdge.Core.Memptr.
USING OpenEdge.Core.ByteBucket.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.


/* Main block */
DEFINE VARIABLE o-json-resp AS JsonObject NO-UNDO.
DEFINE VARIABLE lc-json     AS LONGCHAR   NO-UNDO.
  
/* chamda htts e retorna um objeto Json */
DEFINE VARIABLE c-verbo AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-url   AS CHARACTER          NO-UNDO.
 

DEFINE VARIABLE o-uri            AS URI                NO-UNDO.
DEFINE VARIABLE o-request        AS IHttpRequest       NO-UNDO. 
DEFINE VARIABLE o-client         AS IHttpClient        NO-UNDO.
DEFINE VARIABLE o-response       AS IHttpResponse      NO-UNDO.
DEFINE VARIABLE o-lib            AS IHttpClientLibrary NO-UNDO. 
DEFINE VARIABLE c-ssl-protocols  AS CHARACTER          NO-UNDO EXTENT 2. 
DEFINE VARIABLE c-ssl-ciphers    AS CHARACTER          NO-UNDO EXTENT 10.

DEFINE VARIABLE o-byte-image AS CLASS ByteBucket NO-UNDO.
DEFINE VARIABLE o-mpt-Image  AS CLASS Memptr     NO-UNDO.

DEFINE VARIABLE oClient AS IHttpClient NO-UNDO.

ASSIGN
    c-url   = "https://httpbin.org/image/jpeg"
    c-verbo = "GET".
        
o-uri = URI:Parse(c-url).
o-request = RequestBuilder
            :Build(c-verbo, o-uri)
            :AcceptAll()
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

IF o-response:StatusCode <> 200 THEN DO:

    UNDO, THROW NEW Progress.Lang.AppError(SUBSTITUTE("Erro no retorno da api: &1 - &2 ", o-response:StatusCode, o-response:StatusReason), o-response:StatusCode).
    
END.
ELSE DO:
    
   o-byte-image = CAST(o-response:Entity, ByteBucket).
   
   o-mpt-Image = o-byte-image:GetBytes().
   
   COPY-LOB FROM o-mpt-Image:VALUE TO FILE SESSION:TEMP-DIRECTORY + "image-request.jpeg".
   
   MESSAGE "imagem disponivel em: " SESSION:TEMP-DIRECTORY + "image-request.jpeg"
   VIEW-AS ALERT-BOX. 
    
END.    

FINALLY:
    
    DELETE OBJECT o-byte-image NO-ERROR.
    DELETE OBJECT o-mpt-Image  NO-ERROR.
    DELETE OBJECT o-uri        NO-ERROR. 
    DELETE OBJECT o-request    NO-ERROR. 
    DELETE OBJECT o-client     NO-ERROR. 
    DELETE OBJECT o-response   NO-ERROR. 
    DELETE OBJECT o-lib        NO-ERROR.
              
END FINALLY.
