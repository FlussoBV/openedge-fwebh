 
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
using fwebh.pas.data.RequestDataBuilder.
using fwebh.pas.webhandlers.WebHandlerCommon.

class fwebh.pas.webhandlers.ResourceWebHandler inherits WebHandlerCommon: 

  method override protected integer HandleGet(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData data.
    var JsonObject json.

    response = new WebResponse().

    /*
      the idea is: 
        - first get the request info (resource name etc)
        - get the service
        - see if service has preferences on how the data should be put in the RequestData object
        - execute logic
        - create response data
        - ...
    */

    data = RequestDataBuilder:Get():ProcessRequestInfo(request).
    json = (new SimpleJsonSerializer()):Serialize(data).

    response:Entity = json.
    response:ContentType = "application/json".

    WriteResponse(response).

    return 0.

  end method.

end class.
