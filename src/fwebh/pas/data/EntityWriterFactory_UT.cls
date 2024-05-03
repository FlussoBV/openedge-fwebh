 /*------------------------------------------------------------------------
    File        : EntityWriterFactory_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue Apr 23 11:31:38 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using fwebh.pas.data.EntityWriterFactory.
using fwebh.pas.data.IEntityWriter.
using OpenEdge.Core.Assert.
using fwebh.core.ProPathHelper.

block-level on error undo, throw.

class fwebh.pas.data.EntityWriterFactory_UT: 
  
  var EntityWriterFactory factory.  

  @Before.
  method public void beforeStartAllTests():
    factory = new EntityWriterFactory().
  end method.
  
  @Setup.
  method public void beforeTest():   
  end method.
  
  @TearDown.
  method public void afterTest():   
  end method.
  
  @After.
  method public void afterStartAllTests():
  end method.
  
  @Test.
  method public void TestJsonEntityWriter():
    define variable entityWriter as IEntityWriter no-undo.
    entityWriter = factory:GetEntityWriter("application/json").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.JsonEntityWriter").
  end method.

  @Test.
  method public void TestXmlEntityWriter():
    define variable entityWriter as IEntityWriter no-undo.
    entityWriter = factory:GetEntityWriter("text/xml").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.XmlEntityWriter").
  end method.

  @Test.
  method public void TestBinaryEntityWriterForImage():
    define variable entityWriter as IEntityWriter no-undo.
    entityWriter = factory:GetEntityWriter("image/*").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.BinaryEntityWriter").
  end method.

  @Test.
  method public void TestBinaryEntityWriterForApplication():
    define variable entityWriter as IEntityWriter no-undo.
    entityWriter = factory:GetEntityWriter("application/*").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.BinaryEntityWriter").
  end method.

  @Test.
  method public void TestBinaryEntityWriterForPdf():
    define variable entityWriter as IEntityWriter no-undo.
    entityWriter = factory:GetEntityWriter("application/pdf").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.BinaryEntityWriter").
  end method.

  @Test(expected="fwebh.lang.error.NotFoundException").
  method public void TestFailureForDummy():
    define variable entityWriter as IEntityWriter no-undo.
    entityWriter = factory:GetEntityWriter("dummy").
  end method.

  @todo(what="extend loadDefinitions to validate input write fail loadDefinitions").
  // @Test(expected="fwebh.lang.error.NotFoundException").
  method public void TestFailureForLoadDefinitions():
    var EntityWriterFactory factory = new EntityWriterFactory().  
    var IEntityWriter entityWriter.
    
    ProPathHelper:addFirstEntry("src/test/pas/data").
    message search("entitywriter.json")
    view-as alert-box.
    entityWriter = factory:GetEntityWriter("dummy").
    finally:
      ProPathHelper:removeFirstEntry().
      delete object factory.
    end finally.
  end method.

end class.