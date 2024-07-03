 
 /*------------------------------------------------------------------------
    File        : UnauthorizedException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Jul 03 13:33:59 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using Progress.Lang.AppError.

class fwebh.lang.error.UnauthorizedException inherits AppError: 

  constructor public UnauthorizedException(errorMessage as character):
    super (substitute("UnauthorizedException: &1", errorMessage), -1).
  end.

end class.
