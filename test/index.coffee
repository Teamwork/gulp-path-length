chai = require 'chai'
expect = chai.expect
should = chai.should()
pathLength = require '../src/'
gutil = require 'gulp-util'
File = gutil.File


describe 'gulp-path-length', =>

    describe 'defaults', ->
        it 'should fail for file with path of length 257', (done) ->

            file = gimmeFile 257
            setupStreams {file, shouldPass: false, done}


        it 'should pass for file with path of length 256', (done) ->

            file = gimmeFile 256
            setupStreams {file, shouldPass: true, done}


gimmeFile = (pathLength)->
    fileName = 'magic.coffee'

    return new File
        cwd: '/'
        base: '/'
        path: "/#{new Array(pathLength - fileName.length - 1).join 'a'}/#{fileName}"
        contents: new Buffer('omg')

setupStreams = ({file, options, shouldPass, done}) ->
        stream = pathLength(options)

        hasPassed = true

        stream.on 'error', (err) ->
            hasPassed = false

        stream.on 'data', () ->

        stream.on 'end', () ->
            expect(hasPassed).to.equal(shouldPass)
            done()

        stream.write file
        stream.end()