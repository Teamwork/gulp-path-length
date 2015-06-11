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

        if options.rewrite?
            if options.rewrite.replacement? and not options.rewrite.match?
                return cb new PluginError pluginName, 'Required option not set: "rewrite.match"'

            if options.rewrite.match? and not options.rewrite.replacement?
                return cb new PluginError pluginName, 'Required option not set: "rewrite.replacement"'

        # don't support stream for now
        if file.isStream()
            returncb new PluginError pluginName, 'Streaming not supported'


        filePath = file.path

        if doRewrite
            filePath = filePath.replace rewriteMatch, rewriteReplacement

        if filePath.length > maxLength
            return cb new PluginError pluginName, "File '#{filePath}' path length greater than #{maxLength}"

        cb null, file