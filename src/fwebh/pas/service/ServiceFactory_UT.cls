 
 /*------------------------------------------------------------------------
    File        : ServiceFactory_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Apr 12 10:56:12 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.
using fwebh.pas.service.ServiceFactory.


class fwebh.pas.service.ServiceFactory_UT: 
  
  var private ServiceFactory factory.
   
  @BeforeEach.
  method public void _BeforeEach():   
    factory = new ServiceFactory().
  end method.
  
  @AfterEach.
  method public void _AfterEach():   
    if (propath matches "*faulty*") then  // reset from faulty services.json in propath
      removeFirstPropathEntry().
    delete object factory no-error.
  end method.
  
  @BeforeAll.
  method public void _BeforeAll():
    addPropathEntry("./src/test/pas/service").  // make sure the unittest services.json is found 
  end method.
  
  @AfterAll.
  method public void _AfterAll():
    removeFirstPropathEntry().
  end method.
  
  @Test.
  method public void get_instance():
    Assert:NotNull(factory:GetGetDataService("sysinfo")).
  end method.
  
  @Test.
  method public void non_singleton_return_new_instances():
    var Progress.Lang.Object obj1, obj2.
    
    obj1 = factory:GetGetDataService("non-single").
    obj2 = factory:GetGetDataService("non-single").
   
    Assert:NotEqual(obj1, obj2).
  end.

  @Test.
  method public void singleton_return_same_instances():
    var Progress.Lang.Object obj1, obj2.
    
    obj1 = factory:GetGetDataService("single").
    obj2 = factory:GetGetDataService("single").
   
    Assert:Equals(obj1, obj2).
  end.

  @Test(expected="fwebh.lang.error.NotFoundException"). 
  method public void non_existent_classname_should_throw_error():   
    addPropathEntry("./src/test/pas/service/faulty").
    factory = new ServiceFactory().
  end method.

  @Test(expected="fwebh.lang.error.NotFoundException"). 
  method public void non_existent_indentifier_should_throw_error():   
    factory:GetGetDataService("i-do-not-exist").
  end method.

  @Test(expected="fwebh.lang.error.NotImplementedException").
  method public void service_with_DELETE_not_implemented_should_throw():
    factory:GetDeleteDataService("empty").  
  end.
  
  @Test(expected="fwebh.lang.error.NotImplementedException").
  method public void service_with_GET_not_implemented_should_throw():
    factory:GetGetDataService("empty").  
  end.
  
  @Test(expected="fwebh.lang.error.NotImplementedException").
  method public void service_with_PATCH_not_implemented_should_throw():
    factory:GetPatchDataService("empty").  
  end.
  
  @Test(expected="fwebh.lang.error.NotImplementedException").
  method public void service_with_POST_not_implemented_should_throw():
    factory:GetPostDataService("empty").  
  end.
  
  @Test(expected="fwebh.lang.error.NotImplementedException").
  method public void service_with_PUT_not_implemented_should_throw():
    factory:GetPutDataService("empty").  
  end.
  
  method private void addPropathEntry(dir as char):
    propath = dir + "," + propath.
  end method.
  
  method private void removeFirstPropathEntry():
    propath = substring(propath, index(propath, ",") + 1).
  end method.
  
end class.  // ServiceFactory_UT
