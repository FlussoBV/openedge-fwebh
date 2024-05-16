# serializing / deserializing
Although OpenEdge has serializing capabilities, the output may not be what is wanted. For example, OpenEdge places version info in the output JSON and all the property one level deeper.
The idea behind this (de-)serializer is to operate the same as one can expect when serializing JavaScript objects.

Suppose you want to serialize this class:

```
class SimpleObject serializable:
  define public property Prop1 as character no-undo get. set.
  define public property Prop2 as character no-undo get. set.
  define public property Prop3 as character no-undo get. set.
end class.
```
OpenEdge produces the following JSON:

```
{
  "prods:version": 1,
  "prods:objId": 1,
  "SimpleObject": {
    "Prop1": "",
    "Prop2": "",
    "Prop3": ""
  }
}
```

Whereas the ideal output would be:
```
{
  "Prop1": "",
  "Prop2": "",
  "Prop3": ""
}
```

The serializer serializes all the public properties. Temp-tables cannot be found by reflection and therefor the class to be serialized need to implement the `lib.serialize.ISerializableDataStructure` interface. An example can be found in `lib.serialize.test.TestTempTables`:
```
  method public IMap GetDataStructures():

    var IMap dataStructs.

    dataStructs = new Map().
    dataStructs:Put(new String("definitions"), new WidgetHandle(temp-table ttfactorydef:handle)).

    return dataStructs.

  end method.
```

The class will be serialized as:

```
{
    "definitions": [
        {
            "topic": "bol.com:order",
            "classname": "channel.processors.BolOrderProcessor"
        },
        {
            "topic": "gallweb:order",
            "classname": "channel.processors.GallProcessor"
        }
    ]
}
```

Serializing an object is as simple as:

```
var SimpleObject obj.
var SimpleJsonSerializer serializer.
var longchar resultString.

obj = new SimpleObject().
serializer = new SimpleJsonSerializer().

resultString = serializer:SerializeToLongchar(obj).
```

The object can be serialized to a `JsonObject` as well by the `Serialize` method.

## Deserializing
Since OpenEdge lacks the flexibility when it comes to turning JSON into objects you have to know what JSON (i.e. the structure) of what you will receive.

So suppose you expect to receive something like:
```
{
  "version": "1.0",
  "active": true,
  "rows": [
    { "field1": "hello", "field2": "world" },
    { "field1": "openedge", "field2": "12.0" }
  ]
}
```
A receiving class could look like, note the GetDataStructures method where you define in what node you expect to receive the contents for the temp-table.

```
using lib.serialize.ISerializableDataStructure.
using OpenEdge.Core.*.

block-level on error undo, throw.

class lib.serialize.test.CompoundObject implements ISerializableDataStructure:

  define public property version as character no-undo get. set.
  define public property active as logical no-undo get. set.

  define private temp-table ttfield no-undo
    field field1 as character
    field field2 as character
    .


  method public IMap GetDataStructures():

    var IMap dataStructs.

    dataStructs = new Map().
    dataStructs:Put(new String("rows"), new WidgetHandle(temp-table ttfield:handle)).

    return dataStructs.

  end method.

end class.
```

### Deserialize an array of string

Consider the JSON for a Person object with an array of strings like:
```
{
  "Name": "brian",
  "Functions": [
    "f1",
    "f2"
  ]
}
```
The deserializer needs to be told `Functions` is not only a `List`, but a `List` of strings, `OpenEdge.Core.String`'s to be precise:

```
using lib.serialize.IListInfo.
using OpenEdge.Core.Collections.List.

class sandbox.serialization.Person implements IListInfo: 
  
  define public property Name as char no-undo get. set.
  define public property Functions as List no-undo get. set.
  
    method public character GetListType(listName as character):     
    case listName:
      when "Functions" then return "OpenEdge.Core.String".
    end case.        
    
  end method.  // GetListType
  
end class.
``` 

In the code the `Functions` can be read like (where `p1` is an object of type `Person`):

```
{foreach.i String f in p1:Functions}
  message string(f:Value) view-as alert-box.
end.
```

For primitive data types like `character`, `integer`, etc JsonArray can also be used.
This would be:
```
define public property Functions as JsonArray no-undo get. set.
```
Handling this would be via normal handling of a JsonArray

