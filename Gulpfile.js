var gulp = require('gulp');

// var cmq = require('gulp-combine-media-queries');
// var uncss = require('gulp-uncss');
// var cssmin = require('gulp-cssmin');

var rename = require('gulp-rename');
var sass = require('gulp-sass');
var livereload = require('gulp-livereload');
var changed = require('gulp-changed');
var concat = require('gulp-concat');
var concatSourcemap = require('gulp-concat-sourcemap');
var imagemin = require('gulp-imagemin');
var uglify = require('gulp-uglify');

var paths = {
  scripts: 'ui/js/**/*.js',
  styles: 'ui/scss/**/*.scss',
  images: 'ui/img/**/*'
};

gulp.task('styles', function() {
  return gulp.src(paths.styles)
    .pipe(sass({
      errLogToConsole: true,
      sourceComments: 'map',
      outputStyle: 'expanded'
    }))
    .pipe(gulp.dest('public/assets/css'));
});

gulp.task('styles-build', function() {
  return gulp.src(paths.styles)
    .pipe(sass({
      errLogToConsole: true,
      outputStyle: 'compressed'
    }))
    .pipe(rename({suffix: '.min'}))
    .pipe(gulp.dest('public/assets/css'));
});

gulp.task('scripts', function() {
  return gulp.src(paths.scripts)
    .pipe(concatSourcemap('scripts.js', {
      sourcesContent: true
    }))
    .pipe(gulp.dest('public/assets/js'));
});

gulp.task('scripts-build', function() {
  return gulp.src(paths.scripts)
    .pipe(concat('scripts.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('public/assets/js'));
});

gulp.task('images', function() {
  return gulp.src(paths.images)
    .pipe(imagemin({
      progressive: true,
      interlaced: true,
      optimizationLevel: 9
    }))
    .pipe(gulp.dest('public/assets/img'));
});

gulp.task('watch', function() {
  var server = livereload();

  gulp.watch(paths.scripts, ['scripts']);
  gulp.watch(paths.styles, ['styles']);
  gulp.watch(paths.images, ['images']);

  gulp.watch('public/assets/**').on('change', function(file) {
    server.changed(file.path);
  });
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['styles', 'scripts', 'images']);

gulp.task('build', ['styles-build', 'scripts-build', 'images']);
