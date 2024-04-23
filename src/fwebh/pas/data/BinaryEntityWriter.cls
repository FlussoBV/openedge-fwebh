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

using Progress.Lang.AppError.
using fwebh.pas.data.ResponseDataType.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IResponseData.
using OpenEdge.Core.Memptr.

class fwebh.pas.data.BinaryEntityWriter implements IEntityWriter: 

  method public Progress.Lang.Object Write( responseData as IResponseData ):
    
    case responseData:DataType:
      when ResponseDataType:MEMPTR then return new Memptr(responseData:Memptr).
      otherwise undo, throw new AppError(substitute("BinaryEntityWriter cannot process EntityDataType '&1'",responseData:DataType),-1).
    end case.

  end method. 

end class.