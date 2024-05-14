 /*------------------------------------------------------------------------
    File        : DefaultUnitTest_UT
    Purpose     : If there are no unittests at all the unittest step in 
                  the pipeline fails. Although this class is not needed
                  anymore we leave it.
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sat Mar 23 15:04:14 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.

class fwebh.misc.DefaultUnitTest_UT: 

  @Test.
  method public void needed_as_only_unittest():
    Assert:Equals(true, true).
  end method.

end class.
