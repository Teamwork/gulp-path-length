through = require 'through2'
path = require 'path'
gutil = require 'gulp-util'
PluginError = gutil.PluginError
pluginName = 'gulp-path-length'


module.exports = (options={}) ->
    maxLength = options.maxLength ? 256
    doRewrite = options.rewrite? and options.rewrite.replacement? and options.rewrite.match?

    if doRewrite
        rewriteMatch = path.resolve options.rewrite.match
        rewriteReplacement = options.rewrite.replacement

    through.obj (file, enc, cb) ->
        # pass through null files
        if file.isNull()
            cb null, file
            return

        # don't support stream for now
        if file.isStream()
            cb new PluginError pluginName, 'Streaming not supported'
            return

        filePath = file.path

        if doRewrite
            filePath = filePath.replace rewriteMatch, rewriteReplacement

        if filePath.length > maxLength
            cb new PluginError pluginName, "File '#{filePath}' path length greater than #{maxLength}"
            return

        cb null, file