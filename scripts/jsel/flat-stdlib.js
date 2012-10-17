;
;
;
;
var tests = ((function(arguments, object15215) {
  return (object15215);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
var TestResults = function(successes, failures) {
  (log)("Entering Test-Results");
  ((this).successes = (successes), undefined);
  ((this).failures = (failures), undefined);
  ((this).toString = (function() {
      return ((plus)("Test-results: ", (this).successes.length, " successes, \n", (this).failures.length, " failures, \n", "names of failed tests: \n[", (((map1)(function(sharpQuoteArgminus15217) {
          return ((sharpQuoteArgminus15217)["name"]);
      }, (this).failures)).join)(", "), "]"));
    }), undefined);
  return (this);
  };
var timeslastArgstimes = undefined;
var runTests = function() {
  (timeslastArgstimes = (arguments), undefined);
  return (((equalequalequal)(0, (arguments).length) ? ((function(arguments, successes, failures) {
      (log)("0 case");
    ((function(arguments, iteratableminus15218) {
          for (index in iteratableminus15218)        {
        ((function(arguments, index, element) {
                  return ((((element)["testLambda"])() ? ((successes).push)(element) : ((failures).push)(element)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus15218)[index]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), tests));
    return ((new TestResults(successes, failures)));
    })((("undefined"===((typeof arguments))) ? undefined : arguments), [], [])) : ((function(arguments, successes, failures) {
      (log)("arguments case");
    ((function(arguments, iteratableminus15220) {
          for (index in iteratableminus15220)        {
        ((function(arguments, index, element) {
                  return (((function(arguments, test) {
                      return ((("undefined"===((typeof test))) ? ((function(arguments) {
                          throw (plus)("Undefined test ", index, ".");
              return (undefined);
              })((("undefined"===((typeof arguments))) ? undefined : arguments))) : ((function(arguments, result) {
                          return ((result ? ((successes).push)(test) : ((failures).push)(test)));
              })((("undefined"===((typeof arguments))) ? undefined : arguments), (funcall)((test)["testLambda"])))));
            })((("undefined"===((typeof arguments))) ? undefined : arguments), (tests)[element])));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus15220)[index]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), arguments));
    return ((new TestResults(successes, failures)));
    })((("undefined"===((typeof arguments))) ? undefined : arguments), [], []))));
  };
(tests["thisTestFailsOnPurpose"] = (((function(arguments, object15221) {
  (object15221["name"] = ("thisTestFailsOnPurpose"), undefined);
  (object15221["description"] = ("A test to test test failure."), undefined);
  (object15221["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, false));
    }), undefined);
  return (object15221);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
var leftFold = function(flessThanitAcgreaterThan, init, a) {
  ((function(arguments, iteratableminus15222) {
      for (index in iteratableminus15222)      {
      ((function(arguments, index, element) {
              return ((init = ((flessThanitAcgreaterThan)(element, init)), undefined));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus15222)[index]));
      };
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), a));
  return (init);
  };
var primitiveminusequalequalequal = function(a, b) {
  return (a===b);
  };
var first = function(sharpQuoteArgminus15223) {
  return ((sharpQuoteArgminus15223)[0]);
  };
var second = function(sharpQuoteArgminus15224) {
  return ((sharpQuoteArgminus15224)[1]);
  };
var third = function(sharpQuoteArgminus15225) {
  return ((sharpQuoteArgminus15225)[2]);
  };
var fourth = function(sharpQuoteArgminus15226) {
  return ((sharpQuoteArgminus15226)[3]);
  };
var fifth = function(sharpQuoteArgminus15227) {
  return ((sharpQuoteArgminus15227)[4]);
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
(tests["equalequalequalTest1"] = (((function(arguments, object15228) {
  (object15228["name"] = ("equalequalequalTest1"), undefined);
  (object15228["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object15228["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, (equalequalequal)("a", "a")));
    }), undefined);
  return (object15228);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest2"] = (((function(arguments, object15229) {
  (object15229["name"] = ("equalequalequalTest2"), undefined);
  (object15229["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object15229["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(false, (equalequalequal)("a", "b")));
    }), undefined);
  return (object15229);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest3"] = (((function(arguments, object15230) {
  (object15230["name"] = ("equalequalequalTest3"), undefined);
  (object15230["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object15230["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, (equalequalequal)("a", "a", "a")));
    }), undefined);
  return (object15230);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest4"] = (((function(arguments, object15231) {
  (object15231["name"] = ("equalequalequalTest4"), undefined);
  (object15231["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object15231["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(true, (equalequalequal)(5, 5, 5)));
    }), undefined);
  return (object15231);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["equalequalequalTest5"] = (((function(arguments, object15232) {
  (object15232["name"] = ("equalequalequalTest5"), undefined);
  (object15232["description"] = ("Test that ===, which takes any number of arguments, is correct."), undefined);
  (object15232["testLambda"] = (function() {
      return ((primitiveminusequalequalequal)(false, (equalequalequal)(5, 5, 4)));
    }), undefined);
  return (object15232);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
var map1 = function(f, anArray) {
  return (((function(arguments, output) {
      ((function(arguments, iteratableminus15233) {
          for (index in iteratableminus15233)        {
        ((function(arguments, index, element) {
                  return (((output).push)((f)(element)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), index, (iteratableminus15233)[index]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), anArray));
    return (output);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), [])));
  };
var plus = function() {
  var total = (arguments)[0];
  ((function(arguments, iteratableminus15234) {
      for (i in iteratableminus15234)      {
      ((function(arguments, i, el) {
              return ((total = (total+el), undefined));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), i, (iteratableminus15234)[i]));
      };
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), (rest)((argumentsminusgreaterThanarray)(arguments))));
  return (total);
  };
(tests["plusBinary"] = (((function(arguments, object15298) {
  (object15298["name"] = ("plusBinary"), undefined);
  (object15298["description"] = ("Test two argument addition."), undefined);
  (object15298["testLambda"] = (function() {
      return ((equalequalequal)(4, (plus)(2, 2)));
    }), undefined);
  return (object15298);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["plusTrinary"] = (((function(arguments, object15299) {
  (object15299["name"] = ("plusTrinary"), undefined);
  (object15299["description"] = ("Test three argument addition."), undefined);
  (object15299["testLambda"] = (function() {
      return ((equalequalequal)(6, (plus)(2, 2, 2)));
    }), undefined);
  return (object15299);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["plusStrings"] = (((function(arguments, object15300) {
  (object15300["name"] = ("plusStrings"), undefined);
  (object15300["description"] = ("Test plus for strings."), undefined);
  (object15300["testLambda"] = (function() {
      return ((equalequalequal)("abcdef", (plus)("abc", "def")));
    }), undefined);
  return (object15300);
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
      ((function(arguments, iteratableminus15301) {
          for (i in iteratableminus15301)        {
        ((function(arguments, i, el) {
                  return (((greaterThan)(i, 0) ? (value = (value-el), undefined) : undefined));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), i, (iteratableminus15301)[i]));
        };
      return (undefined);
      })((("undefined"===((typeof arguments))) ? undefined : arguments), arguments));
    return (value);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), (arguments)[0])) : ((function(arguments, value) {
      return (-value);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), (arguments)[0]))));
  };
(tests["minusNegation"] = (((function(arguments, object15341) {
  (object15341["name"] = ("minusNegation"), undefined);
  (object15341["description"] = (""), undefined);
  (object15341["testLambda"] = (function() {
      return ((equalequalequal)(-1, (minus)(1)));
    }), undefined);
  return (object15341);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["minusBinary"] = (((function(arguments, object15342) {
  (object15342["name"] = ("minusBinary"), undefined);
  (object15342["description"] = (""), undefined);
  (object15342["testLambda"] = (function() {
      return ((equalequalequal)(-1, (minus)(0, 1)));
    }), undefined);
  return (object15342);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["minusTrinary"] = (((function(arguments, object15343) {
  (object15343["name"] = ("minusTrinary"), undefined);
  (object15343["description"] = (""), undefined);
  (object15343["testLambda"] = (function() {
      return ((equalequalequal)(0, (minus)(3, 2, 1)));
    }), undefined);
  return (object15343);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var not = function(v) {
  return (!v);
  };
var times = function() {
  var value = 1;
  ((function(arguments, iteratableminus15344) {
      for (i in iteratableminus15344)      {
      ((function(arguments, i, el) {
              return ((value = (el*value), undefined));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), i, (iteratableminus15344)[i]));
      };
    return (undefined);
    })((("undefined"===((typeof arguments))) ? undefined : arguments), arguments));
  return (value);
  };
(tests["timesBinary"] = (((function(arguments, object15378) {
  (object15378["name"] = ("timesBinary"), undefined);
  (object15378["description"] = (""), undefined);
  (object15378["testLambda"] = (function() {
      return ((equalequalequal)(4, (times)(2, 2)));
    }), undefined);
  return (object15378);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["timesTrinary"] = (((function(arguments, object15379) {
  (object15379["name"] = ("timesTrinary"), undefined);
  (object15379["description"] = (""), undefined);
  (object15379["testLambda"] = (function() {
      return ((equalequalequal)((times)(2, 2, 2), 8));
    }), undefined);
  return (object15379);
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
(tests["divideBinary"] = (((function(arguments, object15414) {
  (object15414["name"] = ("divideBinary"), undefined);
  (object15414["description"] = (""), undefined);
  (object15414["testLambda"] = (function() {
      return ((equalequalequal)((divide)(4, 2), 2));
    }), undefined);
  return (object15414);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["divideTrinary"] = (((function(arguments, object15415) {
  (object15415["name"] = ("divideTrinary"), undefined);
  (object15415["description"] = (""), undefined);
  (object15415["testLambda"] = (function() {
      return ((equalequalequal)((divide)(10.0, 2, 1), 5.0));
    }), undefined);
  return (object15415);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var functionAnd = function() {
  return (((primitiveminusequalequalequal)(0, (arguments).length) ? true : ((not)(((arguments)[0])()) ? false : (simpleApply)(functionAnd, (rest)((argumentsminusgreaterThanarray)(arguments))))));
  };
;
(tests["andArgumentEvaluation"] = (((function(arguments, object15445) {
  (object15445["name"] = ("andArgumentEvaluation"), undefined);
  (object15445["description"] = (""), undefined);
  (object15445["testLambda"] = (function() {
      return (((function(arguments, a) {
          (functionAnd)(function() {
              return (false);
        }, function() {
              return ((a = (10), undefined));
        });
      return ((equalequalequal)(a, 0));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), 0)));
    }), undefined);
  return (object15445);
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
(tests["orArgumentEvaluation"] = (((function(arguments, object15476) {
  (object15476["name"] = ("orArgumentEvaluation"), undefined);
  (object15476["description"] = (""), undefined);
  (object15476["testLambda"] = (function() {
      return (((function(arguments, a) {
          (functionOr)(function() {
              return (true);
        }, function() {
              return ((a = (10), undefined));
        });
      return ((equalequalequal)(a, 0));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), 0)));
    }), undefined);
  return (object15476);
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
(tests["trivialTest"] = (((function(arguments, object15479) {
  (object15479["name"] = ("trivialTest"), undefined);
  (object15479["description"] = ("A totally trivial test."), undefined);
  (object15479["testLambda"] = (function() {
      return ((equalequalequal)(true, true));
    }), undefined);
  return (object15479);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
var numberwho = function(o) {
  return ((equalequalequal)("number", (typeof o)));
  };
(tests["numberwhoIsNumber"] = (((function(arguments, object15513) {
  (object15513["name"] = ("numberwhoIsNumber"), undefined);
  (object15513["description"] = (""), undefined);
  (object15513["testLambda"] = (function() {
      return ((equalequalequal)(true, (numberwho)(10)));
    }), undefined);
  return (object15513);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["numberwhoIsNotNumber"] = (((function(arguments, object15514) {
  (object15514["name"] = ("numberwhoIsNotNumber"), undefined);
  (object15514["description"] = (""), undefined);
  (object15514["testLambda"] = (function() {
      return ((equalequalequal)(false, (numberwho)("10")));
    }), undefined);
  return (object15514);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var arraywho = function(o) {
  return ((equalequalequal)(((Object).prototype.toString.call)(o), "[object Array]"));
  };
(tests["arraywhoIsArray"] = (((function(arguments, object15548) {
  (object15548["name"] = ("arraywhoIsArray"), undefined);
  (object15548["description"] = (""), undefined);
  (object15548["testLambda"] = (function() {
      return ((equalequalequal)(true, (arraywho)([])));
    }), undefined);
  return (object15548);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["arraywhoIsNotArray"] = (((function(arguments, object15549) {
  (object15549["name"] = ("arraywhoIsNotArray"), undefined);
  (object15549["description"] = (""), undefined);
  (object15549["testLambda"] = (function() {
      return ((equalequalequal)(false, (arraywho)(10)));
    }), undefined);
  return (object15549);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
var jsonEqual = function(a, b) {
  return ((equalequalequal)(((JSON).stringify)(a), ((JSON).stringify)(b)));
  };
(tests["jsonEqualTrueCase"] = (((function(arguments, object15583) {
  (object15583["name"] = ("jsonEqualTrueCase"), undefined);
  (object15583["description"] = (""), undefined);
  (object15583["testLambda"] = (function() {
      return ((equalequalequal)(true, (jsonEqual)([1, 2, 3], [1, 2, 3])));
    }), undefined);
  return (object15583);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["jsonEqualFalseCase"] = (((function(arguments, object15584) {
  (object15584["name"] = ("jsonEqualFalseCase"), undefined);
  (object15584["description"] = (""), undefined);
  (object15584["testLambda"] = (function() {
      return ((equalequalequal)(false, (jsonEqual)("[1 2 3]", [1, 2, 3])));
    }), undefined);
  return (object15584);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
;
var timesmatchFailtimes = ((function(arguments, object15586) {
  return (object15586);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
;
(tests["match1Array"] = (((function(arguments, object15645) {
  (object15645["name"] = ("match1Array"), undefined);
  (object15645["description"] = (""), undefined);
  (object15645["testLambda"] = (function() {
      return ((equalequalequal)(6, ((function(arguments, value15708) {
          return (((functionAnd)(function() {
              return ((arraywho)(value15708));
        }, function() {
              return ((greaterThan)((value15708).length, 0));
        }) ? ((function(arguments, hdminus15709, tlminus15710) {
              return (((function(arguments, x) {
                  return (((function(arguments, value15777) {
                      return (((functionAnd)(function() {
                          return ((arraywho)(value15777));
              }, function() {
                          return ((greaterThan)((value15777).length, 0));
              }) ? ((function(arguments, hdminus15778, tlminus15779) {
                          return (((function(arguments, y) {
                              return (((function(arguments, value15846) {
                                  return (((functionAnd)(function() {
                                      return ((arraywho)(value15846));
                    }, function() {
                                      return ((greaterThan)((value15846).length, 0));
                    }) ? ((function(arguments, hdminus15847, tlminus15848) {
                                      return (((function(arguments, z) {
                                          return (((function(arguments, value15882) {
                                              return (((functionAnd)(function() {
                                                  return ((arraywho)(value15882));
                          }, function() {
                                                  return ((equalequalequal)(0, (value15882).length));
                          }) ? (plus)(x, y, z) : timesmatchFailtimes));
                        })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus15848)));
                      })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus15847)));
                    })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value15846), (rest)(value15846))) : undefined));
                  })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus15779)));
                })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus15778)));
              })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value15777), (rest)(value15777))) : undefined));
            })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus15710)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus15709)));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value15708), (rest)(value15708))) : undefined));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), [1, 2, 3]))));
    }), undefined);
  return (object15645);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1LiteralNumber"] = (((function(arguments, object15883) {
  (object15883["name"] = ("match1LiteralNumber"), undefined);
  (object15883["description"] = (""), undefined);
  (object15883["testLambda"] = (function() {
      return ((equalequalequal)("matched", ((function(arguments, value15894) {
          return (((equalequalequal)(value15894, 10) ? "matched" : timesmatchFailtimes));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), 10))));
    }), undefined);
  return (object15883);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1LiteralString"] = (((function(arguments, object15895) {
  (object15895["name"] = ("match1LiteralString"), undefined);
  (object15895["description"] = (""), undefined);
  (object15895["testLambda"] = (function() {
      return ((equalequalequal)("matched", ((function(arguments, value15909) {
          return (((equalequalequal)(value15909, "x") ? "matched" : timesmatchFailtimes));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), "x"))));
    }), undefined);
  return (object15895);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1Arrayplus"] = (((function(arguments, object15910) {
  (object15910["name"] = ("match1Arrayplus"), undefined);
  (object15910["description"] = (""), undefined);
  (object15910["testLambda"] = (function() {
      return ((jsonEqual)([1, 2, 3], ((function(arguments, value15962) {
          return (((functionAnd)(function() {
              return ((arraywho)(value15962));
        }, function() {
              return ((greaterThan)((value15962).length, 0));
        }) ? ((function(arguments, hdminus15963, tlminus15964) {
              return (((function(arguments, a) {
                  return (((function(arguments, value15987) {
                      return (((arraywho)(value15987) ? ((function(arguments, tail) {
                          return (tail);
              })((("undefined"===((typeof arguments))) ? undefined : arguments), value15987)) : timesmatchFailtimes));
            })((("undefined"===((typeof arguments))) ? undefined : arguments), tlminus15964)));
          })((("undefined"===((typeof arguments))) ? undefined : arguments), hdminus15963)));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), (first)(value15962), (rest)(value15962))) : undefined));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), [0, 1, 2, 3]))));
    }), undefined);
  return (object15910);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1ObjectMatch1"] = (((function(arguments, object15992) {
  (object15992["name"] = ("match1ObjectMatch1"), undefined);
  (object15992["description"] = (""), undefined);
  (object15992["testLambda"] = (function() {
      return ((equalequalequal)("match", ((function(arguments, jselcolonautoGensymTheObjectminus16082, jselcolonautoGensymKeyValueminus16083, jselcolonautoGensymRefValueminus16084) {
          var jselcolonautoGensymTheObjectminus16082 = ((function(arguments, object16085) {
              (object16085["x"] = (20), undefined);
        return (object16085);
        })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
      var jselcolonautoGensymKeyValueminus16083 = "x";
      var jselcolonautoGensymRefValueminus16084 = (jselcolonautoGensymTheObjectminus16082)[jselcolonautoGensymKeyValueminus16083];
      return (((function(arguments, value16096) {
              return (((equalequalequal)(value16096, 20) ? "match" : timesmatchFailtimes));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), jselcolonautoGensymRefValueminus16084)));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined, undefined, undefined))));
    }), undefined);
  return (object15992);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
(tests["match1ObjectMatch2"] = (((function(arguments, object16138) {
  (object16138["name"] = ("match1ObjectMatch2"), undefined);
  (object16138["description"] = (""), undefined);
  (object16138["testLambda"] = (function() {
      return ((equalequalequal)(timesmatchFailtimes, ((function(arguments, jselcolonautoGensymTheObjectminus16228, jselcolonautoGensymKeyValueminus16229, jselcolonautoGensymRefValueminus16230) {
          var jselcolonautoGensymTheObjectminus16228 = ((function(arguments, object16231) {
              (object16231["x"] = (30), undefined);
        return (object16231);
        })((("undefined"===((typeof arguments))) ? undefined : arguments), {}));
      var jselcolonautoGensymKeyValueminus16229 = "x";
      var jselcolonautoGensymRefValueminus16230 = (jselcolonautoGensymTheObjectminus16228)[jselcolonautoGensymKeyValueminus16229];
      return (((function(arguments, value16242) {
              return (((equalequalequal)(value16242, 20) ? "match" : timesmatchFailtimes));
        })((("undefined"===((typeof arguments))) ? undefined : arguments), jselcolonautoGensymRefValueminus16230)));
      })((("undefined"===((typeof arguments))) ? undefined : arguments), undefined, undefined, undefined))));
    }), undefined);
  return (object16138);
  })((("undefined"===((typeof arguments))) ? undefined : arguments), {}))), undefined);
;
(log)((runTests)());
