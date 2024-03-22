 
 /*------------------------------------------------------------------------
    File        : NotFoundException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Aug 23 11:42:22 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.AppError.

block-level on error undo, throw.

class okelib.lang.error.NotFoundException inherits AppError: 
  
  constructor public NotFoundException(errorMessage as character):
    super (substitute("&1", errorMessage), -1).
  end.
  
end class.
