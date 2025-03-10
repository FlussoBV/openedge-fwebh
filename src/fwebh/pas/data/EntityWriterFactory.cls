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

using fwebh.core.IFactory.
using fwebh.core.JSON.
using fwebh.lang.error.NotAcceptableException.
using fwebh.pas.data.IEntityWriter.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class fwebh.pas.data.EntityWriterFactory: 

  var private IFactory factory.
  
  constructor public EntityWriterFactory():
    factory = dynamic-new("fwebh.core.Factory")().  // no hard refs
    loadDefinitions("entitywriter.json").
  end constructor.
  
  method public IEntityWriter GetEntityWriter(mimeType as character):

    var IEntityWriter entityWriter.
    var char tmp.

    if (factory:Has(mimeType)) then
      entityWriter = cast(factory:GetInstance(mimeType), IEntityWriter).      
    else do:
      tmp = entry(1, mimeType, "/") + "/*".
      entityWriter = cast(factory:GetInstance(tmp), IEntityWriter).
    end.
      
    return entityWriter.
   
    catch err as Progress.Lang.Error :
      undo, throw new NotAcceptableException(mimeType).
    end catch.

  end method.  // GetEntityWriter

  method private void loadDefinitions(filename as character):
    
    var JsonObject defs.
    var int i.
    var char[] names.
    
    file-info:file-name = filename.
    // give informative error of the filename passed instead of:
    // Invalid source parameter to Progress.Json.ObjectModel.ObjectModelParser:ParseFile( ). Can not be UNKNOWN (?) or empty string. (16055)
    if file-info:full-pathname = ? then
      undo, throw new AppError(substitute("Could not find file (&1) for EntityWriterFactory",filename),-1).

    defs = JSON:ParseFileToObject(filename).
    
    names = defs:GetNames().
    do i = 1 to extent(names):
      factory:AddDefinition(names[i], defs:GetCharacter(names[i]), true, ?).
    end.

  end method.  // loadDefinitions

end class.
