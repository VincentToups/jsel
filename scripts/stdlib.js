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
  ((function(iteratableminus128230) {
      for (index in iteratableminus128230)      {
      ((function(index, element) {
              return (((function() {
                  init = ((flessThanitampersandacgreaterThan)(element, init));
          return (undefined);
          })()));
        })(index, (iteratableminus128230)[index]));
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
var first = function(sharpQuoteArgminus128232) {
  return ((sharpQuoteArgminus128232)[0]);
  };
var second = function(sharpQuoteArgminus128233) {
  return ((sharpQuoteArgminus128233)[1]);
  };
var third = function(sharpQuoteArgminus128234) {
  return ((sharpQuoteArgminus128234)[2]);
  };
var fourth = function(sharpQuoteArgminus128235) {
  return ((sharpQuoteArgminus128235)[3]);
  };
var fifth = function(sharpQuoteArgminus128236) {
  return ((sharpQuoteArgminus128236)[4]);
  };
var sixth = function(sharpQuoteArgminus128237) {
  return ((sharpQuoteArgminus128237)[5]);
  };
var seventh = function(sharpQuoteArgminus128238) {
  return ((sharpQuoteArgminus128238)[6]);
  };
var nth = function(n, a) {
  return ((function(sharpQuoteArgminus128240) {
      return ((sharpQuoteArgminus128240)[n]);
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
  return (((function(iteratableminus128241) {
      for (index in iteratableminus128241)      {
      ((function(index, element) {
              return (((console).log)(element));
        })(index, (iteratableminus128241)[index]));
      };
    return (undefined);
    })((argumentsminusgreaterThanarray)(arguments))));
  };
((function(testVariable) {
  return (((function() {
      ((stdlib).incr)(testVariable);
    ((stdlib).incr)(testVariable);
    ((stdlib).incr)(testVariable);
    return (testVariable);
    })()));
  })(0));
var testModule = ((function(primitiveModuleD7421bf4cdc04a8200155c2dac670ade) {
  var (primitiveModuleD7421bf4cdc04a8200155c2dac670ade).x = 10;
  var (primitiveModuleD7421bf4cdc04a8200155c2dac670ade).+x = function(y) {
      return ((plus)(y, x));
    };
  ;
  return (primitiveModuleD7421bf4cdc04a8200155c2dac670ade);
  })({}));
((function(x) {
  ((function() {
      x = ((minus)(x, 1));
    return (undefined);
    })());
  ((function() {
      x = ((minus)(x, 1));
    return (undefined);
    })());
  return (x);
  })(10));
