
/*------------------------------------------------------------------------
    File        : IGetDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 14 14:25:32 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.pas.data.IResponseData.
using fwebh.pas.data.IRequestData.

interface fwebh.pas.service.IGetDataService:  
  
  method public IResponseData GetData(request as IRequestData).
  
end interface.
