 /*------------------------------------------------------------------------
    File        : EntityWriterFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Mon Apr 15 14:58:39 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using fwebh.core.IFactory.
using fwebh.core.JSON.
using fwebh.lang.error.NotFoundException.
using fwebh.lang.error.NotAcceptableException.
using fwebh.pas.data.IEntityWriter.

class fwebh.pas.data.EntityWriterFactory: 

  var private IFactory factory.
  
  constructor public EntityWriterFactory():
    factory = dynamic-new("fwebh.core.Factory")().  // no hard refs
    loadDefinitions("entitywriter.json").
  end constructor.
  
  method public IEntityWriter GetEntityWriter(mimeType as character):

    var IEntityWriter entityWriter.
    var char tmp.
    
    do on error undo, throw:
      
      if (factory:Has(mimeType)) then
        entityWriter = cast(factory:GetInstance(mimeType), IEntityWriter).
      else do:
        tmp = entry(1, mimeType, "/") + "/*".
        entityWriter = cast(factory:GetInstance(tmp), IEntityWriter).
      end.
      
      catch err1 as Progress.Lang.Error :
        undo, throw new NotAcceptableException(mimeType).
      end catch.
      
    end.  // do on error...
            
    return entityWriter.
   
  end method.  // GetEntityWriter

  method private void loadDefinitions(filename as character):
    
    var JsonObject defs.
    var int i.
    var char[] names.

    defs = JSON:ParseFileToObject(filename).

    names = defs:GetNames().
    do i = 1 to extent(names):
      factory:AddDefinition(names[i], defs:GetCharacter(names[i]), true).
    end.
    
  end method.  // loadDefinitions

end class.
