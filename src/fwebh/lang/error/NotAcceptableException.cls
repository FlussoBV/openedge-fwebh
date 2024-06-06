 
 /*------------------------------------------------------------------------
    File        : NotAcceptableException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon May 06 16:01:58 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError. 
  
class fwebh.lang.error.NotAcceptableException inherits AppError: 
  
  constructor public NotAcceptableException (errorMessage as character):
    super (substitute("Not Acceptable: &1", errorMessage), -1).
  end constructor.
  
end class.
