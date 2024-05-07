
 /*------------------------------------------------------------------------
    File        : SystemInfoService
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Tue Mar 26 09:27:58 +01:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.
using fwebh.pas.service.IGetDataService.

class fwebh.pas.service.system.SystemInfoService implements IGetDataService:

  constructor public SystemInfoService():
    
  end constructor.

  method public IResponseData GetData(request as IRequestData):
    var JsonObject json = new JsonObject().
    var ResponseData response = new ResponseData().
    
    if (request:Accept = "..." ) then 
      response:ContentType = "application/json".

    json:Add("status", "ok").
    json:Add("time", iso-date(datetime-tz(now))).
    
    response:Data:Json = json.
    
    return response.
    
  end method.  // GetData

end class.  // SystemInfoService
