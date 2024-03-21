
/*------------------------------------------------------------------------
    File        : IGetDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 14 14:25:32 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using okelib.pas.data.IResponseData.
using okelib.pas.data.IRequestData.

interface okelib.pas.service.IGetDataService:  
  
  method public IResponseData GetData(request as IRequestData).
  
end interface.
