 
 /*------------------------------------------------------------------------
    File        : BadRequestException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Nov 24 11:50:22 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.

class fwebh.lang.error.BadRequestException inherits AppError: 

  constructor public BadRequestException (errorMessage as character):
    super (substitute("BadRequestException: &1", errorMessage), -1).
  end constructor.

end class.
