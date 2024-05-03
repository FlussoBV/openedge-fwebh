 
 /*------------------------------------------------------------------------
    File        : EntityData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri May 03 12:21:02 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.


class fwebh.pas.data.EntityData: 
  
  define public property Entity as Progress.Lang.Object no-undo get. private set.
  define public property ContentType as char no-undo get. private set.
  
  constructor EntityData(entity as Progress.Lang.Object, contentType as char):
    Entity = entity.
    ContentType = contentType.
  end constructor.
  
end class.
