 
 /*------------------------------------------------------------------------
    File        : InvalidDataException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon May 16 11:03:58 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.

class fwebh.lang.error.InvalidDataException inherits AppError: 

  constructor public InvalidDataException (errorMessage as character):
    super (substitute("InvalidDataException: &1", errorMessage), -1).
  end constructor.

end class.