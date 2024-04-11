
using test.serialize.Address.
using fwebh.serialize.SimpleJsonSerializer.

var longchar addrString.
var Address addr = new Address().
addr:Street = "Hamersveldseweg".
addr:HouseNumber = 125.
addr:Postcode = "3833 GV".
addr:Municipale = "Leusden".

addrString = (new SimpleJsonSerializer()):SerializeToLongchar(addr, true).
copy-lob addrString to file "src/test/serialize/addr-string2.txt".

