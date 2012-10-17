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
  ((function(iteratableminus69039) {
      for (index in iteratableminus69039)      {
      ((function(index, element) {
              return (((function() {
                  init = ((flessThanitampersandacgreaterThan)(element, init));
          return (undefined);
          })()));
        })(index, (iteratableminus69039)[index]));
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
var first = function(sharpQuoteArgminus69041) {
  return ((sharpQuoteArgminus69041)[0]);
  };
var second = function(sharpQuoteArgminus69042) {
  return ((sharpQuoteArgminus69042)[1]);
  };
var third = function(sharpQuoteArgminus69043) {
  return ((sharpQuoteArgminus69043)[2]);
  };
var fourth = function(sharpQuoteArgminus69044) {
  return ((sharpQuoteArgminus69044)[3]);
  };
var fifth = function(sharpQuoteArgminus69045) {
  return ((sharpQuoteArgminus69045)[4]);
  };
var sixth = function(sharpQuoteArgminus69046) {
  return ((sharpQuoteArgminus69046)[5]);
  };
var seventh = function(sharpQuoteArgminus69047) {
  return ((sharpQuoteArgminus69047)[6]);
  };
var nth = function(n, a) {
  return ((function(sharpQuoteArgminus69049) {
      return ((sharpQuoteArgminus69049)[n]);
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
  return (((function(iteratableminus69050) {
      for (index in iteratableminus69050)      {
      ((function(index, element) {
              return (((console).log)(element));
        })(index, (iteratableminus69050)[index]));
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
(require)(["jsel/test-module", "jsel/stdlib"], function(tm, jseldividestdlib) {
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
    (log)("test mod: ", ((jseldividestdlib).modsign)(10, 4));
    return (((function(x) {
          ((function() {
              x = ((plus)(x, 1));
        return (undefined);
        })());
      return ((log)("x is: ", x));
      })(0)));
    })()));
  });
