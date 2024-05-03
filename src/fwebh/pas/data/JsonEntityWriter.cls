 
 /*------------------------------------------------------------------------
    File        : JsonEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Mon Apr 15 13:48:25 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseDataType.


class fwebh.pas.data.JsonEntityWriter implements IEntityWriter: 

  method public Progress.Lang.Object Write(responseData as IResponseData):
    
    var Progress.Lang.Object entityData.
    
    case responseData:DataType:
      when ResponseDataType:DATASET then entityData = writeDataset(responseData:DatasetHandle).
      when ResponseDataType:TEMP-TABLE then entityData = writeTemptable(responseData:DatasetHandle).
      when ResponseDataType:BUFFER then entityData = writeBuffer(responseData:DatasetHandle).
      when ResponseDataType:JSON then entityData = responseData:Json.
      otherwise undo, throw new AppError(substitute("JsonEntityWriter cannot process EntityDataType '&1'", responseData:DataType), -1).
    end case.
    
    return entityData.
    
  end method.

  method private JsonObject writeBuffer(bufferHandle as handle):
    
    var JsonObject bufferData = new JsonObject().
    
    bufferHandle:serialize-row(
      "JSON",
      "JsonObject",
      bufferData,
      false, // formatted
      ?, // encoding
      false, // omit-initial-values
      true // omit-outer-object
    ).

    return bufferData.
    
  end method.

  method private JsonObject writeDataset(datasetHandle as handle):
    
    var JsonObject datasetData = new JsonObject().
    
    datasetHandle:write-json(
      "JsonObject",
      datasetData,
      false, // formatted
      ?, // encoding
      false, // omit-initial-values
      true, // omit-outer-object
      false // write-before-image
    ).

    return datasetData.
    
  end method.

  method private JsonArray writeTemptable(temptableHandle as handle):
    
    var JsonArray temptableData = new JsonArray().
    
    temptableHandle:write-json(
      "JsonArray",
      temptableData,
      false, // formatted
      ?, // encoding
      false, // omit-initial-values
      true, // omit-outer-object
      false // write-before-image
    ).

    return temptableData.
    
  end method.

end class.
