 
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
    
    define variable dataStructs as IMap no-undo.
    
    dataStructs = new Map().
    dataStructs:Put(new String("temptable"), new WidgetHandle(temp-table tt:handle)).
    
    return dataStructs.
    
  end method.  // GetDataStructures
  
end class.
