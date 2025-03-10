 
 /*------------------------------------------------------------------------
    File        : ProPathHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue Apr 23 11:56:11 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class fwebh.core.ProPathHelper: 

  method public static void AddFirstEntry(dir as char):
    propath = dir + "," + propath.
  end method.
  
  method public static void RemoveFirstEntry():
    propath = substring(propath, index(propath, ",") + 1).
  end method.

end class.