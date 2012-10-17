(define)([], function() {
  return (((function() {
      return (((function(primitiveModuleminus016fc5121003e3282a5434796a8c2bb5) {
          /*
Include: flat-stdlib.jsel
*/
;
      //(defmacro primitive-module-016fc5121003e3282a5434796a8c2bb5-def* (&rest args) (\` (def-or-def-external (\,@ args))));
      //(defmacro primitive-module-016fc5121003e3282a5434796a8c2bb5-defmacro* (&rest args) (\` (defmacro-or-defmacro-external (\,@ args))));
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).plus = (function() {
                  var total = 0;
          ((function(iteratableminus99436) {
                      for (i in iteratableminus99436)              {
              ((function(i, el) {
                              return (((function() {
                                  total = (total+el);
                  return (undefined);
                  })()));
                })(i, (iteratableminus99436)[i]));
              };
            return (undefined);
            })(arguments));
          return (total);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).greaterThan = (function(a, b) {
                  return (a>b);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).greaterThanequal = (function(a, b) {
                  return (a>=b);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).lessThan = (function(a, b) {
                  return (a<b);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).lessThanequal = (function(a, b) {
                  return (a<=b);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).modsign = (function(a, b) {
                  return (a%b);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).minus = (function() {
                  var value = (arguments)[0];
          (forIn)(((i)(el))(arguments), ((((primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).greaterThan)(i, 0)) ? (((function() {
                      total = (value-el);
            return (undefined);
            })())) : (undefined)));
          return (value);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).times = (function() {
                  var value = 1;
          ((function(iteratableminus99438) {
                      for (i in iteratableminus99438)              {
              ((function(i, el) {
                              return (((function() {
                                  value = (el*value);
                  return (undefined);
                  })()));
                })(i, (iteratableminus99438)[i]));
              };
            return (undefined);
            })(arguments));
          return (value);
          });
        return (undefined);
        })());
      (defExternal)(rest, (anArray)(), ((anArray).slice)(1));
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).argumentsminusgreaterThanarray = (function(anArguments) {
                  return ((([]).slice.apply)(anArguments));
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).simpleApply = (function(f, anArray) {
                  return (((f).apply)(f, a));
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).divide = (function() {
                  var numerator = (arguments)[0];
          var denominator = ((primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).simpleApply)((primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).times, (rest)(arguments));
          return (numerator/denominator);
          });
        return (undefined);
        })());
      /*
Some macros.
*/
;
      ;
      ;
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).plusminus1 = (function(a) {
                  ((function() {
                      a = ((plus)(1, a));
            return (undefined);
            })());
          return (a);
          });
        return (undefined);
        })());
      ((function() {
              (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5).minusminus1 = (function(a) {
                  ((function() {
                      a = ((minus)(a, 1));
            return (undefined);
            })());
          return (a);
          });
        return (undefined);
        })());
      ;
      return (primitiveModuleminus016fc5121003e3282a5434796a8c2bb5);
      })({})));
    })()));
  })