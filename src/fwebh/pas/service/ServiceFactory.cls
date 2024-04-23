
 /*------------------------------------------------------------------------
    File        : ServiceFactory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Tue Mar 26 08:50:28 +01:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using fwebh.core.Factory.
using fwebh.core.JSON.
using fwebh.lang.error.NotAllowedException.
using fwebh.lang.error.NotFoundException.
using fwebh.pas.service.IDeleteDataService.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.IPatchDataService.
using fwebh.pas.service.IPostDataService.
using fwebh.pas.service.IPutDataService.
using fwebh.pas.service.ServiceDescription.
using fwebh.serialize.SimpleJsonDeserializer.

class fwebh.pas.service.ServiceFactory: 
  
  define private variable factory as Factory no-undo.
  
  constructor public ServiceFactory():
    factory = new Factory().
    loadDefinitions().
  end constructor.
  
  method public IGetDataService GetGetDataService(identifier as character):
    var Progress.Lang.Object obj = getFromFactory(identifier, "fwebh.pas.service.IGetDataService").
    return cast(obj, IGetDataService).
  end method.

  method public IPatchDataService GetPatchDataService(identifier as character):
    var Progress.Lang.Object obj = getFromFactory(identifier, "fwebh.pas.service.IPatchDataService").
    return cast(obj, IPatchDataService).
  end method.

  method public IPostDataService GetPostDataService(identifier as character):
    var Progress.Lang.Object obj = getFromFactory(identifier, "fwebh.pas.service.IPostDataService").
    return cast(obj, IPostDataService).
  end method.

  method public IPutDataService GetPutDataService(identifier as character):
    var Progress.Lang.Object obj = getFromFactory(identifier, "fwebh.pas.service.IPutDataService").
    return cast(obj, IPutDataService).
  end method.
    
  method public IDeleteDataService GetDeleteDataService(identifier as character):
    var Progress.Lang.Object obj = getFromFactory(identifier, "fwebh.pas.service.IDeleteDataService").
    return cast(obj, IDeleteDataService).
  end method.
  
  method private Progress.Lang.Object getFromFactory(identifier as char, expectedInterface as char):
    var char methodName.
    var Progress.Lang.Object obj = factory:GetInstance(identifier).
     
    if (not obj:GetClass():IsA(expectedInterface)) then do:
      methodName = caps(replace(replace(expectedInterface, "fwebh.pas.service.I", ""), "DataService", "")). 
      undo, throw new NotAllowedException(substitute("&1 for '&2'", methodName, identifier)).
    end.
    
    return obj.
    
  end method.
  
  

  method private void loadDefinitions():
    
    var SimpleJsonDeserializer deserializer.
    var JsonObject defs.
    var ServiceDescription svcDef.
    var int i.
    var char[] names.
    
    deserializer = new SimpleJsonDeserializer().
    defs = JSON:ParseFileToObject("services.json").
    
    names = defs:GetNames().
    do i = 1 to extent(names):
      svcDef = cast(deserializer:Deserialize(defs:GetJsonObject(names[i]), "fwebh.pas.service.ServiceDescription"), ServiceDescription).
      
      // the actual class must exist
      do on error undo, throw:
        Progress.Lang.Class:GetClass(svcDef:classname).
        catch err as Progress.Lang.Error:
          undo, throw new NotFoundException(substitute("ServiceFactory definition '&1', class not found: '&2'", names[i], svcDef:classname)).
        end catch.
      end.
              
      factory:AddDefinition(names[i], svcDef:classname, svcDef:singleton).
      
    end.
    
  end method.  // loadDefinitions
    
end class.  // ServiceFactory
