 
 /*------------------------------------------------------------------------
    File        : ListTest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Apr 09 16:34:08 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Collections.List.
using OpenEdge.Core.String.
using fwebh.serialize.IListInfo.


class test.serialize.ListTest implements IListInfo: 
  
  define public property entries as List no-undo get. set.
  
  constructor public ListTest():
    this-object:entries = new List().
  end.
  
  method public void AddEntry(testvalue as char):
    this-object:entries:Add(new String(testvalue)).
  end method.
  
  // make it possible for the deserializer to use the correct type
  method public character GetListType(listName as character):
    var char listType.
    
    case listName:
      when "entries" then listType = "OpenEdge.Core.String".
    end.
    
    return listType.
    
  end method.
  
end class.
