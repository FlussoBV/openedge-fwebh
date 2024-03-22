 
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

using okelib.pas.data.IRequestData.

class okelib.pas.data.RequestData implements IRequestData: 
  
  define public property MimeType as char no-undo get. set.
  
  constructor public RequestData():
    
  end constructor.

end class.
