 /*------------------------------------------------------------------------
    File        : BinaryEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue Apr 23 09:53:54 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.lang.error.NotAcceptableException.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseDataType.
using OpenEdge.Core.Memptr.
using Progress.Lang.AppError.

class fwebh.pas.data.BinaryEntityWriter implements IEntityWriter: 

  method public Progress.Lang.Object Write(responseData as IResponseData):
    
    var Progress.Lang.Object entityData.
    
    case responseData:Data:DataType:
      when ResponseDataType:MEMPTR then entityData = new Memptr(responseData:Data:Memptr).
      otherwise undo, throw new NotAcceptableException(substitute("BinaryEntityWriter cannot process EntityDataType '&1'", responseData:Data:DataType)).
    end case.
    
    return entityData.
    
  end method. 

end class.
