 
 /*------------------------------------------------------------------------
    File        : UnacceptableException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon May 06 16:01:58 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError. 

class fwebh.lang.error.UnacceptableException inherits AppError: 
  
  constructor public UnacceptableException (errorMessage as character):
    super (substitute("Unacceptable: &1", errorMessage), -1).
  end constructor.
  
end class.
