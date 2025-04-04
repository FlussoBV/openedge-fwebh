 
/*------------------------------------------------------------------------
   File        : Factory
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : bronco
   Created     : Fri Nov 27 08:36:48 CET 2020
   Notes       : The default entries for this factory are fetched from services.json
                 which must located somewhere in the propath. The format of 
                 this service.json file is:
                 {
                   "<service-name>": "<fq class>",
                   ...,
                   "<service-name2>": { "class": "<fq class>", "singleton": true }                   
                 }    
                 In the latter case this factory makes sure there's just 
                 one instance of the class.
                 The object lifecycle of non-singleton instances are NOT managed by this 
                 factory and therefor should be taken care of by the programmer. 
                 This by either letting the Garbage Collector (GC) do its job or 
                 delete objects manually.  
 ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.core.Factory.
using fwebh.core.IConfigurable.
using fwebh.core.IFactory.
using fwebh.lang.error.InvalidDataException.
using fwebh.lang.error.NotFoundException.
using OpenEdge.Core.Assert.
using OpenEdge.Core.JsonDataTypeEnum.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.

class fwebh.core.Factory implements IFactory: 
    
  {fwebh/core/ttfactorydef.i &accessor=private}
      
  define temp-table ttinstance no-undo
    field objtype as character
    field obj as Progress.Lang.Object
    .
    
  define public static property Instance as Factory get. private set.
    
  /* you can create your own Factory and load definitions */ 
  constructor public Factory():
  end.
    
    
  constructor static Factory():
    Factory:Instance = new Factory().
  end constructor.
    
    
  method public void LoadDefinitions(jsonDefinitionFile as character):
        
    var JsonObject jsonDefinitions.
    var ObjectModelParser parser.
    
    do on error undo, throw:
      
      jsonDefinitionFile = search(jsonDefinitionFile).
      if jsonDefinitionFile = ? then 
        undo, throw new AppError(substitute("factory definition file ~"&1~" not found", jsonDefinitionFile), -1).
              
      parser = new ObjectModelParser().
          
      jsonDefinitions = cast(parser:ParseFile(jsonDefinitionFile), JsonObject).
          
      this-object:ProcessDefinitions(jsonDefinitions).
      
      catch err1 as Progress.Lang.Error :
        undo, throw new InvalidDataException(err1:GetMessage(1)).  
      end catch.
      
    end.  // do on error...
                   
  end method.  // LoadDefinitions
  
  
  method public void AddDefinition(identifier as char, classname as char, singleton as logical, config as JsonObject):
    
    find ttdefintion where ttdefintion.indentifier = identifier no-error.
    if (not available(ttdefintion)) then do:
      create ttdefintion.
      ttdefintion.indentifier = identifier.
    end.
    
    ttdefintion.classname = classname.
    ttdefintion.singleton = singleton.  
    ttdefintion.config = config.
    
  end method.  // AddDefinitions
    
    
  method private void ProcessDefinitions(jsonDefintions as JsonObject):
      
    var int i, propertyType.
    var char[] names.
    var JsonObject defintionObject.
    var JsonObject config.
    
    var char identifier, classname.
    var logical singleton.
        
    names = jsonDefintions:GetNames().
    do i = 1 to extent(names):
            
      identifier = names[i].
      propertyType = jsonDefintions:GetType(identifier).
            
      case (propertyType):
                
        when JsonDataTypeEnum:String:GetValue() then do:
          classname = jsonDefintions:GetCharacter(identifier).
          singleton = false.   
        end.
                
        when JsonDataTypeEnum:Object:GetValue() then do:
          defintionObject = jsonDefintions:GetJsonObject(identifier).
          classname = defintionObject:GetCharacter("class").
          singleton = (defintionObject:Has("singleton") and defintionObject:GetLogical("singleton")).
          if defintionObject:Has("config") then
            config = defintionObject:GetJsonObject("config").
        end.
                
        otherwise do:
          // nothing 
        end.
             
      end case.
      
      AddDefinition(identifier, classname, singleton, config).
        
    end.  // do i = 1 to extent(names)...
      
  end method.  // ProcessDefinitions
    
  /**
  * @param instanceName   the logical name of the requested object
  * @return               the requested object instance
  */  
  method public Progress.Lang.Object GetInstance(instanceName as character):
        
    var Progress.Lang.Object instanceRef.
    var logical singleInstanceFound.
    
    find ttdefintion where ttdefintion.indentifier = instanceName no-error.
    if not available(ttdefintion) then 
      undo, throw new NotFoundException(substitute("no definition found for '&1'", instanceName)).
            
    singleInstanceFound = false.
    if ttdefintion.singleton then do:
      for first ttinstance where ttinstance.objtype = instanceName:
        instanceRef = ttinstance.obj.
        singleInstanceFound = true.
      end.    
    end. 
    
    if not valid-object(instanceRef) then do:
      instanceRef = dynamic-new(ttdefintion.classname)() no-error.
            
      if not error-status:error and instanceRef:GetClass():IsA("fwebh.core.IConfigurable") and valid-object(ttdefintion.config) then
        cast(instanceRef, IConfigurable):Configure(cast(ttdefintion.config, JsonObject)).
    end.              
    
    if (not valid-object(instanceRef)) then      
      undo, throw new AppError(substitute("class not found: &1", ttdefintion.classname), -1).
    
    if ttdefintion.singleton and not singleInstanceFound then do:
      create ttinstance.
      assign
        ttinstance.objtype = ttdefintion.indentifier 
        ttinstance.obj = instanceRef
        .
    end. 
                                
    return instanceRef.
              
  end method.  // GetInstance
    
    
  method public Progress.Lang.Object DeleteInstance(instanceName as character):
    for first ttinstance where ttinstance.objtype = instanceName:
      if valid-object(ttinstance.obj) then
        delete object ttinstance.obj.
      delete ttinstance.
    end.
  end method.  // DeleteInstance
  
  
  method public logical Has(instanceName as char):
    return can-find(first ttdefintion where ttdefintion.indentifier = instanceName).
  end method.  
  
end class.
