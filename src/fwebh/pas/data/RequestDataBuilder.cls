 
 /*------------------------------------------------------------------------
    File        : RequestDataBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Mar 22 08:47:18 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.pas.data.IRequestData.
using fwebh.pas.data.RequestData.
using fwebh.pas.data.RequestDataBuilder.
using OpenEdge.Web.IWebRequest.

class fwebh.pas.data.RequestDataBuilder: 
  
  var private IRequestData rd.
  
  define public property RequestData as IRequestData 
    get():
      return rd.
    end.
    
  constructor private RequestDataBuilder():
    rd = new RequestData().
  end.
  
  method public static RequestDataBuilder Get(req as IWebRequest):
    return new RequestDataBuilder().
  end method.  // Get
  
end class.