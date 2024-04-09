
/*------------------------------------------------------------------------
    File        : IPutDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 21 10:59:53 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.pas.data.IResponseData.
using fwebh.pas.data.IRequestData.

interface fwebh.pas.service.IPutDataService:  

  method public IResponseData PutData(request as IRequestData).
  
end interface.
