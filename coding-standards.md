# 4GL coding standards

## language
The language for coding is English (American). Domain specific terms can be in local language (eindloonregeling anyone?).

## casing
- 4GL statements: *lowercase* (every self respecting language uses lowercase)
- directory names: lowercase (so also for package of `using`)
- `.p`, `.i` & `.w` filenames in lowercase
- Class names: PascalCase
- public, protected members: PascalCase
- private members: camelCase
- acronyms in PascalCase, with the exception of 2 letters ones. So for example: HttpVerbs and IOStream.

## abbreviations
Do not use abbreviations. Use for example GetWindow instead of GetWin.

## acronyms
Do not use acronyms unless they are common, like IO, HTTP, BTW (Dutch for VAT).

## indentation
Indentation is 2 spaces. Not 3, not 4, no tabs.
Correct indentation is essential for readability. There's no excuse to mess this up.

## prefixes
No prefixes for variables, parameters for either their datatype and they're being input/output. If one thinks prefixes are necessary they arguably make their (internal) procedure and/or methods too big. Exceptions for "technical datatypes":
- `h` for handle
- `ptr` for memptr
- `raw` for raw

### buffers 
Buffers are prefixed by `b-`. So:
```define buffer b-customer for customer.```
If more than one buffer is necessary then postfix them, `b-customer2`.

### temp-tables 
Temp-tables are prefixed with `tt`

### datasets 
Datasets are prefixed with `ds`

### interfaces
Interfaces are prefixed with `I`

## operators
Used `=, <>, <, <=, >, >=` NOT `eq, ne, le`, etc
When in doubt, use parentheses for the expression:

```
success = (returnCode = 'OK')
```
(remember, operators like `+=` are on their way > 12.2)

## if-then-else
`if-then-do` as much as possible on one line, probably most of your audience reads from left to right.

```
if expr then
    // something
else
    // something different
```

and

```
if expr then do:
    // something
end.
else do:
    // something different
end.
```

## compound expressions
Try to make them clear, use a variable telling what the (way too long) expression represents:

NOT:
```
if can-find(first order where order.orderdate < today - 10 and lookup(order.orderstatus, 'open,hold,busy' ) > 0 then
    // ...
```

but:
```
define variable openOrders as logical no-undo.

openOrders = (can-find(first order where order.orderdate < today - 10 and lookup(order.orderstatus, 'open,hold,busy' ) > 0).
if (openOrders) then 
    // ...
```
Use a variable to tell the reader what the expression actually represents. Use that variable for follow up behavior.
The performance impact of using a variable is negligible, the readability is increased dramatically.

This can be done by a function as well. Depending on the amount of data in the current block, calling a function and put everything on the stack can prove costly.

## functions/methods
Try for your methods and functions to be pure. This mean that the result is a function of the input parameters AND has no side effects. The latter is not always possible (think database I/O), but well worth striving for. It makes your code predictable and testable. Try to avoid using "globals" in functions/methods. If they are needed inject them parameter. So:

```
class Foo:
  
    define private variable Y as integer no-undo.

    // anti pattern:
    method private integer add (x as integer):
        return x + this-object:Y.
    end method.

    // use:
    method private integer add (x as integer, z as integer):
        return x + z.
    end method.

    // and call add(1, Y).
end class.
```

# classes

Class name should be nouns, `Person`, `Address` are perfect examples. Sometimes this is a but harder, for example classes with just static method (keep those limited). `Helper`, `Processor` or `Manager` are most of the time useful postfixes for these. Think `StringHelper` where `String` that it holds an actual string (character).

## using
For every class used the should be a separate `using` line:

```
using OpenEdge.Core.String.
using OpenEdge.Core.Memptr.
```

NOT:
```
using OpenEdge.Core.*.
```

When using wildcards it's never clear where the classes used are coming from, so DON'T.
An added bonus is that it's easier to search for the use of classes (without having to resort to xref etc).

