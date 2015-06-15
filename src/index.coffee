through = require 'through2'
gutil = require 'gulp-util'
PluginError = gutil.PluginError
pluginName = 'gulp-path-length'
rewritePath = require './rewrite'

module.exports = (options={}) ->
    maxLength = options.maxLength ? 256
    doRewrite = options.rewrite? and options.rewrite.replacement? and options.rewrite.match?

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
            filePath = rewritePath(filePath, options.rewrite.match, options.rewrite.replacement)

        if filePath.length > maxLength
            return cb new PluginError pluginName, "File '#{filePath}' path length greater than #{maxLength}"

        cb null, file