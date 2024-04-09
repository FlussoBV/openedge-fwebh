
 /*------------------------------------------------------------------------
    File        : Route
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Tue Mar 26 07:42:18 +01:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class okelib.pas.router.Route:

  define public property Resource as char no-undo get. private set.
  define public property Id as char no-undo get. set.
  

  constructor public Route():
              
  end constructor.

end class.  // Route
