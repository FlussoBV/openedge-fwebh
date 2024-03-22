 
 /*------------------------------------------------------------------------
    File        : BadRequestException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Nov 24 11:50:22 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.AppError.

block-level on error undo, throw.

class okelib.lang.error.BadRequestException inherits AppError: 

  constructor public BadRequestException (errorMessage as character):
    super (substitute("Bad request: &1", errorMessage), -1).
  end constructor.

end class.
