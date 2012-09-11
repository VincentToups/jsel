JSEL
----
> A Lisp Dialect for Javascript 

JSEL (pronounced "Giselle") is a dialect of Lisp targeting Javascript
with the following basic idea: Giselle is semantically Javascript with
S-expression syntax + dirty macros.  A moderate attempt is made to
make the standard forms used by Giselle respect the idea that
everything is an expression. 

This is in contrast to other Lisp's targeting Javascript which attempt
to weld some other semantics onto the language.  JSEL does not try to
trick you into thinking you are coding in a really Lispy Lisp dialect,
or pun up Cons cells and Lists.  It is a Lisp-1 which abuses Lisp-2
syntax in a predictable and simple way.

All that and its written in Emacs Lisp, which provides the macro
language.  It depends upon [Shadchen][].

JSEL doesn't try to produce readable javascript because, seriously,
once you get any metaprogramming going at all, nothing JSEL will do
will protect you.

I plan to use it with Node and the browser for game development and
fiddling.  

# What does this look like?

Well, this

    (def (foldl f<it&ac> init a)
         (for ((index element) :in a)
              (setq init (f<it&ac> element init)))
         init)

Turns into this:

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

# Some Notes

Variable declaration is done via a `def` form, which is like Scheme's
define.  That is, 

    (def x 10)

Creates a variable x, value 10.  While:

    (def (f x) 10)

Creates a function f, with one argument x, which returns 10.  There is
no syntax in function definitions which handles mulitple arguments.
Use the `arguments` object for that.  I plan to add a `def+` at some
point that does some of that work for you.  

* * *

The mangler leaves `.` unmangled, so you can write:

    (this.that x)

You can also write the equivalent:

    ((.. this that) x)

`..` expressions take symbolic arguments, except for the first
argument.  So you can say:

    ((.. [] slice apply) arguments)

to convert an arguments object to an array.

You can also write the above like this:

    (..* ^ [] slice apply ^ arguments)

Here `^` is a sigil that separates the function part of a chain from
the arguments it is applied to.

or, in most cases,

    (.: [] slice apply : arguments)

Here, `:` is assumed to be the sigil.

The above is kind of a "stupid syntax trick" but in real JS, there is
so much `x.y.z(foo)` that conciseness is a nice feature here.   

Indexing into objects is written:

    ([] x 10)

Which is the same as

    x[10]

These can be chained:

    ([] x 10 11 12)

is 

    x[10][11][12]

Speaking of which, arrays are written as arrays:

    [1 2 3]

is 

    [1,2,3]

and associations/objects are written:

    (object key-expr1 val-expr1 ...)

Both keys and values are expressions, not mere syntax.  Handily,
keywords are rendered into (mangled) strings:

    :this-is-a-test

becomes

    "thisIsATest"

For loops look like one of

    (for (index :in object) expr ...)

Which is a for-in loop in javascript.  For convenience, (I don't know
why this isn't in JS)

    (for ((index element) :in object) expr ...)

Is just like a for-in except element is bound to the element in object
at index in the body.  

or 

    (for (init cond-expr update) expr ...)

Which is a regular for loop.  

Loops do ensure that index and element bindings are lexical, unlike in
naked javascript.  I hate languages which have bindings other than
lexical bindings!  What if I want to close over a loop index?

Finally, since JSEL is a Lisp-1, the sharp-quote syntax is hijacked so
that:

    #'expr

Becomes

    (lambda (id) ([] id expr))

Where `id` is gensymed.  

This lets you write ridiculous things like:

    (#':some-member (create :some-member 12))

Which evaluates to 12.  Or:

    (def first #'0)


* * *

[Shadchen]:https://github.com/VincentToups/shadchen-el