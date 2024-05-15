 
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

using fwebh.pas.data.EntityWriterFactory.
using fwebh.pas.data.IEntityWriter.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.RequestDataProcessor.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.IPostDataService.
using fwebh.pas.service.IPutDataService.
using fwebh.pas.service.ServiceFactory.
using fwebh.pas.webhandlers.WebHandlerCommon.
using fwebh.serialize.SimpleJsonSerializer.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.WebResponse.
using Progress.Json.ObjectModel.JsonObject.


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
  
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
      
      // get the service instance and execute the logic
      service = serviceFactory:GetGetDataService(requestData:Resource:Name).      
      responseData = service:GetData(requestData).
      
      responseData:ContentType = handleContentType(service, requestData, responseData).
      
      // write the data to the response       
      entityWriter = getEntityWriter(responseData).
      responseObj = entityWriter:Write(responseData).
      
      response:Entity = responseObj.
      response:ContentType = responseData:ContentType.
               
      catch err1 as Progress.Lang.Error:
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

    WriteResponse(response).
    
    @todo(what="garbage collect, certainly in case of memptr's").
    
    return 0.

  end method.  // HandleGet


  method override protected integer HandlePost(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData requestData.
    var IResponseData responseData.
    var JsonObject json.
    var IPostDataService service.
    var IEntityWriter entityWriter.
    var Progress.Lang.Object responseObj.
    
    do on error undo, throw:
      
      response = new WebResponse().
  
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
      
      // get the service instance and execute the logic
      service = serviceFactory:GetPostDataService(requestData:Resource:Name).      
      responseData = service:PostData(requestData).
      
      responseData:ContentType = handleContentType(service, requestData, responseData).
      
      // write the data to the response       
      entityWriter = getEntityWriter(responseData).
      responseObj = entityWriter:Write(responseData).
      
      response:Entity = responseObj.
      response:ContentType = responseData:ContentType.
               
      catch err1 as Progress.Lang.Error:
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

    WriteResponse(response).
    
    @todo(what="garbage collect, certainly in case of memptr's").
    
    return 0.

  end method.  // HandlePost


  method override protected integer HandlePut(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData requestData.
    var IResponseData responseData.
    var JsonObject json.
    var IPutDataService service.
    var IEntityWriter entityWriter.
    var Progress.Lang.Object responseObj.
    
    do on error undo, throw:
      
      response = new WebResponse().
  
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
      
      // get the service instance and execute the logic
      service = serviceFactory:GetPutDataService(requestData:Resource:Name).      
      responseData = service:PutData(requestData).
      
      responseData:ContentType = handleContentType(service, requestData, responseData).
      
      // write the data to the response       
      entityWriter = getEntityWriter(responseData).
      responseObj = entityWriter:Write(responseData).
      
      response:Entity = responseObj.
      response:ContentType = responseData:ContentType.
               
      catch err1 as Progress.Lang.Error:
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

    WriteResponse(response).
    
    @todo(what="garbage collect, certainly in case of memptr's").
    
    return 0.

  end method.  // HandlePut
  
  
  method private IHttpResponse handleErrors(err as Progress.Lang.Error):
    
    var WebResponse response.
    var char errorType = err:GetClass():TypeName.
    var char errorMessage, contentType.
    var int errorNumber.
  
    contentType = "text/plain".  
    case errorType:
      when "fwebh.lang.error.BadRequestException" then do:
        errorMessage = err:GetMessage(1).
        errorNumber = 400.
      end.      
      when "fwebh.lang.error.NotFoundException" then do:
        errorMessage = err:GetMessage(1).
        errorNumber = 404.
      end.      
      when "fwebh.lang.error.NotAllowedException" then do:
        errorMessage = err:GetMessage(1).
        errorNumber = 405.
      end.
      when "fwebh.lang.error.NotAcceptableException" then do:
        errorMessage = err:GetMessage(1).
        errorNumber = 406.
      end.
      otherwise do:
        errorMessage = err:GetClass():TypeName + ": " + err:GetMessage(1).
        errorNumber = 500.
      end.
    end case.  
    
    response = new WebResponse().
    response:Entity = new String(errorMessage).
    response:StatusCode = errorNumber.
    response:ContentType = contentType.
    
    return response.
    
  end method.  // handleErrors

 
  method private char handleContentType(service as Progress.Lang.Object, requestData as IRequestData, responseData as IResponseData):
    
    var char contentType.

    if (responseData:ContentType > "") then 
      contentType = responseData:ContentType.
    else if requestData:Accept > "" and requestData:Accept <> "*/*" then 
      contentType = requestData:Accept.
    else if service:GetClass():IsA("fwebh.pas.data.IDefaultContentType") then 
      contentType = cast(service, "fwebh.pas.data.IDefaultContentType"):GetDefaultContentType().
    
    if contentType = "" then
      contentType = "application/json".  // last resort
   
    return contentType.
    
  end method.  // handleContentType
  
  
  method private IEntityWriter getEntityWriter(responseData as IResponseData):
    
    return writerFactory:GetEntityWriter(responseData:ContentType).
    
  end method.
  
end class.  // ResourceWebHandler
