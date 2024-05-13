 /*------------------------------------------------------------------------
    File        : EntityWriterFactory_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue Apr 23 11:31:38 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.core.ProPathHelper.
using fwebh.pas.data.EntityWriterFactory.
using fwebh.pas.data.IEntityWriter.
using OpenEdge.Core.Assert.

block-level on error undo, throw.

class fwebh.pas.data.EntityWriterFactory_UT: 
  
  var EntityWriterFactory factory.  

  @Setup.
  method public void _setup_each_test():
    factory = new EntityWriterFactory().
  end method.
  
  @Test.
  method public void application_json_returns_correct_writer():
    var IEntityWriter entityWriter.
    entityWriter = factory:GetEntityWriter("application/json").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.JsonEntityWriter").
  end method.

  @Test.
  method public void application_asterisk_returns_correct_writer():
    var IEntityWriter entityWriter.
    entityWriter = factory:GetEntityWriter("application/*").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.BinaryEntityWriter").
  end method.

  @Test.
  method public void text_xml_returns_correct_writer():
    var IEntityWriter entityWriter.
    entityWriter = factory:GetEntityWriter("text/xml").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.XmlEntityWriter").
  end method.

  @Test.
  method public void image_png_returns_correct_writer():
    var IEntityWriter entityWriter.
    entityWriter = factory:GetEntityWriter("image/png").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.BinaryEntityWriter").
  end method.

  @Test.
  method public void image_asterisk_returns_correct_writer():
    var IEntityWriter entityWriter.
    entityWriter = factory:GetEntityWriter("image/*").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.BinaryEntityWriter").
  end method.

  @Test.
  method public void application_pdf_returns_correct_writer():
    var IEntityWriter entityWriter.
    entityWriter = factory:GetEntityWriter("application/pdf").
    Assert:Equals(entityWriter:GetClass():TypeName, "fwebh.pas.data.BinaryEntityWriter").
  end method.

  @Test(expected="fwebh.lang.error.NotAcceptableException").
  method public void dummy_fails():
    var IEntityWriter entityWriter.
    entityWriter = factory:GetEntityWriter("dummy").
  end method.

  @Test(expected="Progress.Json.JsonParserError ").
  method public void corrupt_json_fails_load_definitions():
    var EntityWriterFactory factory.  
    var IEntityWriter entityWriter.

    ProPathHelper:addFirstEntry("src/test/pas/data/corrupt").
    factory = new EntityWriterFactory().

    finally:
      ProPathHelper:removeFirstEntry().
    end finally.
  end method.

  @Test(expected="Progress.Json.JsonError ").
  method public void invalid_json_fails_load_definitions():
    var EntityWriterFactory factory.  
    var IEntityWriter entityWriter.
    
    ProPathHelper:addFirstEntry("src/test/pas/data/invalid").
    factory = new EntityWriterFactory().

    finally:
      ProPathHelper:removeFirstEntry().
    end finally.
  end method.

end class.
