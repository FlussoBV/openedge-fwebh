
 /*------------------------------------------------------------------------
    File        : Language
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Fri Jun 07 13:35:56 +02:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class test.serialize.Language:

  define public property id as int no-undo get. set.
  define public property name as char no-undo get. set.
  
  constructor public Language():
  end.  
      
  constructor public Language(id as int, name as char):
    this-object:id = id.
    this-object:name = name.
  end.
  
  method public override char ToString():
    return substitute("&1: &2", id, name).
  end.
  
end class.  // Language
