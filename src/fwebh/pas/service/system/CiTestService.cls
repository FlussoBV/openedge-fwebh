 
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

using OpenEdge.Core.String.
using Progress.Lang.AppError.
using Progress.Json.ObjectModel.JsonObject.
using fwebh.lang.error.*.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.
using fwebh.pas.service.IGetDataService.
using fwebh.serialize.SimpleJsonSerializer.

class fwebh.pas.service.system.CiTestService implements IGetDataService: 

  method public IResponseData GetData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
    var char errorCode = request:Parameters:Get("error").
    var JsonObject json.
    
    if errorCode > "" then do:
      case errorCode:
        when "400" then undo, throw new BadRequestException("bad request").
        when "404" then undo, throw new NotFoundException("not found").
        when "405" then undo, throw new NotAllowedException("not allowed").
        when "500" then undo, throw new Progress.Lang.AppError("requested 500 error", -1).
        otherwise undo, throw new AppError("unforseen error", -1).
      end case.
    end.
    else do:
      json = new JsonObject().
      json:Add("test", "ok").
      response:Data:Json = json.
    end. 
    
    return response.
    
  end method.  // GetData

end class.