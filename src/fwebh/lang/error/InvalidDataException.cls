 
 /*------------------------------------------------------------------------
    File        : InvalidDataException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon May 16 11:03:58 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Lang.AppError.

block-level on error undo, throw.

class fwebh.lang.error.InvalidDataException inherits AppError: 

  constructor public InvalidDataException (errorMessage as character):
    super (substitute("Invalid Data: &1", errorMessage), -1).
  end constructor.

end class.