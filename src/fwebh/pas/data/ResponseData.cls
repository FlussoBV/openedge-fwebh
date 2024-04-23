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
using fwebh.pas.data.*.


class fwebh.pas.data.ResponseData implements IResponseData: 

  define public property DatasetHandle as handle no-undo get. set.
  define public property TempTableHandle as handle no-undo get. set.
  define public property BufferHandle as handle no-undo get. set.
  define public property Json as JsonConstruct no-undo get. set.
  define public property Memptr as memptr no-undo get. set.
  define public property DataType as ResponseDataType no-undo get. set. 
  define public property ContentType as char no-undo get. set.
  
end class.
