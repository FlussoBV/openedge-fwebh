 
 /*------------------------------------------------------------------------
    File        : EchoService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Apr 23 14:06:11 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using Progress.Json.ObjectModel.JsonObject.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.
using fwebh.pas.service.IGetDataService.
using fwebh.serialize.SimpleJsonSerializer.


class fwebh.pas.service.system.EchoService implements IGetDataService:
  
  method public IResponseData GetData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
        
    response:Json = new SimpleJsonSerializer():Serialize(request).
    
    return response.
    
  end method.  // GetData

end class.
