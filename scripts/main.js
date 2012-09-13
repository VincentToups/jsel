;
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
  ((function(iteratableminus18574) {
      for (index in iteratableminus18574)      {
      ((function(index, element) {
              return (((function() {
                  init = ((flessThanitampersandacgreaterThan)(element, init));
          return (undefined);
          })()));
        })(index, (iteratableminus18574)[index]));
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
var first = function(sharpQuoteArgminus18575) {
  return ((sharpQuoteArgminus18575)[0]);
  };
var second = function(sharpQuoteArgminus18576) {
  return ((sharpQuoteArgminus18576)[1]);
  };
var third = function(sharpQuoteArgminus18577) {
  return ((sharpQuoteArgminus18577)[2]);
  };
var fourth = function(sharpQuoteArgminus18578) {
  return ((sharpQuoteArgminus18578)[3]);
  };
var fifth = function(sharpQuoteArgminus18579) {
  return ((sharpQuoteArgminus18579)[4]);
  };
var sixth = function(sharpQuoteArgminus18580) {
  return ((sharpQuoteArgminus18580)[5]);
  };
var seventh = function(sharpQuoteArgminus18581) {
  return ((sharpQuoteArgminus18581)[6]);
  };
var nth = function(n, a) {
  return ((function(sharpQuoteArgminus18582) {
      return ((sharpQuoteArgminus18582)[n]);
    })(a));
  };
var rest = function(a) {
  return ((a.slice)(1));
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
  return ((f.apply)(f, a));
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
  return (((function(iteratableminus18583) {
      for (index in iteratableminus18583)      {
      ((function(index, element) {
              return ((console.log)(element));
        })(index, (iteratableminus18583)[index]));
      };
    return (undefined);
    })((argumentsminusgreaterThanarray)(arguments))));
  };
;
/*
document.addEventListener('DOMContentLoaded',function(){})
*/
;
(document.addEventListener)("DOMContentLoaded", function() {
  (log)("Simple ready works.");
  var canvas = ((document).getElementById)("canvas");
  var context = ((canvas).getContext)("2d");
  ((function() {
      context.font = ("38pt Arial");
    return (undefined);
    })());
  ((function() {
      context.fillStyle = ("cornflowerblue");
    return (undefined);
    })());
  ((function() {
      context.strokeStyle = ("blue");
    return (undefined);
    })());
  ((function(x, y) {
      ((context).fillText)("Hello Jsel", x, y);
    return (((context).strokeText)("Hello Jsel", x, y));
    })((minus)((divide)(canvas.width, 2), 150), (plus)((divide)(canvas.height, 2), 15)));
  return (((function(x) {
      ((function() {
          x = ((plus)(1, x));
      return (undefined);
      })());
    return ((log)("x is: ", x));
    })(0)));
  });
