 
 /*------------------------------------------------------------------------
    File        : TempTableService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon May 06 13:35:26 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.pas.service.IGetDataService.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.

class fwebh.pas.service.example.TempTableService implements fwebh.pas.service.IGetDataService, fwebh.pas.data.IDefaultContentType: 
  
  define protected temp-table tt no-undo
    serialize-name "test"
    field id as int
    field testvalue as char
    .
  
  constructor public TempTableService():
    fillTT().  
  end.
  
  method public IResponseData GetData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
        
    response:Data:TempTableHandle = temp-table tt:handle.
    
    return response.
    
  end method.  // GetData
  
  method private void fillTT():
    
    create tt.
    tt.id = 1. tt.testvalue = "c1".
    
    create tt.
    tt.id = 2. tt.testvalue = "c2".

  end method.

  method public char GetDefaultContentType():
    return "text/xml".
  end method.
  
end class.
