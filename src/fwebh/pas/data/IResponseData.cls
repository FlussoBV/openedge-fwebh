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
using fwebh.pas.data.IDataHolder.
using fwebh.pas.data.ResponseDataType.

interface fwebh.pas.data.IResponseData:  
  
  define public property Data as IDataHolder no-undo get.
  define public property ContentType as char no-undo get. set.
  
end interface.
