
 /*------------------------------------------------------------------------
    File        : ServiceFactory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Tue Mar 26 08:50:28 +01:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using okelib.core.Factory.
using okelib.pas.service.IDeleteDataService.
using okelib.pas.service.IGetDataService.
using okelib.pas.service.IPatchDataService.
using okelib.pas.service.IPostDataService.
using okelib.pas.service.IPutDataService.

block-level on error undo, throw.

class okelib.pas.service.ServiceFactory: 
  
  define private variable factory as Factory no-undo.
  
  constructor public ServiceFactory():
    factory = new Factory().
    factory:LoadDefinitions("services.json").
  end constructor.
  
  
  method public IGetDataService GetGetDataService(instanceName as character):
    return cast(factory:GetInstance(instanceName), IGetDataService).
  end method.

  method public IPatchDataService GetPatchDataService(instanceName as character):
    return cast(factory:GetInstance(instanceName), IPatchDataService).
  end method.

  method public IPostDataService GetPostDataService(instanceName as character):
    return cast(factory:GetInstance(instanceName), IPostDataService).
  end method.

  method public IPutDataService GetPutDataService(instanceName as character):
    return cast(factory:GetInstance(instanceName), IPutDataService).
  end method.
    
  method public IDeleteDataService GetDeleteDataService(instanceName as character):
    return cast(factory:GetInstance(instanceName), IDeleteDataService).
  end method.
  
end class.  // ServiceFactory
