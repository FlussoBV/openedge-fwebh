 
 /*------------------------------------------------------------------------
    File        : RequestDataProcessor
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Mar 22 08:47:18 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Web.IWebRequest.
using OpenEdge.Core.Collections.StringStringMap.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.RequestData.
using fwebh.pas.data.RequestDataProcessor.
using fwebh.net.UrlHelper.
using fwebh.pas.resource.ResourceDescriptor.
using OpenEdge.Net.HTTP.HttpHeader.

class fwebh.pas.data.RequestDataProcessor: 
  
  method public IRequestData ProcessRequestInfo(request as IWebRequest):
    
    /* to do:
      - process route information into a ResourceDescriptor
    */
    
    var RequestData data = new RequestData().
    
    data:Resource = getResourceInfo(request).
    data:Verb = getContextValue(request, "REQUEST_METHOD").
    data:ContentType = getContextValue(request, "CONTENT_TYPE").
    data:Accept = getContextValue(request, "HTTP_ACCEPT").
    data:Version = request:GetPathParameter("version").
    data:Parameters = extractQueryParameters(request).  // StringStringMap is not yet supported by serializer
    data:Headers = extractHeaders(request).
    
    return data.
    
  end method.  // ProcessRequest
  
  method private ResourceDescriptor getResourceInfo(request as IWebRequest):
    
    var ResourceDescriptor resource = new ResourceDescriptor(request:GetPathParameter("resource")).

    if hasPathParameter(request, "id") then resource:Id = request:GetPathParameter("id").    
    if hasPathParameter(request, "parent-resource") then resource:ParentName = request:GetPathParameter("parent-resource").
    if hasPathParameter(request, "parent-id") then resource:ParentId = request:GetPathParameter("parent-id").

    return resource.
    
  end method.  // getResourceInfo

  method private logical hasPathParameter(request as IWebRequest, name as character):
    return lookup(name, request:PathParameterNames) > 0.
  end method.  

  method private char getContextValue(request as IWebRequest, name as character):
    var char contentType = request:GetContextValue(name).
    if (contentType = "") then
      contentType = ?.
    return contentType.
  end method.

  method private StringStringMap extractQueryParameters(request as IWebRequest):
    
    var char parameters, currentEntry, parameterName, parameterValue.
    var int i, parameterCount.
    var StringStringMap queryParameters. 
    
    queryParameters = new StringStringMap().
    parameters = request:GetContextValue("QUERY_STRING").
    
    parameterCount = num-entries(parameters, "&").
    do i = 1 to parameterCount:
      currentEntry = entry(i, parameters, "&").
      parameterName = entry(1, currentEntry, "=").
      parameterValue = UrlHelper:Decode(entry(2, currentEntry, "=")).
      queryParameters:Put(parameterName, parameterValue).
    end.
    
    return queryParameters.
    
  end method.  // extractQueryParameters
  
  method private StringStringMap extractHeaders(request as IWebRequest):
    
    var StringStringMap headers.
    var HttpHeader[] httpHeaders.  //, currentHeader.
    var HttpHeader currentHeader.
    var int i, headerCount.
    
    headers = new StringStringMap().
    
    headerCount = request:GetHeaders(httpHeaders).
    do i = 1 to headerCount:
      currentHeader = httpHeaders[i].
      headers:Put(normalizeHeaderName(currentHeader:Name), currentHeader:Value).
    end.
    
    return headers.
    
  end method.  // extractHeaders 

  /*------------------------------------------------------------------------------
  Purpose: Normalizes context names from the (web) context to header names. For example
           f("CONTENT_TYPE") = "ContentType"
  Notes:
  @param the header name
  @return char normalized header name
  ------------------------------------------------------------------------------*/
  method private character normalizeHeaderName(headerName as character):
    
    var logical nextCharUpper.
    var char resultString, currentChar.
    var int i, headerNameLength.
    
    headerNameLength = length(headerName).
    nextCharUpper = true.
    do i = 1 to headerNameLength:
      
      currentChar = substring(headerName, i, 1).

      if (nextCharUpper) then do:
        resultString += caps(currentChar).
        nextCharUpper = false.
        next.
      end.  
      
      if (currentChar = '_') then
        currentChar = '-'.
      
      if (currentChar = '-') then
        nextCharUpper = true.        
      
      resultString += lc(currentChar).
      
    end.
    
    return resultString.
    
  end method.  // normalizeHeaderName
    
end class.
