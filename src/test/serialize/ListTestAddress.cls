 
 /*------------------------------------------------------------------------
    File        : ListTestAddress
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Apr 10 07:32:10 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Collections.List.
using test.serialize.Address.


class test.serialize.ListTestAddress: 
  
  define public property addresses as List no-undo get. set.
  
  constructor public ListTestAddress():
    this-object:addresses = new List().
  end.

  method public void Add(addr as Address):
    this-object:addresses:Add(addr).
  end method.

end class.
