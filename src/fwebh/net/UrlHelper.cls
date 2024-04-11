
 /*------------------------------------------------------------------------
    File        : UrlHelper
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco
    Created     : Thu Apr 11 15:22:14 +02:00 2024
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class fwebh.net.UrlHelper final:

  constructor private UrlHelper():  // no instantiation
  end constructor.

  method public static character Decode(urlEntry as character):
    urlEntry = replace(urlEntry, "%20", " ").
    return urlEntry.
  end method.  // UrlDecode

end class.  // UrlHelper
