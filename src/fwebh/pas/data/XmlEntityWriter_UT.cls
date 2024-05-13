 /*------------------------------------------------------------------------
    File        : XmlEntityWriter_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue May 07 14:00:15 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.pas.data.XmlEntityWriter.
using fwebh.pas.data.ResponseData.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.Assert.
using OpenEdge.Core.String.
using Progress.Lang.Object.

block-level on error undo, throw.

class fwebh.pas.data.XmlEntityWriter_UT: 
  
  define temp-table tt no-undo
    field f as char.
  define dataset ds for tt.
  
  var XmlEntityWriter writer.
  var ResponseData response.

  @Before.
  method public void _before_all_tests():
    create tt.
    tt.f = "test".
  end method.
  
  @Setup.
  method public void _setup_each_test():
    writer = new XmlEntityWriter().
    response = new ResponseData().
  end method.
  
  @Test(expected="Progress.Lang.AppError").
  method public void memptr_fails_write(  ):
    var memptr mem.
    
    set-size(mem) = 1.
    response:Data:Memptr = mem.
    writer:Write(response).

    finally:
      set-size(mem) = 0.  
    end finally.
  end method.  

  @Test.
  method public void set_buffer_correct_write(  ):
    var Object obj.
    
    find tt.
    response:Data:BufferHandle = buffer tt:handle.
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(String)).

  end method.  
  
  @Test.
  method public void set_buffer_correct_compare(  ):
    var Object obj.
    var longchar data.
    
    find tt.
    response:Data:BufferHandle = buffer tt:handle.
    obj = writer:Write(response).
    buffer tt:serialize-row("xml",
                            "longchar",
                            data,
                            false, // formatted
                            ?, // encoding
                            false // omit-initial-values
                            ).
    Assert:Equals(cast(obj, String):Value, data).

  end method.  

  @Test.
  method public void set_dataset_correct_write(  ):
    var Object obj.
    
    response:Data:DatasetHandle = dataset ds:handle.
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(String)).

  end method.  
  
  @Test.
  method public void set_dataset_correct_compare(  ):
    var Object obj.
    var longchar data.
    
    response:Data:DatasetHandle = dataset ds:handle.
    obj = writer:Write(response).
    dataset ds:write-xml ( "longchar",
                            data,
                            false, // formatted
                            ? // encoding
                          ).
    Assert:Equals(cast(obj, String):Value, data).

  end method.  

  @Test.
  method public void set_temp_table_correct_write(  ):
    var Object obj.
    
    response:Data:TempTableHandle = temp-table tt:handle.
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(String)).

  end method.  
  
  @Test.
  method public void set_temp_table_correct_compare(  ):
    var Object obj.
    var longchar data.
    
    response:Data:TempTableHandle = temp-table tt:handle.
    obj = writer:Write(response).
    temp-table tt:write-xml( "longchar",
                            data,
                            false, // formatted
                            ? // encoding
                            ).
    Assert:Equals(cast(obj, String):Value, data).

  end method.  

end class.
