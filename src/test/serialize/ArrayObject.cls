 
 /*------------------------------------------------------------------------
    File        : ArrayObject
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sun Jun 27 13:35:43 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

class test.serialize.ArrayObject: 
  
  define public property id as integer no-undo get. set.
  define public property ids as integer extent initial [1, 2, 3, 5] get. set.
  define public property names as character extent initial ["Luke", "Leia", "Han"] no-undo get. set.
  
end class.