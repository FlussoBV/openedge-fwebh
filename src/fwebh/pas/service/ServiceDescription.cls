 
 /*------------------------------------------------------------------------
    File        : ServiceDescription
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Apr 12 10:53:24 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class fwebh.pas.service.ServiceDescription: 
  
  define public property classname as char no-undo get. set.
  define public property singleton as logical no-undo get. set.  
  
end class.