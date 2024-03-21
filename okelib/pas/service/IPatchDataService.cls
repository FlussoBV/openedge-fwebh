
/*------------------------------------------------------------------------
    File        : IPatchDataService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Mar 21 10:57:42 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using okelib.pas.data.IResponseData.
using okelib.pas.data.IRequestData.

interface okelib.pas.service.IPatchDataService:  
  
  method public IResponseData PatchData(request as IRequestData).
  
end interface.
