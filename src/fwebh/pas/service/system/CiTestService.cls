 
 /*------------------------------------------------------------------------
    File        : CiTestService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed May 08 13:13:04 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using fwebh.lang.error.BadRequestException.
using fwebh.lang.error.ConcurrencyException.
using fwebh.lang.error.ForbiddenException.
using fwebh.lang.error.InvalidDataException.
using fwebh.lang.error.NotAcceptableException.
using fwebh.lang.error.NotAllowedException.
using fwebh.lang.error.NotFoundException.
using fwebh.lang.error.UnauthorizedException.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.
using fwebh.pas.service.IDeleteDataService.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.IPostDataService.

// all exceptions

class fwebh.pas.service.system.CiTestService implements IDeleteDataService, IGetDataService, IPostDataService: 

  method public IResponseData GetData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
    var char errorCode = request:Parameters:Get("error").
    var logical jsonError = (request:Parameters:Get("jsonError") = "true").
    var JsonObject json.
    
    if errorCode > "" then do:
      case errorCode:
        when "400" then undo, throw new BadRequestException("bad request").
        when "401" then undo, throw new UnauthorizedException("unauthorized").
        when "403" then undo, throw new ForbiddenException("forbidden").
        when "404" then undo, throw new NotFoundException("not found").
        when "405" then undo, throw new NotAllowedException("not allowed").
        when "406" then undo, throw new NotAcceptableException("not acceptable").
        when "409" then undo, throw new ConcurrencyException("test-resource", -1).
        when "500" then undo, throw new Progress.Lang.AppError("requested 500 error", -1).
        otherwise undo, throw new AppError("unforseen error", -1).
      end case.
    end.
    else if request:Accept = "application/json" or request:Accept = "*/*" then do:
      json = new JsonObject().
      // test the JSON body for error response
      if jsonError then do:
        json:Add("code", "400").
        json:Add("message", "custom JSON error, check!").
        response:Error = new fwebh.lang.error.BadRequestException("").
      end.
      else  
        json:Add("test", "ok").
      
      response:Data:Json = json.
    end.
    else if request:Accept = "text/plain" then do:
      response:Data:PlainText = "text test OK".
    end.
    
    return response.
    
  end method.  // GetData

  method public IResponseData DeleteData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
    var JsonObject jsonIn, jsonOut.
    var char id.
    
    do on error undo, throw:
      
      if request:Resource:Id > "" then do:
        // do nothing, empty 
      end.
      else do on error undo, throw: 
        
        jsonIn = new JsonObject().
        jsonOut = new JsonObject().
        
        jsonIn = cast(request:Data:JSON, "Progress.Json.ObjectModel.JsonObject").
        jsonOut:Add("deleted", jsonIn:GetCharacter("id")).
        
        response:Data:Json = jsonOut.        
      end.

      catch err1 as Progress.Lang.Error :
        undo, throw new InvalidDataException(err1:GetMessage(1)).
      end catch.           
      
    end.
    
    return response.
    
  end method.  // DeleteData
  
  
  method public IResponseData PostData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
    
    if request:ContentType = "text/plain" then do:
      response:Data:PlainText = substitute("request body: &1", request:Data:PlainText).
    end.
    
    return response.
    
  end method.  // PostData

end class.
