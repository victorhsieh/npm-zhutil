require! <[gulp gulp-livescript gulp-wrap-exports gulp-uglify gulp-rename gulp-clean]>


gulp.task 'clean' ->
  gulp.src 'build'
    .pipe gulp-clean!

gulp.task 'build' <[clean]> ->

  gulp.src 'src/*.ls'
    .pipe gulp-livescript!
    .pipe gulp-wrap-exports name: 'zhutil'
    .pipe gulp.dest 'build'
    .pipe gulp-rename suffix: '.min'
    .pipe gulp-uglify!
    .pipe gulp.dest 'build'

gulp.task 'default' <[build]>