# letUtils

[Immutability][] is [good][]. But one day I got tired of repeating variable names over and over
again:

```nim
let fib = block: # OK, we are going to declare `fib`.
  var fib = @[0, 1] # I already got it will be `fib`, thanks.
  for i in 2 ..< 13:
    fib &= fib[^1] + fib[^2]
  fib # Once again? Really?
```

So I wrote a bunch of macros that handle the boilerplate. Now we can do this:

```nim
import letUtils

freezeVars:
  var fib = @[0, 1]
  for i in 2 ..< 13:
    fib &= fib[^1] + fib[^2]

echo fib
assert not compiles (fib[0] = 123)
```

Look at the [documentation][] for more goodies.

[Immutability]: https://www.haskell.org/
[good]: https://doc.rust-lang.org/stable/book/ch03-01-variables-and-mutability.html#shadowing
[documentation]: https://sirnickolas.github.io/let-utils-nim/letUtils
