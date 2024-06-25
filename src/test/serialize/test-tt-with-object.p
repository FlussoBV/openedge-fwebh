// test.p
using fwebh.serialize.*.
using test.serialize.*.

var longchar jsonString, jsonString2.
var PersonList pl.

pl = new PersonList().
pl:Fill().

jsonString = new SimpleJsonSerializer():SerializeToLongchar(pl).

delete object pl.
message string(jsonString).

//copy-lob jsonString to file "src/test/serialize/tt-with-obj.json".
copy-lob file "src/test/serialize/tt-with-obj2.json" to jsonString2.

pl = cast(new SimpleJsonDeserializer():DeserializeString(jsonString, "test.serialize.PersonList"), PersonList).
message "deserialized:~n" pl:ToString().
message "done" view-as alert-box.

