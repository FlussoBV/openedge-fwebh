 
 /*------------------------------------------------------------------------
    File        : NotImplementedException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Apr 12 13:31:19 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.

class fwebh.lang.error.NotImplementedException inherits AppError: 
  
  constructor public NotImplementedException(errorMessage as character):
    super (substitute("NotImplementedException: &1", errorMessage), -1).
  end.
  
end class.
