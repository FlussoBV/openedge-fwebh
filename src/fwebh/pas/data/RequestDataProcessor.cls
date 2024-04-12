 
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

class fwebh.pas.data.RequestDataProcessor: 
  
  method public IRequestData ProcessRequestInfo(request as IWebRequest):
    
    /* to do:
      - process route information into a ResourceDescriptor
    */
    
    var RequestData data = new RequestData().
    
    data:Resource = getResourceInfo(request).
    data:Verb = getContextValue(request, "REQUEST_METHOD").
    data:MimeType = getContextValue(request, "CONTENT_TYPE").
    data:Version = request:GetPathParameter("version").
    data:Parameters = ExtractQueryParameters(request).  // StringStringMap is not yet supported by serializer
    
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

  method public StringStringMap ExtractQueryParameters(request as IWebRequest):
    
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
    
  end method.  // ExtractQueryParameters

end class.
