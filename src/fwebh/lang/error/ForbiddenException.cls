 
 /*------------------------------------------------------------------------
    File        : ForbiddenException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Jul 03 13:38:50 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.

class fwebh.lang.error.ForbiddenException inherits AppError: 

  constructor public ForbiddenException(errorMessage as character):
    super (substitute("ForbiddenException: &1", errorMessage), -1).
  end.

end class.
