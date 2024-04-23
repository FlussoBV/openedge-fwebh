 
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

  method public Progress.Lang.Object Write( responseData as IResponseData ):
    
    case responseData:DataType:
      when ResponseDataType:DATASET then return writeDataset(responseData:DatasetHandle).
      when ResponseDataType:TEMP-TABLE then return writeTemptable(responseData:DatasetHandle).
      when ResponseDataType:BUFFER then return writeBuffer(responseData:DatasetHandle).
      otherwise undo, throw new AppError(substitute("XmlEntityWriter cannot process EntityDataType '&1'",responseData:DataType),-1).
    end case.

  end method.

  method private String writeBuffer( bufferHandle as handle ):
    
    var longchar bufferData .
    var String xml.
    
    bufferHandle:serialize-row("XML",
                               "longchar",
                               bufferData,
                               true, // formatted
                               ?, // encoding
                               false, // omit-initial-values
                               true // omit-outer-object
                               ).

    return new String(bufferData).
    
  end method.

  method private String writeDataset( datasetHandle as handle ):
    
    var longchar datasetData.
    
    datasetHandle:write-json("longchar",
                             datasetData,
                             true, // formatted
                             ?, // encoding
                             false, // omit-initial-values
                             true, // omit-outer-object
                             false // write-before-image
                             ).

    return new String(datasetData).
    
  end method.

  method private String writeTemptable( temptableHandle as handle ):
    
    var longchar temptableData.
    
    temptableHandle:write-json("longchar",
                               temptableData,
                               true, // formatted
                               ?, // encoding
                               false, // omit-initial-values
                               true, // omit-outer-object
                               false // write-before-image
                               ).

    return new String(temptableData).
    
  end method.

end class.