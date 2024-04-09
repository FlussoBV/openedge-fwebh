
/*------------------------------------------------------------------------
    File        : IListInfo
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Jul 27 12:29:23 CEST 2018
    Notes       : This interface is necessary to compensate for the lack of
                  generics in the 4GL.
  ----------------------------------------------------------------------*/

interface fwebh.serialize.IListInfo:  
  
  method public character GetListType(listName as character).
  
end interface.
