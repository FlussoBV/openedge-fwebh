 
 /*------------------------------------------------------------------------
    File        : DefaultUnitTest_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sat Mar 23 15:04:14 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.

class okelib.misc.DefaultUnitTest_UT: 

  @Test.
  method public void this_is_the_first_unittest():
    Assert:Equals(true, true).
  end method.

end class.
