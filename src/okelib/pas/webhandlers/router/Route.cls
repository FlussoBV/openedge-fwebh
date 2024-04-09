 
 /*------------------------------------------------------------------------
    File        : Route
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon Mar 25 13:00:59 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using okelib.pas.webhandlers.HTTPVerbsEnum.

class okelib.pas.webhandlers.router.Route: 
  
  define public property Resource as char no-undo get. set.
  define public property Verbs as HTTPVerbsEnum no-undo get. set.
  define public property TTL as int no-undo get. set.
  
end class.
