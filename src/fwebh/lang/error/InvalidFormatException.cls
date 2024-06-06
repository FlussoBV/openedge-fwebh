 
 /*------------------------------------------------------------------------
    File        : InvalidFormatException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Mar 22 12:17:16 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.

class fwebh.lang.error.InvalidFormatException inherits AppError: 

  constructor public InvalidFormatException (formattedValue as character):
    super (substitute("InvalidFormatException: &1", formattedValue), -1).
  end constructor.

end class.
