require! '../lib/zhutil'

expect = (name, expected, f, ...args) ->
  actual = f.apply [], args
  input = name + \( + ([JSON.stringify x for x in args] * ',') + \)
  if actual != expected
    console.error "[FAIL] #input"
    console.error "    EXPECTED: #expected"
    console.error "    ACTUAL: #actual"
  else
    console.log "[PASS] #input == #expected"


#
# zhutil.parseZHNumber
#

expectZH = (input, expected) ->
  expect \parseZHNumber, expected, zhutil.parseZHNumber, input

expectZH '零', 0
expectZH '一', 1
expectZH '叁', 3
expectZH '十', 10
expectZH '十ㄧ', 11 # 'ㄧ' is zhu-yin
expectZH '十二', 12
expectZH '二十', 20
expectZH '三十四', 34
expectZH '五百', 500
expectZH '六百七十', 670
expectZH '六百零九', 609
expectZH '陸佰捌拾玖', 689
expectZH '七千', 7000
expectZH '七千零八十六', 7086
expectZH '七千零二十', 7020
expectZH '七千三百零二', 7302
expectZH '一萬兩千三百四十五', 12345
expectZH '壹萬貳仟參佰肆拾伍', 12345
expectZH '一萬零一', 10001
expectZH '一萬零三百零一', 10301
expectZH '三百０五萬０七百０九', 3050709
expectZH '玖億零捌', 900000008
expectZH '玖億捌仟柒佰陸拾伍萬', 987650000
expectZH '玖億捌仟柒佰陸拾伍萬肆仟參佰貳拾壹', 987654321
expectZH '一兆五千零三十', 1000000005030
expectZH '一兆一千萬零十一', 1000010000011
expectZH '負五百', -500

# non-natural cases
expectZH '一百十二', 112


#
# zhutil.annotate
#

expectAnnotation = (input, expected) ->
  expect \annotate, expected, zhutil.annotate, input

expectAnnotation 10987654321, \109億8765萬4321
expectAnnotation 87654321, \8765萬4321
expectAnnotation 4321, \4321
expectAnnotation 1, \1
expectAnnotation '10987654321', \109億8765萬4321
expectAnnotation 'not number', 'not number'
expectAnnotation '54,321', \5萬4321
expectAnnotation -4321, '-4321'
expectAnnotation '-54,321', \-5萬4321


#
# zhutil.approximate
#

expectApproximate = (number, options, expected) ->
  expect \approximate, expected, zhutil.approximate, number, options

expectApproximate 10987654321, {}, \109億
expectApproximate 987654321, {}, \9.8億
expectApproximate 321, {}, \321
expectApproximate 10987654321, {base: \億}, \109億
expectApproximate 10987654321, {base: \億, extra_decimal: 1}, \109.8億
expectApproximate 102412200, {base: \億, extra_decimal: 2}, \1.02億
expectApproximate 10987654321, {base: \萬}, \109億8765萬
expectApproximate '987654321', {}, \9.8億
expectApproximate 'not number', {}, 'not number'
expectApproximate -987654321, {}, \-9.8億
expectApproximate -987654321, {negative_prefix: '(虧損)'}, '(虧損)9.8億'

# "smart" (defaults on) puts extra digit if the number is relatively small.
expectApproximate 54321, {}, \5.4萬
expectApproximate 654321, {}, \65萬
expectApproximate 54321, {extra_decimal: 2}, \5.43萬
expectApproximate 54321, {extra_decimal: 0}, \5萬
expectApproximate 54321, {smart: false}, \5萬
expectApproximate '54,321', {}, \5.4萬
expectApproximate '-54,321', {}, \-5.4萬
expectApproximate -654321, {}, \-65萬
