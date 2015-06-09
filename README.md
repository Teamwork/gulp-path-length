gulp-path-length 
===

[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Windows Build Status][appveyor-image]][appveyor-url] [![Dependency Status][depstat-image]][depstat-url] 

---

A [Gulp](gulpjs.com) plugin for enforcing a character limit on file paths. Created with Windows' 256 character limit in mind but can be used on other platforms too.

## Installation

```shell
npm install gulp-path-length
```

## Usage

```javascript
var gulp = require('gulp');
var pathLength = require('gulp-path-length');

gulp.task('default', function(){
    gulp.src('./example/path/to/directory/**', {read: false})
        .pipe(pathLength()); 
});
```

This will stop the build with an error if you've an overly long path. I've passed `{read: false}` to `gulp.src` here because we don't need to read the contents, we just need the paths. But if you're using `gulp-path-length` after some other pipes, it's likely you shouldn't pass `{read: false}`.

## API

There is only one (optional) parameter; an `options` object. The possible properties it can contain are:
- `maxLength` - defaults to `256`
- `rewrites` - This is an optional object which contains mappings between directories. So for example, you could have `{'./example/path/to/directory/': 'C:\\Program Files (x86)\\abc'}`. Then when the plugin goes to check the file `./example/path/to/directory/x.txt`, it will actually check `C:\Program Files (x86)\abc\x.txt`. The keys and values can be relative or absolute paths.


[npm-url]: https://npmjs.org/package/gulp-path-length
[npm-image]: http://img.shields.io/npm/v/gulp-path-length.svg?style=flat

[travis-url]: http://travis-ci.org/Teamwork/gulp-path-length
[travis-image]: http://img.shields.io/travis/Teamwork/gulp-path-length.svg?style=flat

[appveyor-url]: https://ci.appveyor.com/project/4ver/gulp-path-length/branch/master
[appveyor-image]: https://ci.appveyor.com/api/projects/status/tradq3vg1hoah36j/branch/master?svg=true

[depstat-url]: https://david-dm.org/Teamwork/gulp-path-length
[depstat-image]: https://david-dm.org/Teamwork/gulp-path-length.svg?style=flat
