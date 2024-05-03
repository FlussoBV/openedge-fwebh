 /*------------------------------------------------------------------------
    File        : ResponseData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Apr 12 13:59:18 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonConstruct.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseDataType.

class fwebh.pas.data.ResponseData implements IResponseData: 

  define public property DatasetHandle as handle no-undo 
    get. 
    set(h as handle):
      DatasetHandle = h.
      this-object:DataType = ResponseDataType:DATASET.
    end.
    
  define public property TempTableHandle as handle no-undo 
    get. 
    set(h as handle):
      TempTableHandle = h.
      this-object:DataType = ResponseDataType:TEMP-TABLE.
    end.
    
  define public property BufferHandle as handle no-undo 
    get. 
    set(h as handle):
      BufferHandle = h.
      this-object:DataType = ResponseDataType:BUFFER.
    end.
  
  define public property Json as JsonConstruct no-undo 
    get. 
    set(jsonIn as JsonConstruct):
      Json = jsonIn.
      this-object:DataType = ResponseDataType:JSON.
    end.
    
  define public property Memptr as memptr no-undo 
    get. 
    set(p as memptr):
      this-object:Memptr = p.
      this-object:DataType = ResponseDataType:MEMPTR.
    end.
  
  define public property DataType as ResponseDataType no-undo get. set. 
  define public property ContentType as char no-undo get. set.
  
end class.
