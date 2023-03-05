## A collection of small templates and macros that aid in limiting the scope of mutable `var`iables
## as much as practical.

func unreachable {.noReturn, inline.} = discard

template scope*(body: untyped): auto =
  ##[
    Open a new lexical scope (variables declared in the body are not accessible outside). Similar
    to the built-in `block` `language construct`_ but does not interfere with `break`. All credits
    for the implementation go to **@markspanbroek**.

    Unlabeled `break` inside a `block` has been deprecated in Nim 2.0; `see details and rationale
    <https://github.com/nim-lang/Nim/pull/20785>`_.

    .. _language construct: https://nim-lang.org/docs/manual.html#statements-and-expressions-block-expression
  ]##
  if true:
    body
  else:
    unreachable()

template asLet*(value, name, body: untyped): auto =
  ##[
    Equivalent to:

    .. code-block:: nim
      let name = value
      body
      name

    **Example:**

    .. code-block:: nim
      processObj:
        getObj().asLet obj:
          obj.field = 1
  ]##
  scope:
    let name = value
    body
    name

template asVar*(value, name, body: untyped): auto =
  ##[
    Equivalent to:

    .. code-block:: nim
      var name = value
      body
      name

    **Example:**

    .. code-block:: nim
      from std/strbasics import strip

      processStr:
        getStr().asVar s:
          s.strip
  ]##
  scope:
    var name = value
    body
    name

template viaVar*[T](t: typedesc[T]; name, body: untyped): T =
  ##[
    Equivalent to:

    .. code-block:: nim
      var name: T
      body
      name

    **Example:**

    .. code-block:: nim
      processSeq:
        seq[string].viaVar data:
          for i in 0 ..< 5:
            data &= $i

    **See also:**

    `std/sugar: collect <https://nim-lang.org/docs/sugar.html#collect.m%2Cuntyped>`_
  ]##
  scope:
    var name: T
    body
    name
