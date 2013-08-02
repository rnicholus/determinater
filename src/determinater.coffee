determinater = {}

if exports
    if module && module.exports
        exports = module.exports = determinater
    exports.determinater = determinater
else
    this.determinater = determinater

determinater.determine = (fileOrBlob, possibleMimeTypes) ->
    console.log 'TODO'