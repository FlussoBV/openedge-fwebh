 
 /*------------------------------------------------------------------------
    File        : SimpleJsonSerializer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Jul 20 11:53:54 CEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.serialize.IListInfo.
using fwebh.serialize.ISerializable.
using fwebh.serialize.ISerializableDataStructure.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.KeySet.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.WidgetHandle.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Class.
using Progress.Reflect.Property.


class fwebh.serialize.SimpleJsonSerializer implements ISerializable: 
  
  var private char serializeThese.
  var private char skipThese. 
  
  constructor public SimpleJsonSerializer():
    serializeThese = "character,date,datetime,datetimetz,decimal,integer,int64,logical,longchar,memptr".
    skipThese = "handle".    
  end.
  
  
  method public JsonObject Serialize(objectToSerialize as Progress.Lang.Object):
    return Serialize(objectToSerialize, false).
  end method.  // Serialize
   
   
  method public JsonObject Serialize(objectToSerialize as Progress.Lang.Object, includeClassName as logical): 
    
    var Progress.Lang.Class cls.
    var Property[] props.
    var Property prop.
    var JsonObject jsonOut, jsonSerialized.
    var JsonConstruct jc.
    var Progress.Lang.Object valueObject.
    var int i.
   

    cls = objectToSerialize:GetClass().
    props = cls:GetProperties().  
    jsonOut = new JsonObject().
    if (includeClassName) then do:
      jsonSerialized = new JsonObject().
      jsonOut:Add(cls:TypeName, jsonSerialized).
    end.
    else 
      jsonSerialized = jsonOut.
    
    do i = 1 to extent(props) on error undo, throw:
      
      prop = props[i].
      if (not prop:CanRead or prop:Name = "next-sibling" or prop:Name = "prev-sibling") then
        next.

      if (lookup(prop:DataType:ToString(), skipThese) > 0) then
        next.
        
      if (lookup(prop:DataType:ToString(), serializeThese) > 0) then do:
        
        if (prop:Extent = 0) then
          jsonSerialized:Add(prop:Name, dynamic-property(objectToSerialize, prop:Name)).
        else
          jsonSerialized:Add(prop:Name, serializeExtent(objectToSerialize, prop)).
          
      end.
      else do:
          
        if (prop:DataTypeName = "OpenEdge.Core.Collections.List") then do:
          jsonSerialized:Add(prop:Name, serializeList(dynamic-property(objectToSerialize, prop:Name))).
        end.
        else if (prop:DataTypeName = "OpenEdge.Core.Collections.StringStringMap") then do:
          jsonSerialized:Add(prop:Name, serializeStringStringMap(dynamic-property(objectToSerialize, prop:Name))).
        end.
        else if (prop:DataTypeName begins "Progress." or prop:DataTypeName begins "OpenEdge.") then do:
                   
          case true:
                         
            when (prop:DataTypeName begins "Progress.Json.ObjectModel.Json") then do:
              jc = dynamic-property(objectToSerialize, prop:Name) no-error.
              if (valid-object(jc)) then
                jsonSerialized:Add(prop:Name, dynamic-property(objectToSerialize, prop:Name)).
            end.
            
            otherwise do:
              // nothing   
            end.
            
          end case.
          
        end.
        else do:
          valueObject = dynamic-property(objectToSerialize, prop:Name).           
          if (valid-object(valueObject)) then
            jsonSerialized:Add(prop:Name, Serialize(valueObject)).
        end.
        
      end.
      
      catch err1 as Progress.Lang.Error :
        message substitute("error serializing '&1': &2", prop:Name, err1:GetMessage(1)) view-as alert-box.
      end catch.
      
    end.  // do i = 1 to extent(props)
    
    if (objectToSerialize:GetClass():IsA("fwebh.serialize.ISerializableDataStructure")) then
      addDatastructures(cast(objectToSerialize, "fwebh.serialize.ISerializableDataStructure"), jsonSerialized).
    
    return jsonOut.
    
  end method.  // Serialize
  
  
  method public longchar SerializeToLongchar(objectToSerialize as Progress.Lang.Object):   
    return SerializeToLongchar(objectToSerialize, false).
  end method.  // SerializeToLongchar
  
  
  method public longchar SerializeToLongchar(objectToSerialize as Progress.Lang.Object, formatted as logical):
    
    var JsonObject json.
    var longchar resultString.
    
    json = this-object:Serialize(objectToSerialize, formatted).
    json:Write(resultString).
    
    return resultString.
    
  end method.  // SerializeToLongchar


  method private void addDatastructures(objectToSerialize as ISerializableDataStructure, jsonOut as JsonObject):
    
    var IMap dataStructs.
    var IMapEntry dataStruct.
    var ISet keyset.
    var IIterator iterator.
    var char keyname.
    var handle dataHandle.
    var Progress.Lang.Object keyObject, valueObject.
    var WidgetHandle dataObject.
    var int i.
    
    dataStructs = objectToSerialize:GetDataStructures().
    keyset = dataStructs:KeySet.
    iterator = keyset:Iterator().
    
    do while (iterator:HasNext()):
      keyObject = iterator:Next().
      keyname = string(cast(keyObject, "OpenEdge.Core.String"):Value).
      valueObject = dataStructs:Get(keyObject).
      if (valueObject:GetClass():TypeName <> "OpenEdge.Core.WidgetHandle") then
        next.
      dataObject = cast(valueObject, "OpenEdge.Core.WidgetHandle").
      dataHandle = dataObject:Value.
      serializeDataObject(keyname, datahandle, jsonOut).
    end.
    
  end method.  // addDatastructures
  
  
  method private void serializeDataObject(propertyName as character, data as handle, jsonOut as JsonObject):
        
    if (data:type <> "temp-table") then do:
      jsonOut:Add(propertyName, substitute("<data struct &1 not serializable>", data:type)).
      return.
    end.  
    
    serializeTempTable(propertyName, data, jsonOut).
    
  end method.  // serializeDataObject
  
  
  method public JsonArray SerializeList(dataArray as List):
    
    var IIterator iterator.
    var Progress.Lang.Object arrayItem.
    var JsonArray array = new JsonArray().
    var Progress.Lang.Object obj.
    
    if (not valid-object(dataArray)) then
      dataArray = new List().
      
    iterator = dataArray:Iterator().
    do while (iterator:HasNext()):
      arrayItem = iterator:Next().
      if (arrayItem:GetClass():TypeName begins "OpenEdge.Core") then
        array:Add(dynamic-property(arrayItem, "Value")).
      else   
        array:Add(Serialize(arrayItem)).
    end.
    
    return array.
    
  end method.  // serializeList
  
  
  method public JsonObject SerializeStringStringMap(dataMap as StringStringMap):
    
    var JsonObject obj = new JsonObject().
    var IIterator iterator.
    var char keyName, keyValue.
    
    if (not valid-object(dataMap)) then 
      dataMap = new StringStringMap().
      
    iterator = dataMap:KeySet:Iterator().    
    do while (iterator:HasNext()):
      keyName = string(cast(iterator:Next(), "OpenEdge.Core.String"):Value).
      keyValue = string(dataMap:Get(keyName)).
      obj:Add(keyName, keyValue).
    end.
    
    return obj.

  end method.  // SerializeStringStringMap
   
  
  method private void serializeTempTable(propertyName as character, data as handle, jsonOut as JsonObject):
    
    var handle queryHandle, bufferHandle, fieldHandle.
    var int i.
    var JsonArray array = new JsonArray().
    var JsonObject record.
    var Progress.Lang.Object obj.
    
    create query queryHandle.
    bufferHandle = data:default-buffer-handle.
    
    queryHandle:set-buffers(bufferHandle).
    queryHandle:query-prepare("for each " + bufferHandle:name).
    queryHandle:query-open().
    
    queryHandle:get-first().
    do while (not queryHandle:query-off-end):
      
      record = new JsonObject().
      
      do i = 1 to bufferHandle:num-fields on error undo, throw:
        fieldHandle = bufferHandle:buffer-field(i).
        record:Add(fieldHandle:serialize-name, fieldHandle:buffer-value).
        catch err1 as Progress.Lang.Error:
          obj = fieldHandle:buffer-value.
          record:Add(fieldHandle:serialize-name, Serialize(obj)).
        end catch.
      end.
        
      array:Add(record).
      queryHandle:get-next().
    end.  // do while...
    
    jsonOut:Add(propertyName, array).
      
    finally:
      delete object queryHandle no-error.
    end.
    
  end method.  // serializeTempTable
  
  
  method private JsonArray serializeExtent(objectToSerialize as Progress.Lang.Object, prop as Property):
    
    var JsonArray serializedExtent = new JsonArray().
    var int i.
    
    
    do i = 1 to prop:Extent:
      serializedExtent:Add(dynamic-property(objectToSerialize, prop:Name, i)).
    end.
    
    return serializedExtent.
    
  end method.  // serializeExtent
  
end class.
