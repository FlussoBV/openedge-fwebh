
/*------------------------------------------------------------------------
    File        : IFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sun Jan 29 14:41:08 CET 2023
    Notes       : 
  ----------------------------------------------------------------------*/

interface okelib.core.IFactory:  
  
  method public Progress.Lang.Object GetInstance(instanceName as character).
  method public Progress.Lang.Object DeleteInstance(instanceName as character). 
  method public void LoadDefinitions(jsonDefinitionFile as character).
    
end interface.