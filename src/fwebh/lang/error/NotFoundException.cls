 
 /*------------------------------------------------------------------------
    File        : NotFoundException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Aug 23 11:42:22 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.

class fwebh.lang.error.NotFoundException inherits AppError: 
  
  constructor public NotFoundException(errorMessage as character):
    super("Not found", -1).
  end.
  
end class.
