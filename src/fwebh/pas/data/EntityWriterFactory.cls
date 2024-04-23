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
using fwebh.core.Factory.
using fwebh.core.JSON.
using fwebh.pas.data.IEntityWriter.
using fwebh.lang.error.NotFoundException.

class fwebh.pas.data.EntityWriterFactory: 

  var private Factory factory.
  
  constructor public EntityWriterFactory():

    factory = new Factory().

    loadDefinitions("entitywriter.json").

  end constructor.
  
  method public IEntityWriter GetEntityWriter( mimeType as character ):

    var IEntityWriter entityWriter.

    do on error undo, throw:

      return cast(factory:GetInstance(mimeType), IEntityWriter).

      catch e as NotFoundException :

        mimeType = entry( 1, mimeType, "/") + "/*".
        return  cast(factory:GetInstance(mimeType), IEntityWriter).

      end catch.
    end.

  end method.

  method private void loadDefinitions( filename as character ):
    
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
