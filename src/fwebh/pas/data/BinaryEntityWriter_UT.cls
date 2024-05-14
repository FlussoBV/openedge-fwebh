 /*------------------------------------------------------------------------
    File        : BinaryEntityWriter_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue May 07 09:48:43 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.pas.data.BinaryEntityWriter.
using fwebh.pas.data.ResponseData.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.Memptr.
using Progress.Lang.Object.

class fwebh.pas.data.BinaryEntityWriter_UT: 
  
  var BinaryEntityWriter writer.
  var ResponseData response.

  @BeforeEach.
  method public void _BeforeEach():
    writer = new BinaryEntityWriter().
    response = new ResponseData().
  end method.

  @Test.
  method public void set_memptr_correct_write(  ):
    var memptr mem.
    var Object obj.
    
    set-size(mem) = 1.
    response:Data:Memptr = mem.
    obj = writer:Write(response).
    
    AssertObject:IsType(obj, get-class(Memptr)).

    finally:
      set-size(mem) = 0.
    end finally.
  end method.  

  @Test.
  method public void write_memptr_correct_size(  ):
    var memptr mem.
    var Object obj.
    
    set-size(mem) = 12.
    response:Data:Memptr = mem.
    obj = writer:Write(response).
    
    Assert:Equals(cast(obj, Memptr):Size, 12).

    finally:
      set-size(mem) = 0.
    end finally.
  end method.  

  @Test(expected="Progress.Lang.AppError").
  method public void set_datasethandle_fails_write(  ):

    response:Data:DataSetHandle = ?.
    writer:Write(response).

  end method.  

end class.
