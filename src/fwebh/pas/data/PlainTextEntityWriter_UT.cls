 /*------------------------------------------------------------------------
    File        : PlainTextEntityWriter_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Richard Kelters / Flusso B.V.
    Created     : Tue May 14 14:56:27 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.pas.data.PlainTextEntityWriter.
using fwebh.pas.data.ResponseData.

class fwebh.pas.data.PlainTextEntityWriter_UT: 
  var PlainTextEntityWriter writer.
  var ResponseData response.

end class.