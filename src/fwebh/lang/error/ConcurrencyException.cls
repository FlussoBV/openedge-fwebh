 
 /*------------------------------------------------------------------------
    File        : ConcurrencyException
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Jun 26 09:08:39 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.


class fwebh.lang.error.ConcurrencyException inherits AppError:  

  constructor public ConcurrencyException (resource as character, id as int64):
    super (substitute("resource '&1' (id: &2) was changed by another user", resource, id), -1).
  end constructor.

end class.
