(true ? ((function() {
  throw "x";
  return (undefined);
  })()) : false);
"a\nb\nc";
