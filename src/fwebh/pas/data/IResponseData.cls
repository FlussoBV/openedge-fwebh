
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

interface fwebh.pas.data.IResponseData:  
  
  define public property DatasetHandle as handle no-undo get. set.
  define public property TempTableHandle as handle no-undo get. set.
  define public property Json as JsonConstruct no-undo get. set.
  
end interface.
