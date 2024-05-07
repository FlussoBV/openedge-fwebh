 
 /*------------------------------------------------------------------------
    File        : XmlEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Mon Apr 15 13:48:25 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using Progress.Lang.AppError.
using fwebh.pas.data.ResponseDataType.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IResponseData.

class fwebh.pas.data.XmlEntityWriter implements IEntityWriter: 

  method public Progress.Lang.Object Write(responseData as IResponseData):
    
    var Progress.Lang.Object entityData.
    
    case responseData:Data:DataType:
      when ResponseDataType:DATASET then entityData = writeDataset(responseData:Data:DatasetHandle).
      when ResponseDataType:TEMP-TABLE then entityData = writeTemptable(responseData:Data:TempTableHandle).
      when ResponseDataType:BUFFER then entityData = writeBuffer(responseData:Data:BufferHandle).
      otherwise undo, throw new AppError(substitute("XmlEntityWriter cannot process EntityDataType '&1'", responseData:Data:DataType), -1).
    end case.
    
    return entityData.

  end method.

  method private String writeBuffer(bufferHandle as handle):
    
    var longchar bufferData .
    
    bufferHandle:serialize-row("XML",
                               "longchar",
                               bufferData,
                               false, // formatted
                               ?, // encoding
                               false, // omit-initial-values
                               true // omit-outer-object
                               ).
  
    return new String(bufferData).
    
  end method.

  method private String writeDataset( datasetHandle as handle):
    
    var longchar datasetData.
    
    datasetHandle:write-xml("longchar",
                             datasetData,
                             false,  // formatted
                             ?  // encoding
                             ).

    return new String(datasetData).
    
  end method.

  method private String writeTemptable(temptableHandle as handle):
    
    var longchar temptableData.
    
    temptableHandle:write-xml("longchar",
                               temptableData,
                               false,  // formatted
                               ?  // encoding
                               ).

    return new String(temptableData).
    
  end method.

end class.
