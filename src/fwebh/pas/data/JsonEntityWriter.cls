 
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
using fwebh.pas.data.ResponseDataType.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IResponseData.

class fwebh.pas.data.JsonEntityWriter implements IEntityWriter: 

  method public Progress.Lang.Object Write( responseData as IResponseData ):
    
    case responseData:DataType:
      when ResponseDataType:DATASET then return writeDataset(responseData:DatasetHandle).
      when ResponseDataType:TEMP-TABLE then return writeTemptable(responseData:DatasetHandle).
      when ResponseDataType:BUFFER then return writeBuffer(responseData:DatasetHandle).
      when ResponseDataType:JSON then return responseData:Json.
      otherwise undo, throw new AppError(substitute("JsonEntityWriter cannot process EntityDataType '&1'",responseData:DataType),-1).
    end case.

  end method.

  method private JsonObject writeBuffer( bufferHandle as handle ):
    
    var JsonObject bufferData = new JsonObject().
    
    bufferHandle:serialize-row("JSON",
                               "JsonObject",
                               bufferData,
                               true, // formatted
                               ?, // encoding
                               false, // omit-initial-values
                               true // omit-outer-object
                               ).

    return bufferData.
    
  end method.

  method private JsonObject writeDataset( datasetHandle as handle ):
    
    var JsonObject datasetData = new JsonObject().
    
    datasetHandle:write-json("JsonObject",
                             datasetData,
                             true, // formatted
                             ?, // encoding
                             false, // omit-initial-values
                             true, // omit-outer-object
                             false // write-before-image
                             ).

    return datasetData.
    
  end method.

  method private JsonArray writeTemptable( temptableHandle as handle ):
    
    var JsonArray temptableData = new JsonArray().
    
    temptableHandle:write-json("JsonArray",
                               temptableData,
                               true, // formatted
                               ?, // encoding
                               false, // omit-initial-values
                               true, // omit-outer-object
                               false // write-before-image
                               ).

    return temptableData.
    
  end method.

end class.