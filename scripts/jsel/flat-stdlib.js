;
;
;
;
var tests = ((function(arguments, object78254) {
  return (object78254);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
var TestResults = function(successes, failures) {
  (log)("Entering Test-Results");
  ((this).successes = (successes), undefined);
  ((this).failures = (failures), undefined);
  ((this).toString = (function() {
      return ((plus)("Test-results: ", (this).successes.length, " successes, \n", (this).failures.length, " failures, \n", "names of failed tests: \n[", (((map1)(function(sharpQuoteArgminus78256) {
          return ((sharpQuoteArgminus78256)["name"]);
      }, (this).failures)).join)(", "), "]"));
    }), undefined);
  return (this);
  };
var timeslastArgstimes = undefined;
var runTests = function() {
  (timeslastArgstimes = (arguments), undefined);
  return (((equalequalequal)(0, (arguments).length) ? ((function(arguments, successes, failures) {
      (log)("0 case");
    ((function(arguments, iteratableminus78257) {
          for (index in iteratableminus78257)        {
        ((function(arguments, index, element) {
                  return ((((element)["testLambda"])() ? ((successes).push)(element) : ((failures).push)(element)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus78257)[index]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), tests));
    return ((new TestResults(successes, failures)));
    })((("undefined"===((typeof arguments))) ? undefined : arguments), [], [])) : ((function(arguments, successes, failures) {
      (log)("arguments case");
    ((function(arguments, iteratableminus78259) {
          for (index in iteratableminus78259)        {
        ((function(arguments, index, element) {
                  return (((function(arguments, test) {
                      return ((("undefined"===((typeof test))) ? ((function(arguments) {
                          throw (plus)("Undefined test ", index, ".");
              return (undefined);
              })((("undefined"===((typeof arguments))) ? undefined : arguments))) : ((function(arguments, result) {
                          return ((result ? ((successes).push)(test) : ((failures).push)(test)));
              })((("undefined"===((typeof arguments))) ? undefined : arguments), (funcall)((test)["testLambda"])))));
            })((("undefined"===((typeof arguments))) ? undefined : arguments), (tests)[element])));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus78259)[index]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), arguments));
    return ((new TestResults(successes, failures)));
    })((("undefined"===((typeof arguments))) ? undefined : arguments), [], []))));
  };
(tests["thisTestFailsOnPurpose"] = (((function(arguments, object78260) {
  (object78260["name"] = ("thisTestFailsOnPurpose"), undefined);
  (object78260["description"] = ("A test to test test failure."), undefined);
  (object78260["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, false));
    }), undefined);
  return (object78260);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
var leftFold = function(flessThanitAcgreaterThan, init, a) {
  ((function(arguments, iteratableminus78261) {
      for (index in iteratableminus78261)      {
      ((function(arguments, index, element) {
              return ((init = ((flessThanitAcgreaterThan)(element, init)), undefined));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus78261)[index]));
      };
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), a));
  return (init);
  };
var primitiveminusequalequalequal = function(a, b) {
  return (a===b);
  };
var first = function(sharpQuoteArgminus78262) {
  return ((sharpQuoteArgminus78262)[0]);
  };
var second = function(sharpQuoteArgminus78263) {
  return ((sharpQuoteArgminus78263)[1]);
  };
var third = function(sharpQuoteArgminus78264) {
  return ((sharpQuoteArgminus78264)[2]);
  };
var fourth = function(sharpQuoteArgminus78265) {
  return ((sharpQuoteArgminus78265)[3]);
  };
var fifth = function(sharpQuoteArgminus78266) {
  return ((sharpQuoteArgminus78266)[4]);
  };
var log = function(x) {
  return (((((not)(("undefined"===((typeof console)))))&&((not)(("undefined"===((typeof (console).log)))))) ? ((console).log)(x) : ((not)(("undefined"===((typeof print)))) ? (print)(x) : undefined)));
  };
var equalequalequal = function() {
  return (((function(arguments, outsideArguments) {
      return (((function(arguments, falseSigil, result) {
          var falseSigil = "falseSigilB19113bd3c014c13a056876994fce043";
      var result = (leftFold)(function(it, ac) {
              return (((primitiveminusequalequalequal)(ac, falseSigil) ? falseSigil : ((primitiveminusequalequalequal)(it, ac) ? it : ((not)((primitiveminusequalequalequal)(it, ac)) ? falseSigil : ((function(arguments) {
                  throw "Cond fell through without any branch being true.";
          return (undefined);
          })((("undefined"===((typeof arguments))) ? undefined : arguments)))))));
        }, (first)(outsideArguments), (rest)((argumentsminusgreaterThanarray)(outsideArguments)));
      return (((primitiveminusequalequalequal)(falseSigil, result) ? false : true));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined, undefined)));
    })((("undefined"===((typeof arguments))) ? undefined : arguments), arguments)));
  };
(tests["equalequalequalTest1"] = (((function(arguments, object78267) {
  (object78267["name"] = ("equalequalequalTest1"), undefined);
  (object78267["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object78267["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, (equalequalequal)("a", "a")));
    }), undefined);
  return (object78267);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest2"] = (((function(arguments, object78268) {
  (object78268["name"] = ("equalequalequalTest2"), undefined);
  (object78268["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object78268["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(false, (equalequalequal)("a", "b")));
    }), undefined);
  return (object78268);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest3"] = (((function(arguments, object78269) {
  (object78269["name"] = ("equalequalequalTest3"), undefined);
  (object78269["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object78269["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, (equalequalequal)("a", "a", "a")));
    }), undefined);
  return (object78269);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest4"] = (((function(arguments, object78270) {
  (object78270["name"] = ("equalequalequalTest4"), undefined);
  (object78270["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object78270["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, (equalequalequal)(5, 5, 5)));
    }), undefined);
  return (object78270);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest5"] = (((function(arguments, object78271) {
  (object78271["name"] = ("equalequalequalTest5"), undefined);
  (object78271["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object78271["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(false, (equalequalequal)(5, 5, 4)));
    }), undefined);
  return (object78271);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
var map1 = function(f, anArray) {
  return (((function(arguments, output) {
      ((function(arguments, iteratableminus78272) {
          for (index in iteratableminus78272)        {
        ((function(arguments, index, element) {
                  return (((output).push)((f)(element)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus78272)[index]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), anArray));
    return (output);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), [])));
  };
var plus = function() {
  var total = (arguments)[0];
  ((function(arguments, iteratableminus78273) {
      for (i in iteratableminus78273)      {
      ((function(arguments, i, el) {
              return ((total = (total+el), undefined));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), i, (iteratableminus78273)[i]));
      };
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), (rest)((argumentsminusgreaterThanarray)(arguments))));
  return (total);
  };
(tests["plusBinary"] = (((function(arguments, object78337) {
  (object78337["name"] = ("plusBinary"), undefined);
  (object78337["description"] = ("Test two argument addition."), undefined);
  (object78337["testLambda"] = (function() {
      return ((equalequalequal)(4, (plus)(2, 2)));
    }), undefined);
  return (object78337);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["plusTrinary"] = (((function(arguments, object78338) {
  (object78338["name"] = ("plusTrinary"), undefined);
  (object78338["description"] = ("Test three argument addition."), undefined);
  (object78338["testLambda"] = (function() {
      return ((equalequalequal)(6, (plus)(2, 2, 2)));
    }), undefined);
  return (object78338);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["plusStrings"] = (((function(arguments, object78339) {
  (object78339["name"] = ("plusStrings"), undefined);
  (object78339["description"] = ("Test plus for strings."), undefined);
  (object78339["testLambda"] = (function() {
      return ((equalequalequal)("abcdef", (plus)("abc", "def")));
    }), undefined);
  return (object78339);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var greaterThan = function(a, b) {
  return (a>b);
  };
var greaterThanequal = function(a, b) {
  return (a>=b);
  };
var lessThan = function(a, b) {
  return (a<b);
  };
var lessThanequal = function(a, b) {
  return (a<=b);
  };
var modsign = function(a, b) {
  return (a%b);
  };
var minus = function() {
  return (((greaterThan)((arguments).length, 1) ? ((function(arguments, value) {
      ((function(arguments, iteratableminus78340) {
          for (i in iteratableminus78340)        {
        ((function(arguments, i, el) {
                  return (((greaterThan)(i, 0) ? (value = (value-el), undefined) : undefined));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), i, (iteratableminus78340)[i]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), arguments));
    return (value);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), (arguments)[0])) : ((function(arguments, value) {
      return (-value);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), (arguments)[0]))));
  };
(tests["minusNegation"] = (((function(arguments, object78380) {
  (object78380["name"] = ("minusNegation"), undefined);
  (object78380["description"] = (""), undefined);
  (object78380["testLambda"] = (function() {
      return ((equalequalequal)(-1, (minus)(1)));
    }), undefined);
  return (object78380);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["minusBinary"] = (((function(arguments, object78381) {
  (object78381["name"] = ("minusBinary"), undefined);
  (object78381["description"] = (""), undefined);
  (object78381["testLambda"] = (function() {
      return ((equalequalequal)(-1, (minus)(0, 1)));
    }), undefined);
  return (object78381);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["minusTrinary"] = (((function(arguments, object78382) {
  (object78382["name"] = ("minusTrinary"), undefined);
  (object78382["description"] = (""), undefined);
  (object78382["testLambda"] = (function() {
      return ((equalequalequal)(0, (minus)(3, 2, 1)));
    }), undefined);
  return (object78382);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var not = function(v) {
  return (!v);
  };
var times = function() {
  var value = 1;
  ((function(arguments, iteratableminus78383) {
      for (i in iteratableminus78383)      {
      ((function(arguments, i, el) {
              return ((value = (el*value), undefined));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), i, (iteratableminus78383)[i]));
      };
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), arguments));
  return (value);
  };
(tests["timesBinary"] = (((function(arguments, object78417) {
  (object78417["name"] = ("timesBinary"), undefined);
  (object78417["description"] = (""), undefined);
  (object78417["testLambda"] = (function() {
      return ((equalequalequal)(4, (times)(2, 2)));
    }), undefined);
  return (object78417);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["timesTrinary"] = (((function(arguments, object78418) {
  (object78418["name"] = ("timesTrinary"), undefined);
  (object78418["description"] = (""), undefined);
  (object78418["testLambda"] = (function() {
      return ((equalequalequal)((times)(2, 2, 2), 8));
    }), undefined);
  return (object78418);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var rest = function(anArray) {
  return (((anArray).slice)(1));
  };
var argumentsminusgreaterThanarray = function(anArguments) {
  return ((([]).slice.apply)(anArguments));
  };
var simpleApply = function(f, anArray) {
  return (((f).apply)(f, anArray));
  };
var divide = function() {
  var numerator = (arguments)[0];
  var denominator = (simpleApply)(times, (rest)((argumentsminusgreaterThanarray)(arguments)));
  return (numerator/denominator);
  };
(tests["divideBinary"] = (((function(arguments, object78453) {
  (object78453["name"] = ("divideBinary"), undefined);
  (object78453["description"] = (""), undefined);
  (object78453["testLambda"] = (function() {
      return ((equalequalequal)((divide)(4, 2), 2));
    }), undefined);
  return (object78453);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["divideTrinary"] = (((function(arguments, object78454) {
  (object78454["name"] = ("divideTrinary"), undefined);
  (object78454["description"] = (""), undefined);
  (object78454["testLambda"] = (function() {
      return ((equalequalequal)((divide)(10.0, 2, 1), 5.0));
    }), undefined);
  return (object78454);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var functionAnd = function() {
  return (((primitiveminusequalequalequal)(0, (arguments).length) ? true : ((not)(((arguments)[0])()) ? false : (simpleApply)(functionAnd, (rest)((argumentsminusgreaterThanarray)(arguments))))));
  };
;
(tests["andArgumentEvaluation"] = (((function(arguments, object78484) {
  (object78484["name"] = ("andArgumentEvaluation"), undefined);
  (object78484["description"] = (""), undefined);
  (object78484["testLambda"] = (function() {
      return (((function(arguments, a) {
          (functionAnd)(function() {
              return (false);
        }, function() {
              return ((a = (10), undefined));
        });
      return ((equalequalequal)(a, 0));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), 0)));
    }), undefined);
  return (object78484);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var functionOr = function() {
  return (((equalequalequal)(0, (arguments).length) ? ((function(arguments) {
      throw "Or cannot be invoked with zero arguments.";
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments))) : ((equalequalequal)(1, (arguments).length) ? (((argument)[0])() ? true : false) : ("otherwise" ? (((arguments)[0])() ? true : (simpleminus)(apply, functionOr, (rest)((argumentsminusgreaterThanarray)(arguments)))) : ((function(arguments) {
      throw "Cond fell through without any branch being true.";
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments)))))));
  };
;
(tests["orArgumentEvaluation"] = (((function(arguments, object78515) {
  (object78515["name"] = ("orArgumentEvaluation"), undefined);
  (object78515["description"] = (""), undefined);
  (object78515["testLambda"] = (function() {
      return (((function(arguments, a) {
          (functionOr)(function() {
              return (true);
        }, function() {
              return ((a = (10), undefined));
        });
      return ((equalequalequal)(a, 0));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), 0)));
    }), undefined);
  return (object78515);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
/*
Some macros.
*/
;
;
;
var plusminus1 = function(a) {
  (a = ((plus)(1, a)), undefined);
  return (a);
  };
var minusminus1 = function(a) {
  (a = ((minus)(a, 1)), undefined);
  return (a);
  };
(tests["trivialTest"] = (((function(arguments, object78518) {
  (object78518["name"] = ("trivialTest"), undefined);
  (object78518["description"] = ("A totally trivial test."), undefined);
  (object78518["testLambda"] = (function() {
      return ((equalequalequal)(true, true));
    }), undefined);
  return (object78518);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
var numberwho = function(o) {
  return ((equalequalequal)("number", (typeof o)));
  };
(tests["numberwhoIsNumber"] = (((function(arguments, object78552) {
  (object78552["name"] = ("numberwhoIsNumber"), undefined);
  (object78552["description"] = (""), undefined);
  (object78552["testLambda"] = (function() {
      return ((equalequalequal)(true, (numberwho)(10)));
    }), undefined);
  return (object78552);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["numberwhoIsNotNumber"] = (((function(arguments, object78553) {
  (object78553["name"] = ("numberwhoIsNotNumber"), undefined);
  (object78553["description"] = (""), undefined);
  (object78553["testLambda"] = (function() {
      return ((equalequalequal)(false, (numberwho)("10")));
    }), undefined);
  return (object78553);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var arraywho = function(o) {
  return ((equalequalequal)(((Object).prototype.toString.call)(o), "[object Array]"));
  };
(tests["arraywhoIsArray"] = (((function(arguments, object78587) {
  (object78587["name"] = ("arraywhoIsArray"), undefined);
  (object78587["description"] = (""), undefined);
  (object78587["testLambda"] = (function() {
      return ((equalequalequal)(true, (arraywho)([])));
    }), undefined);
  return (object78587);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["arraywhoIsNotArray"] = (((function(arguments, object78588) {
  (object78588["name"] = ("arraywhoIsNotArray"), undefined);
  (object78588["description"] = (""), undefined);
  (object78588["testLambda"] = (function() {
      return ((equalequalequal)(false, (arraywho)(10)));
    }), undefined);
  return (object78588);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var jsonEqual = function(a, b) {
  return ((equalequalequal)(((JSON).stringify)(a), ((JSON).stringify)(b)));
  };
(tests["jsonEqualTrueCase"] = (((function(arguments, object78622) {
  (object78622["name"] = ("jsonEqualTrueCase"), undefined);
  (object78622["description"] = (""), undefined);
  (object78622["testLambda"] = (function() {
      return ((equalequalequal)(true, (jsonEqual)([1, 2, 3], [1, 2, 3])));
    }), undefined);
  return (object78622);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["jsonEqualFalseCase"] = (((function(arguments, object78623) {
  (object78623["name"] = ("jsonEqualFalseCase"), undefined);
  (object78623["description"] = (""), undefined);
  (object78623["testLambda"] = (function() {
      return ((equalequalequal)(false, (jsonEqual)("[1 2 3]", [1, 2, 3])));
    }), undefined);
  return (object78623);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
;
var timesmatchFailtimes = ((function(arguments, object78625) {
  return (object78625);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
var recurValueStack = [];
var recurValue = function() {
  return ((first)(recurValueStack));
  };
var array = function() {
  return ((argumentsminusgreaterThanarray)(arguments));
  };
var prefix = function(element, anArray) {
  return (([element]).(concat)(anArray));
  };
var toStringtimes = function(o) {
  return ((("undefined"===((typeof JSON))) ? ((o).toString)() : ((JSON).stringify)(o)));
  };
var RecurHandle = function(keyValue, arguments) {
  ((this).keyValue = (keyValue), undefined);
  ((this).arguments = (arguments), undefined);
  ((this).toString = (function() {
      return ((plus)("Recur-Handle ", ((map1)(toStringtimes, (this).arguments))((join)(" "))));
    }), undefined);
  return (this);
  };
var currentRecurValue = function() {
  return ((recurValueStack)[(minus)((recurValueStack).length, 1)]);
  };
;
var peek = function(anArray) {
  return ((anArray)[(minus)((anArray).length, 1)]);
  };
var localRecurHandleP = function(v) {
  return ((functionAnd)(function() {
      return ((v instanceof RecurHandle));
    }, function() {
      return ((equalequalequal)((v).keyValue, (currentRecurValue)()));
    }));
  };
;
;
(tests["letdividerecurSimplest"] = (((function(arguments, object78663) {
  (object78663["name"] = ("letdividerecurSimplest"), undefined);
  (object78663["description"] = (""), undefined);
  (object78663["testLambda"] = (function() {
      return ((equalequalequal)("success", ((function(arguments, jselcolonautoGensymRecurObjectminus78664) {
          return (((function(arguments, recur) {
              return (((function(arguments, tryRetval78665) {
                  try            {
            ((recurValueStack).push)(jselcolonautoGensymRecurObjectminus78664);
            (tryRetval78665 = (((function(arguments, jselcolonautoGensymFminus78667, jselcolonautoGensymDoneminus78669, jselcolonautoGensymResultminus78668, jselcolonautoGensymArgumentsminus78670) {
                          ((function(arguments) {
                              while ((not)(jselcolonautoGensymDoneminus78669))                  {
                  (jselcolonautoGensymResultminus78668 = ((simpleApply)(jselcolonautoGensymFminus78667, jselcolonautoGensymArgumentsminus78670)), undefined);
                  ((localRecurHandleP)(jselcolonautoGensymResultminus78668) ? (jselcolonautoGensymArgumentsminus78670 = ((jselcolonautoGensymResultminus78668).arguments), undefined) : (jselcolonautoGensymDoneminus78669 = (true), undefined));
                  };
                return (undefined);
                })((("undefined"===((typeof arguments))) ? undefined : arguments)));
              return (jselcolonautoGensymResultminus78668);
              })((("undefined"===((typeof arguments))) ? undefined : arguments), function(x, y) {
                          return ("success");
              }, false, null, [1, 1]))), undefined);
            }catch (exceptionminus78666)            {
            ((function(arguments) {
                          throw exceptionminus78666;
              return (undefined);
              })((("undefined"===((typeof arguments))) ? undefined : arguments)));
            }finally            {
            ((recurValueStack).pop)();
            };
          return (tryRetval78665);
          })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined)));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), function() {
              return ((new RecurHandle(jselcolonautoGensymRecurObjectminus78664, (argumentsminusgreaterThanarray)(arguments))));
        })));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), ((function(arguments, object78671) {
          return (object78671);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))))));
    }), undefined);
  return (object78663);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["letdividerecurALoop"] = (((function(arguments, object78672) {
  (object78672["name"] = ("letdividerecurALoop"), undefined);
  (object78672["description"] = (""), undefined);
  (object78672["testLambda"] = (function() {
      return ((equalequalequal)(10, ((function(arguments, jselcolonautoGensymRecurObjectminus78673) {
          return (((function(arguments, recur) {
              return (((function(arguments, tryRetval78674) {
                  try            {
            ((recurValueStack).push)(jselcolonautoGensymRecurObjectminus78673);
            (tryRetval78674 = (((function(arguments, jselcolonautoGensymFminus78676, jselcolonautoGensymDoneminus78678, jselcolonautoGensymResultminus78677, jselcolonautoGensymArgumentsminus78679) {
                          ((function(arguments) {
                              while ((not)(jselcolonautoGensymDoneminus78678))                  {
                  (jselcolonautoGensymResultminus78677 = ((simpleApply)(jselcolonautoGensymFminus78676, jselcolonautoGensymArgumentsminus78679)), undefined);
                  ((localRecurHandleP)(jselcolonautoGensymResultminus78677) ? (jselcolonautoGensymArgumentsminus78679 = ((jselcolonautoGensymResultminus78677).arguments), undefined) : (jselcolonautoGensymDoneminus78678 = (true), undefined));
                  };
                return (undefined);
                })((("undefined"===((typeof arguments))) ? undefined : arguments)));
              return (jselcolonautoGensymResultminus78677);
              })((("undefined"===((typeof arguments))) ? undefined : arguments), function(x) {
                          return (((lessThan)(x, 10) ? (recur)((plus)(x, 1)) : x));
              }, false, null, [0]))), undefined);
            }catch (exceptionminus78675)            {
            ((function(arguments) {
                          throw exceptionminus78675;
              return (undefined);
              })((("undefined"===((typeof arguments))) ? undefined : arguments)));
            }finally            {
            ((recurValueStack).pop)();
            };
          return (tryRetval78674);
          })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined)));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), function() {
              return ((new RecurHandle(jselcolonautoGensymRecurObjectminus78673, (argumentsminusgreaterThanarray)(arguments))));
        })));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), ((function(arguments, object78680) {
          return (object78680);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))))));
    }), undefined);
  return (object78672);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
;
;
;
(tests["match1Array"] = (((function(arguments, object78741) {
  (object78741["name"] = ("match1Array"), undefined);
  (object78741["description"] = (""), undefined);
  (object78741["testLambda"] = (function() {
      return ((equalequalequal)(6, ((function(arguments, value78804) {
          return (((functionAnd)(function() {
              return ((arraywho)(value78804));
        }, function() {
              return ((greaterThan)((value78804).length, 0));
        }) ? ((function(arguments, hdminus78805, tlminus78806) {
              return (((function(arguments, x) {
                  return (((function(arguments, value78873) {
                      return (((functionAnd)(function() {
                          return ((arraywho)(value78873));
              }, function() {
                          return ((greaterThan)((value78873).length, 0));
              }) ? ((function(arguments, hdminus78874, tlminus78875) {
                          return (((function(arguments, y) {
                              return (((function(arguments, value78942) {
                                  return (((functionAnd)(function() {
                                      return ((arraywho)(value78942));
                    }, function() {
                                      return ((greaterThan)((value78942).length, 0));
                    }) ? ((function(arguments, hdminus78943, tlminus78944) {
                                      return (((function(arguments, z) {
                                          return (((function(arguments, value78978) {
                                              return (((functionAnd)(function() {
                                                  return ((arraywho)(value78978));
                          }, function() {
                                                  return ((equalequalequal)(0, (value78978).length));
                          }) ? (plus)(x, y, z) : timesmatchFailtimes));
                        })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus78944)));
                      })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus78943)));
                    })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value78942), (rest)(value78942))) : undefined));
                  })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus78875)));
                })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus78874)));
              })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value78873), (rest)(value78873))) : undefined));
            })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus78806)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus78805)));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value78804), (rest)(value78804))) : undefined));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), [1, 2, 3]))));
    }), undefined);
  return (object78741);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1LiteralNumber"] = (((function(arguments, object78979) {
  (object78979["name"] = ("match1LiteralNumber"), undefined);
  (object78979["description"] = (""), undefined);
  (object78979["testLambda"] = (function() {
      return ((equalequalequal)("matched", ((function(arguments, value78990) {
          return (((equalequalequal)(value78990, 10) ? "matched" : timesmatchFailtimes));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), 10))));
    }), undefined);
  return (object78979);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1LiteralString"] = (((function(arguments, object78991) {
  (object78991["name"] = ("match1LiteralString"), undefined);
  (object78991["description"] = (""), undefined);
  (object78991["testLambda"] = (function() {
      return ((equalequalequal)("matched", ((function(arguments, value79005) {
          return (((equalequalequal)(value79005, "x") ? "matched" : timesmatchFailtimes));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), "x"))));
    }), undefined);
  return (object78991);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1Arrayplus"] = (((function(arguments, object79006) {
  (object79006["name"] = ("match1Arrayplus"), undefined);
  (object79006["description"] = (""), undefined);
  (object79006["testLambda"] = (function() {
      return ((jsonEqual)([1, 2, 3], ((function(arguments, value79058) {
          return (((functionAnd)(function() {
              return ((arraywho)(value79058));
        }, function() {
              return ((greaterThan)((value79058).length, 0));
        }) ? ((function(arguments, hdminus79059, tlminus79060) {
              return (((function(arguments, a) {
                  return (((function(arguments, value79083) {
                      return (((arraywho)(value79083) ? ((function(arguments, tail) {
                          return (tail);
              })((("undefined"===((typeof arguments))) ? undefined : arguments), value79083)) : timesmatchFailtimes));
            })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus79060)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus79059)));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value79058), (rest)(value79058))) : undefined));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), [0, 1, 2, 3]))));
    }), undefined);
  return (object79006);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1ObjectMatch1"] = (((function(arguments, object79088) {
  (object79088["name"] = ("match1ObjectMatch1"), undefined);
  (object79088["description"] = (""), undefined);
  (object79088["testLambda"] = (function() {
      return ((equalequalequal)("match", ((function(arguments, jselcolonautoGensymTheObjectminus79178, jselcolonautoGensymKeyValueminus79179, jselcolonautoGensymRefValueminus79180) {
          var jselcolonautoGensymTheObjectminus79178 = ((function(arguments, object79181) {
              (object79181["x"] = (20), undefined);
        return (object79181);
        })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
      var jselcolonautoGensymKeyValueminus79179 = "x";
      var jselcolonautoGensymRefValueminus79180 = (jselcolonautoGensymTheObjectminus79178)[jselcolonautoGensymKeyValueminus79179];
      return (((function(arguments, value79192) {
              return (((equalequalequal)(value79192, 20) ? "match" : timesmatchFailtimes));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), jselcolonautoGensymRefValueminus79180)));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined, undefined, undefined))));
    }), undefined);
  return (object79088);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1ObjectMatch2"] = (((function(arguments, object79234) {
  (object79234["name"] = ("match1ObjectMatch2"), undefined);
  (object79234["description"] = (""), undefined);
  (object79234["testLambda"] = (function() {
      return ((equalequalequal)(timesmatchFailtimes, ((function(arguments, jselcolonautoGensymTheObjectminus79324, jselcolonautoGensymKeyValueminus79325, jselcolonautoGensymRefValueminus79326) {
          var jselcolonautoGensymTheObjectminus79324 = ((function(arguments, object79327) {
              (object79327["x"] = (30), undefined);
        return (object79327);
        })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
      var jselcolonautoGensymKeyValueminus79325 = "x";
      var jselcolonautoGensymRefValueminus79326 = (jselcolonautoGensymTheObjectminus79324)[jselcolonautoGensymKeyValueminus79325];
      return (((function(arguments, value79338) {
              return (((equalequalequal)(value79338, 20) ? "match" : timesmatchFailtimes));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), jselcolonautoGensymRefValueminus79326)));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined, undefined, undefined))));
    }), undefined);
  return (object79234);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
(log)((runTests)());
(log)(((function(arguments, jselcolonautoGensymRecurObjectminus79380) {
  return (((function(arguments, recur) {
      return (((function(arguments, tryRetval79381) {
          try        {
        ((recurValueStack).push)(jselcolonautoGensymRecurObjectminus79380);
        (tryRetval79381 = (((function(arguments, jselcolonautoGensymFminus79383, jselcolonautoGensymDoneminus79385, jselcolonautoGensymResultminus79384, jselcolonautoGensymArgumentsminus79386) {
                  ((function(arguments) {
                      while ((not)(jselcolonautoGensymDoneminus79385))              {
              (jselcolonautoGensymResultminus79384 = ((simpleApply)(jselcolonautoGensymFminus79383, jselcolonautoGensymArgumentsminus79386)), undefined);
              ((localRecurHandleP)(jselcolonautoGensymResultminus79384) ? (jselcolonautoGensymArgumentsminus79386 = ((jselcolonautoGensymResultminus79384).arguments), undefined) : (jselcolonautoGensymDoneminus79385 = (true), undefined));
              };
            return (undefined);
            })((("undefined"===((typeof arguments))) ? undefined : arguments)));
          return (jselcolonautoGensymResultminus79384);
          })((("undefined"===((typeof arguments))) ? undefined : arguments), function(x) {
                  return (((lessThan)(x, 10) ? (recur)((plus)(x, 1)) : x));
          }, false, null, [0]))), undefined);
        }catch (exceptionminus79382)        {
        ((function(arguments) {
                  throw exceptionminus79382;
          return (undefined);
          })((("undefined"===((typeof arguments))) ? undefined : arguments)));
        }finally        {
        ((recurValueStack).pop)();
        };
      return (tryRetval79381);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined)));
    })((("undefined"===((typeof arguments))) ? undefined : arguments), function() {
      return ((new RecurHandle(jselcolonautoGensymRecurObjectminus79380, (argumentsminusgreaterThanarray)(arguments))));
    })));
  })((("undefined"===((typeof arguments))) ? undefined : arguments), ((function(arguments, object79387) {
  return (object79387);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {})))));
