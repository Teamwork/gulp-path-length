gulp-path-length 
===

[npm badge] [travis badge] [appveyor badge]

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
