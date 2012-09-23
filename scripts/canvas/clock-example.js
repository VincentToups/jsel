(define)(["canvas/macros", "macros/simple-macros"], function(canvasdividemacros, macrosdividesimpleMacros) {
  return (((function() {
      return (((function(primitiveModuleE2961cc55e78c92ea34d879fdd35c9f2) {
          var canvas = ((document).getElementById)("canvas"),
        context = ((canvas).getContext)("2d"),
FONT_HEIGHT = 15,
MARGIN = 30,
HAND_TRUNCATION = (divide)((canvas).height, 2),
HOUR_HAND_TRUNCATION = (divide)((canvas).height, 10),
NUMERAL_SPACING = 20,
RADIUS = (minus)((divide)((canvas).width, 2), MARGIN),
HAND_RADIUS = (plus)(RADIUS, NUMERAL_SPACING);;
      var drawCircle = function() {
              return (((function(object64673) {
                  ((object64673).beginPath)();
          ((object64673).arc)((divide)((canvas).width, 2), (divide)((canvas).height, 2), 5, 0, (times)(2, (MATH).PI), true);
          return (((object64673).stroke)());
          })(context)));
        };
      return (primitiveModuleE2961cc55e78c92ea34d879fdd35c9f2);
      })({})));
    })()));
  })