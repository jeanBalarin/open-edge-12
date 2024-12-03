/*******************************************************************************
Programa..: json/get-types-json.p
Autor.....: Jean Marcos 
Objetivo..: Mostra os tipos retornados por cata tipo de dado em um Json.
data......: 03/01/24 
********************************************************************************/

USING Progress.Json.ObjectModel.*.

DEF VAR oJson AS JsonObject.
DEF VAR oArray AS jsonArray.
DEF VAR jsFilho AS jsonObject.
DEF VAR jsonString AS LONGCHAR.
DEF VAR nulo AS CHAR INIT ?.

oJson = NEW JsonObject().
oJson:ADD("cha", "JEAN MARCOS").
oJson:ADD("int", 1).
oJson:ADD("dec", 2.23).
oJson:ADD("log", TRUE).
oJson:ADD("nulo", nulo).

jsFilho = NEW JsonObject().
jsFilho:ADD ("json", "teste").
oJson:ADD("jsonObject", jsFilho).

oArray = NEW JsonArray().

jsFilho = NEW JsonObject().
jsFilho:ADD ("cp", 1).
oArray:ADD(jsFilho).

jsFilho = NEW JsonObject().
jsFilho:ADD ("cp", 2).
oArray:ADD(jsFilho).

jsFilho = NEW JsonObject().
jsFilho:ADD ("cp", 3).
oArray:ADD(jsFilho).



oJson:ADD("jsonArray", oArray).


oJson:WRITE(jsonString, TRUE).

MESSAGE 

        "------- json exemple ---------" SKIP (1)
        STRING(jsonString) SKIP(3)
        
        " --------------- TYPES -------------" SKIP(1)
        
        
        "cha........: " oJson:getType("cha") SKIP
        "int........: " oJson:getType("int") SKIP   
        "dec:.......: " oJson:getType("dec") SKIP
        "log........: " oJson:getType("log") SKIP
        "jsonObject.: " oJson:getType("jsonObject") SKIP
        "jsonArray..: " oJson:getType("jsonArray")  SKIP
        "nulo.......: " oJson:getType("nulo")       SKIP
     
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
