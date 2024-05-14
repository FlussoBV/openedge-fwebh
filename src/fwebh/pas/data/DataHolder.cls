 
 /*------------------------------------------------------------------------
    File        : DataHolder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue May 07 09:47:49 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonConstruct.
using fwebh.pas.data.IDataHolder.
using fwebh.pas.data.ResponseDataType.

class fwebh.pas.data.DataHolder implements IdataHolder: 
  
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
  
  define public property GenericHandle as handle no-undo 
    get. 
    set(h as handle):
      GenericHandle = h.
      this-object:DataType = ResponseDataType:WIDGET-HANDLE.
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
  
end class.