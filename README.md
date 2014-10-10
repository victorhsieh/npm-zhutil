npm-zhutil
==========
Utils to handle Chinese, e.g. convert Chinese number to decimal.

 * https://npmjs.org/package/zhutil
 * https://github.com/victorhsieh/npm-zhutil

Example
=======
  ```
  zhutil.parseZHNumber('陸佰捌拾玖') === 689

  zhutil.annotate(10987654321) === '109億8765萬4321'

  zhutil.approximate(10987654321, {base: '億'}) === '109億'
  zhutil.approximate(987654321, {base: '億'}) === '9.8億'
  zhutil.approximate(10987654321, {base: '億', extra_decimal: 2}) === '9.87億'
  zhutil.approximate(987654321, {base: '億', smart: false}) === '9億'
  ```

See test/zhutil_test.ls for more example.

Build
=====
  ```
  $ npm run build
  ```

Release
=======
  ```
  $ node_modules/.bin/gulp --require LiveScript build && git add -u build/ && ...
  $ npm version X.Y.Z
  $ (update package.ls ...)
  $ npm publish
  $ git commit; git push --tags
  ```
