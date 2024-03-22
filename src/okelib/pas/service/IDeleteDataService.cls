
/*------------------------------------------------------------------------
    File        : IDeleteDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 21 10:56:01 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using okelib.pas.data.IResponseData.
using okelib.pas.data.IRequestData.

interface okelib.pas.service.IDeleteDataService:  
  
  method public IResponseData DeleteData(request as IRequestData).
  
end interface.
