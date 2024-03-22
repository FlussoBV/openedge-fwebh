 
 /*------------------------------------------------------------------------
    File        : InvalidFormatException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Mar 22 12:17:16 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.AppError.

block-level on error undo, throw.

class okelib.lang.error.InvalidFormatException inherits AppError: 

  constructor public InvalidFormatException (formattedValue as character):
    super (substitute("Invalid format: &1", formattedValue), -1).
  end constructor.

end class.
