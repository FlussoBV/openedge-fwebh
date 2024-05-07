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
using fwebh.pas.data.DataHolder.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.IDataHolder.

class fwebh.pas.data.ResponseData implements IResponseData: 
  
  // lazy instantiate, requests may not have data (204 No Content f.e.)
  define public property Data as IDataHolder no-undo 
    get():
      if not valid-object(Data) then 
        Data = new DataHolder().
      return Data.
    end. 
    private set.

  define public property ContentType as char no-undo get. set.
  
end class.
