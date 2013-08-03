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

# AMD Support, with a fallback that adds a `determinater` property to the global namespace.
if exports
    if module && module.exports
        exports = module.exports = determinater
    exports.determinater = determinater
else
    this.determinater = determinater

###
    Grab the signatures JSON file from the CDN, parse it, and
    cache it.
###
loadSignatures = ->
    console.log "Loading signatures from CDN..."

    xhr = new XMLHttpRequest

    xhr.open "GET", signaturesUrl

    xhr.onload = ->
        if xhr.status == 200
            determinater.signatures = JSON.parse xhr.responseText
            console.log "Signatures loaded."
        else
            console.error "#{xhr.status} status returned by signature server."

    xhr.send()

# Only ask the CDN for the signatures file if we haven't already loaded it in this browsing context.
if !determinater.signatures then loadSignatures()

###
    Identify a `File` or `Blob`, optionally passing in an array of
    exclusive extensions.  If such an array is included, determinater
    will only consider these file types when attempting to identify
    the file.
###
determinater.determine = (fileOrBlob, possibleExtensions) ->
    console.log "TODO"