### from
Classes are searched for first in the `propath` and then in the assemblies (if applicable). Compiling sources can be a lot quicker if .NET using's are post fixed with `from assembly.`. This way the compiler can skip searching the propath.
Tip: don't use .NET classes, it wil bite you somewhere along the line.

Remove `from propath`, it just clutters your source without benefits.

## block-level
Make sure that there's always a:
```block-level on error undo, throw.``` 
on top of your `.cls` file. This way you don't lose exceptions in for example `for each` statements. If you want to conceal an exception, use a `catch` block.
This is not just for classes, `.p`'s benefit from this as well.

# proceduces (.p)
One `.p` should ran normally or persistently, not both. If a procedure is not programmed to be ran persistently this can give nasty results if they being used persistent (think transaction, trigger overrides). 

## non-persistent
Add the following to non-persistent procedure:
```
if (this-procedure:persistent) then
  undo, throw new AppError(substitute('&1 should not be ran persistently', this-procedure:file-name), -1).
```
or similar.

## persistent
Make sure that all internal procedures which are not meant to be accessed from the outside to be `private`:
``` 
procedure toString() private:
```

## internal procedures
End the procedure as follows:
```
end procedure.  // toString
```

So, with `procedure` after `end` AND a comment stating the procedure name, two spaces after the dot(`.`). Improves readability and accidental poking in the wrong procedure.

# includes
Includes should be used sparsely. They are good for data definition (temp-table & dataset) and a few other case. DON'T put business logic in an include, there are more elegant way for this.

Don't put double quotes around an include reference:
`{src/adm2/smart.i}` doesn't need `"`.

# functions
Use functions rather than (internal) procedure. Although one has to provide a `forward` defintion it makes for much more elegant code:

```
if (isOrderOK(orderNumber)) then
...
```

is far preferable to 
```
define variable orderOK as logical no-undo.

run isOrderOk(output orderOK).
if (isOrderOK) then
...
```

## definition 
Functions are preferably defined on one line and ended with a comment like:
```
function isOrderOK returns logical private (orderNumber as integer):
  
  define orderOK as logical no-undo.

  return orderOK.

end function.  // isOrderOK
```
It is considered good style to define a variable with a name with resembles the function name to hold the return value. Improves readability. So `function getCustomerName` uses `customerName`, etc.
Of course don't forget the `private` if it is in a persistent procedure, if appropriate. If not `private`, the function should start with a capital.

## space usage
Readability usually improves when using some space here and then. However, don't exagerate:
```
yes:   y = f(x).
no:    y = f (x). 
worse: y = f ( x ) .
worst: y = f ( input x ) .
```  
After a comma space follows:
```
y = f(x, y).  // not f(x,y)
```

# Linux
The following are essential for running code on Linux, but are a good haibit in general.

## case
ALWAYS use the correct case for filenames and class names. This is the main reason for .i's and .p filenames to be lowercase.

## path separators
Although Windows uses `\` and Linux/Unix `/` for path separators, in 4GL we use a `/` exclusively, except when the particular is outputted to some sort of Windows process.
So: `run adm2/smart.p` and never ever `run adm2\smart.p`. 

## backslashes
If it is necessary to use `\` somehow (see above) in a string, ALWAYS prefix it with a tilde `~`. So: `"~\"`. \
At some point your code may end up on Linux and making this a habit greatly simplifies your task.

## Avoid .NET
Although .NET support is present for PAS on Linux it is advisable to avoid it as much as possible. If you do use it, create a 4GL wrapper in order to keep 4GL code 4GL.

## Unit tests
Unit tests are written preferably for as much code as possible. Unit test concerning classes are put in the same directory as the class and have the same name postfixed by `_UT`. Unit test themselves are class only, no procedures (`.p`).

## Enums
see: https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/names-of-classes-structs-and-interfaces#naming-enumerations
- names are NOT plural, unless it a flags enum
- enums are not prefixed, nor postfixed with `Enum`. So, `OrderType` instead of `OrderTypesEnum` (assuming it's not a flags enum).
- for each member an integer value is provided. Enums may be persisted and implicit values may lead to errors. 
