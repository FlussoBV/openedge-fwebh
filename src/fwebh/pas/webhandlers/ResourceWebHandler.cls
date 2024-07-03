 
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
using fwebh.pas.data.ResponseDataType.
using fwebh.pas.service.IDeleteDataService.
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
    var IGetDataService service.
    
    do on error undo, throw:
      
      response = new WebResponse().
  
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
      
      // get the service instance and execute the logic
      service = serviceFactory:GetGetDataService(requestData:Resource:Name).      
      responseData = service:GetData(requestData).
      
      response = handleResponse(service, requestData, responseData).

      catch err1 as Progress.Lang.Error:
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

    WriteResponse(response).
    
    return 0.

  end method.  // HandleGet


  method override protected integer HandlePost(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData requestData.
    var IResponseData responseData.
    var IPostDataService service.
    
    do on error undo, throw:
      
      response = new WebResponse().
  
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
      
      // get the service instance and execute the logic
      service = serviceFactory:GetPostDataService(requestData:Resource:Name).      
      responseData = service:PostData(requestData).
      
      response = handleResponse(service, requestData, responseData).
           
      catch err1 as Progress.Lang.Error:
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

    WriteResponse(response).
    
    return 0.

  end method.  // HandlePost


  method override protected integer HandlePut(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData requestData.
    var IResponseData responseData.
    var IPutDataService service.
    
    do on error undo, throw:
      
      response = new WebResponse().
  
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
      
      // get the service instance and execute the logic
      service = serviceFactory:GetPutDataService(requestData:Resource:Name).      
      responseData = service:PutData(requestData).
      
      response = handleResponse(service, requestData, responseData).
               
      catch err1 as Progress.Lang.Error:
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

    WriteResponse(response).
    
    return 0.

  end method.  // HandlePut
  

  method override protected integer HandleDelete(request as IWebRequest):
    
    var IHttpResponse response.
    var IRequestData requestData.
    var IResponseData responseData.
    var IDeleteDataService service.
    
    do on error undo, throw:
      
      requestData = new RequestDataProcessor():ProcessRequestInfo(request).
      
      // get the service instance and execute the logic
      service = serviceFactory:GetDeleteDataService(requestData:Resource:Name).      
      responseData = service:DeleteData(requestData).
      
      response = handleResponse(service, requestData, responseData).
                           
      catch err1 as Progress.Lang.Error:
        response = handleErrors(err1).  
      end catch.
      
    end.  // do on error undo, throw

    WriteResponse(response).
    
    return 0.

  end method.  // HandleDelete
  
  
  method private IHttpResponse handleResponse(service as Progress.Lang.Object, requestData as IRequestData, responseData as IResponseData):
    
    var IEntityWriter entityWriter.
    var Progress.Lang.Object responseObj.    
    var IHttpResponse response = new WebResponse().
        
    responseData:ContentType = handleContentType(service, requestData, responseData).
    
    if responseData:Data:DataType <> ResponseDataType:NONE then do:
      
      // write the data to the response       
      entityWriter = getEntityWriter(responseData).
      responseObj = entityWriter:Write(responseData).
      
      response:Entity = responseObj.
      response:ContentType = responseData:ContentType.
      
      if valid-object(responseData:Error) then 
        response:StatusCode = getHttpErrorCode(responseData:Error).
      
    end.
    else do:
      response:StatusCode = 204.
    end.
    
    return response.
    
  end method.  // handleResponse
  
  
  method private IHttpResponse handleErrors(err as Progress.Lang.Error):
    
    var WebResponse response.
    
    var char errorMessage, contentType.
    var int errorCode.
  
    contentType = "text/plain".  
    
    errorMessage = err:GetMessage(1).
    errorCode = getHttpErrorCode(err).
    
    if not err:GetClass():TypeName begins "fwebh.lang.error." then
      errorMessage = err:GetClass():TypeName + ": " + err:GetMessage(1).
         
    response = new WebResponse().
    response:Entity = new String(errorMessage).
    response:StatusCode = errorCode.
    response:ContentType = contentType.
    
    return response.
    
  end method.  // handleErrors
  
  
  method private int getHttpErrorCode(err as Progress.Lang.Error):
        
    var int errorCode.
    
    case err:GetClass():TypeName:
      when "fwebh.lang.error.BadRequestException" then
        errorCode = 400.

      when "fwebh.lang.error.NotFoundException" then 
        errorCode = 404.

      when "fwebh.lang.error.NotAllowedException" then
        errorCode = 405.

      when "fwebh.lang.error.NotAcceptableException" then
        errorCode = 406.
      
      when "fwebh.lang.error.ConcurrencyException" then
        errorCode = 409.
        
      otherwise
        errorCode = 500.
      
    end case.  
    
    return errorCode.
    
  end method.  // getHttpErrorCode

 
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
