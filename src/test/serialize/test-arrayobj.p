using test.serialize.ArrayObject.
using fwebh.serialize.SimpleJsonSerializer.

var longchar str.
var ArrayObject ao = new ArrayObject().

str = (new SimpleJsonSerializer()):SerializeToLongchar(ao, false).

copy-lob str to file "src/test/serialize/arrayobj-string1.txt".
