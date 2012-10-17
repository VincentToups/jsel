What I did on my Honeymoon
==========================

Hi blog readers - I've been too busy to write much on my blog lately.
I've recently taken up full time work as a Common Lisp programmer AND
I just got married.  On top of that I'm trying to work out a move to
Europe in the next few months, so things are bit crazy.  Obviously I
haven't had much time to work on recreational programming in the last
5 months.

But my honeymoon, about which I'll say very little, involved a fair
amount of down time, so I worked on something I've been meaning to do
for a long time: a way to make programming in Javascript tolerable.  

Introducing JSEL
----------------

[JSEL]() is a Lisp dialect (written in Elisp) I cooked up to work with
Javascript.  Because I wanted to avoid writing glue-code, JSEL is a
fairly literal minded transcoder which converts s-expressions directly
to their equivalent javascript.  There are many other projects
converting Lisp to Javascript (and I wrote JSEL partly out of a desire
to improve my understanding of Javascript, rather than to supercede
any of those projects), but I wanted something which was very close to
Javascript with s-expression syntax, rather than a new language on top
of the JS run time.  I believe that when you have s-expressions and
macros, you can implement the features you want on top of almost any
language, so rather than build up a new Lisp, I'd start with
Javascript and S-expressions and meta-program as needed, later.

For similar reasons, JSEL doesn't really attempt to generate readable
Javascript code - serious macro magic will make the generated code
hard to read anyway.  Identifiers are transcoded in a reasonably
simple way, so that you can find them in your Lisp code, but other
than that, let's just say its something I might work on later. 

JSEL Basics
-----------

#### Definition

Variable definition can be affected via `var`, as in Javascript:

    (var x 10)

Is equivalent to 

    var x = 10;

But for convenience a form called `def` exists:

    (def x 10)

is the same as `(var x 10)` but `def` also makes function definition
handy:

    (def (f x y) (- x y))

Transcodes to something like:

    var f = (function (x,y) { return (minus)(x,y) })

#### Identifier Mangling & Associated Concerns

Identifiers are mangled on their way to Javascript, to allow the user
to use Lisp-style identifiers.  For instance:

    x			-> x
    this-test	-> thisTest
    set!		-> setbang
    array?		-> arraywho
    +			-> plus
    minus		-> minus 

Etc.  See the code for full documentation.  Mangling is handy, but it
highlights one of the problems of Javascript, which is that it
distinguishes between _functions_ and _operators_.  There isn't an
easy way to refer to operators directly in JSEL, so its handy to
define wrappers (a library of such is in the git repository).  For
instance,

    (def (+)
      (let ((output 0)) 
       (for ((i el) :in arguments)
         (setq output (literally "el+output")))
       output))

Becomes, roughly:

    var plus = function() 
           { var output = 0;
             for (i in arguments)
                { var el = arguments[i];
                  output = output+el} 
             return output;}

Here we've used the special form `literally` to insert text directly
into the transcoding.  For this kind of wrapper over an operator,
`literally` is pretty useful.  That is its only real use case, though.

It is unfortunate that JSEL requires wrappers for operators, but the
alternative, in which JSEL puns its way through transcoding, trying to
make what look like function invokations into operator expressions is
worse.  JSEL deals with function invokations only, so if you need a
`plus` function, define one.

This leads to the next section, but first, a note about dotted
symbols.

JSEL doesn't mangle away dots, so you can refer to values like this:

    x.y.z

Just as you would in javascript.  JSEL has a symbol macro system
living under its hood, so you should know that the above actually
is transformed to 

    (.. x y z)

Before being transcoded.  The first element of such a form is expanded
via symbol-macro before being transcoded, while the other symbols are
not.  That is:

    (symbol-macro-letq ((x cats)
                        (y dogs))
      x.y.z)

Is equivalent to the Javascript code:

    cats.y.z

I never use symbol macros in regular programming, but they are needed
for some advanced features of JSEL, so its important to bear this in
mind if things aren't working as you expect.

Includes, modules, etc
----------------------

