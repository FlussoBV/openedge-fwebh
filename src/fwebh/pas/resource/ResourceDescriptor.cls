 
 /*------------------------------------------------------------------------
    File        : ResourceDescriptor
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Apr 11 08:05:30 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class fwebh.pas.resource.ResourceDescriptor: 
  
  define public property Name as char no-undo get. set.
  define public property Id as char init ? no-undo get. set.
  define public property ParentName as char init ? no-undo get. set.
  define public property ParentId as char no-undo init ? get. set.
  
  constructor public ResourceDescriptor(resource as char):
    Name = resource.  
  end constructor.
  
end class.
