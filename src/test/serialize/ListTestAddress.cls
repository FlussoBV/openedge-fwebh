 
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
using fwebh.serialize.IListInfo.
using test.serialize.Address.


class test.serialize.ListTestAddress implements IListInfo: 
  
  define public property addresses as List no-undo get. set.
  
  constructor public ListTestAddress():
    this-object:addresses = new List().
  end.

  method public void Add(addr as Address):
    this-object:addresses:Add(addr).
  end method.

  // make it possible for the deserializer to use the correct type
  method public character GetListType(listName as character):
    var char listType.
    
    case listName:
      when "addresses" then listType = "test.serialize.Address".
    end.
    
    return listType.
    
  end method.

end class.
