
/*------------------------------------------------------------------------
    File        : IDataHolder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue May 07 09:47:14 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Json.ObjectModel.JsonConstruct.
using fwebh.pas.data.ResponseDataType.

interface fwebh.pas.data.IDataHolder:  

  define public property DatasetHandle as handle no-undo get. set.
  define public property TempTableHandle as handle no-undo get. set.
  define public property BufferHandle as handle no-undo get. set.
  define public property Json as JsonConstruct no-undo get. set.
  define public property Memptr as memptr no-undo get. set.
  define public property DataType as ResponseDataType no-undo get. set.
  
end interface.