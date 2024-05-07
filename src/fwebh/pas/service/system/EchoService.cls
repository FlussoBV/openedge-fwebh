 
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
using fwebh.lang.error.InvalidDataException.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.IPostDataService.
using fwebh.pas.service.system.EchoPostData.
using fwebh.serialize.SimpleJsonDeserializer.
using fwebh.serialize.SimpleJsonSerializer.


class fwebh.pas.service.system.EchoService implements IGetDataService, IPostDataService:
  
  method public IResponseData GetData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
        
    response:Data:Json = new SimpleJsonSerializer():Serialize(request).
    
    return response.
    
  end method.  // GetData
  
  
  method public IResponseData PostData(request as IRequestData):
    
    var EchoPostData postedData.
    var SimpleJsonSerializer serializer = new SimpleJsonSerializer().
    var IResponseData response = new ResponseData().
    var JsonObject jsonOut = new JsonObject().
    
    do on error undo, throw:
      
      postedData = cast(
        new SimpleJsonDeserializer():Deserialize(
          cast(request:Data:Json, "Progress.Json.ObjectModel.JsonObject"), 
          "fwebh.pas.service.system.EchoPostData"
        ),
        "fwebh.pas.service.system.EchoPostData"
      ).
      
      catch err1 as Progress.Lang.Error :
        undo, throw new InvalidDataException(err1:GetMessage(1)).
      end catch.
            
    end.
    
    jsonOut:Add("request", serializer:Serialize(request)).
    jsonOut:Add("posted", serializer:Serialize(postedData)).
    
    response:Data:Json = jsonOut.
    
    return response.
    
  end method.  // PostData

end class.
