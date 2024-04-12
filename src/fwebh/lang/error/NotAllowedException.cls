 
 /*------------------------------------------------------------------------
    File        : NotAllowedException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Apr 12 13:28:56 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.


class fwebh.lang.error.NotAllowedException inherits AppError: 

  constructor public NotAllowedException(errorMessage as character):
    super (substitute("NotAllowedException: &1", errorMessage), -1).
  end.

end class.
