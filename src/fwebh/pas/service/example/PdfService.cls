 
 /*------------------------------------------------------------------------
    File        : PdfService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon May 06 11:23:39 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/
  
block-level on error undo, throw.
  
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.
using fwebh.pas.service.IGetDataService.

class fwebh.pas.service.example.PdfService implements IGetDataService: 
  
  method public IResponseData GetData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
    var memptr pdfData.
    
    copy-lob file search("fwebh/pas/service/example/example.pdf") to pdfData.
    
    response:Data:Memptr = pdfData.    
    response:ContentType = "application/pdf".
    
    return response.
    
    finally:
      set-size(pdfData) = 0.
    end.
           
  end method.  // GetData

end class.
