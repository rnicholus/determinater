determinater
============

Efficient, flexible, _and_ accurate client-side file identification tool.


**Notice**: this is a work in progress and is not yet ready for use.  Once it is functional, 
I will be sure to version it appropriately.


<br/>
#### Summary
The intent of this library is to identify a [`File`](http://www.w3.org/TR/FileAPI/#dfn-file) or 
[`Blob`](http://www.w3.org/TR/FileAPI/#dfn-Blob) by looking for "magic numbers" or "magic bytes".
This can be efficiently accomplished client-side by [slicing](http://www.w3.org/TR/FileAPI/#slide-method-algo) 
off a small initial portion of the file, converting that portion of the file's bytes to a hex string representation 
using [FileReader](http://www.w3.org/TR/FileAPI/#FileReader-interface), and then comparing
these bytes to a table of magic numbers.  

The process can be made even more efficient if a subset of important file types is provided.  In the abcense of 
such a filter, [web workers](http://www.w3.org/TR/workers/) can be utilized wherever possible to ensure 
matching does not tie up the UI thread.


<br/>
#### Supported Browsers (planned)
* IE10+
* Firefox
* Chrome
* Safari 6
* Opera 11.1
* iOS 6+ (Safari, Chrome, and Firefox)
* Blackberry 10
* Android 4+ (Chrome & Firefox)

<br/>
#### License
This library is MIT licensed.  See the [license file](LICENSE) for specifics.
