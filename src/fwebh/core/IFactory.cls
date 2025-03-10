
/*------------------------------------------------------------------------
    File        : IFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sun Jan 29 14:41:08 CET 2023
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Json.ObjectModel.JsonObject.

interface fwebh.core.IFactory:  
  
  method public Progress.Lang.Object GetInstance(instanceName as char).
  method public Progress.Lang.Object DeleteInstance(instanceName as char). 
  method public logical Has(instanceName as char).
  method public void LoadDefinitions(jsonDefinitionFile as char).
  method public void AddDefinition(instanceName as char, className as char, singleton as logical, config as JsonObject).
    
end interface.
