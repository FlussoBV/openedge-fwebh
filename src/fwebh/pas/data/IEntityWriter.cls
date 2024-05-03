
/*------------------------------------------------------------------------
    File        : IEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Mon Apr 15 16:28:35 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

using fwebh.pas.data.IResponseData.

interface fwebh.pas.data.IEntityWriter:  
  
  method public Progress.Lang.Object Write( responseData as IResponseData ).
  
end interface.
