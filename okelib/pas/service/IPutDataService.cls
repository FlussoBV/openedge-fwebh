
/*------------------------------------------------------------------------
    File        : IPutDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 21 10:59:53 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using okelib.pas.data.IResponseData.
using okelib.pas.data.IRequestData.

interface okelib.pas.service.IPutDataService:  

  method public IResponseData PutData(request as IRequestData).
  
end interface.
