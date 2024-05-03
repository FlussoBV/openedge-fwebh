/*------------------------------------------------------------------------
    File        : IDataResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 14 14:20:24 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Json.ObjectModel.JsonConstruct.
using fwebh.pas.data.*.

interface fwebh.pas.data.IResponseData:  
  
  define public property DatasetHandle as handle no-undo get. set.
  define public property TempTableHandle as handle no-undo get. set.
  define public property BufferHandle as handle no-undo get. set.
  define public property Json as JsonConstruct no-undo get. set.
  define public property Memptr as memptr no-undo get. set.
  define public property DataType as ResponseDataType no-undo get. set. 
  define public property ContentType as char no-undo get. set.
  
end interface.
