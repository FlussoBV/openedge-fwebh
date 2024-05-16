 
 /*------------------------------------------------------------------------
    File        : TempTableTest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Apr 09 16:22:05 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.Map.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.

using fwebh.serialize.ISerializableDataStructure.

class test.serialize.TempTableTest implements ISerializableDataStructure: 
  
  define private temp-table tt no-undo
    field firstname as char
    field lastname as char
    .
  
  method public void AddEntry(firstname as char, lastname as char):
    create tt.
    tt.firstname = firstname.
    tt.lastname = lastname.
  end method.
  
  method public IMap GetDataStructures():
    
    var IMap dataStructs.
    
    dataStructs = new Map().
    dataStructs:Put(new String("temptable"), new WidgetHandle(temp-table tt:handle)).
    
    return dataStructs.
    
  end method.  // GetDataStructures
  
  method public char GetLastName(firstname as char):
    var char lastname = ?.
    for first tt where tt.firstname = firstname:
      lastname = tt.lastname.
    end.
    return lastname.
  end method.  // GetLastName
  
  method public int CountRecords():
    var int i.
    for each tt:
      i += 1.
    end.
    return i.
  end method.  // CountRecords
  
end class.
