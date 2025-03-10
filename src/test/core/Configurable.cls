
 /*------------------------------------------------------------------------
    File        : Configurable
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Mon Mar 10 07:56:28 +01:00 2025
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.core.IConfigurable.
using Progress.Json.ObjectModel.JsonObject.

class test.core.Configurable implements IConfigurable:
  
  define public property Test as char no-undo get. set.
  
  method public void Configure(config as JsonObject):
    if config:Has("test") then
      Test = config:GetCharacter("test").
      
  end method.  // Configure

end class.  // Configurable
