Notes
=====

Semantics of symbol macros.  

Cases of interest:

x.y.z

Where x, y and z are symbol macros.

And 

(.. x y z) in the same case.

Possible Rule one:
------------------

x.y.z converts to

(.. x y z) before any symbol macro action.

Then symbol macros expand on the first element only.

This is simple enough for symbols indicating regular variables.

It sucks for macros because we have to check for macros before
transcoding.  

Eg, if there is a macro bound to 

lib.macro 

We have to apply that macro before converting to 

(.. lib macro)

OR we have to store the macro in both (.. lib macro) and lib.macro.

Or macro definition always expands dotted symbols and binds to the
expanded and macro invocation always expands dotted symbols and looks
up the macro appropriately, after using symbol macro expansion on the
first argument.  This is likely to produce somewhat consistent
semantics for macros and regular values.

Possible Rule two:
------------------

Convert expressions of the form:

(.. e s1 s2)

to 

    (let ((id# e))
      (id#.s1.s2))

