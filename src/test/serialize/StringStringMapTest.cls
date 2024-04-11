 
 /*------------------------------------------------------------------------
    File        : StringStrinMapTest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Apr 11 15:53:32 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Collections.StringStringMap.

class test.serialize.StringStringMapTest: 
  
  define public property pairs as StringStringMap no-undo get. set.
  
end class.
