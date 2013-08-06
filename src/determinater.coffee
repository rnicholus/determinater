###
    determinater - An efficient, flexible, and accurate client-side file identification tool.

    Copyright (c) 2013 Ray Nicholus
    Licensed under the MIT license (http://opensource.org/licenses/MIT)
###

console.log "Creating determinater..."
determinater = {}

###
    We will retrieve the signatures from this location on startup.
    Keeping the signatures out of the source allows me to add more signatures
    over time without requiring users to download new versions of the code.
    TODO: Allow integrators to point to a different location.
###
signaturesUrl = "https://dl.dropboxusercontent.com/u/199054115/signatures.json"

###
    The minimum number of bytes from offset 0 that need to be examined
    in order to properly identify any file.
    TODO Programmatically determine this after signatures have been loaded.
###
minimumBytesToExamine = 16

# AMD Support, with a fallback that adds a `determinater` property to the global namespace.
if exports
    if module? and module.exports?
        exports = module.exports = determinater
    else
        exports.determinater = determinater
else
    @determinater = determinater

###
    Grab the signatures JSON file from the CDN, parse it, and
    cache it.
###
loadSignatures = ->
    console.log "Loading signatures from CDN..."

    xhr = new XMLHttpRequest

    xhr.open "GET", signaturesUrl

    xhr.onload = ->
        if xhr.status is 200
            determinater.signatures = JSON.parse xhr.responseText
            console.log "Signatures loaded."
        else
            console.error "#{xhr.status} status returned by signature server!"

    xhr.send()

# Only ask the CDN for the signatures file if we haven't already loaded it in this browsing context.
if !determinater.signatures then loadSignatures()

###
    Identify one or more `Files` or `Blobs`, optionally passing in an array of
    exclusive extensions or MIME types.  If such an array is included,
    determinater will only consider these file types when attempting
    to identify the file(s).

    This will return a promise since the work required to fulfill this request
    will be handled in one or more asynchronous calls.
###
determinater.determine = (filesOrBlobs, possibleExtensionsOrMimeTypes) ->
    determinations = new Promise
    examined = 0
    failed = 0


    ###
        Sets the `determinedType` property of the File or Blob
        to match the determined MIME type.  This also decrements
        the number of determinations left and possibly calls the
        success function on the promise if we have no determinations
        left to make.  The success function will be passed all
        Files or Blobs that were properly identified.
    ###
    handleDeterminedType = (fileOrBlob, determinedType) ->
        examined++

        if examined == filesOrBlobs.length
            determinations.success filesOrBlobs

    ###
        Called when we cannot identify one or more files due to some unexpected error.
        If all files fail to be identified due to an unexpected error, we will invoke the
        failure callback.
    ###
    handleTypeDeterminationFailure = (fileOrBlob, failureReason) ->
        examined++
        failed++

        if failureReason? then console.log failureReason else "Unexpected error during determination!"

        if failed == filesOrBlobs.length
            determinations.failure filesOrBlobs
        else if examined == filesOrBlobs.length
            determinations.success filesOrBlobs


    filesOrBlobs.forEach (fileOrBlob) ->
        slice = sliceFile fileOrBlob, possibleExtensionsOrMimeTypes
        getBytesAsString(slice).then (firstBytes) ->
            determineType(firstBytes, possibleExtensionsOrMimeTypes)
                .then (determinedType) -> handleDeterminedType fileOrBlob, determinedType,
            () -> handleTypeDeterminationFailure fileOrBlob

    return determinations


###
    Slice the minimum number of bytes off the the file required
    to properly identify it.  Return the resulting Blob.
###
sliceFile = (fileOrBlob) ->
    #TODO

###
    Get a hex string that represents all bytes associated with
    the passed Blob.  This returns a promise since this is an async
    operation.  When the promise is fulfilled, the bytes as a string
    will be passed into the success callback.
###
getBytesAsString = (blob) ->
    #TODO

###
    Determine what type of file is associated with the
    hex string.  This returns a promise as this is an
    async operation.  When the promise is fulfilled,
    a MIME value identifying the file will be returned.
    If the file cannot be identified, the failure callback
    will be invoked.
###
determineType = (hexString, filterByExtsOrMimes) ->
    #TODO

###
    Simple helper that allows us to add some advice
    after a function has been invoked.
###
after = (func, advice) ->
    ->
        result = func.apply @, arguments
        advice.call @, result
        return result

###
    Simple helper function that allows us to add some advice
    before a function is invoked.
###
before = (func, advice) ->
    ->
        advice.apply @, arguments
        func.apply @, arguments
###
    Simple promise pattern implementation.
###
class Promise
    successCallbacks = []
    failureCallbacks = []
    status = null
    doneArgs = null

    success: ->
        status = "success"
        doneArgs = arguments
        callback.apply null, arguments for callback in successCallbacks
        return @

    failure: ->
        status = "failure"
        doneArgs = arguments
        callback.apply null, arguments for callback in failureCallbacks
        return @

    then: (successCallback, failureCallback) ->
        if status is "success"
            successCallback.apply null, doneArgs
        else
            successCallbacks.push successCallback

        if status is "failure"
            failureCallback.apply null, doneArgs
        else
            failureCallbacks.push failureCallback

        return @
