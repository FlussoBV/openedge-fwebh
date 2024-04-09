 
 /*------------------------------------------------------------------------
    File        : Address
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sat Jul 21 10:26:29 CEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using test.serialize.Address.

class test.serialize.Address serializable: 
  
  define public property Street as character no-undo get. set.
  define public property HouseNumber as integer no-undo get. set.
  define public property Municipale as character no-undo get. set.
  define public property Postcode as character no-undo get. set.
  
  method public override logical Equals(obj as Progress.Lang.Object):
    var Address addr.
    
    addr = cast(obj, Address).
    
    return 
      addr:Street = this-object:Street and
      addr:HouseNumber = this-object:HouseNumber and
      addr:Municipale = this-object:Municipale and
      addr:Postcode = this-object:Postcode
      .
      
  end method.  // Equals
  
end class.
