 /*------------------------------------------------------------------------
    File        : Factory_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sun Jan 29 15:11:44 CET 2023
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.core.Factory.
using fwebh.core.IFactory.
using OpenEdge.Core.Assert.
using Progress.Lang.Object.
using test.core.Configurable.


class fwebh.core.Factory_UT: 
  
  define private variable factory as IFactory no-undo.
  
  {fwebh/core/ttfactorydef.i}
  
  @BeforeEach.
  method public void _BeforeEach():
    factory = new Factory().
  end method.
  
  @AfterEach.
  method public void _AfterEach():
    if (valid-object(factory)) then
      delete object factory.
  end method.
  
   
  @Test.
  method public void load_correct_factory_definitions():
    
    factory:LoadDefinitions("test/core/test-factory.json").
    
  end method.

  @Test(expected="fwebh.lang.error.InvalidDataException").
  method public void load_errorneous_factory_definitions():
    
    factory:LoadDefinitions("test/core/test-factory-errorneous.json").
    
  end method.
  
  @Test(expected="Progress.Lang.AppError").
  method public void non_defined_returns_error():
    
    var Object inst1.
    
    factory:LoadDefinitions("test/core/test-factory.json").
    inst1 = {getinstance.i janedoe as Progress.Lang.Object from factory}.
    
  end method.

  @Test.
  method public void non_singleton_returns_new_instance():
    
    var Object inst1.
    var Object inst2.
    
    factory:LoadDefinitions("test/core/test-factory.json").
    
    inst1 = {getinstance.i johndoe as Progress.Lang.Object from factory}.
    inst2 = {getinstance.i johndoe as Progress.Lang.Object from factory}.
    
    Assert:NotEqual(inst1, inst2).
    
  end method.

  @Test.
  method public void singleton_returns_same_instance():
    
    var Factory inst1.
    var Factory inst2.
    
    factory:LoadDefinitions("test/core/test-factory.json").
    
    inst1 = {getinstance.i single as Factory from factory}.
    inst2 = {getinstance.i single as Factory from factory}.
    
    Assert:Equals(inst1, inst2).
    
  end method.

  @Test(expected="Progress.Lang.AppError").  // = standard error (14284)
  method public void class_not_found_returns_error():
    
    var Object inst1.
    
    factory:LoadDefinitions("test/core/test-factory.json").
    
    inst1 = {getinstance.i classnotfound as Progress.Lang.Object from factory}.

  end method.

  @Test(expected="fwebh.lang.error.NotFoundException").
  method public void defintions_not_found_returns_error():
    
    var Object inst1.
    
    factory:LoadDefinitions("test/core/test-factory.json").
    
    inst1 = {getinstance.i notdefined as Progress.Lang.Object from factory}.
        
  end method.
  
  @Test.
  method public void configuration_passed_to_object():
    
    var Configurable cfg.
    
    factory:LoadDefinitions("test/core/test-factory.json").
    cfg = {getinstance.i testconfig as Configurable from factory}.
    
    Assert:Equals("ok", cfg:Test).
    
  end method.
  
end class.
