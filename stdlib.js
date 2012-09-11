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
  ((function(iteratableminus60156) {
      for (index in iteratableminus60156)      {
      ((function(index, element) {
              return (((function() {
                  init = ((flessThanitampersandacgreaterThan)(element, init));
          return (undefined);
          })()));
        })(index, (iteratableminus60156)[index]));
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
var first = function(sharpQuoteArgminus60157) {
  return ((sharpQuoteArgminus60157)[0]);
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
