
 /*------------------------------------------------------------------------
    File        : ServiceFactory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Tue Mar 26 08:50:28 +01:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.core.Factory.
using fwebh.pas.service.IDeleteDataService.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.IPatchDataService.
using fwebh.pas.service.IPostDataService.
using fwebh.pas.service.IPutDataService.

block-level on error undo, throw.

class fwebh.pas.service.ServiceFactory: 
  
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
