author:
  name: ['Victor Hsieh']
  email: 'victor@csie.org'
name: 'zhutil'
description: 'Chinese utils'
version: '0.6.3'
repository:
  type: 'git'
  url: 'git://github.com/victorhsieh/npm-zhutil.git'
scripts:
  prepublish: """
    ./node_modules/.bin/lsc -cj package.ls
    ./node_modules/.bin/lsc -cbo lib src
  """
  test: './node_modules/.bin/lsc test/zhutil_test.ls'
  build: 'node_modules/.bin/gulp --require LiveScript build'
main: 'lib/zhutil.js'
engines:
  node: '0.10.x'
  npm: '1.x'
dependencies: {}
devDependencies:
  LiveScript: \1.1.x
  gulp: '~3.6.1'
  'gulp-livescript': '~0.2.1'
  'gulp-wrap-exports': '~0.2.0'
  'gulp-uglify': '~0.2.1'
  'gulp-rename': '~1.2.0'
  'gulp-clean': '~0.2.4'
optionalDependencies: {}
