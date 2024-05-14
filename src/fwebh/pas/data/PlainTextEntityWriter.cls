 /*------------------------------------------------------------------------
    File        : PlainTextEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue May 14 14:28:15 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using Progress.Lang.AppError.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseDataType.

class fwebh.pas.data.PlainTextEntityWriter implements IEntityWriter: 

  method public Progress.Lang.Object Write(responseData as IResponseData):
    
    var Progress.Lang.Object entityData.
    
    case responseData:Data:DataType:
      when ResponseDataType:LONGCHAR then entityData = new String(responseData:Data:PlainText).
      otherwise undo, throw new AppError(substitute("PlainTextWriter cannot process EntityDataType '&1'", responseData:Data:DataType), -1).
    end case.
    
    return entityData.
    
  end method.

end class.