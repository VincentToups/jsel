/*
Include: stdlib.jsel
*/
;
var primitiveminusplus = function(a, b) {
  return (a+b);
  };
var primitiveminusminus = function(a, b) {
  return (a-b);
  };
var primitiveminusdivide = function(a, b) {
  return (a/b);
  };
var primitiveminustimes = function(a, b) {
  return (a*b);
  };
var foldl = function(flessThanitampersandacgreaterThan, init, a) {
  ((function(iteratableminus91363) {
      for (index in iteratableminus91363)      {
      ((function(index, element) {
              return (((function() {
                  init = ((flessThanitampersandacgreaterThan)(element, init));
          return (undefined);
          })()));
        })(index, (iteratableminus91363)[index]));
      };
    return (undefined);
    })(a));
  return (init);
  };
var argumentsminusgreaterThanarray = function(anArguments) {
  return ((([]).slice.apply)(anArguments));
  };
/*
+ takes any number of arguments.
*/
;
var plus = function() {
  return ((foldl)(primitiveminusplus, 0, (argumentsminusgreaterThanarray)(arguments)));
  };
var first = function(sharpQuoteArgminus91365) {
  return ((sharpQuoteArgminus91365)[0]);
  };
var second = function(sharpQuoteArgminus91366) {
  return ((sharpQuoteArgminus91366)[1]);
  };
var third = function(sharpQuoteArgminus91367) {
  return ((sharpQuoteArgminus91367)[2]);
  };
var fourth = function(sharpQuoteArgminus91368) {
  return ((sharpQuoteArgminus91368)[3]);
  };
var fifth = function(sharpQuoteArgminus91369) {
  return ((sharpQuoteArgminus91369)[4]);
  };
var sixth = function(sharpQuoteArgminus91370) {
  return ((sharpQuoteArgminus91370)[5]);
  };
var seventh = function(sharpQuoteArgminus91371) {
  return ((sharpQuoteArgminus91371)[6]);
  };
var nth = function(n, a) {
  return ((function(sharpQuoteArgminus91373) {
      return ((sharpQuoteArgminus91373)[n]);
    })(a));
  };
var rest = function(a) {
  return (((a).slice)(1));
  };
/*
- takes any number of arguments
*/
;
var minus = function() {
  return (((function(argsArray) {
      return ((primitiveminusminus)((first)(argsArray), (foldl)(primitiveminusplus, 0, (rest)(argsArray))));
    })((argumentsminusgreaterThanarray)(arguments))));
  };
/*
* takes any number of arguments.
*/
;
var times = function() {
  return ((foldl)(primitiveminustimes, 1, (argumentsminusgreaterThanarray)(arguments)));
  };
/*
simple-apply takes a function and an array.
*/
;
var simpleApply = function(f, a) {
  return (((f).apply)(f, a));
  };
/*
/ takes any number of arguments
*/
;
var divide = function() {
  return ((primitiveminusdivide)((first)(arguments), (foldl)(primitiveminustimes, 1, (rest)((argumentsminusgreaterThanarray)(arguments)))));
  };
var primitiveminusequalequalequal = function(a, b) {
  return (a===b);
  };
var log = function() {
  return (((function(iteratableminus91374) {
      for (index in iteratableminus91374)      {
      ((function(index, element) {
              return (((console).log)(element));
        })(index, (iteratableminus91374)[index]));
      };
    return (undefined);
    })((argumentsminusgreaterThanarray)(arguments))));
  };
;
/*
document.addEventListener('DOMContentLoaded',function(){})
*/
;
(log)("At least here.");
(require)(["jsel/test-module"], function(tm) {
  return (((function() {
      (log)("Simple ready works.");
    var canvas = ((document).getElementById)("canvas");
    var context = ((canvas).getContext)("2d");
    ((function() {
          (context).font = ("38pt Arial");
      return (undefined);
      })());
    ((function() {
          (context).fillStyle = ("cornflowerblue");
      return (undefined);
      })());
    ((function() {
          (context).strokeStyle = ("blue");
      return (undefined);
      })());
    ((function(x, y) {
          ((context).fillText)("Hello Jsel", x, y);
      return (((context).strokeText)("Hello Jsel", x, y));
      })((minus)((divide)((canvas).width, 2), 150), (plus)((divide)((canvas).height, 2), 15)));
    return (((function(x) {
          ((function() {
              x = ((plus)(x, 1));
        return (undefined);
        })());
      return ((log)("x is: ", x));
      })(0)));
    })()));
  });
