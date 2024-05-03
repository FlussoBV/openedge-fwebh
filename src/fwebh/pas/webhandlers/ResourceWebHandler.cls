 
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

using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.WebResponse.
using Progress.Json.ObjectModel.JsonObject.
using fwebh.pas.data.EntityWriterFactory.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.RequestDataProcessor.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.ServiceFactory.
using fwebh.pas.webhandlers.WebHandlerCommon.
using fwebh.serialize.SimpleJsonSerializer.


class fwebh.pas.webhandlers.ResourceWebHandler inherits WebHandlerCommon: 
  
  var private ServiceFactory serviceFactory.
  var private EntityWriterFactory writerFactory.
  
  constructor public ResourceWebHandler():
    serviceFactory = new ServiceFactory().
    writerFactory = new EntityWriterFactory().
  end.
  
  method override protected integer HandleGet(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData requestData.
    var IResponseData responseData.
    var JsonObject json.
    var IGetDataService service.
    var IEntityWriter entityWriter.
    var Progress.Lang.Object responseObj.
    
    do on error undo, throw:
      
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
      
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
message "get:" requestData:Resource:Name.      
      // get the service instance and execute the logic
      service = serviceFactory:GetGetDataService(requestData:Resource:Name).
message "valid service" valid-object(service).      
      responseData = service:GetData(requestData).
message "valid responseData" valid-object(responseData) responseData:ContentType.   
      // write the data to the response       

      entityWriter = getEntityWriter(responseData).
message "valid entityWriter" valid-object(entityWriter).       
      responseObj = entityWriter:Write(responseData).
      
      
      response:Entity = responseObj.
message "valid responseObj" valid-object(responseObj).      
      response:ContentType = responseData:ContentType.
               
      catch err1 as Progress.Lang.Error:
        MESSAGE "error?" VIEW-AS ALERT-BOX.
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

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
    json = new JsonObject().
    json:Add("requestData", new SimpleJsonSerializer():Serialize(data)).
    json:Add("response", cast(responseData:Json, JsonObject)).
    
    response:Entity = json.
    response:ContentType = "application/json".

    WriteResponse(response).

    return 0.

  end method.  // HandleGet
  
  
  method private IHttpResponse handleErrors(err as Progress.Lang.Error):
    
    var WebResponse response.
    var char errorType = err:GetClass():TypeName.
    var char errorMessage, contentType.
    var int errorNumber.
    
    contentType = "text/plain".  
    case errorType:
      when "fwebh.lang.error.NotImplementedException" then do:
        errorMessage = err:GetMessage(1).
        errorNumber = 405.
      end.
      otherwise do:
        errorMessage = err:GetMessage(1).
      end.
    end case.  
    
    response = new WebResponse().
    response:Entity = new String(errorMessage).
    response:StatusCode = errorNumber.
    response:StatusReason = StatusCodeHelper:GetMessage(errorNumber).
    response:ContentType = contentType.
    
    return response.
    
  end method.  // handleErrors
 
 
  method private IEntityWriter getEntityWriter(responseData as IResponseData):
    return writerFactory:GetEntityWriter(responseData:ContentType).
  end method.
  
end class.  // ResourceWebHandler
