 
 /*------------------------------------------------------------------------
    File        : SimpleJsonDeserializer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sat Aug 18 16:52:43 CEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.KeySet.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.WidgetHandle.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Class.
using Progress.Reflect.Property.

using fwebh.serialize.IListInfo.
using fwebh.serialize.ISerializableDataStructure.
using fwebh.serialize.IDeserializable.
using fwebh.core.JSON.

block-level on error undo, throw.

class fwebh.serialize.SimpleJsonDeserializer implements IDeserializable: 
  
  define private variable serializeThese as character no-undo.
  
  
  constructor public SimpleJsonDeserializer():
    serializeThese = "character,date,datetime,datetimetz,decimal,integer,int64,logical,longchar,memptr".    
  end.
  

  method public Progress.Lang.Object DeserializeFile(jsonFilename as character, className as character):
    
    define variable parser as ObjectModelParser no-undo.
    define variable jsonObj as JsonObject no-undo.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:ParseFile(jsonFilename), "JsonObject").
    
    return Deserialize(jsonObj, className).
    
  end method.  // DeserializeFile
  
  
  method public Progress.Lang.Object DeserializeFile(jsonFilename as character, targetObj as Progress.Lang.Object):
    
    define variable parser as ObjectModelParser no-undo.
    define variable jsonObj as JsonObject no-undo.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:ParseFile(jsonFilename), "JsonObject").
    
    return Deserialize(jsonObj, targetObj).
    
  end method.  // DeserializeFile
   

  // in this method the target class name is expected to the name of the first property
  method public Progress.Lang.Object Deserialize(jsonIn as JsonObject, className as character):
    
    define variable properties as character extent no-undo.
    define variable obj as Progress.Lang.Object no-undo.
    define variable jsonObj as JsonObject no-undo.
       
    do on error undo, throw:
      
      obj = dynamic-new(className)().
      Deserialize(jsonIn, obj).
      
      catch err1 as Progress.Lang.Error :
        message "error:" err1:GetMessage(1) view-as alert-box.
        undo, throw new AppError(substitute("'&1' is not a class", className)).  
      end catch.
    end.
    
    return obj.
    
  end method.  // Deserialize
  
  
  method public Progress.Lang.Object DeserializeString(jsonString as longchar, className as character):
    
    define variable parser as ObjectModelParser no-undo.
    define variable jsonObj as JsonObject no-undo.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:Parse(jsonString), "JsonObject").
    
    return this-object:Deserialize(jsonObj, className).
    
  end method.  // DeserializeString
  
  
  method public void DeserializeString(jsonString as longchar, targetObject as Progress.Lang.Object):
    
    define variable parser as ObjectModelParser no-undo.
    define variable jsonObj as JsonObject no-undo.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:Parse(jsonString), "JsonObject").
    
    this-object:Deserialize(jsonObj, targetObject).
    
  end method.  // DeserializeString
  
  
  method public Progress.Lang.Object Deserialize(jsonIn as JsonObject, targetObj as Progress.Lang.Object): 

    define variable cls as class Class no-undo.
    define variable props as Property extent no-undo.
    define variable prop as Property no-undo.
    define variable jsonOut as JsonObject no-undo.
    define variable resultList as List no-undo.    
    define variable resultObj as Progress.Lang.Object no-undo.
    define variable valueObject as Progress.Lang.Object no-undo.
    define variable i as integer no-undo.
    define variable getter as character no-undo.
    
    // if the JSON is not valid then there's nothing to deserialize
    if (not valid-object(jsonIn)) then do:
      targetObj = ?.
      return ?.
    end.
      
    cls = targetObj:GetClass().
    props = cls:GetProperties().  
    
    do i = 1 to extent(props):
      
      prop = props[i].
      if (not prop:CanWrite or prop:Name = "next-sibling" or prop:Name = "prev-sibling") then
        next.      
      
      do on error undo, throw:

        getter = "Get" + prop:DataType:ToString().        
        if (lookup(prop:DataType:ToString(), serializeThese) > 0) then do:
          dynamic-property(targetObj, prop:Name) = dynamic-invoke(jsonIn, getter, prop:Name) no-error.
          if (error-status:error) then
            dynamic-property(targetObj, prop:Name) = dynamic-invoke(jsonIn, getter, lc(prop:Name)) no-error.
        end.
        else do:
          
          if (prop:DataTypeName begins "Progress.Collections.List") then do:
            message "eval:" prop:DataTypeName view-as alert-box.
          end. 
          else if (prop:DataTypeName = "OpenEdge.Core.Collections.List" and targetObj:GetClass():IsA("fwebh.serialize.IListInfo")) then do:
            //add list entries to object
            resultList = deserializeList(cast(targetObj, "fwebh.serialize.IListInfo"), prop, jsonIn:GetJsonArray(prop:Name)).
            dynamic-property(targetObj, prop:Name) = resultList.
          end.
          else if (prop:DataTypeName begins "Progress." or prop:DataTypeName begins "OpenEdge.") then do:
            // for primitive types only, others are NOT deserialized
            if prop:DataTypeName = "Progress.Json.ObjectModel.JsonArray" then do:
              dynamic-property(targetObj, prop:Name) = jsonIn:GetJsonArray(prop:Name).
            end.
          end.
          else do:
            resultObj = dynamic-new(prop:DataTypeName)().
            resultObj = Deserialize(jsonIn:GetJsonObject(prop:Name), resultObj).
            dynamic-property(targetObj, prop:Name) = resultObj.
          end.
        end.
        
        catch err1 as Progress.Lang.Error:
          message err1:GetMessage(1) view-as alert-box.  
        end catch.
        
      end.  // do on error   
         
    end.  // do i = 1 to extent(props)
    
    if (targetObj:GetClass():IsA("fwebh.serialize.ISerializableDataStructure")) then do:        
      this-object:deserializeDataStructures(jsonIn, cast(targetObj, "fwebh.serialize.ISerializableDataStructure")). 
    end.
    
    return targetObj.
    
  end method.  // Deserialize
  
  method private List deserializeList(targetObject as IListInfo, prop as Property, array as JsonArray):
    
    define variable listType as character no-undo.   
    define variable newList as List no-undo.
    define variable i as integer no-undo.
    define variable jsonObj as JsonObject no-undo.
    define variable obj as Progress.Lang.Object no-undo.
    
    newList = new List().
    listType = targetObject:GetListType(prop:Name).
    
    // when "array":null instead of "array": [] is in he JSON, array is not a valid object
    if (valid-object(array)) then do:  

      do i = 1 to array:Length:
        
        if (listType begins "OpenEdge.Core") then do:
          
          case (listType): 
            
            when "OpenEdge.Core.String" then
              obj = dynamic-new(listType)(array:GetLongchar(i)).
               
            when "OpenEdge.Core.Integer" then 
              obj = dynamic-new(listType)(array:GetInteger(i)).
            
            when "OpenEdge.Core.Decimal" then
              obj = dynamic-new(listType)(array:GetDecimal(i)).
              
            otherwise
              message listType 'not handled' view-as alert-box.
              
          end case.
          
        end.
        else do:
          obj = dynamic-new(listType)().
          jsonObj = array:GetJsonObject(i).
          Deserialize(jsonObj, obj).
        end.
        
        newList:Add(obj).
        
      end.  // do i = 1...
      
    end.  // if (valid-object(array))
    
    return newList.
    
  end method.  // deserializeList
  
  @todo(what="deserialize temp-table").
  method private void deserializeDataStructures(jsonIn as jsonObject, targetObj as ISerializableDataStructure):
    
    define variable dataStructs as IMap no-undo.
    define variable structure as IMapEntry no-undo.
    define variable keyset as ISet no-undo.
    define variable iterator as IIterator no-undo.
    define variable keyObject as Progress.Lang.Object no-undo.
    define variable keyname as character no-undo.
    define variable dataObject as WidgetHandle no-undo.
    define variable array as JsonArray no-undo.
        
    dataStructs = targetObj:GetDataStructures().
    keyset = dataStructs:KeySet.
    iterator = keyset:Iterator().
    
    do while (iterator:HasNext()):
      keyObject = iterator:Next().
      keyname = string(cast(keyObject, "OpenEdge.Core.String"):Value).
      dataObject = cast(dataStructs:Get(keyObject), "OpenEdge.Core.WidgetHandle").
      
      array = jsonIn:GetJsonArray(keyname).
      this-object:jsonArrayToTempTable(array, dataObject:Value).
    end.
       
  end method.  // deserializeDataStructures
  
  
  method private void jsonArrayToTempTable(array as JsonArray, tthandle as handle):
    
    define variable i as integer no-undo.
    define variable j as integer no-undo.
    define variable bufferHandle as handle no-undo.
    define variable bufferField as handle no-undo.
    define variable jsonRecord as JsonObject no-undo.
    define variable getter as character no-undo.
    
    bufferHandle = tthandle:default-buffer-handle.
    
    do i = 1 to array:Length:
      jsonRecord = array:GetJsonObject(i).
      message string(JSON:Stringify(jsonRecord)).
      bufferHandle:buffer-create().
      
      do j = 1 to bufferHandle:num-fields:
        bufferField = bufferHandle:buffer-field(j).
        bufferField:buffer-value = dynamic-invoke(jsonRecord, "Get" + bufferField:data-type, bufferField:serialize-name).
      end.
      
      bufferHandle:buffer-release().
      
    end.  
    
  end method.  // jsonArrayToTempTable

end class.
