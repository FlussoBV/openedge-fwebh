 /*------------------------------------------------------------------------
    File        : JsonEntityWriter_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue May 07 14:00:15 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using fwebh.pas.data.JsonEntityWriter.
using fwebh.pas.data.ResponseData.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.Assertion.AssertObject.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.Assert.
using Progress.Json.ObjectModel.JsonArray.

block-level on error undo, throw.

class fwebh.pas.data.JsonEntityWriter_UT: 
  
  define temp-table tt no-undo
    field f as char.
  define dataset ds for tt.
  
  var JsonEntityWriter writer.
  var ResponseData response.

  @Before.
  method public void _before_all_tests():
    create tt.
    tt.f = "test".
  end method.
  
  @Setup.
  method public void _setup_each_test():
    writer = new JsonEntityWriter().
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
    var Progress.Lang.Object obj.
    
    find tt.
    response:Data:BufferHandle = buffer tt:handle.
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(JsonObject)).

  end method.  
  
  @Test.
  method public void set_buffer_correct_compare(  ):
    var Progress.Lang.Object obj.
    var JsonObject data = new JsonObject().
    
    find tt.
    response:Data:BufferHandle = buffer tt:handle.
    obj = writer:Write(response).
    buffer tt:serialize-row("json",
                            "JsonObject",
                            data,
                            false, // formatted
                            ?, // encoding
                            false, // omit-initial-values
                            true // omit-outer-object
                          ).
    Assert:Equals(cast(obj,JsonObject):GetJsonText(), data:GetJsonText()).

  end method.  

  @Test.
  method public void set_dataset_correct_write(  ):
    var Progress.Lang.Object obj.
    
    response:Data:DatasetHandle = dataset ds:handle.
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(JsonObject)).

  end method.  
  
  @Test.
  method public void set_dataset_correct_compare(  ):
    var Progress.Lang.Object obj.
    var JsonObject data = new JsonObject().
    
    response:Data:DatasetHandle = dataset ds:handle.
    obj = writer:Write(response).
    dataset ds:write-json ( "JsonObject",
                            data,
                            false, // formatted
                            ?, // encoding
                            false, // omit-initial-values
                            true, // omit-outer-object
                            false // write-before-image
                          ).
    Assert:Equals(cast(obj,JsonObject):GetJsonText(), data:GetJsonText()).

  end method.  

  @Test.
  method public void set_json_object_correct_write(  ):
    var Progress.Lang.Object obj.
    
    response:Data:Json = new JsonObject().
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(JsonObject)).

  end method.  
  
  @Test.
  method public void set_json_object_correct_compare(  ):
    var Progress.Lang.Object obj.
    var JsonObject data = new JsonObject().
    
    data:Add("propertyName", "value").
    response:Data:Json = data.
    obj = writer:Write(response).
    
    Assert:Equals(cast(obj,JsonObject):GetJsonText(), data:GetJsonText()).

  end method.  

  @Test.
  method public void set_temp_table_correct_write(  ):
    var Progress.Lang.Object obj.
    
    response:Data:TempTableHandle = temp-table tt:handle.
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(JsonArray)).

  end method.  
  
  @Test.
  method public void set_temp_table_correct_compare(  ):
    var Progress.Lang.Object obj.
    var JsonArray data = new JsonArray().
    
    response:Data:TempTableHandle = temp-table tt:handle.
    obj = writer:Write(response).
    temp-table tt:write-json ( "JsonArray",
                            data,
                            false, // formatted
                            ?, // encoding
                            false, // omit-initial-values
                            true, // omit-outer-object
                            false // write-before-image
                          ).
    Assert:Equals(cast(obj,JsonArray):GetJsonText(), data:GetJsonText()).

  end method.  

end class.