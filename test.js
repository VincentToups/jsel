var x = 10;
var y = 11;
var lessThan = function(a, b) {
  return (a<b);
  };
var greaterThan = function(a, b) {
  return (a>b);
  };
var plusPrimitive = function(a, b) {
  return (a+b);
  };
var plus = function() {
  return (((function(result, argArray) {
      ((function(iteratableminus100351) {
          for (index in iteratableminus100351)        {
        ((function(index, element) {
                  return (((function() {
                      result = ((plusPrimitive)(result, element));
            return (undefined);
            })()));
          })(index, (iteratableminus100351)[index]));
        };
      return (undefined);
      })(argArray));
    return (result);
    })(0, (([]).slice.apply)(arguments))));
  };
(plus)(1, 2, 3, 4, 5);
var z = ((function(x) {
  ((function() {
      x = (11);
    return (undefined);
    })());
  return (x);
  })(10));
var r = ((function(a, o) {
  ((function(iteratableminus100352) {
      for (index in iteratableminus100352)      {
      ((function(index, element) {
              return (((function() {
                  o = ((plusPrimitive)(o, element));
          return (undefined);
          })()));
        })(index, (iteratableminus100352)[index]));
      };
    return (undefined);
    })(a));
  return (o);
  })([1, 2, 3, 4], 0));
var testModule = ((function(primitiveModuleminus03c04fdb2f409ff278723c3efcd378b4) {
  var primitiveModuleminus03c04fdb2f409ff278723c3efcd378b4.a = 10;
  var primitiveModuleminus03c04fdb2f409ff278723c3efcd378b4.b = 10;
  var primitiveModuleminus03c04fdb2f409ff278723c3efcd378b4.plusb = function(x) {
      return ((plus)(x, primitiveModuleminus03c04fdb2f409ff278723c3efcd378b4.b));
    };
  //(defmacro primitive-module-03c04fdb2f409ff278723c3efcd378b4\.progn (&body body) (\` (let nil (\,@ body))));
  return (primitiveModuleminus03c04fdb2f409ff278723c3efcd378b4);
  })(((function(object100354) {
  return (object100354);
  })({}))));
;
(testModule.plusb)(100);
((function() {
  (console.log)("Hello Nurse!");
  (hello)();
  return ((nurse)());
  })());
((function() {
  return ((console.log)("Hello Nurse!"));
  })());
((function() {
  return ((console.log)("HN2"));
  })());
