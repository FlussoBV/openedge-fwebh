 
 /*------------------------------------------------------------------------
    File        : SimpleJsonDeserializer_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Apr 10 08:56:15 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.serialize.SimpleJsonDeserializer.
using OpenEdge.Core.Assert.
using OpenEdge.Core.String.
using test.serialize.Address.
using test.serialize.ArrayObject.
using test.serialize.ListTest.
using test.serialize.ListTestAddress.
using test.serialize.StringStringMapTest.
using test.serialize.TempTableTest.

class fwebh.serialize.SimpleJsonDeserializer_UT: 
  
  var private SimpleJsonDeserializer deserializer.
  
  @BeforeEach.
  method public void _BeforeEach():   
    deserializer = new SimpleJsonDeserializer().
  end method.
  
  @AfterEach.
  method public void _AfterEach():   
    delete object deserializer no-error.
  end method.
  
  @Test.
  method public void instantiate_deserializer():
    Assert:NotUnknown(deserializer).
  end method.
  
  // because of the underlying structure both DeserializeFile and Deserialize methods are tested
  @Test.
  method public void deserialize_address():
    
    var Address addr1, addr2.
    
    addr1 = cast(
      deserializer:DeserializeFile("src/test/serialize/addr-string1.txt", "test.serialize.Address"),
      "test.serialize.Address"
    ).
    addr2 = getAddress().
    
    Assert:Equals(addr1, addr2).
    
  end method.
  
  @Test.
  method public void deserialize_address_string():
    
    var Address addr1, addr2.
    var longchar str.
    
    copy-lob file "src/test/serialize/addr-string1.txt" to str.
    addr1 = cast(
      deserializer:DeserializeString(str, "test.serialize.Address"),
      "test.serialize.Address"
    ).
    addr2 = getAddress().
    
    Assert:Equals(addr1, addr2).
    
  end method.
  
  
  @Test.
  method public void deserialize_openedge_string_list():
    
    var ListTest tst.
    var longchar str, originalString.
    
    tst = cast(
      deserializer:DeserializeFile("src/test/serialize/list-string1.txt", "test.serialize.ListTest"),
      "test.serialize.ListTest"
    ).
    
    Assert:Equals(2, tst:entries:Size).
    Assert:Equals(new String("Einstein"), tst:entries:Get(2)).
    
  end method.

  @Test.
  method public void deserialize_address_list():
    
    var ListTestAddress tst.
    var longchar str, originalString.
    
    tst = cast(
      deserializer:DeserializeFile("src/test/serialize/list-address1.txt", "test.serialize.ListTestAddress"),
      "test.serialize.ListTestAddress"
    ).
    
    Assert:Equals(2, tst:addresses:Size).
    Assert:Equals(126, cast(tst:addresses:Get(2), "test.serialize.Address"):HouseNumber).
    
  end method.

  @Test.
  method public void deserialize_temptable():
    
    var TempTableTest tst.
    var longchar str, originalString.
    
    tst = cast(
      deserializer:DeserializeFile("src/test/serialize/tt-string1.txt", "test.serialize.TempTableTest"),
      "test.serialize.TempTableTest"
    ).
    
    Assert:Equals(2, tst:CountRecords()).
    Assert:Equals("Einstein", tst:GetLastName("Albert")).
    
  end method.

  @Test.
  method public void deserialize_array_in_object():
    var ArrayObject ao.
      
    ao = cast(
      deserializer:DeserializeFile("src/test/serialize/arrayobj-string1.txt", "test.serialize.ArrayObject"),
      "test.serialize.ArrayObject"
    ).
    
    Assert:Equals(5, ao:ids[4]).
    
  end method. 
  
  @Test.
  method public void deserialize_stringstringmap():
    
    var StringStringMapTest tst.
    
    tst = cast(
      deserializer:DeserializeFile("src/test/serialize/map-string1.txt", "test.serialize.StringStringMapTest"),
      "test.serialize.StringStringMapTest"
    ).  
    
    Assert:Equals("value2", tst:pairs:Get("key2")).
    
  end method.
 
  // NOTE: duplicate of same method in SimpleJsonSerializer_UT   
  method private Address getAddress():
    
    var Address addr = new Address().
    
    addr:Street = "Hamersveldseweg".
    addr:HouseNumber = 125.
    addr:Postcode = "3833 GV".
    addr:Municipale = "Leusden".
    
    return addr.
        
  end method.
  
end class.
