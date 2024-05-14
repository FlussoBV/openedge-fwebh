 
 /*------------------------------------------------------------------------
    File        : EchoPostData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue May 07 13:53:27 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class fwebh.pas.service.system.EchoPostData: 
  
  // properties although public in lowercase because of incoming JSON 
  
  define public property id as int64 no-undo get. set.
  define public property client as char no-undo get. set.
  define public property version as char no-undo get. set.
  
end class.