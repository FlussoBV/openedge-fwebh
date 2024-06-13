
 /*------------------------------------------------------------------------
    File        : PersonList
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Fri Jun 07 13:34:15 +02:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.serialize.ISerializableDataStructure.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.Map.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using test.serialize.Language.

class test.serialize.PersonList implements ISerializableDataStructure:

  {test/serialize/tt-with-object.i}
  
  method public void Fill():
    create tt.
    tt.id = 1.
    tt.name = "Enzo".
    tt.lang = new Language(1, "Italiaans").
    create tt.
    tt.id = 2.
    tt.name = "Günther".
    tt.lang = new Language(2, "Duits").     
  end method.  

  method public IMap GetDataStructures():
    var IMap dataStructs = new Map().
    dataStructs:Put(new String("persons"), new WidgetHandle(temp-table tt:handle)).
    dataStructs:Put(new String("persons.taal"), new String("test.serialize.Language")).
    return dataStructs.
  end.
  
  method public override char ToString():
    var char result.
    for each tt:
      result += substitute("&1: &2 (&3)~n", tt.name, cast(tt.lang, Language):id, cast(tt.lang, Language):name).
    end.   
    return result.
  end method.
  
end class.  // PersonList
