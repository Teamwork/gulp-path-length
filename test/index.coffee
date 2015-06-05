chai = require 'chai'
expect = chai.expect
should = chai.should()
pathLength = require '../src/'
gutil = require 'gulp-util'
File = gutil.File
fs = require 'vinyl-fs'
path = require 'path'

describe 'gulp-path-length', =>

    describe 'defaults', ->
        it 'should fail for file with path of length 257', (done) ->

            file = gimmeFile {pathLength:257}
            setupStreams {file, shouldPass: false, done}


        it 'should pass for file with path of length 256', (done) ->

            file = gimmeFile {pathLength:256}
            setupStreams {file, shouldPass: true, done}


    describe 'options', ->
        it 'rewrite path fail', (done) ->

            options =
                maxLength: 5
                rewrite:
                    match: './test/dummyfiles'
                    replacement: '/Users/Bullshit'

            testOptions {options, shouldPass: false, done}

        it 'rewrite path pass', (done) ->

            options =
                maxLength: 30
                rewrite:
                    match: './test/dummyfiles'
                    replacement: '/Users/Bullshit'

            testOptions {options, shouldPass: true, done}


testOptions = ({options, shouldPass, done}) ->
    stream = fs.src ['./test/dummyfiles/*']
        .pipe pathLength options

    hasPassed = true

    stream.on 'error', (err) ->
        stream.end()
        hasPassed = false

    stream.on 'data', () ->

    stream.on 'end', () ->
        expect(hasPassed).to.equal(shouldPass)
        done()


gimmeFile = ({pathLength, path})->
    fileName = 'magic.coffee'
    path = path ? "/#{new Array(pathLength - fileName.length - 1).join 'a'}/#{fileName}"

    return new File
        cwd: '/'
        base: '/'
        path: path
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