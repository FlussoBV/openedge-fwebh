 
 /*------------------------------------------------------------------------
    File        : ISerializable
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Jul 20 11:51:07 CEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Json.ObjectModel.JsonObject.

interface fwebh.serialize.ISerializable:
  method public JsonObject Serialize(objectToSerialize as Progress.Lang.Object).
end interface.