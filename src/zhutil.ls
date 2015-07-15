zhnumber = <[○ 一 二 三 四 五 六 七 八 九]>
zhnumberformal = <[零 壹 貳 參 肆 伍 陸 柒 捌 玖]>
zhmap = {[c, i] for c, i in zhnumber}
zhwordmap = {[zhnumberformal[i], c] for c, i in zhnumber} <<< {
  '０': '○', 'ㄧ': '一', '兩': '二', '叁': '三', '拾': '十', '佰': '百', '仟': '千'
}
zhmap10 = {
  '十': 10, '百': 100, '千': 1000, '萬': 10000,
  '億': Math.pow(10, 8), '兆': Math.pow(10, 12) }
commitword = <[ 萬 億 兆 ]>

string2number = (str) ->
  num = parseInt(str - ',')
  return if isNaN(num) then void else num

parseZHNumber = (number) ->
  if number[0] == \負
    return -parseZHNumber number.slice(1)
  result = 0
  buffer = 0
  tmp = 0
  for digit in number.split('')
    digit = zhwordmap[digit] if zhwordmap[digit]?
    if digit of zhmap
      tmp = zhmap[digit]
    else if digit in commitword
      result += (buffer + tmp) * zhmap10[digit]
      buffer = 0
      tmp = 0
    else
      if digit is '十' and tmp is 0
        tmp = 1
      buffer += tmp * zhmap10[digit]
      tmp = 0
  result + buffer + tmp

annotate_positive = (number) ->
  str = ''
  for word in commitword
    str = number % 10000 + str
    number = Math.floor number / 10000
    if number > 0
      str = word + str
    else
      break
  return str

approximate_positive = (number, args) ->
  if not args.base?
    str = number.toString!
    log1000 = Math.floor(str.length / 4)
    if log1000 < 1
      return str
    base = commitword[log1000 - 1]
  else
    base = args.base
  smart = args.smart ? true
  extra_decimal = args.extra_decimal ? 0
  if args.extra_decimal?
    smart = false  # override

  number = annotate_positive number

  index = number.indexOf base
  if index < 0
    return number

  result = number.substr 0, index
  if smart and result.length < 2 and extra_decimal == 0
    extra_decimal = 1

  if extra_decimal > 0
    [_, digits] = number.substr(index + 1).match /^(\d+)/
    digits = '0' * (4 - digits.length) + digits
    result += \. + digits.substr 0, extra_decimal
  return result + base

input_filter = (func_expects_positive) ->
  return ->
    [number, args] = Array.prototype.slice.call arguments
    if typeof number is \string
      tmp = string2number number
      return number if tmp is void
      number = tmp

    if number < 0
      (args?negative_prefix ? \-) + func_expects_positive.call @, -number, args
    else
      func_expects_positive.call @, number, args

annotate = input_filter annotate_positive
approximate = input_filter approximate_positive

module.exports = {parseZHNumber, annotate, approximate}
