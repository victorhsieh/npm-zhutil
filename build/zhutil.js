!function(module, global){
var exports = module.exports;
(function(){
  var zhnumber, zhnumberformal, zhmap, res$, i$, len$, i, c, zhwordmap, ref$, zhmap10, commitword, string2number, parseZHNumber, annotate_positive, approximate_positive, input_filter, annotate, approximate, replace$ = ''.replace;
  zhnumber = ['○', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
  zhnumberformal = ['零', '壹', '貳', '參', '肆', '伍', '陸', '柒', '捌', '玖'];
  res$ = {};
  for (i$ = 0, len$ = zhnumber.length; i$ < len$; ++i$) {
    i = i$;
    c = zhnumber[i$];
    res$[c] = i;
  }
  zhmap = res$;
  zhwordmap = (ref$ = (function(){
    var i$, ref$, len$, results$ = {};
    for (i$ = 0, len$ = (ref$ = zhnumber).length; i$ < len$; ++i$) {
      i = i$;
      c = ref$[i$];
      results$[zhnumberformal[i]] = c;
    }
    return results$;
  }()), ref$['０'] = '○', ref$['兩'] = '二', ref$['叁'] = '三', ref$['拾'] = '十', ref$['佰'] = '百', ref$['仟'] = '千', ref$);
  zhmap10 = {
    '十': 10,
    '百': 100,
    '千': 1000,
    '萬': 10000,
    '億': Math.pow(10, 8),
    '兆': Math.pow(10, 12)
  };
  commitword = ['萬', '億', '兆'];
  string2number = function(str){
    var num;
    num = parseInt(replace$.call(str, ',', ''));
    return isNaN(num) ? void 8 : num;
  };
  parseZHNumber = function(number){
    var result, buffer, tmp, i$, ref$, len$, digit;
    if (number[0] === '負') {
      return -parseZHNumber(number.slice(1));
    }
    result = 0;
    buffer = 0;
    tmp = 0;
    for (i$ = 0, len$ = (ref$ = number.split('')).length; i$ < len$; ++i$) {
      digit = ref$[i$];
      if (zhwordmap[digit] != null) {
        digit = zhwordmap[digit];
      }
      if (digit in zhmap) {
        tmp = zhmap[digit];
      } else if (in$(digit, commitword)) {
        result += (buffer + tmp) * zhmap10[digit];
        buffer = 0;
        tmp = 0;
      } else {
        if (digit === '十' && tmp === 0) {
          tmp = 1;
        }
        buffer += tmp * zhmap10[digit];
        tmp = 0;
      }
    }
    return result + buffer + tmp;
  };
  annotate_positive = function(number){
    var str, i$, ref$, len$, word;
    str = '';
    for (i$ = 0, len$ = (ref$ = commitword).length; i$ < len$; ++i$) {
      word = ref$[i$];
      str = number % 10000 + str;
      number = Math.floor(number / 10000);
      if (number > 0) {
        str = word + str;
      } else {
        break;
      }
    }
    return str;
  };
  approximate_positive = function(number, args){
    var str, log1000, base, smart, ref$, extra_decimal, index, result, _, digits;
    if (args.base == null) {
      str = number.toString();
      log1000 = Math.floor(str.length / 4);
      if (log1000 < 1) {
        return str;
      }
      base = commitword[log1000 - 1];
    } else {
      base = args.base;
    }
    smart = (ref$ = args.smart) != null ? ref$ : true;
    extra_decimal = (ref$ = args.extra_decimal) != null ? ref$ : 0;
    if (args.extra_decimal != null) {
      smart = false;
    }
    number = annotate_positive(number);
    index = number.indexOf(base);
    if (index < 0) {
      return number;
    }
    result = number.substr(0, index);
    if (smart && result.length < 2 && extra_decimal === 0) {
      extra_decimal = 1;
    }
    if (extra_decimal > 0) {
      ref$ = number.substr(index + 1).match(/^(\d+)/), _ = ref$[0], digits = ref$[1];
      digits = repeatString$('0', 4 - digits.length) + digits;
      result += '.' + digits.substr(0, extra_decimal);
    }
    return result + base;
  };
  input_filter = function(func_expects_positive){
    return function(){
      var ref$, number, args, tmp;
      ref$ = Array.prototype.slice.call(arguments), number = ref$[0], args = ref$[1];
      if (typeof number === 'string') {
        tmp = string2number(number);
        if (tmp === void 8) {
          return number;
        }
        number = tmp;
      }
      if (number < 0) {
        return ((ref$ = args != null ? args.negative_prefix : void 8) != null ? ref$ : '-') + func_expects_positive.call(this, -number, args);
      } else {
        return func_expects_positive.call(this, number, args);
      }
    };
  };
  annotate = input_filter(annotate_positive);
  approximate = input_filter(approximate_positive);
  module.exports = {
    parseZHNumber: parseZHNumber,
    annotate: annotate,
    approximate: approximate
  };
  function in$(x, xs){
    var i = -1, l = xs.length >>> 0;
    while (++i < l) if (x === xs[i]) return true;
    return false;
  }
  function repeatString$(str, n){
    for (var r = ''; n > 0; (n >>= 1) && (str += str)) if (n & 1) r += str;
    return r;
  }
}).call(this);

global.zhutil = module.exports;
}({ exports: {} }, function(){ return this; }());