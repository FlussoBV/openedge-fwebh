 
/*------------------------------------------------------------------------
   File        : JsonHelper
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : bronco
   Created     : Fri Jul 20 13:18:28 CEST 2018
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

block-level on error undo, throw.

class fwebh.core.JSON: 
  
  method public static JsonConstruct ParseFile(filename as character):
    
    define variable parser as ObjectModelParser no-undo.
    define variable json   as JsonConstruct     no-undo.
    
    parser = new ObjectModelParser().
    json = parser:ParseFile(search(fileName)).
    
    return json.
    
  end method.  // ParseFile
  
  
  method public static JsonObject ParseFileToObject(filename as character):
    return cast(ParseFile(filename), JsonObject).
  end method.
  
  
  method public static JsonArray ParseFileToArray(filename as character):
    return cast(ParseFile(filename), JsonArray).
  end method.
  
  
  method public static JsonConstruct ParseString(jsonString as longchar):
    
    define variable parser as ObjectModelParser no-undo.
    define variable json   as JsonConstruct     no-undo.
    
    parser = new ObjectModelParser().
    do on error undo, throw:
      json = parser:Parse(jsonString).
      catch err1 as Progress.Lang.Error :
        json = ?.      
      end catch.
    end.
    
    return json.
    
  end method.  // ParseString
  

  method public static longchar Stringify(json as JsonConstruct):
    return Stringify(json, false).
  end method.  // Stringify
    

  method public static longchar Stringify(json as JsonConstruct, formatJson as logical):
    define variable resultString as longchar no-undo.
    json:Write(resultString, formatJson).
    return resultString.
  end method.  // Stringify
    

  method public static longchar Stringify(h as handle):
    define variable dataString as longchar no-undo.
    h:write-json('longchar', dataString, true, ?, ?, true).    
    return dataString.
  end method.  // Stringify


  method public static JsonArray GetArrayFromTemptable(tempTableHandle as handle):
    define variable array as JsonArray no-undo.
    array = new JsonArray().
    tempTableHandle:write-json("JsonArray", array).
    return array.
  end method.  // GetArray
      
end class.  // JSON
