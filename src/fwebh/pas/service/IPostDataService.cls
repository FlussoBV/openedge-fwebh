
/*------------------------------------------------------------------------
    File        : IPostDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 21 10:59:09 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.pas.data.IResponseData.
using fwebh.pas.data.IRequestData.

interface fwebh.pas.service.IPostDataService:  
  
  method public IResponseData PostData(request as IRequestData).
  
end interface.
