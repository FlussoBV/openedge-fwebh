
/*------------------------------------------------------------------------
    File        : IDeserializable
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : bronco
    Created     : Sat Aug 18 16:58:04 CEST 2018
    Notes       :
  ----------------------------------------------------------------------*/


using Progress.Json.ObjectModel.JsonObject.

interface fwebh.serialize.IDeserializable:
  method public Progress.Lang.Object Deserialize(data as JsonObject, targetObj as Progress.Lang.Object).
end interface.