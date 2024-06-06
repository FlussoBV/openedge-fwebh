 
 /*------------------------------------------------------------------------
    File        : RequestData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Mar 22 09:18:43 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.pas.data.DataHolder.
using fwebh.pas.data.IDataHolder.
using fwebh.pas.data.IRequestData.
using fwebh.pas.resource.ResourceDescriptor.
using OpenEdge.Core.Collections.IStringStringMap.

class fwebh.pas.data.RequestData implements IRequestData: 
  
  define public property Resource as ResourceDescriptor no-undo get. set.
  define public property ContentType as char no-undo get. set.
  define public property Accept as char no-undo get. set.
  define public property Verb as char no-undo get. set.
  define public property Version as char no-undo get. set.
  define public property Parameters as IStringStringMap no-undo get. set.
  define public property Headers as IStringStringMap no-undo get. set.
  
  // lazy instantiate, GET requests do not have data (=body)
  define public property Data as IDataHolder no-undo 
    get():
      if not valid-object(Data) then 
        Data = new DataHolder().
      return Data.
    end. 
    private set.
  
end class.
