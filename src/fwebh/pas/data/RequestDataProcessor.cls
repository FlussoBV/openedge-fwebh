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

using fwebh.net.UrlHelper.
using fwebh.pas.data.IDataHolder.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.RequestData.
using fwebh.pas.data.RequestDataProcessor.
using fwebh.pas.data.ResponseDataType.
using fwebh.pas.resource.ResourceDescriptor.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Web.IWebRequest.
using Progress.Json.ObjectModel.JsonConstruct.

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
    
    if valid-object(request:Entity) then 
      processBody(request, data).
      
    return data.
    
  end method.  // ProcessRequest

  
  method private void processBody(request as IWebRequest, data as RequestData):
    
    var char type.
    var handle h.
    
    type = request:Entity:GetClass():TypeName.
    
    case type:
      
      when "Progress.Json.ObjectModel.JsonObject" or when "Progress.Json.ObjectModel.JsonArray" then
        data:Data:Json = cast(request:Entity, Progress.Json.ObjectModel.JsonConstruct).
        
      when "OpenEdge.Core.Memptr" then
        processMemptr(cast(request:Entity, OpenEdge.Core.Memptr), 
                      request:ContentType, 
                      data:Data).
      
      when "OpenEdge.Core.WidgetHandle" then do:
        h = cast(request:Entity, OpenEdge.Core.WidgetHandle):Value.
        data:Data:GenericHandle = h.  // with the tmp var h it might crash
      end.
        
    end case.

  end method.  // processBody
  

  // see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type
  // Content-Type: text/html; charset=utf-8
  // Content-Type: multipart/form-data; boundary=something
  method private void processMemptr(entity as OpenEdge.Core.Memptr, contentType as character, data as IDataHolder):

    var char mimeType, charset = "utf-8".  // assume utf-8.
    
    mimeType = trim(entry(1, contentType, ";")).
    
    case mimeType:
      
      when "text/plain" then do:
          
        if num-entries(contentType, ";") = 2 and trim(entry(2, contentType, ";")) begins "charset=" then
          charset = trim(entry(2, entry(2, contentType, ";"), "=")).
    
        // no codepage convert, consumer must use get-codepage function and handle it accordingly 
        fix-codepage(data:PlainText) = charset.
        copy-lob from entity:Value to data:PlainText. 
        
      end.
        
      otherwise 
        data:Memptr = entity:Value.
          
    end case.

  end method. // processMemptr


  method private ResourceDescriptor getResourceInfo(request as IWebRequest):
    
    var ResourceDescriptor resource = new ResourceDescriptor(request:GetPathParameter("resource")).

    resource:Id = getPathParameter(request, "id").    
    resource:ParentName = getPathParameter(request, "parentResource").
    resource:ParentId = getPathParameter(request, "parentId").
    resource:Version = getPathParameter(request, "version").

    return resource.
    
  end method.  // getResourceInfo

  method private logical hasPathParameter(request as IWebRequest, name as character):
    return lookup(name, request:PathParameterNames) > 0.
  end method.  

  method private char getPathParameter(request as IWebRequest, pathParameter as char):
    
    var char parameterValue = ?.
    
    if hasPathParameter(request, pathParameter) then 
      parameterValue = request:GetPathParameter(pathParameter).
    
    return parameterValue.
    
  end method.  // getPathParameter
  
  method private char getContextValue(request as IWebRequest, name as character):
    var char contentType = request:GetContextValue(name).
    if (contentType = "") then
      contentType = ?.
    return contentType.
  end method.
  
  method private IStringStringMap extractQueryParameters(request as IWebRequest):

    return request:URI:GetQueryMap().

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
