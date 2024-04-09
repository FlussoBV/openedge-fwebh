 
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

using fwebh.pas.data.IRequestData.

class fwebh.pas.data.RequestData implements IRequestData: 
  
  define public property MimeType as char no-undo get. set.
  
  constructor public RequestData():
    
  end constructor.

end class.
