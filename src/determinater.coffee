root = this

determinater = {}

if exports
    if module && module.exports
        exports = module.exports = determinater
    exports.determinater = determinater
else
    root.determinater = determinater

determinater.determine = (fileOrBlob, possibleMimeTypes) ->
    console.log 'TODO'