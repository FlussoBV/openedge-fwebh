 
 /*------------------------------------------------------------------------
    File        : SimpleJsonDeserializer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sat Aug 18 16:52:43 CEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.serialize.IDeserializable.
using fwebh.serialize.IListInfo.
using fwebh.serialize.ISerializableDataStructure.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.KeySet.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Class.
using Progress.Reflect.DataType.
using Progress.Reflect.Property.

class fwebh.serialize.SimpleJsonDeserializer implements IDeserializable: 
  
  define private variable serializeThese as character no-undo.
  
  
  constructor public SimpleJsonDeserializer():
    serializeThese = "character,date,datetime,datetimetz,decimal,integer,int64,logical,longchar,memptr".    
  end.
  

  method public Progress.Lang.Object DeserializeFile(jsonFilename as character, className as character):
    
    var ObjectModelParser parser.
    var JsonObject jsonObj.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:ParseFile(jsonFilename), "JsonObject").
    
    return Deserialize(jsonObj, className).
    
  end method.  // DeserializeFile
  
  
  method public Progress.Lang.Object DeserializeFile(jsonFilename as character, targetObj as Progress.Lang.Object):
    
    var ObjectModelParser parser.
    var JsonObject jsonObj.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:ParseFile(jsonFilename), "JsonObject").
    
    return Deserialize(jsonObj, targetObj).
    
  end method.  // DeserializeFile
   

  // in this method the target class name is expected to the name of the first property
  method public Progress.Lang.Object Deserialize(jsonIn as JsonObject, className as character):
    
    var char[] properties.
    var Progress.Lang.Object obj.
    var JsonObject jsonObj.
       
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
    
    var ObjectModelParser parser.
    var JsonObject jsonObj.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:Parse(jsonString), "JsonObject").
    
    return this-object:Deserialize(jsonObj, className).
    
  end method.  // DeserializeString
  
  
  method public void DeserializeString(jsonString as longchar, targetObject as Progress.Lang.Object):
    
    var ObjectModelParser parser.
    var JsonObject jsonObj.
    
    parser = new ObjectModelParser().
    jsonObj = cast(parser:Parse(jsonString), "JsonObject").
    
    this-object:Deserialize(jsonObj, targetObject).
    
  end method.  // DeserializeString
  
  
  method public Progress.Lang.Object Deserialize(jsonIn as JsonObject, targetObj as Progress.Lang.Object): 

    var Progress.Lang.Class cls.
    var Property[] props.
    var Property prop.
    var JsonObject jsonOut.
    var List resultList.    
    var Progress.Lang.Object resultObj, valueObject.
    var int i.
    var char getter.
    
    var StringStringMap dataMap.
    
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
          // it may be an array
          if (prop:Extent = 0) then do:
            dynamic-property(targetObj, prop:Name) = dynamic-invoke(jsonIn, getter, prop:Name) no-error.
            if (error-status:error) then
              dynamic-property(targetObj, prop:Name) = dynamic-invoke(jsonIn, getter, lc(prop:Name)) no-error.
          end.
          else do:  // extent > 0
            deserializeExtent(targetObj, prop, jsonIn:GetJsonArray(prop:Name)).
          end.
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
          else if (prop:DataTypeName = "OpenEdge.Core.Collections.StringStringMap" /*and targetObj:GetClass():IsA("fwebh.serialize.IListInfo")*/) then do:
            dataMap = deserializeStringStringMap(jsonIn:GetJsonObject(prop:Name)).
            dynamic-property(targetObj, prop:Name) = dataMap.
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
  
  method private void deserializeExtent(targetObj as Progress.Lang.Object, prop as Property, array as JsonArray):
    
    var int i.
    
    if (valid-object(array)) then do:
      do i = 1 to array:Length:
        case prop:DataType:
          when DataType:Integer then dynamic-property(targetObj, prop:Name, i) = array:GetInteger(i).
          when DataType:Character then dynamic-property(targetObj, prop:Name, i) = array:GetCharacter(i).
          when DataType:Decimal then dynamic-property(targetObj, prop:Name, i) = array:GetDecimal(i).
          when DataType:Date then dynamic-property(targetObj, prop:Name, i) = array:GetDate(i).
          when DataType:DateTime then dynamic-property(targetObj, prop:Name, i) = array:GetDatetime(i).
          when DataType:DateTimeTZ then dynamic-property(targetObj, prop:Name, i) = array:GetDatetimeTZ(i).
          when DataType:Decimal then dynamic-property(targetObj, prop:Name, i) = array:GetDecimal(i).
          when DataType:Logical then dynamic-property(targetObj, prop:Name, i) = array:GetLogical(i).
        end case.
      end. 
    end.
    
  end method.  // deserializeExtent
  
  method private List deserializeList(targetObject as IListInfo, prop as Property, array as JsonArray):
    
    var char listType.   
    var List newList.
    var int i.
    var JsonObject jsonObj.
    var Progress.Lang.Object obj.
    
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
  
  method public StringStringMap deserializeStringStringMap(obj as JsonObject):
    
    var StringStringMap dataMap = new StringStringMap().
    var char[] names = obj:GetNames().
    var int i.
    
    do i = 1 to extent(names):
      dataMap:Put(names[i], obj:GetCharacter(names[i])).
    end.
    
    return dataMap.
    
  end method.
  
  @todo(what="deserialize temp-table").
  method private void deserializeDataStructures(jsonIn as jsonObject, targetObj as ISerializableDataStructure):
    
    var IMap dataStructs.
    var IMapEntry structure.
    var ISet keyset.
    var IIterator iterator.
    var Progress.Lang.Object keyObject, valueObject.
    var char keyname.
    var WidgetHandle dataObject.
    var JsonArray array.
        
    dataStructs = targetObj:GetDataStructures().
    keyset = dataStructs:KeySet.
    iterator = keyset:Iterator().
    
    do while (iterator:HasNext()):
      keyObject = iterator:Next().
      keyname = string(cast(keyObject, "OpenEdge.Core.String"):Value).
      
      valueObject = dataStructs:Get(keyObject).
      if (valueObject:GetClass():TypeName <> "OpenEdge.Core.WidgetHandle") then
        next.
        
      dataObject = cast(valueObject, "OpenEdge.Core.WidgetHandle").
      
      array = jsonIn:GetJsonArray(keyname).
      this-object:jsonArrayToTempTable(array, dataObject:Value, dataStructs).
    end.
       
  end method.  // deserializeDataStructures
  
  
  method private void jsonArrayToTempTable(array as JsonArray, tthandle as handle, dataStructs as IMap):
    var int i, j.
    var handle bufferHandle, bufferField.
    var JsonObject jsonRecord.
    var char getter, targetClass, mapExpression.

    bufferHandle = tthandle:default-buffer-handle.
    
    do i = 1 to array:Length:
      jsonRecord = array:GetJsonObject(i).
      bufferHandle:buffer-create().
      
      do j = 1 to bufferHandle:num-fields:
        bufferField = bufferHandle:buffer-field(j).
        if (bufferField:data-type = "Progress.Lang.Object") then do:
          mapExpression = tthandle:serialize-name + "." + bufferField:serialize-name.
          targetClass = string(cast(dataStructs:Get(new String(mapExpression)), "OpenEdge.Core.String"):Value) no-error.         
          if (targetClass = "") then
            undo, throw new AppError(substitute("mapping error: '&1' not found (GetDataStructures)", mapExpression), -1).
          bufferField:buffer-value = Deserialize(dynamic-invoke(jsonRecord, "GetJsonObject", bufferField:serialize-name), targetClass).
        end.  
        else  
          bufferField:buffer-value = dynamic-invoke(jsonRecord, "Get" + bufferField:data-type, bufferField:serialize-name).          
      end.
      
      bufferHandle:buffer-release().
      
    end.  
    
  end method.  // jsonArrayToTempTable

end class.
