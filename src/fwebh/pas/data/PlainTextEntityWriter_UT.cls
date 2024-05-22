 /*------------------------------------------------------------------------
    File        : PlainTextEntityWriter_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue May 14 14:56:27 CEST 2024
    Notes       : FIrst some codepage tests. These will fail if cpstream 
                  is not utf8.
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.pas.data.PlainTextEntityWriter.
using fwebh.pas.data.ResponseData.
using fwebh.pas.data.IEntityWriter.
using OpenEdge.Core.Assert.

class fwebh.pas.data.PlainTextEntityWriter_UT: 
  
  var IEntityWriter writer.
  var ResponseData response.

  @BeforeEach.
  method public void _BeforeEach():
    writer = new PlainTextEntityWriter().
    response = new ResponseData().
  end method.
  
  // first two tests for character encoding, maybe this should be put somewhere else
  @Test.
  method public void utf8_chars_loaded_correctly_to_longchar():
    
    var longchar str.
    
    copy-lob file "src/test/pas/data/utf8_plain-text.txt" to str.  // utf8 is assume cpinternal, cpstream
    
    Assert:Equals(str, "äëïöü").
    
  end method.

  @Test.
  method public void win1252_chars_loaded_correctly_to_longchar():
    
    var longchar str.
    
    copy-lob file "src/test/pas/data/1252_plain-text.txt" to str convert source codepage "1252".
    
    Assert:Equals(str, "äëïöü").
    
  end method.
  
  @Test.
  method private void writer_correctly_handles_utf8_input():
    
    var longchar str.
    copy-lob file "src/test/pas/data/utf8_plain-text.txt" to str.
        
  end.  
  
end class.
