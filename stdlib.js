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
  ((function(iteratableminus39749) {
      for (index in iteratableminus39749)      {
      ((function(index, element) {
              return (((function() {
                  init = ((flessThanitampersandacgreaterThan)(element, init));
          return (undefined);
          })()));
        })(index, (iteratableminus39749)[index]));
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
var first = function(sharpQuoteArgminus39750) {
  return ((sharpQuoteArgminus39750)[0]);
  };
var second = function(sharpQuoteArgminus39751) {
  return ((sharpQuoteArgminus39751)[1]);
  };
var third = function(sharpQuoteArgminus39752) {
  return ((sharpQuoteArgminus39752)[2]);
  };
var fourth = function(sharpQuoteArgminus39753) {
  return ((sharpQuoteArgminus39753)[3]);
  };
var fifth = function(sharpQuoteArgminus39754) {
  return ((sharpQuoteArgminus39754)[4]);
  };
var sixth = function(sharpQuoteArgminus39755) {
  return ((sharpQuoteArgminus39755)[5]);
  };
var seventh = function(sharpQuoteArgminus39756) {
  return ((sharpQuoteArgminus39756)[6]);
  };
var nth = function(n, a) {
  return ((function(sharpQuoteArgminus39757) {
      return ((sharpQuoteArgminus39757)[n]);
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
  return (((function(iteratableminus39758) {
      for (index in iteratableminus39758)      {
      ((function(index, element) {
              return ((console.log)(element));
        })(index, (iteratableminus39758)[index]));
      };
    return (undefined);
    })((argumentsminusgreaterThanarray)(arguments))));
  };
