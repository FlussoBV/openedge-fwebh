 
 /*------------------------------------------------------------------------
    File        : SimpleJsonSerializer_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Apr 09 13:49:21 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using fwebh.serialize.SimpleJsonSerializer.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.StringStringMap.
using test.serialize.Address.
using test.serialize.ArrayObject.
using test.serialize.ListTest.
using test.serialize.ListTestAddress.
using test.serialize.StringStringMapTest.
using test.serialize.TempTableTest.

class fwebh.serialize.SimpleJsonSerializer_UT: 
  
  var private SimpleJsonSerializer serializer.
  
  @BeforeEach.
  method public void _BeforeEach():   
    serializer = new SimpleJsonSerializer().
  end method.
  
  @AfterEach.
  method public void _AfterEach():   
    delete object serializer no-error.
  end method.
  
  @Test.
  method public void instantiate_serializer():
    Assert:NotUnknown(serializer).
  end method.
  
  @Test.
  method public void serialized_address_equal_to_template():
    var Address addr = getAddress().
    var longchar addrString, originalString.
    addrString = serializer:SerializeToLongchar(addr, false).
    copy-lob file "src/test/serialize/addr-string1.txt" to originalString.
    Assert:Equals(addrString, originalString).
  end method.
  
  @Test.
  method public void serialized_address_with_fqcn_equal_to_template():
    var Address addr = getAddress().
    var longchar str, originalString.
    str = serializer:SerializeToLongchar(addr, true).
    copy-lob file "src/test/serialize/addr-string2.txt" to originalString.
    Assert:Equals(str, originalString).
  end method.
  
  @Test.
  method public void test_address_equals_method():
    var Address addr1, addr2.
    addr1 = getAddress().
    addr2 = getAddress().
    Assert:Equals(addr1:Equals(addr2), true).
  end method.

  @Test.
  method public void serialized_arrayobj_equal_to_template():
    var longchar str, originalString.
    var ArrayObject ao = new ArrayObject().
    
    assign 
      ao:id = -1
      ao:ids[1] = 1 ao:ids[2] = 2 ao:ids[3] = 3 ao:ids[4] = 5
      ao:names[1] = "Luke" ao:names[2] = "Leia" ao:names[3] = "Han"
      .
    //message ao:names[2] view-as alert-box.
    str = serializer:SerializeToLongchar(ao, false).
    copy-lob file "src/test/serialize/arrayobj-string1.txt" to originalString.
    
    Assert:Equals(str, originalString).
    
  end method.    

  @Test.
  method public void serialize_temptable():
    
    var TempTableTest tst = new TempTableTest().
    var longchar str, originalString.
    
    tst:AddEntry("Isaac", "Newton").
    tst:AddEntry("Albert", "Einstein").
    
    str = serializer:SerializeToLongchar(tst, false).
    copy-lob file "src/test/serialize/tt-string1.txt" to originalString.
    
    Assert:Equals(str, originalString).
    
  end method.
  

  @Test.
  method public void serialize_openedge_string_list():
    
    var ListTest tst = new ListTest().
    var longchar str, originalString.
    
    tst:AddEntry("Newton").
    tst:AddEntry("Einstein").
    
    str = serializer:SerializeToLongchar(tst, false).
    copy-lob file "src/test/serialize/list-string1.txt" to originalString.
    
    Assert:Equals(str, originalString).
    
  end method.

  @Test.
  method public void serialize_openedge_object_list():
    
    var ListTestAddress tst = new ListTestAddress().
    var Address addr.
    var longchar str, originalString.
    
    tst:Add(getAddress()).
    addr = getAddress().
    addr:Street = "Flusso".
    addr:HouseNumber = 126.
    tst:Add(addr).
    
    str = serializer:SerializeToLongchar(tst, false).
    copy-lob file "src/test/serialize/list-address1.txt" to originalString.
    
    Assert:Equals(str, originalString).
    
  end method.
  
  
  @Test.
  method public void utf_char_serialization():
    
    var ListTest lst = new ListTest().
    var longchar str, originalString.
    
    lst:AddEntry("euro: €").
    lst:AddEntry("empty collection: Ø").
    lst:AddEntry("αβγδ").
    
    str = serializer:SerializeToLongchar(lst, false).
    copy-lob file "src/test/serialize/list-utf-chars.txt" to originalString.
    
    Assert:Equals(str, originalString).
    
  end method.
  
  @Test.
  method public void serialize_stringstringmap():
    
    var longchar str, originalString.
    var StringStringMapTest tst = new StringStringMapTest().
    
    tst:pairs = new StringStringMap().
    tst:pairs:Put("key1", "value1").
    tst:pairs:Put("key2", "value2").
    copy-lob file "src/test/serialize/map-string1.txt" to originalString.
    
    str = serializer:SerializeToLongchar(tst, false).
    
    Assert:Equals(string(originalString), string(str)).
    
  end method.
  
  // NOTE: duplicate of same method in SimpleJsonDeserializer_UT
  method private Address getAddress():
    
    var Address addr = new Address().
    
    addr:Street = "Hamersveldseweg".
    addr:HouseNumber = 125.
    addr:Postcode = "3833 GV".
    addr:Municipale = "Leusden".
    
    return addr.
        
  end method.
  
end class.
