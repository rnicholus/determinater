determinater
============

Efficient, flexible, _and_ accurate client-side file identification tool.


The intent of this library is to identify a [`File`](http://www.w3.org/TR/FileAPI/#dfn-file) or 
[`Blob`](http://www.w3.org/TR/FileAPI/#dfn-Blob) by looking for "magic numbers" or "magic bytes".
This can be efficiently accomplished client-side by [slicing](http://www.w3.org/TR/FileAPI/#slide-method-algo) 
off a small initial portion of the file, converting that portion of the file's bytes to a hex string representation 
using [FileReader](http://www.w3.org/TR/FileAPI/#FileReader-interface), and then comparing
these bytes to a table of magic numbers.  

The process can be made even more efficient if a subset of important file types is provided.  
In the abcense of such a filter, [web workers](http://www.w3.org/TR/workers/) 
can be utilized wherever possible to ensure matching does not tie up the UI thread.


**Notice**: this is a work in progress and is not yet ready for use.  Once it is functional, 
I will be sure to version it appropriately.
