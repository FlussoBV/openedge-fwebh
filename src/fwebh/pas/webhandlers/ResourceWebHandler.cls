 
 /*------------------------------------------------------------------------
    File        : ResourceWebHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon Mar 25 12:45:03 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.WebResponse.
using OpenEdge.Net.HTTP.IHttpResponse.
using Progress.Json.ObjectModel.JsonObject.

using fwebh.serialize.SimpleJsonSerializer.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.RequestDataProcessor.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.ServiceFactory.
using fwebh.pas.webhandlers.WebHandlerCommon.

class fwebh.pas.webhandlers.ResourceWebHandler inherits WebHandlerCommon: 
  
  var private ServiceFactory factory.
  
  constructor public ResourceWebHandler():
    factory = new ServiceFactory().
  end.
  
  method override protected integer HandleGet(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData data.
    var IResponseData responseData.
    var JsonObject json.
    var IGetDataService service.
    
    response = new WebResponse().

    /*
      the idea is: 
        - first get the request info (resource name etc)
        - get the service
        - see if service has preferences on how the data should be put in the RequestData object (POST, PUT, etc)
        - execute logic
        - create response data
        - ...
    */
    
    data = new RequestDataProcessor():ProcessRequestInfo(request).
    
    // get the service instance and execute the logic
    service = factory:GetGetDataService(data:Resource:Name).
    responseData = service:GetData(data).
    
    // for testing purposes serialize the RequestData and return it
    // assume JSON for now 
    json = new JsonObject().
    json:Add("request", new SimpleJsonSerializer():Serialize(data)).
    json:Add("response", cast(responseData:Json, JsonObject)).
    
    response:Entity = json.
    response:ContentType = "application/json".

    WriteResponse(response).

    return 0.

  end method.  // HandleGet

end class.  // ResourceWebHandler
