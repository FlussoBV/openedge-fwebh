
/*------------------------------------------------------------------------
    File        : IRequestData
    Purpose     : 
    Syntax      : 
    Description : This interface describes which the 
    Author(s)   : bronco
    Created     : Thu Mar 14 14:49:23 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/


using OpenEdge.Core.Collections.IStringStringMap.
using fwebh.pas.data.IDataHolder.
using fwebh.pas.resource.ResourceDescriptor.

@DefaultImplementation(class="fwebh.pas.data.RequestData").
interface fwebh.pas.data.IRequestData:  
  
  define public property Resource as ResourceDescriptor no-undo get. set.
  define public property ContentType as char no-undo get. set.
  define public property Accept as char no-undo get. set.
  define public property Verb as char no-undo get. set.
  define public property Version as char no-undo get. set.
  define public property Parameters as IStringStringMap no-undo get. set.
  define public property Headers as IStringStringMap no-undo get. set.
  define public property Data as IDataHolder no-undo get. 
  
end interface.
