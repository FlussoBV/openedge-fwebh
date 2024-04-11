 
 /*------------------------------------------------------------------------
    File        : WebHandlerCommon
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Mar 05 11:19:17 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.WebHandler.
using OpenEdge.Web.WebResponse.
using OpenEdge.Web.WebResponseWriter.


class fwebh.pas.webhandlers.WebHandlerCommon inherits WebHandler: 

  define protected property QueryParameters as StringStringMap get. private set.
    
  method protected StringStringMap ExtractQueryParameters(request as IWebRequest):
    
    var char parameters, currentEntry, parameterName, parameterValue.
    var int i, parameterCount.
    var StringStringMap queryParameters. 
    
    queryParameters = new StringStringMap().
    parameters = request:GetContextValue("QUERY_STRING").
    
    parameterCount = num-entries(parameters, "&").
    do i = 1 to parameterCount:
      currentEntry = entry(i, parameters, "&").
      parameterName = entry(1, currentEntry, "=").
      parameterValue = this-object:urlDecode(entry(2, currentEntry, "=")).
      queryParameters:Put(parameterName, parameterValue).
    end.
    
    return queryParameters.
    
  end method.  // extractHttpInfo
  
  method override protected integer HandleGet(request as IWebRequest):
    QueryParameters = ExtractQueryParameters(request).
  end method.

  method protected void WriteResponse(response as IHttpResponse):
    var WebResponseWriter writer.
    writer = new WebResponseWriter(response).
    writer:Open().
    writer:Close().
  end method.  //WriteResponse

  method override protected integer HandleNotAllowedMethod(request as IWebRequest):

    var IHttpResponse response = new WebResponse().

    response:StatusCode = 405.
    response:Entity = new String("not allowed").
    writeResponse(response).

    return 0.

  end method.  // HandleNotAllowedMethod


  method override protected integer HandleNotImplemented(request as IWebRequest):
    
    var IHttpResponse response = new WebResponse().

    response:StatusCode = 501.
    response:Entity = new String("not implemented").
    writeResponse(response).

    return 0.

  end method.  // HandleNotImplemented

end class.
