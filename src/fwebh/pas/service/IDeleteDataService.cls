
/*------------------------------------------------------------------------
    File        : IDeleteDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 21 10:56:01 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.pas.data.IResponseData.
using fwebh.pas.data.IRequestData.

interface fwebh.pas.service.IDeleteDataService:  
  
  method public IResponseData DeleteData(request as IRequestData).
  
end interface.