One of my big beefs with Javascript is the lack of even a primitive
module system, or the ability to "include" one piece of Javascript in
another.  JSEL addresses this problem in a layered approach.  The
simplest solution is to use JSEL's `primitive-include` facility.  The
form:


    (primitive-include "location/file1.jsel"
                       "location/file2.jsel")

Transcodes the files directly into the JSEL code being translated.
This is the simplest possible module-system.

#### Primitive Modules

JSEL also supports something called a "primitive module".  A primitive
module combines the regular Javascript idiom of using objects as
modules with some simple static tracking of macros, so that you can
use the same system for both macro and run time code.

Eg:

    (def-primitive-module utils 
      (def-external doc "This module provides a nice macro.")
      (defmacro-external incr (where)
        `(setq ,where (+ 1 ,where))))

    (let ((x 0))
      (utils.incr x)
      x)

Results in 1 for the second form.  `def-primitive-module` and
`defmacro-external` coordinate to make sure that the macro identifiers
are available in the right places.  Inside a primitive module,
`def-external` creates external bindings, `defmacro-external` creates
external macro bindings, while `def` and `defmacro` create private
bindings, not externally accessible.  

The simplest way to use primitive modules is to define each one in its
own file via `defmacro-external` and then include each file in your
main project.

#### Require.js style Modules.

[Require.js][] is a Javascript module system which supports explicit
dependencies between modules and handles loading modules when needed
and in the right order.  This is such an appealing feature to me that
I have a special add-on to JSEL which integrates `require.js` with
support for tracking macros too.

This system involves files, each of which contains a `rjs-module`
form.  The file system represents module organization.  Here is an
example of usage:

    (rjs-module 
      ((utils/macros :as macros :using (incr decr))
       (utils/strings :as s :using (split concat))
       (utils/operator-funs :using (+ - / *)))

      (def-external (incr-end s)
        (let* ((parts (split s "-"))
               (n-part (parse-int ([] parts 1))))
            (incr n-part)
            (concat ([] parts 0) "-" (+ "" n-part)))))

This example creates a new module, and uses functions from three
modules.  Each module is referred to by its path relative to the root
directory of the `require.js` system (emacs will ask for this
directory the first time you compile a module.)  For instance,
`utils/macros` will cause the `rjs-module` form to look for a file
called "utils/macros.jsel", compile that file, collect information
about its external identifiers, and the compile the body of the
module.  Symbols named in a `:using` clause must be external to the
module referenced and can be either regular values or macros.  In the
subsequent body, they can be used without qualification.  

Non `used` symbols can be referred to like this:

    (utils/macros.decr x)

Or, as in the above case, when an `:as` form is used,

    (macros.decr x)

`:as` and `:using` are mediated via symbol macros, so you can treat
the identifiers in the body of the module exactly like the dotted
expressions.  That is, if we say:

    (rjs-module 
      ((utils/some-module :as macros :using (some-variable)))

      (setq some-variable (+ 1 some-variable)))

the body means exactly:

     (setq utils/some-module.some-variable 
           (+ 1 utils/some-module.some-variable))

This is not an effect achievable by regular values in Javascript.

The git repository shows an example of using the `require.js` type
module system.  Since the module system handles transcoding modules as
they are needed, it also doubles as a build system.  If you require
certain modules in `main.jsel`, the system will ensure that all the
dependencies are also built when you transcode `main.jsel` to
javascript.  Once day this will be cached.

Future Thoughts
---------------

I'd like to make JSEL self hosting, since some people will probably
object to using Emacs to handle all their Javascript.  This will take
significant work, though, since my Elisp development library is much
more complete and powerful than anything available in Javascript.  But
that is good, since I'll have to develop some libraries in JSEL.  At
minimum, to bootstrap, I need an Elisp compatibility layer and a
pattern matcher.

On that note, if you use this code, you might want to check out
`apropos jsel:transcode` to see complete documentation of the entire
transcoder.  This is generated automatically via JSEL's only elisp
dependency, [shadchen.el][].



