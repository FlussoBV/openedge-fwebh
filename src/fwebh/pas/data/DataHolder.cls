 /*------------------------------------------------------------------------
    File        : DataHolder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue May 07 09:47:49 CEST 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using fwebh.pas.data.IDataHolder.
using fwebh.pas.data.ResponseDataType.
using Progress.Json.ObjectModel.JsonConstruct.

class fwebh.pas.data.DataHolder implements IDataHolder: 
  
  define public property DatasetHandle as handle no-undo 
    get. 
    set(h as handle):
      DatasetHandle = h.
      this-object:DataType = ResponseDataType:DATASET.
    end.
    
  define public property TempTableHandle as handle no-undo 
    get. 
    set(h as handle):
      TempTableHandle = h.
      this-object:DataType = ResponseDataType:TEMP-TABLE.
    end.
    
  define public property BufferHandle as handle no-undo 
    get. 
    set(h as handle):
      BufferHandle = h.
      this-object:DataType = ResponseDataType:BUFFER.
    end.
  
  define public property GenericHandle as handle no-undo 
    get. 
    set(h as handle):
      GenericHandle = h.
      this-object:DataType = ResponseDataType:WIDGET-HANDLE.
    end.
  
  define public property Json as JsonConstruct no-undo 
    get. 
    set(jsonIn as JsonConstruct):
      Json = jsonIn.
      this-object:DataType = ResponseDataType:JSON.
    end.
    
  define public property Memptr as memptr no-undo 
    get. 
    set(p as memptr):
      this-object:Memptr = p.
      this-object:DataType = ResponseDataType:MEMPTR.
    end.

  define public property PlainText as longchar no-undo 
    get. 
    set(c as longchar):
      PlainText = c.
      this-object:DataType = ResponseDataType:LONGCHAR.
    end.
    
  define public property DataType as ResponseDataType no-undo get. set.
  
  constructor public DataHolder():
    this-object:DataType = ResponseDataType:NONE.
  end.
  
  destructor DataHolder():
    
    // an object may hold data. Especially in the case of memptr it is vital 
    // that these are cleaned.
    
    case Datatype:
      when ResponseDataType:MEMPTR then do:        
        if get-size(this-object:Memptr) > 0 then  // need to check first, otherwise the session crashes
          set-size(this-object:Memptr) = 0.
      end.
    end case.

  end destructor.
  
end class.
