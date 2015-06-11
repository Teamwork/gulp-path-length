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
            testWithFile {file, shouldPass: false, done}


        it 'should pass for file with path of length 256', (done) ->

            file = gimmeFile {pathLength:256}
            testWithFile {file, shouldPass: true, done}


    describe 'options', ->
        it 'should fail when the maxLength is less than the rewritten path', (done) ->

            options =
                maxLength: 5
                rewrite:
                    match: './test/dummyfiles'
                    replacement: '/Users/Bullshit'

            testWithDummyFiles {options, shouldPass: false, done}

        it 'should pass when the maxLength is more than the rewritten path', (done) ->

            options =
                maxLength: 30
                rewrite:
                    match: './test/dummyfiles'
                    replacement: '/Users/Bullshit'

            testWithDummyFiles {options, shouldPass: true, done}

        it 'should fail when the only match is supplied', (done) ->

            options =
                maxLength: 30
                rewrite:
                    match: './test/dummyfiles'

            cb = (err) ->
                expect(err?.message).to.equal 'Required option not set: "rewrite.replacement"'
                done()

            testWithDummyFiles {options, cb}


        it 'should fail when the only replacement is supplied', (done) ->

            options =
                maxLength: 30
                rewrite:
                    replacement: '/Users/Bullshit'

            cb = (err) ->
                expect(err?.message).to.equal 'Required option not set: "rewrite.match"'
                done()

            testWithDummyFiles {options, cb}

    it 'should be called for each file', (done) ->

        options =
            rewrite:
                match: './test/dummyfiles'
                replacement: '/Users/Bullshit'
        numFiles = 0

        onData = -> numFiles = numFiles + 1

        cb = (err) ->
            expect(numFiles).to.equal 4
            done()

        testWithDummyFiles {options, cb, onData}




testWithDummyFiles = ({options, shouldPass, done, cb, onData}) ->
    stream = fs.src ['./test/dummyfiles/*']
        .pipe pathLength options

    handleStreams({stream, shouldPass, done, cb, onData})


testWithFile = ({file, options, shouldPass, done, cb}) ->
    stream = pathLength(options)

    handleStreams({stream, shouldPass, done})

    stream.write file
    stream.end()

gimmeFile = ({pathLength, path})->
    fileName = 'magic.coffee'
    path = path ? "/#{new Array(pathLength - fileName.length - 1).join 'a'}/#{fileName}"

    return new File
        cwd: '/'
        base: '/'
        path: path
        contents: new Buffer('omg')

handleStreams = ({stream, shouldPass, done, cb, onData}) ->
    hasPassed = true

    stream.on 'error', (err) ->
        if cb?
            return cb err

        hasPassed = false
        expect(hasPassed).to.equal(shouldPass)
        done()

    stream.on 'data', () ->
        onData.apply this, arguments if onData?

    stream.on 'end', (err) ->
        return unless hasPassed

        if cb?
           return cb err

        expect(hasPassed).to.equal(shouldPass)
        done()
