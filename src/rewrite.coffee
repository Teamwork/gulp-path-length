path = require 'path'

module.exports = (filePath, match, replacement) ->
    match = path.resolve match
    replacement = replacement

    return filePath.replace match, replacement