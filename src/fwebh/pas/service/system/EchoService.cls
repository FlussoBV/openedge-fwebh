 
 /*------------------------------------------------------------------------
    File        : EchoService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Apr 23 14:06:11 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.lang.error.InvalidDataException.
using fwebh.pas.data.IRequestData.
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.ResponseData.
using fwebh.pas.data.ResponseDataType.
using fwebh.pas.service.IGetDataService.
using fwebh.pas.service.IPostDataService.
using fwebh.pas.service.IPutDataService.
using fwebh.pas.service.system.EchoPostData.
using fwebh.serialize.SimpleJsonDeserializer.
using fwebh.serialize.SimpleJsonSerializer.
using OpenEdge.Core.String.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.

class fwebh.pas.service.system.EchoService implements IGetDataService, IPostDataService, IPutDataService:
  
  method public IResponseData GetData(request as IRequestData):
    
    var IResponseData response = new ResponseData().
        
    response:Data:Json = new SimpleJsonSerializer():Serialize(request).
    
    return response.
    
  end method.  // GetData
  
  
  method public IResponseData PostData(request as IRequestData):
    
    var Progress.Lang.Object postedData.
    var SimpleJsonSerializer serializer = new SimpleJsonSerializer().
    var IResponseData response = new ResponseData().
    var JsonObject jsonOut = new JsonObject().
    
    do on error undo, throw:
      
      case request:Data:DataType:
      
        when ResponseDataType:JSON or when ResponseDataType:Memptr then         
          postedData = cast(
            new SimpleJsonDeserializer():Deserialize(
              cast(request:Data:Json, Progress.Json.ObjectModel.JsonObject),
              "fwebh.pas.service.system.EchoPostData"
            ),
            "fwebh.pas.service.system.EchoPostData"
          ).
        
        when ResponseDataType:WIDGET-HANDLE then do:
          case request:Data:GenericHandle:type:
            when "x-document" then 
              postedData = handleXml(request:Data:GenericHandle).
            otherwise do:
              message "not handled request:Data:GenericHandle:type:" request:Data:GenericHandle:type.
            end.
              
          end case.
        end.
        
        otherwise do:
          message "not handled ResponseDataType:" request:Data:DataType:ToString().
        end.
        
      end case.
      
      catch err1 as Progress.Lang.Error :
        undo, throw new InvalidDataException(err1:GetMessage(1)).
      end catch.
            
    end.
    
    jsonOut:Add("request", serializer:Serialize(request)).
    
    if postedData:GetClass():TypeName = "Progress.Json.ObjectModel.JsonObject" then
      jsonOut:Add("posted", cast(postedData, Progress.Json.ObjectModel.JsonObject)).
    else
      jsonOut:Add("posted", serializer:Serialize(postedData)).
    
    response:Data:Json = jsonOut.
    
    return response.
    
  end method.  // PostData
  

  method public IResponseData PutData(request as IRequestData):
    
    var Progress.Lang.Object putData.
    var SimpleJsonSerializer serializer = new SimpleJsonSerializer().
    var IResponseData response = new ResponseData().
    var JsonObject jsonOut = new JsonObject().
    
    do on error undo, throw:
      
      case request:Data:DataType:
      
        when ResponseDataType:JSON or when ResponseDataType:Memptr then         
          putData = cast(
            new SimpleJsonDeserializer():Deserialize(
              cast(request:Data:Json, Progress.Json.ObjectModel.JsonObject),
              "fwebh.pas.service.system.EchoPostData"
            ),
            "fwebh.pas.service.system.EchoPostData"
          ).
        
        when ResponseDataType:WIDGET-HANDLE then do:
          case request:Data:GenericHandle:type:
            when "x-document" then 
              putData = handleXml(request:Data:GenericHandle).
            otherwise do:
              message "not handled request:Data:GenericHandle:type:" request:Data:GenericHandle:type.
            end.
              
          end case.
        end.
        
        otherwise do:
          message "not handled ResponseDataType:" request:Data:DataType:ToString().
        end.
        
      end case.
      
      catch err1 as Progress.Lang.Error :
        undo, throw new InvalidDataException(err1:GetMessage(1)).
      end catch.
            
    end.
    
    jsonOut:Add("request", serializer:Serialize(request)).
    
    if putData:GetClass():TypeName = "Progress.Json.ObjectModel.JsonObject" then
      jsonOut:Add("put", cast(putData, Progress.Json.ObjectModel.JsonObject)).
    else
      jsonOut:Add("put", serializer:Serialize(putData)).
    
    response:Data:Json = jsonOut.
    
    return response.
    
  end method.  // PutData

  method private Progress.Lang.Object handleXml(xmldoc as handle):

    var longchar xmltext. 
    var JsonObject json = new JsonObject(). 
    
    var handle root. 
    
    xmldoc:save("longchar", xmltext).
    
    // remove the <?xml... 
    xmltext = substring(xmltext, index(xmltext, "?>") + 2).
    xmltext = replace(xmltext, "\n", "").
    
    json:Add("xml", xmltext).
    
    return json.
    
  end method.  // handleXml
  
end class.
