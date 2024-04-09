
 /*------------------------------------------------------------------------
    File        : SystemInfoService
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Tue Mar 26 09:27:58 +01:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using okelib.pas.data.IRequestData.
using okelib.pas.data.IResponseData.
using okelib.pas.service.IGetDataService.

class okelib.pas.service.system.SystemInfoService implements IGetDataService:

  constructor public SystemInfoService():
    
  end constructor.

  method public IResponseData GetData(request as IRequestData):

  end method.  // GetData

end class.  // SystemInfoService
